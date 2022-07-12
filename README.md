# netCDFthings_Installation
A script for netCDF, NCO, Ncview installation

`install.sh` - the script for installation

`packages.tar.gz` - packages, which include: 

```shell
$ tar -tvf packages.tar.gz | grep ^d | awk '{print $6}' | awk -F/ '{if (NF<3) print }'
antlr2-master/
hdf5-hdf5-1_10_6/
libpng-1.6.37/
nco-5.0.6/
ncview-2.1.7/
netcdf-c-4.3.3/
netcdf-fortran-4.4.1/
openmpi-4.0.7/
szip-2.1/
udunits-2.2.28/
X11/
zlib-1.2.8/
```

see [ 一个脚本完成安装netCDF、NCO、Ncview库_Cuiyingzhe的博客-CSDN博客](https://blog.csdn.net/cyzzym000/article/details/125739284) for more information

