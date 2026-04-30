#!/bin/sh
#
# build_for_pack.sh - Build script for odbfilter in a pack environment
#
# This script configures and builds the project using CMake in a specific
# pack environment (CY49T1, CY50T2, etc.). It sets up the required
# environment variables, paths, and compiler settings for the build.
#
# Usage: ./build_for_pack.sh
#

# Print environment information
echo "====================="
echo "Environment from pack"
echo "====================="

# Load required modules
module load cmake/3.15.4

# Environment setup for CY49T1 (Cycles 49, Type 1)
# This sets up Intel compiler and MPI environment
source ~gco/apps/mkpack/support/wrapper/env_intel-mpi-2018.05.274_auxlib-014R64
BUILDDIR=build-49

# Environment setup for CY50T2 (Cycles 50, Type 2) - Commented out
#source ~mary/.gmkpack/env/env_intel-mpi-2023.2-eccodes2.44.0
#BUILDDIR=build-50

# Pack root directory (contains ODB, libraries, and dependencies)
export PACK=/home/gmap/mrpe/arbogaste/pack/cy49t1_op1.07.IMPIIFC2018DP.x

# Pack type: "main" for production, "local" for development
export TYPE_PACK=main

# Extract NetCDF library paths from pack configuration
# LD_USR_NETCDF_F: Fortran NetCDF library path
# LD_USR_NETCDF: C NetCDF library path
NCDFF=`grep "LD_USR_NETCDF_F " $PACK/.gmkfile/* | cut -d\  -f 3`
NCDF=`grep "LD_USR_NETCDF " $PACK/.gmkfile/* | cut -d\  -f 3`

# Add NetCDF libraries to LD_LIBRARY_PATH for runtime
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NCDFF:$NCDF

# ODB compiler and flags
export ODB_COMPILER=$PACK/sys
export ODB_COMPILER_FLAGS=$PACK/src/$TYPE_PACK/odb/ddl.CCMA/odb98.flags

# ODB helper scripts
export ODB_CREATE_IOASSIGN=$PACK/src/$TYPE_PACK/odb/scripts/create_ioassign
export ODB_SYSPATH=$PACK/src/$TYPE_PACK/odb/ddl.CCMA

# ODB C compiler flags (without OML support)
export ODB_CC="gcc -DWITHOUT_OML"

# Print build information
echo "=============="
echo "Build, Install"
echo "=============="

# Clean previous build and install directories
rm -rf build install

# Configure with CMake
# - Use Intel compilers (icc, icpc, ifort)
# - Set ODB and NetCDF paths
# - Enable Fiat library support
# - Install to local "install" directory
cmake . \
  -DCMAKE_C_COMPILER=icc \
  -DCMAKE_CXX_COMPILER=icpc \
  -DCMAKE_Fortran_COMPILER=ifort \
  -DCMAKE_Fortran_COMPILER_ID=Intel \
  -DODB_COMPILER=$ODB_COMPILER \
  \
  -DLIBNCDF=$NCDF \
  -DLIBNCDFF=$NCDFF \
  -DINC_CMA=$PACK/src/$TYPE_PACK/odb/ddl \
  -DINC_ODB=$PACK/src/$TYPE_PACK/odb/module \
  -DFIAT_DIR=$PACK/hub/$TYPE_PACK/install/Fiat \
  -DTYPE_PACK=$TYPE_PACK \
  -DPACK=$PACK \
  \
  -DCMAKE_INSTALL_PREFIX=install \
  -B build

# Build and install
cd build
make -j10
make install
