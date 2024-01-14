#!/bin/bash
#####################################################
# the tar.gz file should be decompressed in $SPATH
# all packages are installed in $SPATH/intel-software
#####################################################

export CC=mpiicc
export CXX=mpiicpc
export FC=mpiifort
export F90=mpiifort
export F77=mpiifort
export MPIF90=mpiifort
export MPIF77=mpiifort
export MPICC=mpiicc
export MPICXX=mpiicpc

SPATH=/home/mppadmin/software #software path, the tar.gz file should be decompressed there
cd $SPATH
if [ -f .env ];then
    rm .env
fi
touch .env

# OPENMPI
source ~/.bashrc


# NETCDF

## zlib
export ZLIBPATH=$SPATH/intel-software/zlib-1.2.8
cd $SPATH/zlib-1.2.8
./configure --prefix=ZLIBPATH --eprefix=$ZLIBPATH
make clean;make;make install;make check;make clean
CMD="export LD_LIBRARY_PATH=$ZLIBPATH/lib:$LD_LIBRARY_PATH"
$CMD;echo $CMD>>$SPATH/.env
## szip
export SZIPPATH=$SPATH/intel-software/szip-2.1
cd $SPATH/szip-2.1
./configure --prefix=$SZIPPATH --build=x86_64 CFLAGS="-O2 -fPIC" FCFLAGS="-O2 -fPIC" CXXFLAGS="-O2 -fPIC"
make;make install;make check;make clean
CMD="export LD_LIBRARY_PATH=$SZIPPATH/lib:$LD_LIBRARY_PATH"
$CMD;echo $CMD>>$SPATH/.env



## hdf
cd $SPATH/hdf5-hdf5-1_10_6
export HDFPATH=$SPATH/intel-software/hdf5-1.10.6
./configure --prefix=$HDFPATH --enable-fortran --enable-parallel --with-zlib=$ZLIBPATH --with-szlib=$SZIPPATH CFLAGS="-O2 -fPIC" FCFLAGS="-O2 -fPIC" CXXFLAGS="-O2 -fPIC"
make clean;make -j16;make install;make clean
CMD="export LD_LIBRARY_PATH=$HDFPATH/lib:$LD_LIBRARY_PATH"
$CMD;echo $CMD>>$SPATH/.env
CMD="export PATH=$HDFPATH/bin:$PATH"
$CMD;echo $CMD>>$SPATH/.env
source $SPATH/.env

## netcdf-c
cd $SPATH/netcdf-c-4.3.3
export NCPATH=$SPATH/intel-software/netcdf-4.3.3
./configure --prefix=$NCPATH --enable-netcdf4 --enable-extra-example-tests --enable-parallel-tests --enable-logging --enable-extra-tests --enable-large-file-tests --disable-dap-remote-tests --disable-dap LDFLAGS=" -L$HDFPATH/lib -L$SZIPPATH/lib/ -L$ZLIBPATH/lib/" LIBS=" -lhdf5 -lhdf5_hl -lhdf5hl_fortran -lhdf5_fortran -lz -lsz -lcurl" CPPFLAGS=" -I$HDFPATH/include -I$ZLIBPATH/include -I$SZIPPATH/include"
make clean;make -j16;make install;make check;make clean
CMD="export LD_LIBRARY_PATH=$NCPATH/lib:$LD_LIBRARY_PATH"
$CMD;echo $CMD>>$SPATH/.env
CMD="export PATH=$NCPATH/bin:$PATH"
$CMD;echo $CMD>>$SPATH/.env

## netcdf-fortran
cd $SPATH/netcdf-fortran-4.4.1
./configure --prefix=$NCPATH LDFLAGS=" -L$HDFPATH/lib -L$SZIPPATH/lib/ -L$ZLIBPATH/lib/ -L$NCPATH/lib" LIBS=" -lhdf5 -lhdf5_hl -lhdf5hl_fortran -lhdf5_fortran -lz -lsz -lcurl -lnetcdf" CPPFLAGS=" -I$HDFPATH/include -I$SZIPPATH/include -I$ZLIBPATH/include -I$NCPATH/include"
make clean;make -j16;make install;make check;make clean
source $SPATH/.env


# NCO

## udunits
cd $SPATH/udunits-2.2.28
export UDPATH=$SPATH/intel-software/udunits-2.2.28
export LIBINC=$SPATH/X11
./configure --prefix=$UDPATH CPPFLAGS=-I$LIBINC LDFLAGS=-L$LIBINC LIBS=" -lexpat"
make clean;make -j16;make install;make clean
CMD="export LD_LIBRARY_PATH=$UDPATH/lib:$LD_LIBRARY_PATH"
$CMD;echo $CMD>>$SPATH/.env
source $SPATH/.env


## antlr
cd $SPATH/antlr2-master
export ATPATH=$SPATH/intel-software/antlr-2.7.7
./configure --prefix=$ATPATH --disable-csharp --disable-java --disable-python
make clean;make;make install;make clean
CMD="export LD_LIBRARY_PATH=$ATPATH/lib:$LD_LIBRARY_PATH"
$CMD;echo $CMD>>$SPATH/.env
source $SPATH/.env


## nco
cd $SPATH/nco-5.0.6
export NCOPATH=$SPATH/intel-software/nco-5.0.6
./configure --prefix=$NCOPATH CPPFLAGS=-I$ATPATH/include/ LDFLAGS=-L$ATPATH/lib LIBS=" -lantlr"  NETCDF_INC=$NCPATH/include NETCDF_LIB=$NCPATH/lib NETCDF_ROOT=$NCPATH ALTLR_ROOT=$ATPATH UDUNITS2_PATH=$UDPATH --enable-udunits2
make clean;make;make install;make clean
CMD="export LD_LIBRARY_PATH=$NCOPATH/lib:$LD_LIBRARY_PATH"
$CMD;echo $CMD>>$SPATH/.env
CMD="export PATH=$NCOPATH/bin:$PATH"
$CMD;echo $CMD>>$SPATH/.env
source $SPATH/.env


# NCVIEW
cd $SPATH/ncview-2.1.7
export NCVPATH=$SPATH/intel-software/ncview-2.1.7
./configure --prefix=$NCVPATH --with-nc-config=$NCPATH/bin/nc-config --with-udunits2_incdir=$UDPATH/include --with-udunits2_libdir=$UDPATH/lib --with-png_incdir=$SPATH/libpng-1.6.37/include --with-png_libdir=$SPATH/libpng-1.6.37/lib CPPFLAGS=-I$SPATH LDFLAGS=-L$SPATH/X11 --x-includes=$SPATH --x-libraries=$SPATH --with-x
make clean;make;make install;make clean
CMD="export PATH=$NCVPATH/bin:$PATH"
$CMD;echo $CMD>>$SPATH/.env
source $SPATH/.env
