LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE    := libz
LOCAL_SRC_FILES := zlib/adler32.c \
		zlib/compress.c \
                zlib/cpu_features.c \
		zlib/crc32.c \
		zlib/deflate.c \
		zlib/gzclose.c \
		zlib/gzlib.c \
		zlib/gzread.c \
		zlib/gzwrite.c \
		zlib/infback.c \
		zlib/inffast.c \
		zlib/inflate.c \
		zlib/inftrees.c \
		zlib/trees.c \
		zlib/uncompr.c \
		zlib/zutil.c \
                zlib/adler32_simd.c \
                zlib/crc32_simd.c

LOCAL_CFLAGS += -Izlib \
		-DHAVE_HIDDEN \
		-DZLIB_CONST \
		-Wall \
		-Werror \
		-Wno-unused \
		-Wno-unused-parameter \
                -DARMV8_OS_LINUX \
                -O3 \
                -DCPU_NO_SIMD \
                -UCPU_NO_SIMD \
                -DADLER32_SIMD_NEON \
                -DCRC32_ARMV8_CRC32 \
                -DINFLATE_CHUNK_READ_64LE

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libext2_com_err
LOCAL_SRC_FILES := android_external_e2fsprogs/lib/et/error_message.c \
        android_external_e2fsprogs/lib/et/et_name.c \
        android_external_e2fsprogs/lib/et/init_et.c \
        android_external_e2fsprogs/lib/et/com_err.c \
        android_external_e2fsprogs/lib/et/com_right.c

LOCAL_CFLAGS += -Wno-unused-variable \
                -Iandroid_external_e2fsprogs/lib/et \
                -Iandroid_external_e2fsprogs/lib

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libext2_uuid
LOCAL_SRC_FILES := android_external_e2fsprogs/lib/uuid/clear.c \
        android_external_e2fsprogs/lib/uuid/compare.c \
        android_external_e2fsprogs/lib/uuid/copy.c \
        android_external_e2fsprogs/lib/uuid/gen_uuid.c \
        android_external_e2fsprogs/lib/uuid/isnull.c \
        android_external_e2fsprogs/lib/uuid/pack.c \
        android_external_e2fsprogs/lib/uuid/parse.c \
        android_external_e2fsprogs/lib/uuid/unpack.c \
        android_external_e2fsprogs/lib/uuid/unparse.c \
        android_external_e2fsprogs/lib/uuid/uuid_time.c

LOCAL_CFLAGS += -Wno-unused-function \
                -Wno-unused-parameter \
                -Iandroid_external_e2fsprogs/lib/uuid \
                -Iandroid_external_e2fsprogs/lib

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libext2_blkid
LOCAL_SRC_FILES := android_external_e2fsprogs/lib/blkid/cache.c \
        android_external_e2fsprogs/lib/blkid/dev.c \
        android_external_e2fsprogs/lib/blkid/devname.c \
        android_external_e2fsprogs/lib/blkid/devno.c \
        android_external_e2fsprogs/lib/blkid/getsize.c \
        android_external_e2fsprogs/lib/blkid/llseek.c \
        android_external_e2fsprogs/lib/blkid/probe.c \
        android_external_e2fsprogs/lib/blkid/read.c \
        android_external_e2fsprogs/lib/blkid/resolve.c \
        android_external_e2fsprogs/lib/blkid/save.c \
        android_external_e2fsprogs/lib/blkid/tag.c \
        android_external_e2fsprogs/lib/blkid/version.c

LOCAL_CFLAGS += -Wno-error=attributes \
                -Wno-error=pointer-sign \
                -Wno-unused-parameter \
                -fno-strict-aliasing \
                -Iandroid_external_e2fsprogs/lib/blkid \
                -Iandroid_external_e2fsprogs/lib

LOCAL_STATIC_LIBRARIES := libext2_uuid

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libext2_e2p
LOCAL_SRC_FILES := android_external_e2fsprogs/lib/e2p/encoding.c \
        android_external_e2fsprogs/lib/e2p/feature.c \
        android_external_e2fsprogs/lib/e2p/fgetflags.c \
        android_external_e2fsprogs/lib/e2p/fsetflags.c \
        android_external_e2fsprogs/lib/e2p/fgetproject.c \
        android_external_e2fsprogs/lib/e2p/fsetproject.c \
        android_external_e2fsprogs/lib/e2p/fgetversion.c \
        android_external_e2fsprogs/lib/e2p/fsetversion.c \
        android_external_e2fsprogs/lib/e2p/getflags.c \
        android_external_e2fsprogs/lib/e2p/getversion.c \
        android_external_e2fsprogs/lib/e2p/hashstr.c \
        android_external_e2fsprogs/lib/e2p/iod.c \
        android_external_e2fsprogs/lib/e2p/ljs.c \
        android_external_e2fsprogs/lib/e2p/ls.c \
        android_external_e2fsprogs/lib/e2p/mntopts.c \
        android_external_e2fsprogs/lib/e2p/parse_num.c \
        android_external_e2fsprogs/lib/e2p/pe.c \
        android_external_e2fsprogs/lib/e2p/pf.c \
        android_external_e2fsprogs/lib/e2p/ps.c \
        android_external_e2fsprogs/lib/e2p/setflags.c \
        android_external_e2fsprogs/lib/e2p/setversion.c \
        android_external_e2fsprogs/lib/e2p/uuid.c \
        android_external_e2fsprogs/lib/e2p/ostype.c \
        android_external_e2fsprogs/lib/e2p/percent.c

LOCAL_CFLAGS += -Wno-error=attributes \
                -Wno-unused-parameter \
                -Iandroid_external_e2fsprogs/lib/e2p \
                -Iandroid_external_e2fsprogs/lib

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libfmtlib
LOCAL_SRC_FILES := fmtlib/src/format.cc

LOCAL_CFLAGS += -fno-exceptions \
                -Wall \
                -Werror \
                -UNDEBUG \
                -Ifmtlib/include

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := liblog
LOCAL_SRC_FILES := core/liblog/log_event_list.cpp \
                   core/liblog/log_event_write.cpp \
                   core/liblog/logger_name.cpp \
                   core/liblog/logger_read.cpp \
                   core/liblog/logger_write.cpp \
                   core/liblog/logprint.cpp \
                   core/liblog/properties.cpp \
                   core/liblog/event_tag_map.cpp \
                   core/liblog/log_time.cpp \
                   core/liblog/pmsg_reader.cpp \
                   core/liblog/pmsg_writer.cpp \
                   core/liblog/logd_reader.cpp \
                   core/liblog/logd_writer.cpp

LOCAL_CFLAGS += -Wall \
                -Wextra \
                -DLIBLOG_LOG_TAG=1006 \
                -DSNET_EVENT_LOG_TAG=1397638484 \
                -DDEBUGGABLE \
                -Icore/include \
                -Icore/liblog/include \
                -Icore/base/include

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libbase
LOCAL_SRC_FILES := core/base/abi_compatibility.cpp \
                   core/base/chrono_utils.cpp \
                   core/base/cmsg.cpp \
                   core/base/file.cpp \
                   core/base/liblog_symbols.cpp \
                   core/base/logging.cpp \
                   core/base/mapped_file.cpp \
                   core/base/parsebool.cpp \
                   core/base/parsenetaddress.cpp \
                   core/base/process.cpp \
                   core/base/properties.cpp \
                   core/base/stringprintf.cpp \
                   core/base/strings.cpp \
                   core/base/threads.cpp \
                   core/base/test_utils.cpp \
                   core/base//errors_unix.cpp

LOCAL_CFLAGS += -Wall \
                -Wextra \
                -D_FILE_OFFSET_BITS=64 \
                -Icore/base/include \
                -Ifmtlib/include

LOCAL_CPPFLAGS += -Wexit-time-destructors

LOCAL_STATIC_LIBRARIES := libfmtlib \
                          liblog

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libsparse
LOCAL_SRC_FILES := core/libsparse/backed_block.cpp \
                   core/libsparse/output_file.cpp \
                   core/libsparse/sparse.cpp \
                   core/libsparse/sparse_crc32.cpp \
                   core/libsparse/sparse_err.cpp \
                   core/libsparse/sparse_read.cpp

LOCAL_CFLAGS += -Werror \
                -Icore/libsparse/include \
                -Icore/base/include

LOCAL_STATIC_LIBRARIES := libz \
                          libbase

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libext2fs
LOCAL_SRC_FILES := android_external_e2fsprogs/lib/ext2fs/ext2_err.c \
                   android_external_e2fsprogs/lib/ext2fs/alloc.c \
                   android_external_e2fsprogs/lib/ext2fs/alloc_sb.c \
                   android_external_e2fsprogs/lib/ext2fs/alloc_stats.c \
                   android_external_e2fsprogs/lib/ext2fs/alloc_tables.c \
                   android_external_e2fsprogs/lib/ext2fs/atexit.c \
                   android_external_e2fsprogs/lib/ext2fs/badblocks.c \
                   android_external_e2fsprogs/lib/ext2fs/bb_inode.c \
                   android_external_e2fsprogs/lib/ext2fs/bitmaps.c \
                   android_external_e2fsprogs/lib/ext2fs/bitops.c \
                   android_external_e2fsprogs/lib/ext2fs/blkmap64_ba.c \
                   android_external_e2fsprogs/lib/ext2fs/blkmap64_rb.c \
                   android_external_e2fsprogs/lib/ext2fs/blknum.c \
                   android_external_e2fsprogs/lib/ext2fs/block.c \
                   android_external_e2fsprogs/lib/ext2fs/bmap.c \
                   android_external_e2fsprogs/lib/ext2fs/check_desc.c \
                   android_external_e2fsprogs/lib/ext2fs/crc16.c \
                   android_external_e2fsprogs/lib/ext2fs/crc32c.c \
                   android_external_e2fsprogs/lib/ext2fs/csum.c \
                   android_external_e2fsprogs/lib/ext2fs/closefs.c \
                   android_external_e2fsprogs/lib/ext2fs/dblist.c \
                   android_external_e2fsprogs/lib/ext2fs/dblist_dir.c \
                   android_external_e2fsprogs/lib/ext2fs/digest_encode.c \
                   android_external_e2fsprogs/lib/ext2fs/dirblock.c \
                   android_external_e2fsprogs/lib/ext2fs/dirhash.c \
                   android_external_e2fsprogs/lib/ext2fs/dir_iterate.c \
                   android_external_e2fsprogs/lib/ext2fs/dupfs.c \
                   android_external_e2fsprogs/lib/ext2fs/expanddir.c \
                   android_external_e2fsprogs/lib/ext2fs/ext_attr.c \
                   android_external_e2fsprogs/lib/ext2fs/extent.c \
                   android_external_e2fsprogs/lib/ext2fs/fallocate.c \
                   android_external_e2fsprogs/lib/ext2fs/fileio.c \
                   android_external_e2fsprogs/lib/ext2fs/finddev.c \
                   android_external_e2fsprogs/lib/ext2fs/flushb.c \
                   android_external_e2fsprogs/lib/ext2fs/freefs.c \
                   android_external_e2fsprogs/lib/ext2fs/gen_bitmap.c \
                   android_external_e2fsprogs/lib/ext2fs/gen_bitmap64.c \
                   android_external_e2fsprogs/lib/ext2fs/get_num_dirs.c \
                   android_external_e2fsprogs/lib/ext2fs/get_pathname.c \
                   android_external_e2fsprogs/lib/ext2fs/getsize.c \
                   android_external_e2fsprogs/lib/ext2fs/getsectsize.c \
                   android_external_e2fsprogs/lib/ext2fs/hashmap.c \
                   android_external_e2fsprogs/lib/ext2fs/i_block.c \
                   android_external_e2fsprogs/lib/ext2fs/icount.c \
                   android_external_e2fsprogs/lib/ext2fs/imager.c \
                   android_external_e2fsprogs/lib/ext2fs/ind_block.c \
                   android_external_e2fsprogs/lib/ext2fs/initialize.c \
                   android_external_e2fsprogs/lib/ext2fs/inline.c \
                   android_external_e2fsprogs/lib/ext2fs/inline_data.c \
                   android_external_e2fsprogs/lib/ext2fs/inode.c \
                   android_external_e2fsprogs/lib/ext2fs/io_manager.c \
                   android_external_e2fsprogs/lib/ext2fs/ismounted.c \
                   android_external_e2fsprogs/lib/ext2fs/link.c \
                   android_external_e2fsprogs/lib/ext2fs/llseek.c \
                   android_external_e2fsprogs/lib/ext2fs/lookup.c \
                   android_external_e2fsprogs/lib/ext2fs/mmp.c \
                   android_external_e2fsprogs/lib/ext2fs/mkdir.c \
                   android_external_e2fsprogs/lib/ext2fs/mkjournal.c \
                   android_external_e2fsprogs/lib/ext2fs/namei.c \
                   android_external_e2fsprogs/lib/ext2fs/native.c \
                   android_external_e2fsprogs/lib/ext2fs/newdir.c \
                   android_external_e2fsprogs/lib/ext2fs/nls_utf8.c \
                   android_external_e2fsprogs/lib/ext2fs/openfs.c \
                   android_external_e2fsprogs/lib/ext2fs/progress.c \
                   android_external_e2fsprogs/lib/ext2fs/punch.c \
                   android_external_e2fsprogs/lib/ext2fs/qcow2.c \
                   android_external_e2fsprogs/lib/ext2fs/rbtree.c \
                   android_external_e2fsprogs/lib/ext2fs/read_bb.c \
                   android_external_e2fsprogs/lib/ext2fs/read_bb_file.c \
                   android_external_e2fsprogs/lib/ext2fs/res_gdt.c \
                   android_external_e2fsprogs/lib/ext2fs/rw_bitmaps.c \
                   android_external_e2fsprogs/lib/ext2fs/sha256.c \
                   android_external_e2fsprogs/lib/ext2fs/sha512.c \
                   android_external_e2fsprogs/lib/ext2fs/swapfs.c \
                   android_external_e2fsprogs/lib/ext2fs/symlink.c \
                   android_external_e2fsprogs/lib/ext2fs/undo_io.c \
                   android_external_e2fsprogs/lib/ext2fs/unix_io.c \
                   android_external_e2fsprogs/lib/ext2fs/sparse_io.c \
                   android_external_e2fsprogs/lib/ext2fs/unlink.c \
                   android_external_e2fsprogs/lib/ext2fs/valid_blk.c \
                   android_external_e2fsprogs/lib/ext2fs/version.c \
                   android_external_e2fsprogs/lib/ext2fs/test_io.c

LOCAL_CFLAGS += -Wno-unused-parameter \
                -Iandroid_external_e2fsprogs/lib/ext2fs \
                -Iandroid_external_e2fsprogs/lib \
                -Icore/libsparse/include

LOCAL_STATIC_LIBRARIES := libext2_com_err \
                          libsparse \
                          libz \
                          libext2_uuid

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libext2_quota
LOCAL_SRC_FILES := android_external_e2fsprogs/lib/support/dict.c \
                   android_external_e2fsprogs/lib/support/mkquota.c \
                   android_external_e2fsprogs/lib/support/parse_qtype.c \
                   android_external_e2fsprogs/lib/support/plausible.c \
                   android_external_e2fsprogs/lib/support/profile.c \
                   android_external_e2fsprogs/lib/support/profile_helpers.c \
                   android_external_e2fsprogs/lib/support/prof_err.c \
                   android_external_e2fsprogs/lib/support/quotaio.c \
                   android_external_e2fsprogs/lib/support/quotaio_tree.c \
                   android_external_e2fsprogs/lib/support/quotaio_v2.c

LOCAL_CFLAGS += -Iandroid_external_e2fsprogs/lib \
                -Iandroid_external_e2fsprogs/lib/support

LOCAL_STATIC_LIBRARIES := libext2fs \
                          libext2_blkid \
                          libext2_com_err

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libcrypto
LOCAL_SRC_FILES := prebuilts/libcrypto.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libcrypto_utils
LOCAL_SRC_FILES := prebuilts/libcrypto_utils.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libcutils
LOCAL_SRC_FILES := core/libcutils/sockets.cpp \
                   core/libcutils/android_get_control_file.cpp \
                   core/libcutils/socket_inaddr_any_server_unix.cpp \
                   core/libcutils/socket_local_client_unix.cpp \
                   core/libcutils/socket_local_server_unix.cpp \
                   core/libcutils/socket_network_client_unix.cpp \
                   core/libcutils/sockets_unix.cpp \
                   core/libcutils/config_utils.cpp \
                   core/libcutils/canned_fs_config.cpp \
                   core/libcutils/iosched_policy.cpp \
                   core/libcutils/load_file.cpp \
                   core/libcutils/native_handle.cpp \
                   core/libcutils/record_stream.cpp \
                   core/libcutils/strlcpy.c \
                   core/libcutils/threads.cpp \
                   core/libcutils/ashmem-host.cpp \
                   core/libcutils/fs_config.cpp \
                   core/libcutils/trace-host.cpp \
                   core/libcutils/android_reboot.cpp \
                   core/libcutils/ashmem-dev.cpp \
                   core/libcutils/klog.cpp \
                   core/libcutils/partition_utils.cpp \
                   core/libcutils/properties.cpp \
                   core/libcutils/qtaguid.cpp \
                   core/libcutils/trace-dev.cpp \
                   core/libcutils/uevent.cpp

LOCAL_CFLAGS += -Werror \
                -Wall \
                -Wextra \
                -D_GNU_SOURCE \
                -Icore/libcutils \
                -Icore/libcutils/include \
                -Icore/libutils/include \
                -Icore/base/include \
                -Icore/liblog/include

LOCAL_STATIC_LIBRARIES := liblog \
                          libbase

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libcgrouprc_format
LOCAL_SRC_FILES := core/libprocessgroup/cgrouprc_format/cgroup_controller.cpp

LOCAL_CFLAGS += -Wall \
                -Werror \
                -Icore/libprocessgroup/cgrouprc_format/include

LOCAL_STATIC_LIBRARIES := libbase

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libcgrouprc
LOCAL_SRC_FILES := core/libprocessgroup/cgrouprc/cgroup_controller.cpp \
                   core/libprocessgroup/cgrouprc/cgroup_file.cpp

LOCAL_CFLAGS += -Wall \
                -Werror \
                -Icore/libprocessgroup/cgrouprc_format/include \
                -Icore/libprocessgroup/cgrouprc/include \
                -Icore/libprocessgroup/include \
                -Icore/base/include

LOCAL_STATIC_LIBRARIES := libbase \
                          libcgrouprc_format

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libjsoncpp
LOCAL_SRC_FILES := jsoncpp/src/lib_json/json_reader.cpp \
                   jsoncpp/src/lib_json/json_value.cpp \
                   jsoncpp/src/lib_json/json_writer.cpp

LOCAL_CFLAGS += -DJSON_USE_EXCEPTION=0 \
                -Wall \
                -Werror \
                -Wno-implicit-fallthrough \
                -Ijsoncpp/src/lib_json \
                -Ijsoncpp/include

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libprocessgroup
LOCAL_SRC_FILES := core/libprocessgroup/cgroup_map.cpp \
                   core/libprocessgroup/processgroup.cpp \
                   core/libprocessgroup/sched_policy.cpp \
                   core/libprocessgroup/task_profiles.cpp

LOCAL_CFLAGS += -Wall \
                -Wexit-time-destructors \
                -Icore/libcutils/include \
                -Icore/libprocessgroup/include \
                -Icore/base/include \
                -Icore/libprocessgroup \
                -Icore/libprocessgroup/cgrouprc/include \
                -Ijsoncpp/include

LOCAL_STATIC_LIBRARIES := libbase \
                          libcgrouprc \
                          libjsoncpp

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libdl_android
LOCAL_SRC_FILES := prebuilts/libdl_android.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libdl
LOCAL_SRC_FILES := prebuilts/libdl.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libvndksupport
LOCAL_SRC_FILES := core/libvndksupport/linker.cpp

LOCAL_CFLAGS += -Wall \
                -Werror \
                -Icore/libvndksupport/include \
                -Icore/libvndksupport/include/vndksupport \
                -Icore/liblog/include

LOCAL_STATIC_LIBRARIES := liblog

LOCAL_SHARED_LIBRARIES := libdl_android

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libutils
LOCAL_SRC_FILES := core/libutils/Errors.cpp \
                   core/libutils/FileMap.cpp \
                   core/libutils/JenkinsHash.cpp \
                   core/libutils/NativeHandle.cpp \
                   core/libutils/Printer.cpp \
                   core/libutils/PropertyMap.cpp \
                   core/libutils/RefBase.cpp \
                   core/libutils/SharedBuffer.cpp \
                   core/libutils/StopWatch.cpp \
                   core/libutils/String8.cpp \
                   core/libutils/String16.cpp \
                   core/libutils/StrongPointer.cpp \
                   core/libutils/SystemClock.cpp \
                   core/libutils/Threads.cpp \
                   core/libutils/Timers.cpp \
                   core/libutils/Tokenizer.cpp \
                   core/libutils/Unicode.cpp \
                   core/libutils/VectorImpl.cpp \
                   core/libutils/misc.cpp \
                   core/libutils/Trace.cpp \
                   core/libutils/Looper.cpp

LOCAL_CFLAGS += -Werror \
                -Wall \
                -fvisibility=protected \
                -Icore/liblog/include \
                -Icore/libcutils/include \
                -Icore/libprocessgroup/include \
                -Icore/libbacktrace/include \
                -Icore/libutils/include \
                -Icore/base/include \
                -Icore/libsystem/include \
                -Icore/libvndksupport/include

LOCAL_STATIC_LIBRARIES := libcutils \
                          liblog \
                          libprocessgroup \
                          libdl \
                          libvndksupport

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libext4_utils
LOCAL_SRC_FILES := extras/ext4_utils/ext4_utils.cpp \
                   extras/ext4_utils/wipe.cpp \
                   extras/ext4_utils/ext4_sb.cpp

LOCAL_CFLAGS += -Werror \
                -fno-strict-aliasing \
                -Iextras/ext4_utils/include \
                -Icore/base/include

LOCAL_STATIC_LIBRARIES := libbase \
                          libz \
                          libcutils \
                          libext2_uuid

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := liblp
LOCAL_SRC_FILES := core/fs_mgr/liblp/builder.cpp \
                   core/fs_mgr/liblp/images.cpp \
                   core/fs_mgr/liblp/partition_opener.cpp \
                   core/fs_mgr/liblp/property_fetcher.cpp \
                   core/fs_mgr/liblp/reader.cpp \
                   core/fs_mgr/liblp/utility.cpp \
                   core/fs_mgr/liblp/writer.cpp

LOCAL_CFLAGS += -D_FILE_OFFSET_BITS=64 \
                -Icore/fs_mgr/liblp/include \
                -Iextras/ext4_utils/include \
                -Icore/base/include \
                -Icore/libsparse/include \
                -Icore/libcutils/include \
                -Icore/liblog/include \
                -Iboringssl/include

LOCAL_STATIC_LIBRARIES := libbase \
                          liblog \
                          libsparse \
                          libext4_utils \
                          libz \
                          libcutils

LOCAL_SHARED_LIBRARIES := libcrypto \
                          libcrypto_utils

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libdm
LOCAL_SRC_FILES := core/fs_mgr/libdm/dm_table.cpp \
                   core/fs_mgr/libdm/dm_target.cpp \
                   core/fs_mgr/libdm/dm.cpp \
                   core/fs_mgr/libdm/loop_control.cpp \
                   core/fs_mgr/libdm/utility.cpp

LOCAL_CFLAGS += -Icore/fs_mgr/libdm/include \
                -Icore/base/include \
                -Icore/liblog/include \
                -Iandroid_external_e2fsprogs/lib

LOCAL_STATIC_LIBRARIES := libext2_uuid

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libsquashfs_utils
LOCAL_SRC_FILES := extras/squashfs_utils/squashfs_utils.c

LOCAL_CFLAGS += -Werror \
                -Iextras/squashfs_utils \
                -Icore/libcutils/include \
                -Isquashfs-tools/squashfs-tools

LOCAL_STATIC_LIBRARIES := libcutils

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libfec_rs
LOCAL_SRC_FILES := fec/encode_rs_char.c \
                   fec/decode_rs_char.c \
                   fec/init_rs_char.c

LOCAL_CFLAGS += -Wall \
                -Werror \
                -O3 \
                -Ifec

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libavb
LOCAL_SRC_FILES := avb/libavb/avb_chain_partition_descriptor.c \
                   avb/libavb/avb_cmdline.c \
                   avb/libavb/avb_crc32.c \
                   avb/libavb/avb_crypto.c \
                   avb/libavb/avb_descriptor.c \
                   avb/libavb/avb_footer.c \
                   avb/libavb/avb_hash_descriptor.c \
                   avb/libavb/avb_hashtree_descriptor.c \
                   avb/libavb/avb_kernel_cmdline_descriptor.c \
                   avb/libavb/avb_property_descriptor.c \
                   avb/libavb/avb_rsa.c \
                   avb/libavb/avb_sha256.c \
                   avb/libavb/avb_sha512.c \
                   avb/libavb/avb_slot_verify.c \
                   avb/libavb/avb_util.c \
                   avb/libavb/avb_vbmeta_image.c \
                   avb/libavb/avb_version.c \
                   avb/libavb/avb_sysdeps_posix.c

LOCAL_CFLAGS += -D_FILE_OFFSET_BITS=64 \
                -D_POSIX_C_SOURCE=199309L \
                -Wa,--noexecstack \
                -Werror \
                -Wall \
                -Wextra \
                -Wformat=2 \
                -Wmissing-prototypes \
                -Wno-psabi \
                -Wno-unused-parameter \
                -Wno-format \
                -ffunction-sections \
                -fstack-protector-strong \
                -g \
                -DAVB_ENABLE_DEBUG \
                -DAVB_COMPILATION \
                -Iavb/libavb

LOCAL_CPPFLAGS += -Wnon-virtual-dtor \
                  -fno-strict-aliasing

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libfec
LOCAL_SRC_FILES := extras/libfec/fec_open.cpp \
                   extras/libfec/fec_read.cpp \
                   extras/libfec/fec_verity.cpp \
                   extras/libfec/fec_process.cpp \
                   extras/libfec/avb_utils.cpp

LOCAL_CFLAGS += -Wall \
                -Werror \
                -O3 \
                -D_LARGEFILE64_SOURCE \
                -Ifec \
                -Iavb \
                -Iextras/libfec/include \
                -Icore/libcrypto_utils/include \
                -Iextras/ext4_utils/include \
                -Iextras/squashfs_utils \
                -Icore/base/include \
                -Icore/libcutils/include \
                -Icore/libutils/include \
                -Iboringssl/include

LOCAL_STATIC_LIBRARIES := libbase \
                          libcutils \
                          libext4_utils \
                          libsquashfs_utils \
                          libfec_rs \
                          libavb

LOCAL_SHARED_LIBRARIES := libcrypto \
                          libcrypto_utils

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libpcre2
LOCAL_SRC_FILES := pcre/dist2/src/pcre2_auto_possess.c \
                   pcre/dist2//src/pcre2_compile.c \
                   pcre/dist2//src/pcre2_config.c \
                   pcre/dist2//src/pcre2_context.c \
                   pcre/dist2//src/pcre2_convert.c \
                   pcre/dist2//src/pcre2_dfa_match.c \
                   pcre/dist2//src/pcre2_error.c \
                   pcre/dist2//src/pcre2_extuni.c \
                   pcre/dist2//src/pcre2_find_bracket.c \
                   pcre/dist2//src/pcre2_maketables.c \
                   pcre/dist2//src/pcre2_match.c \
                   pcre/dist2//src/pcre2_match_data.c \
                   pcre/dist2//src/pcre2_jit_compile.c \
                   pcre/dist2//src/pcre2_newline.c \
                   pcre/dist2//src/pcre2_ord2utf.c \
                   pcre/dist2//src/pcre2_pattern_info.c \
                   pcre/dist2//src/pcre2_script_run.c \
                   pcre/dist2//src/pcre2_serialize.c \
                   pcre/dist2//src/pcre2_string_utils.c \
                   pcre/dist2//src/pcre2_study.c \
                   pcre/dist2//src/pcre2_substitute.c \
                   pcre/dist2//src/pcre2_substring.c \
                   pcre/dist2//src/pcre2_tables.c \
                   pcre/dist2//src/pcre2_ucd.c \
                   pcre/dist2//src/pcre2_valid_utf.c \
                   pcre/dist2//src/pcre2_xclass.c \
                   pcre/dist2//src/pcre2_chartables.c

LOCAL_CFLAGS += -DHAVE_CONFIG_H \
                -Wall \
                -Werror \
                -Ipcre/include \
                -Ipcre/include_internal

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libpackagelistparser
LOCAL_SRC_FILES := core/libpackagelistparser/packagelistparser.cpp

LOCAL_CFLAGS += -Icore/libpackagelistparser/include \
                -Icore/liblog/include

LOCAL_STATIC_LIBRARIRES := liblog

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libselinux
LOCAL_SRC_FILES := selinux/libselinux/src/booleans.c \
                   selinux/libselinux/src/callbacks.c \
                   selinux/libselinux/src/freecon.c \
                   selinux/libselinux/src/label_backends_android.c \
                   selinux/libselinux/src/label.c \
                   selinux/libselinux/src/label_support.c \
                   selinux/libselinux/src/matchpathcon.c \
                   selinux/libselinux/src/setrans_client.c \
                   selinux/libselinux/src/sha1.c \
                   selinux/libselinux/src/android/android.c \
                   selinux/libselinux/src/avc.c \
                   selinux/libselinux/src/avc_internal.c \
                   selinux/libselinux/src/avc_sidtab.c \
                   selinux/libselinux/src/canonicalize_context.c \
                   selinux/libselinux/src/checkAccess.c \
                   selinux/libselinux/src/check_context.c \
                   selinux/libselinux/src/compute_av.c \
                   selinux/libselinux/src/compute_create.c \
                   selinux/libselinux/src/compute_member.c \
                   selinux/libselinux/src/context.c \
                   selinux/libselinux/src/deny_unknown.c \
                   selinux/libselinux/src/disable.c \
                   selinux/libselinux/src/enabled.c \
                   selinux/libselinux/src/fgetfilecon.c \
                   selinux/libselinux/src/fsetfilecon.c \
                   selinux/libselinux/src/getenforce.c \
                   selinux/libselinux/src/getfilecon.c \
                   selinux/libselinux/src/get_initial_context.c \
                   selinux/libselinux/src/getpeercon.c \
                   selinux/libselinux/src/init.c \
                   selinux/libselinux/src/lgetfilecon.c \
                   selinux/libselinux/src/load_policy.c \
                   selinux/libselinux/src/lsetfilecon.c \
                   selinux/libselinux/src/mapping.c \
                   selinux/libselinux/src/policyvers.c \
                   selinux/libselinux/src/procattr.c \
                   selinux/libselinux/src/reject_unknown.c \
                   selinux/libselinux/src/sestatus.c \
                   selinux/libselinux/src/setenforce.c \
                   selinux/libselinux/src/setfilecon.c \
                   selinux/libselinux/src/stringrep.c \
                   selinux/libselinux/src/label_file.c \
                   selinux/libselinux/src/regex.c \
                   selinux/libselinux/src/android/android_host.c \
                   selinux/libselinux/src/setexecfilecon.c \
                   selinux/libselinux/src/android/android_platform.c

LOCAL_CFLAGS += -DNO_PERSISTENTLY_STORED_PATTERNS \
                -DDISABLE_SETRANS \
                -DDISABLE_BOOL \
                -D_GNU_SOURCE \
                -DNO_MEDIA_BACKEND \
                -DNO_X_BACKEND \
                -DNO_DB_BACKEND \
                -Wall \
                -Werror \
                -Wno-error=missing-noreturn \
                -Wno-error=unused-function \
                -Wno-error=unused-variable \
                -DAUDITD_LOG_TAG=1003 \
                -DUSE_PCRE2 \
                -DNO_FILE_BACKEND \
                -Iselinux/libselinux/src \
                -Iselinux/libselinux/include \
                -Icore/libcutils/include \
                -Icore/liblog/include \
                -Ipcre/include \
                -Icore/libpackagelistparser/include

LOCAL_STATIC_LIBRARIES := liblog \
                          libpackagelistparser \
                          libpcre2

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libgsi
LOCAL_SRC_FILES := gsid/libgsi.cpp

LOCAL_CFLAGS += -Igsid/include \
                -Icore/base/include

LOCAL_STATIC_LIBRARIRES := libbase

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libfstab
LOCAL_SRC_FILES := core/fs_mgr/fs_mgr_fstab.cpp \
                   core/fs_mgr/fs_mgr_boot_config.cpp \
                   core/fs_mgr/fs_mgr_slotselect.cpp

LOCAL_CFLAGS += -Wall \
                -Werror \
                -Icore/fs_mgr/include \
                -Icore/fs_mgr/include_fstab \
                -Igsid/include \
                -Icore/base/include

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libfs_avb
LOCAL_SRC_FILES := core/fs_mgr/libfs_avb/avb_ops.cpp \
                   core/fs_mgr/libfs_avb/avb_util.cpp \
                   core/fs_mgr/libfs_avb/fs_avb.cpp \
                   core/fs_mgr/libfs_avb/fs_avb_util.cpp \
                   core/fs_mgr/libfs_avb/types.cpp \
                   core/fs_mgr/libfs_avb/util.cpp

LOCAL_CFLAGS += -Icore/fs_mgr/libfs_avb/include \
                -Icore/fs_mgr/include \
                -Icore/fs_mgr/include_fstab \
                -Iavb \
                -Icore/base/include \
                -Icore/libutils/include \
                -Ifmtlib/include \
                -Igsid/include \
                -Iboringssl/include \
                -Icore/fs_mgr/libdm/include

LOCAL_STATIC_LIBRARIES := libavb \
                          libdm \
                          libgsi \
                          libfstab \
                          libbase

LOCAL_SHARED_LIBRARIES := libcrypto

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := liblogwrap
LOCAL_SRC_FILES := core/logwrapper/logwrap.cpp

LOCAL_CFLAGS += -Werror \
                -Icore/logwrapper/include \
                -Icore/base/include \
                -Icore/libcutils/include \
                -Icore/liblog/include

LOCAL_STATIC_LIBRARIES := libcutils \
                          liblog

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libkeyutils
LOCAL_SRC_FILES := core/libkeyutils/keyutils.cpp

LOCAL_CFLAGS += -Werror \
                -Icore/libkeyutils/include

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libfscrypt
LOCAL_SRC_FILES := extras/libfscrypt/fscrypt.cpp

LOCAL_CFLAGS += -Iextras/libfscrypt/include \
                -Icore/base/include \
                -Icore/libcutils/include \
                -Icore/libutils/include \
                -Icore/logwrapper/include

LOCAL_STATIC_LIBRARIES := libbase \
                          libcutils \
                          libkeyutils \
                          liblogwrap

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libfs_mgr
LOCAL_SRC_FILES := core/fs_mgr/file_wait.cpp \
                   core/fs_mgr/fs_mgr.cpp \
                   core/fs_mgr/fs_mgr_format.cpp \
                   core/fs_mgr/fs_mgr_verity.cpp \
                   core/fs_mgr/fs_mgr_dm_linear.cpp \
                   core/fs_mgr/fs_mgr_overlayfs.cpp \
                   core/fs_mgr/fs_mgr_roots.cpp \
                   core/fs_mgr/fs_mgr_vendor_overlay.cpp \
                   core/fs_mgr/libfiemap/fiemap_writer.cpp \
                   core/fs_mgr/libfiemap/fiemap_status.cpp \
                   core/fs_mgr/libfiemap/image_manager.cpp \
                   core/fs_mgr/libfiemap/metadata.cpp \
                   core/fs_mgr/libfiemap/split_fiemap_writer.cpp \
                   core/fs_mgr/libfiemap/utility.cpp \
                   core/fs_mgr/libfiemap/passthrough.cpp

LOCAL_CFLAGS += -Wall \
                -D_FILE_OFFSET_BITS=64 \
                -DALLOW_ADBD_DISABLE_VERITY=1 \
                -Icore/fs_mgr/include \
                -Icore/fs_mgr/libfs_avb/include \
                -Icore/fs_mgr/include_fstab \
                -Icore/fs_mgr/libdm/include \
                -Icore/fs_mgr/liblp/include \
                -Icore/fs_mgr/libfiemap/include \
                -Icore/fs_mgr/libstorage_literals \
                -Icore/base/include \
                -Icore/libcutils/include \
                -Iextras/ext4_utils/include \
                -Iavb \
                -Iextras/libfscrypt/include \
                -Icore/liblog/include \
                -Icore/logwrapper/include \
                -Iselinux/libselinux/include \
                -Ivold \
                -Icore/libcrypto_utils/include \
                -Iboringssl/include \
                -Iextras/libfec/include \
                -Icore/fs_mgr \
                -Igsid/include

LOCAL_STATIC_LIBRARIES := libbase \
                          libcutils \
                          libext4_utils \
                          libfec \
                          liblog \
                          liblp \
                          libselinux \
                          libavb \
                          libfs_avb \
                          libfstab \
                          libdm \
                          libgsi \
                          liblogwrap \
                          libext2_uuid \
                          libfscrypt

LOCAL_SHARED_LIBRARIES := libcrypto \
                          libcrypto_utils

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := resize2fs
LOCAL_SRC_FILES := android_external_e2fsprogs/resize/extent.c \
                   android_external_e2fsprogs/resize/resize2fs.c \
                   android_external_e2fsprogs/resize/main.c \
                   android_external_e2fsprogs/resize/online.c \
                   android_external_e2fsprogs/resize/sim_progress.c \
                   android_external_e2fsprogs/resize/resource_track.c

LOCAL_CFLAGS += -Iandroid_external_e2fsprogs/lib

LOCAL_STATIC_LIBRARIES := libext2fs \
                          libext2_com_err \
                          libext2_e2p \
                          libext2_uuid \
                          libext2_blkid

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := e2fsck
LOCAL_SRC_FILES := android_external_e2fsprogs/e2fsck/e2fsck.c \
                   android_external_e2fsprogs/e2fsck/super.c \
                   android_external_e2fsprogs/e2fsck/pass1.c \
                   android_external_e2fsprogs/e2fsck/pass1b.c \
                   android_external_e2fsprogs/e2fsck/pass2.c \
                   android_external_e2fsprogs/e2fsck/pass3.c \
                   android_external_e2fsprogs/e2fsck/pass4.c \
                   android_external_e2fsprogs/e2fsck/pass5.c \
                   android_external_e2fsprogs/e2fsck/logfile.c \
                   android_external_e2fsprogs/e2fsck/journal.c \
                   android_external_e2fsprogs/e2fsck/recovery.c \
                   android_external_e2fsprogs/e2fsck/revoke.c \
                   android_external_e2fsprogs/e2fsck/badblocks.c \
                   android_external_e2fsprogs/e2fsck/util.c \
                   android_external_e2fsprogs/e2fsck/unix.c \
                   android_external_e2fsprogs/e2fsck/dirinfo.c \
                   android_external_e2fsprogs/e2fsck/dx_dirinfo.c \
                   android_external_e2fsprogs/e2fsck/ehandler.c \
                   android_external_e2fsprogs/e2fsck/problem.c \
                   android_external_e2fsprogs/e2fsck/message.c \
                   android_external_e2fsprogs/e2fsck/ea_refcount.c \
                   android_external_e2fsprogs/e2fsck/quota.c \
                   android_external_e2fsprogs/e2fsck/rehash.c \
                   android_external_e2fsprogs/e2fsck/region.c \
                   android_external_e2fsprogs/e2fsck/sigcatcher.c \
                   android_external_e2fsprogs/e2fsck/readahead.c \
                   android_external_e2fsprogs/e2fsck/extents.c

LOCAL_CFLAGS += -Wno-sign-compare \
                -fno-strict-aliasing \
                -Iandroid_external_e2fsprogs/lib

LOCAL_STATIC_LIBRARIES := libext2fs \
                          libext2_blkid \
                          libext2_com_err \
                          libext2_uuid \
                          libext2_quota \
                          libext2_e2p

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := simg2img
LOCAL_SRC_FILES := core/libsparse/simg2img.cpp \
                   core/libsparse/sparse_crc32.cpp

LOCAL_CFLAGS += -Werror \
                -Icore/libsparse/include \
                -Icore/base/include

LOCAL_STATIC_LIBRARIES := libsparse \
                          libz \
                          libbase

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := img2simg
LOCAL_SRC_FILES := core/libsparse/img2simg.cpp

LOCAL_CFLAGS += -Werror \
                -Icore/libsparse/include \
                -Icore/base/include

LOCAL_STATIC_LIBRARIES := libsparse \
                          libz \
                          libbase

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := lptools
LOCAL_SRC_FILES := lptools.cc

LOCAL_CFLAGS += -Wextra \
                -DLPTOOLS_STATIC \
                -D_FILE_OFFSET_BITS=64 \
                -Icore/base/include \
                -Icore/libcutils/include \
                -Icore/fs_mgr \
                -Icore/fs_mgr/include \
                -Icore/fs_mgr/liblp/include \
                -Icore/fs_mgr/libdm/include \
                -Icore/fs_mgr/include_fstab

LOCAL_STATIC_LIBRARIES := libbase \
                          liblog \
                          liblp \
                          libsparse \
                          libfs_mgr \
                          libutils \
                          libcutils \
                          libdm \
                          libext4_utils

LOCAL_SHARED_LIBRARIES := libcrypto

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := losetup
LOCAL_SRC_FILES := util-linux-2.27/lib/at.c \
                   util-linux-2.27/lib/blkdev.c \
                   util-linux-2.27/lib/canonicalize.c \
                   util-linux-2.27/lib/crc32.c \
                   util-linux-2.27/lib/crc64.c \
                   util-linux-2.27/lib/env.c \
                   util-linux-2.27/lib/fileutils.c \
                   util-linux-2.27/lib/ismounted.c \
                   util-linux-2.27/lib/color-names.c \
                   util-linux-2.27/lib/mangle.c \
                   util-linux-2.27/lib/match.c \
                   util-linux-2.27/lib/mbsalign.c \
                   util-linux-2.27/lib/md5.c \
                   util-linux-2.27/lib/pager.c \
                   util-linux-2.27/lib/path.c \
                   util-linux-2.27/lib/procutils.c \
                   util-linux-2.27/lib/randutils.c \
                   util-linux-2.27/lib/setproctitle.c \
                   util-linux-2.27/lib/strutils.c \
                   util-linux-2.27/lib/sysfs.c \
                   util-linux-2.27/lib/timeutils.c \
                   util-linux-2.27/lib/ttyutils.c \
                   util-linux-2.27/lib/exec_shell.c \
                   util-linux-2.27/lib/strv.c \
                   util-linux-2.27/lib/linux_version.c \
                   util-linux-2.27/lib/loopdev.c \
                   util-linux-2.27/lib/colors.c \
                   util-linux-2.27/libsmartcols/src/iter.c \
                   util-linux-2.27/libsmartcols/src/symbols.c \
                   util-linux-2.27/libsmartcols/src/cell.c \
                   util-linux-2.27/libsmartcols/src/column.c \
                   util-linux-2.27/libsmartcols/src/line.c \
                   util-linux-2.27/libsmartcols/src/table.c \
                   util-linux-2.27/libsmartcols/src/table_print.c \
                   util-linux-2.27/libsmartcols/src/version.c \
                   util-linux-2.27/libsmartcols/src/init.c \
                   util-linux-2.27/sys-utils/losetup.c

LOCAL_CFLAGS += -include /root/ndk/android-ndk-r22b/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/sys/sysmacros.h \
                -Iutil-linux-2.27 \
                -Iutil-linux-2.27/include \
                -Iutil-linux-2.27/libsmartcols/src \
                -D__USE_FILE_OFFSET64=1 \
                -D__USE_LARGEFILE64=1 \
                -D_LARGEFILE64_SOURCE=1 \
                -D_FILE_OFFSET_BITS=64 \
                -D_FILE_OFFSET_BIT=64 \
                -D_LARGEFILE_SOURCE=1 \
                -DHAVE_NANOSLEEP=1 \
                -D_PATH_TMP='"/data/local/tmp"' \
                -DHAVE_SYSCONF=0 \
                -DHAVE_ERRX=0 \
                -DHAVE_SYS_TTYDEFAULTS_H=1 \
                -DPACKAGE_STRING='"util-linux 2.27"' \
                -DHAVE_FSYNC=0

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := superrepack.arm64_pie
LOCAL_SRC_FILES := superrepack.c
LOCAL_CFLAGS += -Iinclude
LOCAL_STATIC_LIBRARIES := libfs_mgr
include $(BUILD_EXECUTABLE)
