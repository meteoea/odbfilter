#!/bin/sh
echo "====================="
echo "Environment from pack"
echo "====================="

module load cmake/3.15.4
# CY49T1
source ~gco/apps/mkpack/support/wrapper/env_intel-mpi-2018.05.274_auxlib-014R64
BUILDIR=build-49

# CY50T2
#source ~mary/.gmkpack/env/env_intel-mpi-2023.2-eccodes2.44.0
#BUILDIR=build-50

export PACK=/home/gmap/mrpe/arbogaste/pack/cy49t1_op1.07.IMPIIFC2018DP.x
export TYPE_PACK=main
NCDFF=`grep "LD_USR_NETCDF_F " $PACK/.gmkfile/* | cut -d\  -f 3`
NCDF=`grep "LD_USR_NETCDF " $PACK/.gmkfile/* | cut -d\  -f 3`

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NCDFF:$NCDF
export ODB_COMPILER_FLAGS=$PACK/src/$TYPE_PACK/odb/ddl.CCMA/odb98.flags
export ODB_CREATE_IOASSIGN=$PACK/src/$TYPE_PACK/odb/scripts/create_ioassign
export ODB_SYSPATH=$PACK/src/$TYPE_PACK/odb/ddl.CCMA
export ODB_CC="gcc -DWITHOUT_OML"

echo "=============="
echo "Build, Install"
echo "=============="

rm -rf build install

cmake . \
  -DCMAKE_C_COMPILER=icc \
  -DCMAKE_CXX_COMPILER=icxx \
  -DCMAKE_Fortran_COMPILER=ifort \
  -DCMAKE_Fortran_COMPILER_ID=Intel \
  \
  -DLIBNCDF=$NCDF \
  -DLIBNCDFF=$NCDFF \
  -DINC_CCMA=$PACK/src/$TYPE_PACK/odb/ddl.CCMA \
  -DINC_ECMA=$PACK/src/$TYPE_PACK/odb/ddl.ECMA \
  -DINC1=$PACK/src/$TYPE_PACK/odb/module \
  -DFIAT_DIR=$PACK/hub/$TYPE_PACK/install/Fiat \
  -DTYPE_PACK=$TYPE_PACK \
  -DPACK=$PACK \
  \
  -DCMAKE_INSTALL_PREFIX=install \
  -B build

cd build
make -j10
make install
