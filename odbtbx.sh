WORKDIR=`pwd`
BATOR_NBPOOL=`head -n 5 $WORKDIR/CCMA/CCMA.dd | tail -n 1`
LOG=odbtbx.$$
touch $LOG

##############################################################
# Function filter
##############################################################
function filter {
arg=`echo $1 | sed "s/-/ /g"`
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

echo "PACK: $PACK" >> $LOG
echo "BATOR_NBPOOL: $BATOR_NBPOOL" >> $LOG
echo "FILTER: $PACK/odbfilter/odb_filter $arg" >> $LOG

$PACK/odbfilter/odb_filter $arg
obstype=`echo $arg | cut -d\  -f2`
}

##############################################################
# Function: shuffle
##############################################################
function shuffle {
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

echo "SHUFFLE: ./shuffle -iECMA -oCCMA -a$BATOR_NBPOOL -b1 " >> $LOG
./shuffle -iECMA -oCCMA -a$BATOR_NBPOOL -b1 
rm -rf drhook.* ./shuffle ./ECMA ./IOASSIGN ./__ioassign__.*

echo "FG_DEPAR->HIRES@UPDATE1: $PACK/odbfilter/odb_filter fg_depar" >> $LOG
$PACK/odbfilter/odb_filter fg_depar $obstype
}

##############################################################
# MAIN
##############################################################

module load intel/2018.5.274_mkl_nightly_2019u2

while getopts "f:s" arg; do
  case $arg in
    f)
      filter_args=$OPTARG
      filter $filter_args
      ;;
    s)
      shuffle
      ;;
  esac
done
