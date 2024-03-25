#include <sys/statvfs.h>
#define GB 1073741824

double getTotalDiskSpace() {
    struct statvfs buffer;
    statvfs("/", &buffer);
    const double total = (double)(buffer.f_blocks * buffer.f_frsize) / GB;
    return total;
}

double getUsedDiskSpace() {
    struct statvfs buffer;
    statvfs("/", &buffer);
    const double total = (double)(buffer.f_blocks * buffer.f_frsize) / GB;
    const double available = (double)(buffer.f_bfree * buffer.f_frsize) / GB;
    const double used = total - available;
    return used;
}