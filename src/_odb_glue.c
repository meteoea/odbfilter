/*
 * _odb_glue.c - ODB glue code for odbfilter
 * 
 * This file provides the interface between the ODB (Ocean Data Base) library
 * and the odbfilter application. It sets up entry points for database schemas
 * (CCMA, ECMA) and registers static initializers.
 */

#include <stdio.h>
#include <string.h>

/* Dummy function - ODB context print callback */
void ctxprint_() {}

/* ODB internal function declarations */
extern void
codb_procdata_(int *myproc,
               int *nproc,
               int *pid,
               int *it,
               int *inumt);

/* Function to register a function in ODB's function list */
extern void 
ODB_add2funclist(const char *dbname,
   void (*func)(),
                 int funcno);

/* Macro to initialize a database schema's static data */
#define Static_Init(db) \
if (strncmp(dbname, #db, dbname_len) == 0) { \
  extern void db##_static_init(); \
  ODB_add2funclist(#db, db##_static_init, 0); \
} \
else { /* fprintf(stderr,"***Warning: Not initializing '%s'\n",#db); */ }  

/*
 * Entry point called by ODB to set up database schema initializers
 * Registers static init functions for CCMA and ECMA schemas
 */
void
codb_set_entrypoint_(const char *dbname
               /* Hidden arguments */
               , int dbname_len)
{
  int myproc = 0;
  codb_procdata_(&myproc, NULL, NULL, NULL, NULL);
  if (myproc == 1) {
    fprintf(stderr,
            "codb_set_entrypoint_(dbname='%*s', dbname_len=%d)\n",
            dbname_len, dbname, dbname_len);
  }
  Static_Init(CCMA);
  Static_Init(ECMA);
}

