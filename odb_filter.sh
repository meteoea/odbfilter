PACK=/home/gmap/mrpe/arbogaste/pack/46t1_bf-dev.05.IMPIIFC1805.2y
BATOR_NBPOOL=384

##############################################################
# Filter CCMA
##############################################################
WORKDIR=`pwd`
export ODB_CONSIDER_TABLES="* except /bufr/"
export ODB_SRCPATH_CCMA=$WORKDIR/CCMA
export ODB_DATAPATH_CCMA=$WORKDIR/CCMA
export TO_ODB_ECMWF=0
export TO_ODB_SWAPOUT=0
export ODB_DEBUG=0
export ODB_CTX_DEBUG=0
export ODB_REPRODUCIBLE_SEQNO=4
export ODB_STATIC_LINKING=1
export ODB_IO_METHOD=1
export ODB_CMA=CCMA
export IOASSIGN=$WORKDIR/CCMA/IOASSIGN

$PACK/odbfilter/odb_filter $*

#exit
##############################################################
# Shuffle
##############################################################
unset ODB_CONSIDER_TABLES
unset IOASSIGN

export DR_HOOK=1
export DR_HOOK_IGNORE_SIGNALS=-1
export DR_HOOK_OPT=prof
export DR_HOOK_SILENT=1
export EC_MPI_ATEXIT=0
export EC_PROFILE_HEAP=0
export MPL_MBX_SIZE=1024000000

export KMP_MONITOR_STACKSIZE=128M
export KMP_STACKSIZE=128M
export OMP_STACKSIZE=128M

export ODB_CATCH_SIGNALS=0
export ODB_CMA=ECMA
export ODB_CTX_DEBUG=0
export ODB_DATAPATH_CCMA=$WORKDIR/CCMA
export ODB_DATAPATH_ECMA=$WORKDIR/ECMA
export ODB_ERRTRA=1
export ODB_IO_FILESIZE=32
export ODB_IO_GRPSIZE=$BATOR_NBPOOL
export ODB_IO_LOCK=1
export ODB_IO_METHOD=1
export ODB_IO_OPENMP=0
export ODB_MPEXCHANGE2_PACKMAX=4000000
export ODB_PACKING=-1
export ODB_REPRODUCIBLE_SEQNO=4
export ODB_SRCPATH_CCMA=$WORKDIR/CCMA
export ODB_SRCPATH_ECMA=$WORKDIR/ECMA
export ODB_STATIC_LINKING=1
export ODB_WRITE_EMPTY_FILES=0
export TO_ODB_ECMWF=0
export TO_ODB_SWAPOUT=0
export PATH=$PACK/bin:$PACK/odbfilter:$PATH

# Create IOASSIGN
CCMA2ECMA
ln -s $PACK/bin/odbtools.x shuffle
SWAPP_ODB_IOASSIGN=$PACK/bin/ioassign create_ioassign -l CCMA -n $BATOR_NBPOOL -d $ODB_DATAPATH_CCMA 
cat $ODB_SRCPATH_CCMA/IOASSIGN $ODB_SRCPATH_ECMA/IOASSIGN > IOASSIGN 

./shuffle -iECMA -oCCMA -a$BATOR_NBPOOL -b1 
rm -rf drhook.* ./shuffle ./ECMA ./IOASSIGN ./__ioassign__.*
