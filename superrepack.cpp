/*
 * Copyright (C) 2021 Munjeni
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

#include "version.h"

#if (!defined(_WIN32)) && (!defined(WIN32))
	#ifndef __USE_FILE_OFFSET64
		#define __USE_FILE_OFFSET64 1
	#endif
	#ifndef __USE_LARGEFILE64
		#define __USE_LARGEFILE64 1
	#endif
	#ifndef _LARGEFILE64_SOURCE
		#define _LARGEFILE64_SOURCE 1
	#endif
	#ifndef _FILE_OFFSET_BITS
		#define _FILE_OFFSET_BITS 64
	#endif
	#ifndef _FILE_OFFSET_BIT
		#define _FILE_OFFSET_BIT 64
	#endif
#endif

#ifdef _WIN32
#define __USE_MINGW_ANSI_STDIO 1

#include <windows.h>
#include <setupapi.h>
#include <initguid.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#ifdef HAS_STDINT_H
	#include <stdint.h>
#endif
#include <stdbool.h>

#ifdef unix
	#include <unistd.h>
	#include <sys/types.h>
#endif

#ifdef _WIN32
	#include <direct.h>
	#include <io.h>
#endif

#if defined(USE_FILE32API)
	#define fopen64 fopen
	#define ftello64 ftell
	#define fseeko64 fseek
#else
	#ifdef __FreeBSD__
		#define fopen64 fopen
		#define ftello64 ftello
		#define fseeko64 fseeko
	#endif
	/*#ifdef __ANDROID__
		#define fopen64 fopen
		#define ftello64 ftello
		#define fseeko64 fseeko
	#endif*/
	#ifdef _MSC_VER
		#define fopen64 fopen
		#if (_MSC_VER >= 1400) && (!(defined(NO_MSCVER_FILE64_FUNC)))
			#define ftello64 _ftelli64
			#define fseeko64 _fseeki64
		#else  /* old msc */
			#define ftello64 ftell
			#define fseeko64 fseek
		#endif
	#endif
#endif

#include <ctype.h>
#include <sys/stat.h>
#include <limits.h>
#include <time.h>
#include <dirent.h>
#include <assert.h>

#if !defined(_WIN32) && !defined(__APPLE__)
#include <linux/usbdevice_fs.h>
#include <linux/usb/ch9.h>
#include <asm/byteorder.h>

#include <string.h>
#include <errno.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#include <dirent.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <ctype.h>
#endif

#ifdef __APPLE__
	#include <unistd.h>
	#include <CoreFoundation/CoreFoundation.h>
	#include <IOKit/IOKitLib.h>
	#include <IOKit/IOCFPlugIn.h>
	#include <IOKit/usb/IOUSBLib.h>
	#include <mach/mach.h>

	#define fseeko64 fseeko
	#define ftello64 ftello
	#define fopen64 fopen
#endif

#include "metadata_format.h"

#ifdef __ANDROID__
#include <sysexits.h>
#include <android-base/properties.h>
#include <libavb_user/libavb_user.h>
#endif

#include "e2fsck_bin.h"
#include "resize2fs_bin.h"

#ifdef __ANDROID__
#include "losetup_bin.h"
#endif

#define EXT4_FEATURE_RO_COMPAT_SHARED_BLOCKS	0x4000

#define RW 1
#define RO 2

// return codes
#define RETURN_OK 0
#define NO_ARGUMENTS 1
#define UNABLE_TO_OPEN 2
#define NOT_A_SUPER_IMAGE 3
#define WRONG_LP_METADATA_HEADER_MAGIC 4
#define UNSUPPORTED_METADATA_VERSION 5
#define NOT_A_ROOTED_YET 6
#define SELINUX_ENFORCED 7
#define UNABLE_TO_DETERMINE_SELINUX 8
#define MISSING_TOOLS 9

void fread_unus_res(void *ptr, size_t size, size_t nmemb, FILE *stream) {
	size_t in;
	in = fread(ptr, size, nmemb, stream);
	if (in) {
		/* satisfy warn unused result */
	}
}

static char command_response[64];
static char loop_offset[16];
static char loop_limit[16];
static char loop_sectors[16];

void execute_command(const char *command, bool search_and_replace)
{

	FILE *fp = NULL;
	char ch;
	unsigned char i = 0;

	memset(command_response, 0, sizeof(command_response));

	if ((fp = popen(command, "r")) == NULL)
	{
		command_response[0] = 'P';
		command_response[1] = 0;
		return;
	}

	while(1)
	{
		ch = fgetc(fp);

		if(feof(fp))
			break;

		memcpy(command_response+i, &ch, 1);

		i+=1;
	}

	pclose(fp);

	command_response[i] = 0;

	if (command_response[0] > 0)
	{
		if (search_and_replace)
		{
			for (i=0; i<strlen(command_response); ++i)
			{
				if (command_response[i] == 0x20 || command_response[i] == 0x0D || command_response[i] == 0x0A)
				{
					command_response[i] = 0;
					break;
				}
			}
		}
	}
	else
	{
		command_response[0] = 'N';
		command_response[1] = 0;
		return;
	}
}

bool run_script(char *offset, char *limit, char *response, char *sectors, char *file)
{
	FILE *fp = NULL;
	char cc = 0x23;
#ifdef __ANDROID__
	char script[] = "/data/local/tmp/run.sh";
#else
	char script[] = "./run.sh";
#endif
	char mode[] = "0755";
	unsigned int m = strtol(mode, 0, 8);

#ifdef __ANDROID__
	execute_command("/data/local/tmp/losetup -f", 1);
#else
	execute_command("losetup -f", 1);
#endif
	if (command_response[0] == 'P')
	{
		printf("Error popen!\n");
		return false;
	}

	if (command_response[0] == 'N')
	{
		printf("Error, null reply!\n");
		return false;
	}

	if ((fp = fopen(script, "wb")) == NULL)
	{
		printf("Unable to open run.sh for write!\n");
		return false;
	}

#ifdef __ANDROID__
	fwrite(&cc, 1, 1, fp);
	fprintf(fp, "/system/bin/sh\n\n");
	fprintf(fp, "/data/local/tmp/losetup --offset=%s --sizelimit=%s %s %s >>/data/local/tmp/script.log\n", offset, limit, response, file);
	fprintf(fp, "/data/local/tmp/resize2fs %s %s >>/data/local/tmp/script.log\n", response, sectors);
	fprintf(fp, "sync >>/data/local/tmp/script.log\n");
	fprintf(fp, "/data/local/tmp/e2fsck -fy %s >>/data/local/tmp/script.log\n", response);
	fprintf(fp, "sync >>/data/local/tmp/script.log\n");
	fprintf(fp, "/data/local/tmp/e2fsck -fy -E unshare_blocks %s >>/data/local/tmp/script.log\n", response);
	fprintf(fp, "sync >>/data/local/tmp/script.log\n");
	fprintf(fp, "/data/local/tmp/losetup -d %s >>/data/local/tmp/script.log\n", response);
	fprintf(fp, "echo Ok");
	fprintf(fp, "\nexit 0\n");
#else
	fwrite(&cc, 1, 1, fp);
	fprintf(fp, "/bin/sh\n\n");
	fprintf(fp, "losetup --offset=%s --sizelimit=%s %s %s >>./script.log\n", offset, limit, response, file);
	fprintf(fp, "./resize2fs %s %s >>./script.log\n", response, sectors);
	fprintf(fp, "sync >>./script.log\n");
	fprintf(fp, "./e2fsck -fy %s >>./script.log\n", response);
	fprintf(fp, "sync >>./script.log\n");
	fprintf(fp, "./e2fsck -fy -E unshare_blocks %s >>./script.log\n", response);
	fprintf(fp, "sync >>./script.log\n");
	fprintf(fp, "losetup -d %s >>./script.log\n", response);
	fprintf(fp, "echo Ok");
	fprintf(fp, "\nexit 0\n");
#endif

	fclose(fp);

	if (chmod(script, m) < 0)
	{
		printf("Error in chmod(%s, %s) - %d (%s)\n", script, mode, errno, strerror(errno));
		return false;
	}

	execute_command(script, 0);

	if (command_response[0] == 'P')
	{
		printf("Error popen script!\n");
		return false;
	}

	if (command_response[0] == 'N')
	{
		printf("Error, script null response!\n");
		return false;
	}

	execute_command("sync", 0);

	return true;
}

#ifdef __ANDROID__
static bool g_opt_force = true;

bool is_locked_and_not_forced(void)
{
	std::string device_state;
	device_state = android::base::GetProperty("ro.boot.vbmeta.device_state", "");

	if (device_state == "locked" && !g_opt_force)
	{
		printf("Manipulating vbmeta on a LOCKED device will likely cause the\n"
			"device to fail booting with little chance of recovery.\n"
			"\n"
			"If you really want to do this, use the --force option.\n"
			"\n"
			"ONLY DO THIS IF YOU KNOW WHAT YOU ARE DOING.\n"
			"\n");

		return false;
	}

	return true;
}

/* Function to enable and disable verification. The |ops| parameter
 * should be an |AvbOps| from libavb_user.
 */
int do_set_verification(AvbOps *ops, const std::string &ab_suffix, bool enable_verification)
{
	bool verification_enabled;

	if (!avb_user_verification_get(ops, ab_suffix.c_str(), &verification_enabled))
	{
		printf("Error getting whether verification is enabled.\n");
		return EX_SOFTWARE;
	}

	if ((verification_enabled && enable_verification) || (!verification_enabled && !enable_verification))
	{
		printf("verification is already %s", verification_enabled ? "enabled" : "disabled");

		if (ab_suffix != "")
		{
			printf(" on slot with suffix %s", ab_suffix.c_str());
		}

		printf(".\n");
		return EX_OK;
	}

	if (!is_locked_and_not_forced())
	{
		return EX_NOPERM;
	}

	if (!avb_user_verification_set(ops, ab_suffix.c_str(), enable_verification))
	{
		printf("Error setting verification.\n");
		return EX_SOFTWARE;
	}

	printf("Successfully %s verification", enable_verification ? "enabled" : "disabled");

	if (ab_suffix != "")
	{
		printf(" on slot with suffix %s", ab_suffix.c_str());
	}
  
	printf(". Reboot the device for changes to take effect.\n");
	return EX_OK;
}

/* Function to query if verification. The |ops| parameter should be an
 * |AvbOps| from libavb_user.
 */
int do_get_verification(AvbOps *ops, const std::string &ab_suffix)
{
	bool verification_enabled;

	if (!avb_user_verification_get(ops, ab_suffix.c_str(), &verification_enabled))
	{
		printf("Error getting whether verification is enabled.\n");
		return EX_SOFTWARE;
	}

	printf("verification is %s", verification_enabled ? "enabled" : "disabled");

	if (ab_suffix != "")
	{
		printf(" on slot with suffix %s", ab_suffix.c_str());
	}

	printf(".\n");
	return EX_OK;
}

/* Function to enable and disable dm-verity. The |ops| parameter
 * should be an |AvbOps| from libavb_user.
 */
int do_set_verity(AvbOps *ops, const std::string &ab_suffix, bool enable_verity)
{
	bool verity_enabled;

	if (!avb_user_verity_get(ops, ab_suffix.c_str(), &verity_enabled))
	{
		printf("Error getting whether verity is enabled.\n");
		return EX_SOFTWARE;
	}

	if ((verity_enabled && enable_verity) || (!verity_enabled && !enable_verity))
	{
		printf("verity is already %s", verity_enabled ? "enabled" : "disabled");

		if (ab_suffix != "")
		{
			printf(" on slot with suffix %s", ab_suffix.c_str());
		}

		printf(".\n");
		return EX_OK;
	}

	if (!is_locked_and_not_forced())
	{
		return EX_NOPERM;
	}

	if (!avb_user_verity_set(ops, ab_suffix.c_str(), enable_verity))
	{
		printf("Error setting verity.\n");
		return EX_SOFTWARE;
	}

	printf("Successfully %s verity", enable_verity ? "enabled" : "disabled");

	if (ab_suffix != "")
	{
		printf(" on slot with suffix %s", ab_suffix.c_str());
	}

	printf(". Reboot the device for changes to take effect.\n");
	return EX_OK;
}

/* Function to query if dm-verity is enabled. The |ops| parameter
 * should be an |AvbOps| from libavb_user.
 */
int do_get_verity(AvbOps *ops, const std::string &ab_suffix)
{
	bool verity_enabled;

	if (!avb_user_verity_get(ops, ab_suffix.c_str(), &verity_enabled))
	{
		printf("Error getting whether verity is enabled.\n");
		return EX_SOFTWARE;
	}

	printf("verity is %s", verity_enabled ? "enabled" : "disabled");

	if (ab_suffix != "")
	{
		printf(" on slot with suffix %s", ab_suffix.c_str());
	}

	printf(".\n");
	return EX_OK;
}

/* Helper function to get A/B suffix, if any. If the device isn't
 * using A/B the empty string is returned. Otherwise either "_a",
 * "_b", ... is returned.
 */
std::string get_ab_suffix(void)
{
	return android::base::GetProperty("ro.boot.slot_suffix", "");
}
#endif

int main(int argc, char *argv[])
{
	LpMetadataGeometry geometry;
	LpMetadataHeader header;

	unsigned char i=0;
	unsigned char j=0;

	FILE *rom = NULL;
	FILE *bp = NULL;

	char mode[] = "0755";
	unsigned int m = strtol(mode, 0, 8);

	int ret = RETURN_OK;
	char temp[0x500];
	char partit[64];
	char partit_uuid[16];
	unsigned long long ext4_file_size;
	unsigned int s_feature_ro_compat = 0;

#ifdef __ANDROID__
	AvbOps *ops = NULL;
	std::string ab_suffix;
#endif

	printf("---------------------------------------------------------\n");
	printf("Super image repacker v_%d by munjeni @ xda 2021)\n", VERSION);
	printf("---------------------------------------------------------\n\n");

	if (argc < 2 || argc > 3)
	{
		printf("USAGE: (With no arguments all partitions going to be RW and shared_blocks removed!)\n");
		printf("%s [image or block device] [search by string]\n", argv[0]);
		printf("%s super.img\n", argv[0]);
		printf("%s /dev/block/by-name/super\n", argv[0]);
		printf("%s super.img system_a\n", argv[0]);
		printf("%s /dev/block/by-name/super system_a\n", argv[0]);
		printf("\n");
		ret = NO_ARGUMENTS;
		goto die;
	}

	if ((unsigned int)getuid() != 0)
	{
		printf("Error, you must be root!\n");
		ret = NOT_A_ROOTED_YET;
		goto die;
	}

#ifdef __ANDROID__
	execute_command("echo \"\" > /data/local/tmp/script.log", 1);
#else
	execute_command("echo \"\" > ./script.log", 1);
#endif

#ifdef __ANDROID__
	execute_command("getenforce", 1);

	if (command_response[0] == 'E' && command_response[1] == 'n')
	{
		printf("Error, your device is selinux enforced!\n");
		printf("Put selinux in permisive mode first by command: setenforce 0\n");
		ret = SELINUX_ENFORCED;
		goto die;
	}

	if (command_response[0] == 'P' && command_response[1] != 'e')
	{
		printf("Error, getenforce tool is missing, unable to determine selinux status!\n");
		ret = UNABLE_TO_DETERMINE_SELINUX;
		goto die;
	}

	if (command_response[0] == 'N')
	{
		printf("Error, getenforce null reply, unable to determine selinux status!\n");
		ret = UNABLE_TO_DETERMINE_SELINUX;
		goto die;
	}

	ops = avb_ops_user_new();

	if (ops == nullptr)
	{
		printf("Error getting AVB ops.\n");
		ret = EX_SOFTWARE;
		goto die;
	}

	ab_suffix = get_ab_suffix();

	do_set_verification(ops, ab_suffix, false);
	do_set_verity(ops, ab_suffix, false);
#endif

	memset(partit, 0, sizeof(partit));

	if (argc == 3)
	{
		strncpy(partit, argv[2], sizeof(partit));
		printf("Searching for partitions contain string: %s and making it RW\n", partit);
	}
	else
	{
		printf("Removing shared_blocks and making RW on all partitions!\n");
	}

#ifdef __ANDROID__
	if ((bp = fopen("/data/local/tmp/losetup", "wb")) == NULL)
	{
		printf("Error, unable to open losetup for write!\n");
		ret = MISSING_TOOLS;
		goto die;
	}

	if ((fwrite(losetup, 1, losetup_len, bp)) != losetup_len)
	{
		printf("Error, unable to write losetup!\n");
		fclose(bp);
		ret = MISSING_TOOLS;
		goto die;
	}

	fclose(bp);

	if (chmod("/data/local/tmp/losetup", m) < 0)
	{
		printf("Error in chmod(losetup, %s) - %d (%s)\n", mode, errno, strerror(errno));
		ret = MISSING_TOOLS;
		goto die;
	}
#endif

#ifdef __ANDROID__
	if ((bp = fopen("/data/local/tmp/e2fsck", "wb")) == NULL)
#else
	if ((bp = fopen("./e2fsck", "wb")) == NULL)
#endif
	{
		printf("Error, unable to open e2fsck for write!\n");
		ret = MISSING_TOOLS;
		goto die;
	}

	if ((fwrite(e2fsck, 1, e2fsck_len, bp)) != e2fsck_len)
	{
		printf("Error, unable to write e2fsck!\n");
		fclose(bp);
		ret = MISSING_TOOLS;
		goto die;
	}

	fclose(bp);

#ifdef __ANDROID__
	if (chmod("/data/local/tmp/e2fsck", m) < 0)
#else
	if (chmod("./e2fsck", m) < 0)
#endif
	{
		printf("Error in chmod(e2fsck, %s) - %d (%s)\n", mode, errno, strerror(errno));
		ret = MISSING_TOOLS;
		goto die;
	}

#ifdef __ANDROID__
	if ((bp = fopen("/data/local/tmp/resize2fs", "wb")) == NULL)
#else
	if ((bp = fopen("./resize2fs", "wb")) == NULL)
#endif
	{
		printf("Error, unable to open resize2fs for write!\n");
		ret = MISSING_TOOLS;
		goto die;
	}

	if ((fwrite(resize2fs, 1, resize2fs_len, bp)) != resize2fs_len)
	{
		printf("Error, unable to write resize2fs!\n");
		fclose(bp);
		ret = MISSING_TOOLS;
		goto die;
	}

	fclose(bp);

#ifdef __ANDROID__
	if (chmod("/data/local/tmp/resize2fs", m) < 0)
#else
	if (chmod("./resize2fs", m) < 0)
#endif
	{
		printf("Error in chmod(resize2fs, %s) - %d (%s)\n", mode, errno, strerror(errno));
		ret = MISSING_TOOLS;
		goto die;
	}

	rom = fopen64(argv[1], "rb+");

	if (rom == NULL)
	{
		printf("Unable to open %s!\n", argv[1]);
		ret = UNABLE_TO_OPEN;
		goto die;
	}

	fseeko64(rom, LP_PARTITION_RESERVED_BYTES, SEEK_SET);
	fread_unus_res(&geometry, sizeof(struct LpMetadataGeometry), 1, rom);

	if (geometry.magic != LP_METADATA_GEOMETRY_MAGIC)
	{
		printf("\nThis is not super image! GM=0x%x\n", geometry.magic);
		fclose(rom);
		ret = NOT_A_SUPER_IMAGE;
		goto die;
	}

	printf("\n");
	printf("LpMetadataGeometry magic = 0x%x\n", geometry.magic);
	printf("LpMetadataGeometry struct size = 0x%x\n", geometry.struct_size);
	printf("LpMetadataGeometry sha256 = ");
	for (i=0; i<32; ++i)
		printf("%02X", geometry.checksum[i] & 0xff);
	printf("\n");
	printf("LpMetadataGeometry metadata_max_size = 0x%x\n", geometry.metadata_max_size);
	printf("LpMetadataGeometry metadata_slot_count = 0x%x\n", geometry.metadata_slot_count);
	printf("LpMetadataGeometry logical_block_size = 0x%x\n", geometry.logical_block_size);

	/* ---------------------------------------------------------- */

	fseeko64(rom, LP_PARTITION_RESERVED_BYTES * 3, SEEK_SET);
	fread_unus_res(&header, sizeof(struct LpMetadataHeader), 1, rom);

	if (header.magic != LP_METADATA_HEADER_MAGIC)
	{
		printf("\nWrong LpMetadataHeader magic!\n");
		fclose(rom);
		ret = WRONG_LP_METADATA_HEADER_MAGIC;
		goto die;
	}

	if (header.major_version != LP_METADATA_MAJOR_VERSION)
	{
		printf("\nlp metadata major version %d is incompatible with tool lp metadata major version %d!\n", header.major_version, LP_METADATA_MAJOR_VERSION);
		fclose(rom);
		ret = UNSUPPORTED_METADATA_VERSION;
		goto die;
	}

	if (header.minor_version > LP_METADATA_MINOR_VERSION_MAX)
	{
		printf("\nlp metadata minor version %d is greater than tool lp metadata minor max version %d!\n", header.minor_version, LP_METADATA_MINOR_VERSION_MAX);
		fclose(rom);
		ret = UNSUPPORTED_METADATA_VERSION;
		goto die;
	}

	printf("\n");
	printf("LpMetadataHeader magic = 0x%x\n", header.magic);
	printf("LpMetadataHeader major_version = %d\n", header.major_version);
	printf("LpMetadataHeader minor_version = %d\n", header.minor_version);
	printf("LpMetadataHeader header_size = 0x%x\n", header.header_size);
	printf("LpMetadataHeader header sha256 = ");
	for (i=0; i<32; ++i)
		printf("%02X", header.header_checksum[i] & 0xff);
	printf("\n");
	printf("LpMetadataHeader tables_size = 0x%x\n", header.tables_size);
	printf("LpMetadataHeader tables sha256 = ");
	for (i=0; i<32; ++i)
		printf("%02X", header.tables_checksum[i] & 0xff);
	printf("\n");
	printf("LpMetadataHeader partitions offset = 0x%x\n", header.partitions.offset);
	printf("LpMetadataHeader partitions num_entries = 0x%x\n", header.partitions.num_entries);
	printf("LpMetadataHeader partitions entry_size = 0x%x\n", header.partitions.entry_size);
	printf("LpMetadataHeader extents offset = 0x%x\n", header.extents.offset);
	printf("LpMetadataHeader extents num_entries = 0x%x\n", header.extents.num_entries);
	printf("LpMetadataHeader extents entry_size = 0x%x\n", header.extents.entry_size);
	printf("LpMetadataHeader groups offset = 0x%x\n", header.groups.offset);
	printf("LpMetadataHeader groups num_entries = 0x%x\n", header.groups.num_entries);
	printf("LpMetadataHeader groups entry_size = 0x%x\n", header.groups.entry_size);
	printf("LpMetadataHeader block_devices offset = 0x%x\n", header.block_devices.offset);
	printf("LpMetadataHeader block_devices num_entries = 0x%x\n", header.block_devices.num_entries);
	printf("LpMetadataHeader block_devices entry_size = 0x%x\n", header.block_devices.entry_size);

	/* ---------------------------------------------------------- */

	printf("\nPartitions = %d used, %d not used, total %d\n", header.extents.num_entries, (header.partitions.num_entries - header.extents.num_entries), header.partitions.num_entries);

	for (i=0; i < header.partitions.num_entries; ++i)
	{
		LpMetadataPartition partition;
		LpMetadataPartitionGroup partition_group;
		ext4_file_size = 0LL;

		memset(temp, 0, sizeof(temp));

		fseeko64(rom, (LP_PARTITION_RESERVED_BYTES * 3) + header.header_size + header.partitions.offset + (i * header.partitions.entry_size), SEEK_SET);
		fread_unus_res(&partition, sizeof(struct LpMetadataPartition), 1, rom);

		fseeko64(rom, (LP_PARTITION_RESERVED_BYTES * 3) + header.header_size + header.groups.offset + (partition.group_index * header.groups.entry_size), SEEK_SET);
		fread_unus_res(&partition_group, sizeof(struct LpMetadataPartitionGroup), 1, rom);

		printf("\n  partition_%d_name = %s%s\n", (i+1), partition.name, (partition.num_extents == 0) ? " (unused)" : "");
		printf("    attributes = 0x%x\n", partition.attributes);
		printf("    first_extent_index = 0x%x\n", partition.first_extent_index);
		printf("    num_extents = 0x%x\n", partition.num_extents);
		printf("    group_index = 0x%x\n", partition.group_index);
		printf("    partition_group = %s\n", partition_group.name);

		LpMetadataExtent extent;

		fseeko64(rom, (LP_PARTITION_RESERVED_BYTES * 3) + header.header_size + header.extents.offset + (partition.first_extent_index * header.extents.entry_size), SEEK_SET);
		fread_unus_res(&extent, sizeof(struct LpMetadataExtent), 1, rom);

		printf("    extent num_sectors = 0x%llx (0x%llx bytes total)\n", extent.num_sectors, (extent.num_sectors * 512));
		printf("    extent target_type = 0x%x\n", extent.target_type);
		printf("    extent target_data = 0x%llx (dumping offset = 0x%llx)\n", extent.target_data, (extent.target_data * 512));
		printf("    extent target_source = 0x%x\n", extent.target_source);

		snprintf(loop_offset, sizeof(loop_offset), "%llu", extent.target_data * 512);
		snprintf(loop_limit, sizeof(loop_limit), "%llu", extent.num_sectors * 512);
		snprintf(loop_sectors, sizeof(loop_sectors), "%llu", (extent.num_sectors * 512) / 4096);

		fseeko64(rom, (extent.target_data * 512), SEEK_SET);
		fread_unus_res(temp, sizeof(temp), 1, rom);

		// ext4
		if (memcmp(temp+0x438, "\x53\xef", 2) == 0)
		{
			memcpy(&ext4_file_size, temp+0x404, sizeof(unsigned long long));
			ext4_file_size *= 4096;
			printf("      Partition: %s | EXT4 | 0x%llx | ", partition.name, ext4_file_size);

			memcpy(&s_feature_ro_compat, temp+0x464, sizeof(unsigned int));
			memcpy(partit_uuid, temp+0x468, sizeof(partit_uuid));

			for (j=0; j<sizeof(partit_uuid); ++j)
			{
				printf("%02X", partit_uuid[j] & 0xff);

				switch(j)
				{
					case 3:
					case 5:
					case 7:
					case 9:
						printf("-");
						break;

					default:
						break;
				}

			}
			printf(" | ");

			printf("0x%08X | ", s_feature_ro_compat);

			if (strlen(partit) > 0 && strstr(partition.name, partit) != NULL)
			{
#ifdef __ANDROID__
				execute_command("/data/local/tmp/losetup -f", 1);
#else
				execute_command("losetup -f", 1);
#endif
				if (command_response[0] == '/' && command_response[1] == 'd' && command_response[2] == 'e' && command_response[3] == 'v' && strstr(command_response, "loop") != NULL)
				{
					printf("unsharing blocks and making RW\n");
					s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_SHARED_BLOCKS;
					fseeko64(rom, (extent.target_data * 512)+0x464, SEEK_SET);
					fwrite(&s_feature_ro_compat, sizeof(unsigned int), 1, rom);

					run_script(loop_offset, loop_limit, command_response, loop_sectors, argv[1]);
				}
				else
				{
					printf("Error, no free loop device!\n");
				}
			}
			else
			{
				if (argc == 3)
				{
					printf("skipping\n");
				}
				else
				{
#ifdef __ANDROID__
					execute_command("/data/local/tmp/losetup -f", 1);
#else
					execute_command("losetup -f", 1);
#endif

					if (command_response[0] == '/' && command_response[1] == 'd' && command_response[2] == 'e' && command_response[3] == 'v' && strstr(command_response, "loop") != NULL)
					{
						printf("unsharing blocks and making RW\n");
						s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_SHARED_BLOCKS;
						fseeko64(rom, (extent.target_data * 512)+0x464, SEEK_SET);
						fwrite(&s_feature_ro_compat, sizeof(unsigned int), 1, rom);

						run_script(loop_offset, loop_limit, command_response, loop_sectors, argv[1]);
					}
					else
					{
						printf("Error, no free loop device!\n");
					}
				}
			}
		}
		else
		{
			if (memcmp(temp, "\x7f\x45\x4c\x46", 4) == 0)
			{
				printf("      Partition: %s | ELF | U | U | U | skipping\n", partition.name);
			}
			else if (memcmp(temp, "\xeb\x3c\x90", 3) == 0)
			{
				printf("      Partition: %s | VFAT | U | U | U | skipping\n", partition.name);
			}
			else if (memcmp(temp, "\x41\x4e\x44\x52", 4) == 0)
			{
				printf("      Partition: %s | IMG | U | U | U | skipping\n", partition.name);
			}
			else
			{
				printf("      Partition: %s | UNKNOWN | U | U | U | skipping\n", partition.name);
			}
		}
	}

	fclose(rom);

die:

#ifdef __ANDROID__
	printf("\n=======================================================================\n");
	printf("!!!!!! DO IN MIND IF YOU SEE ANY ERROR THAT MEAN TOOL IS FAILED, YOU NEED RUN TOOL 4-5 TIMES UNTIL ALL ERRORS DISAPEAR !!!!!!\n");
	printf("!!!!!! Read /data/local/tmp/script.log after every run and make sure it not contain errors, when there is no errors you are done! !!!!!!\n");
	printf("\n=======================================================================\n");
#else
	printf("\n=======================================================================\n");
	printf("!!!!!! DO IN MIND IF YOU SEE ANY ERROR THAT MEAN TOOL IS FAILED, YOU NEED RUN TOOL 4-5 TIMES UNTIL ALL ERRORS DISAPEAR !!!!!!\n");
	printf("!!!!!! Read script.log after every run and make sure it not contain errors, when there is no errors you are done! !!!!!!\n");
	printf("\n=======================================================================\n");
	printf("If all is completed without error you are ready to restore your dump on your phone with command:\n");
	printf("dd if=/data/local/tmp/super.dump of=/dev/block/yoursuperpartitiondevice conv=notrunc\nsync\n");
#endif

#ifdef _WIN32
	system("pause");
#endif

	return ret;
}
