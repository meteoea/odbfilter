#ifndef _MEMMAP_H_
#define _MEMMAP_H_

/* memmap.h */

/* Memory mapped I/O */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#ifndef HAS_MMAP

#if defined(LINUX) || defined(__APPLE__)
#define HAS_MMAP
#endif

#endif

#ifdef HAS_MMAP

#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#endif

typedef struct {
  caddr_t buf;
  size_t len;
  off_t offset;
} memmap_t;

extern memmap_t *memmap_open_read(int fd, const off_t *Offset, const size_t *Len);
extern int memmap_close(memmap_t *m);
extern memmap_t *memmap_alloc(size_t Len, int Shared);

#endif
