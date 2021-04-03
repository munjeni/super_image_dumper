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

#define EXT4_FEATURE_RO_COMPAT_SHARED_BLOCKS	0x4000

void fread_unus_res(void *ptr, size_t size, size_t nmemb, FILE *stream) {
	size_t in;
	in = fread(ptr, size, nmemb, stream);
	if (in) {
		/* satisfy warn unused result */
	}
}

int main(int argc, char *argv[])
{
	LpMetadataGeometry geometry;
	LpMetadataHeader header;
	unsigned char i;
	FILE *rom = NULL;

	int ret = 0;
	char temp[0x500];
	unsigned long long ext4_file_size;

	unsigned int s_feature_ro_compat = 0;

	printf("---------------------------------------------------------\n");
	printf("Super image repacker v_%d by munjeni @ xda 2021)\n", VERSION);
	printf("---------------------------------------------------------\n");

	if (argc < 2)
	{
		printf("Usage:\n%s super.img\n", argv[0]);
		printf("\n");
		goto die;
	}

	rom = fopen64(argv[1], "rb+");

	if (rom == NULL)
	{
		printf("Unable to open %s!\n", argv[1]);
		ret = -1;
		goto die;
	}

	fseeko64(rom, LP_PARTITION_RESERVED_BYTES, SEEK_SET);
	fread_unus_res(&geometry, sizeof(struct LpMetadataGeometry), 1, rom);

	if (geometry.magic != LP_METADATA_GEOMETRY_MAGIC)
	{
		printf("\nThis is not super image! GM=0x%x\n", geometry.magic);
		fclose(rom);
		ret = -1;
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
		ret = -1;
		goto die;
	}

	if (header.major_version != LP_METADATA_MAJOR_VERSION)
	{
		printf("\nlp metadata major version %d is incompatible with tool lp metadata major version %d!\n", header.major_version, LP_METADATA_MAJOR_VERSION);
		fclose(rom);
		ret = -1;
		goto die;
	}

	if (header.minor_version > LP_METADATA_MINOR_VERSION_MAX)
	{
		printf("\nlp metadata minor version %d is greater than tool lp metadata minor max version %d!\n", header.minor_version, LP_METADATA_MINOR_VERSION_MAX);
		fclose(rom);
		ret = -1;
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

		fseeko64(rom, (extent.target_data * 512), SEEK_SET);
		fread_unus_res(temp, sizeof(temp), 1, rom);

		if (memcmp(temp+0x438, "\x53\xef", 2) == 0)
		{
			memcpy(&ext4_file_size, temp+0x404, sizeof(unsigned long long));
			ext4_file_size *= 4096;
			printf("      Partition: %s, Filetype EXT4. EXT4 size = 0x%llx\n", partition.name, ext4_file_size);

			memcpy(&s_feature_ro_compat, temp+0x464, sizeof(unsigned int));
			s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_SHARED_BLOCKS;
			fseeko64(rom, (extent.target_data * 512)+0x464, SEEK_SET);
			fwrite(&s_feature_ro_compat, sizeof(unsigned int), 1, rom);

		}
		else
		{
			printf("      Partition: %s, Filetype is not EXT4, skipping it.\n", partition.name);
		}
	}

	fclose(rom);

die:
#ifdef _WIN32
	system("pause");
#endif

	return ret;
}
