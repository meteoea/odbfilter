#!/bin/bash

# Setup environment for compilation
PACK=`pwd`
if [ ! -d .gmkfile ] ; then
  echo "Error: Install odbfilter in a pack directory."
  exit
fi
GCOHOME=~gco
GMKFILE=`ls $PACK/.gmkfile`
ENV=`grep GMK_LOCAL_PROFILE $PACK/.gmkfile/$GMKFILE | cut -d\  -f 3`
ENV=`eval echo $ENV`
. $ENV

FDIR=$PACK/odbfilter
rm -rf $FDIR
mkdir -p $FDIR

TYPE_PACK=local
if [ -d $PACK/src/main ] ; then
  TYPE_PACK=main
fi

F90=`grep FRTNAME $PACK/.gmkfile/$GMKFILE | cut -d\  -f 3`
F90=`eval echo $F90`
if [ -z "$F90" ] ; then
  echo "Error: Fortran compiler not found for this pack"
  exit
fi

NCDFF=`grep "LD_USR_NETCDF_F " $PACK/.gmkfile/$GMKFILE | cut -d\  -f 3`
NCDF=`grep "LD_USR_NETCDF " $PACK/.gmkfile/$GMKFILE | cut -d\  -f 3`
#LIBNCDFF=${NCDFF%/libnetcdff.a}
LIBNCDFF=${NCDFF%/libnetcdff.so}
LIBNCDF=${NCDF%/libnetcdf.so}

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LIBNCDFF:$LIBNCDF
export ODB_COMPILER_FLAGS=$PACK/src/$TYPE_PACK/odb/ddl.CCMA/odb98.flags
export PATH=$PATH:$PACK/src/$TYPE_PACK/odb/scripts/:$PACK/sys
export ODB_CREATE_IOASSIGN=$PACK/src/$TYPE_PACK/odb/scripts/create_ioassign
export ODB_COMPILER=odb98.x
export ODB_SYSPATH=$PACK/src/$TYPE_PACK/odb/ddl.CCMA
export ODB_CC="gcc -DWITHOUT_OML"

# Make odbfilter

cd $FDIR
FIAT="$PACK/hub/$TYPE_PACK/install/Fiat"
INCFIAT=""
MODFIAT=""
LIBFIAT=""
if [ -d "$FIAT" ] ; then
  INCFIAT="-I $FIAT/include/fiat -I $FIAT/module/fiat"
  MODFIAT="-I $FIAT/module/fiat"
  LIBFIAT="-L $FIAT/lib64 -lfiat -Wl,-rpath,$FIAT/lib64"
fi
INC_CCMA="-I $PACK/src/$TYPE_PACK/odb/ddl.CCMA"
INC_ECMA="-I $PACK/src/$TYPE_PACK/odb/ddl.ECMA"
INC1="-I $PACK/src/$TYPE_PACK/odb/module"
INC2="-I $PACK/src/$TYPE_PACK/ifsaux/module"
RPATH="-Wl,-rpath,$LIBNCDFF -Wl,-rpath,$LIBNCDF"

CMA_OBJ='_odb_glue.o CCMA_Sstatic.o ECMA_Sstatic.o odb_filter_mod.o'
LIB0="-lcma-odb.$TYPE_PACK -lodb.$TYPE_PACK  -lmain-odb.$TYPE_PACK -lifsaux.$TYPE_PACK"
LIB1="-L $LIBNCDF -lnetcdf -L $LIBNCDFF -lnetcdff -lstdc++"

SRCDIR=`dirname $0`
MAINS=filter.F90
CMA_SQL=`cd $SRCDIR; ls *.sql`

gcc -DWITHOUT_OML $INC_CCMA -c $SRCDIR/CCMA_Sstatic.c
gcc -DWITHOUT_OML $INC_ECMA -c $SRCDIR/ECMA_Sstatic.c
gcc -DWITHOUT_OML -c $SRCDIR/_odb_glue.c
$F90 -DWITHOUT_OML $INCFIAT $INC1 $INC2 -g -c $SRCDIR/odb_filter_mod.F90

for sql in $CMA_SQL
do
  CMA_OBJ="$CMA_OBJ CCMA_${sql/.sql/.o} ECMA_${sql/.sql/.o}"
  cp $SRCDIR/$sql .
  odb98.x -c $INC_CCMA  -l CCMA -w  -l CCMA -w $sql
  odb98.x -c $INC_ECMA  -l ECMA -w  -l ECMA -w $sql
  rm -f $sql
done

for main in $MAINS
do
  SRC=$SRCDIR/$main
  EXE=odb_${main%.F90}
  $F90 -qopenmp $INCFIAT $INC1 $INC2 $SRC -g -o $EXE -L $PACK/lib -Wl,--allow-multiple-definition -Wl,--start-group $CMA_OBJ $RPATH $LIB0 -Wl,--end-group $LIB1 $LIBFIAT
done

rm -f *.o *.c *.mod
for tool in CCMA2ECMA create_ioassign
do
 cp $SRCDIR/$tool .
done
echo "PACK=$PACK" > odb_shuffle
cat $SRCDIR/odb_shuffle >> odb_shuffle
chmod +x odb_shuffle

if [ ! -f $PACK/bin/odbtools.x ] ; then   
  echo "Warning: odbtools is missing in this pack."
fi
if [ ! -f $PACK/bin/ioassign ] ; then   
  echo "Warning: ioassign is missing in this pack."
fi

echo "#!/usr/bin/bash" > odbtbx.sh
echo  "PACK=$PACK" >> odbtbx.sh
cat $SRCDIR/odbtbx.sh >> odbtbx.sh
chmod +x odbtbx.sh
echo "#!/usr/bin/bash" > odbtbx_new.sh
echo  "PACK=$PACK" >> odbtbx_new.sh
cat $SRCDIR/odbtbx_new.sh >> odbtbx_new.sh
chmod +x odbtbx_new.sh

module load intel/2018.5.274_mkl_nightly_2019u2
ldd odb_filter
