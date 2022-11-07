
#!/bin/sh

##please modify the following environment variables

#export AMBERHOME=~/software/amber18-patch
#export LD_LIBRARY_PATH=$AMBERHOME/lib:$LD_LIBRARY_PATH
#export PATH=$AMBERHOME/bin:$PATH

#pmemd.cuda -O -i 01-min.in -p comp_wat.prmtop -c comp_wat.inpcrd -o 01-min.out -x 01-min.nc -ref comp_wat.inpcrd -r 01-min.rst
#pmemd.cuda -O -i 02-min.in -p comp_wat.prmtop -c 01-min.rst -o 02-min.out -x 02-min.nc -ref 01-min.rst -r 02-min.rst
#pmemd.cuda -O -i 03-nvt.in -p comp_wat.prmtop -c 02-min.rst -o 03-nvt.out -x 03-nvt.nc -ref 02-min.rst -r 03-nvt.rst
#pmemd.cuda -O -i 04-npt.in -p comp_wat.prmtop -c 03-nvt.rst -o 04-npt.out -x 04-npt.nc -ref 03-nvt.rst -r 04-npt.rst
#pmemd.cuda -O -i 05-cmd.in -p comp_wat.prmtop -c 04-npt.rst -o 05-cmd.out -x 05-cmd.nc -r 05-cmd.rst
##GaMD equilibration
cd gamd1
pmemd.cuda -O -i ../md.in -p ../comp_wat.prmtop -c ../05-cmd.rst -o md.out -r gamd1.rst -x md1.nc -gamd md1.log
pmemd.cuda -O -i ../gamd-restart.in -p ../comp_wat.prmtop -c gamd1.rst -o gamd1.out -x gmd1.nc -r gamd2.rst -gamd gamd1.log

cd ../gamd2
pmemd.cuda -O -i ../md.in -p ../comp_wat.prmtop -c ../05-cmd.rst -o md2.out -r gamd1.rst -x md2.nc -gamd md2.log
pmemd.cuda -O -i ../gamd-restart.in -p ../comp_wat.prmtop -c gamd1.rst -o gamd2.out -x gmd2.nc -r gamd2.rst -gamd gamd2.log

cd ../gamd3
pmemd.cuda -O -i ../md.in -p ../comp_wat.prmtop -c ../05-cmd.rst -o md3.out -r gamd1.rst -x md3.nc -gamd md3.log
pmemd.cuda -O -i ../gamd-restart.in -p ../comp_wat.prmtop -c gamd1.rst -o gamd3.out -x gmd3.nc -r gamd3.rst -gamd gamd3.log

#cd ../gamd4
#pmemd.cuda -O -i ../md.in -p ../comp_wat.prmtop -c ../05-cmd.rst -o md4.out -r gamd1.rst -x md4.nc -gamd md4.log
#pmemd.cuda -O -i ../gamd-restart.in -p ../comp_wat.prmtop -c gamd1.rst -o gamd4.out -x gmd4.nc -r gamd4.rst -gamd gamd4.log

#cd ../gamd5
#pmemd.cuda -O -i ../md.in -p ../comp_wat.prmtop -c ../05-cmd.rst -o md5.out -r gamd1.rst -x md5.nc -gamd md4.log
#pmemd.cuda -O -i ../gamd-restart.in -p ../comp_wat.prmtop -c gamd1.rst -o gamd5.out -x gmd5.nc -r gamd5.rst -gamd gamd5.log

#cd ../gamd6
#pmemd.cuda -O -i ../md.in -p ../comp_wat.prmtop -c ../05-cmd.rst -o md6.out -r gamd-1.rst -x md-6.nc -gamd gamd-11.log
#pmemd.cuda -O -i ../gamd-restart.in -p ../comp_wat.prmtop -c gamd-1.rst -o gamd-6.out -x gmd-6.nc -r gamd-6.rst -gamd gamd-12.log

#cd ../gamd7
#pmemd.cuda -O -i ../md.in -p ../comp_wat.prmtop -c ../05-cmd.rst -o md6.out -r gamd-1.rst -x md-7.nc -gamd gamd-13.log
#pmemd.cuda -O -i ../gamd-restart.in -p ../comp_wat.prmtop -c gamd-1.rst -o gamd-7.out -x gmd-7.nc -r gamd-7.rst -gamd gamd-14.log

#cd ../gamd8
#pmemd.cuda -O -i ../md.in -p ../comp_wat.prmtop -c ../05-cmd.rst -o md8.out -r gamd-1.rst -x md-8.nc -gamd gamd-15.log
#pmemd.cuda -O -i ../gamd-restart.in -p ../comp_wat.prmtop -c gamd-1.rst -o gamd-8.out -x gmd-8.nc -r gamd-8.rst -gamd gamd-16.log

#cd ../gamd9
#pmemd.cuda -O -i ../md.in -p ../comp_wat.prmtop -c ../05-cmd.rst -o md9.out -r gamd-1.rst -x md-9.nc -gamd gamd-17.log
#pmemd.cuda -O -i ../gamd-restart.in -p ../comp_wat.prmtop -c gamd-1.rst -o gamd-9.out -x gmd-9.nc -r gamd-9.rst -gamd gamd-18.log

#cd ../gamd10
#pmemd.cuda -O -i ../md.in -p ../comp_wat.prmtop -c ../05-cmd.rst -o md10.out -r gamd-1.rst -x md-10.nc -gamd gamd-19.log
#pmemd.cuda -O -i ../gamd-restart.in -p ../comp_wat.prmtop -c gamd-1.rst -o gamd-10.out -x gmd-10.nc -r gamd-10.rst -gamd gamd-20.log


