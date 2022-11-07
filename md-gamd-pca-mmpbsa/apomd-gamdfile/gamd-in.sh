#!/bin/bash

#workfolder=`pwd`
#source ./commo
natoms=34005 ##the number of atoms in the system
natoms_max=34005 ##the number of atoms in the system
ntwx=1000    ##the steps to write the trajectory
ntwprt=1763 ##the number of  protein-ligand atoms
igamd=3     ##gamd
ntave=168000  ##4*natom
ntcmd=840000 ##5*ntave
ntcmdprep=336000 ##2*ntave
ntebprep=336000 ##2*ntave
nteb=1680000  ##for learning the system multiply ntave, normal 10 times
nstlim=2520000 ##the sum of ntcmd and nteb
map=:1-53

echo "minimization simulation
&cntrl
 imin=1,       ! Minimize the initial structure
 maxcyc=10000, ! Maximum number of cycles for minimization
 ncyc=4000,    ! Switch from steepest descent to conjugate gradient minimization after ncyc cycles
 ntb=1,        ! Constant volume
 ntp=0,        ! No pressure scaling
 ntf=1,        ! Complete force evaluation
 ntc=1,        ! No SHAKE
 ntpr=2000,      ! Print to mdout every ntpr steps
 ntwr=2000,    ! Write a restart file every ntwr steps
 cut=9.0,     ! Nonbonded cutoff in Angstroms
 ! Wrap coordinates when printing them to the same unit cell
 iwrap=1,
 ntwprt = $ntwprt,
 ! Set water atom/residue names for SETTLE recognition
 ! watnam='TIP3', ! Water residues are named TIP3
 ! owtnm='OH2',   ! Water oxygens are named OH2
 ntr=1, restraintmask='$map',
 restraint_wt=2.0
 /">01-min.in

echo "minimization simulation without restrain
&cntrl
 imin=1,       ! Minimize the initial structure
 maxcyc=10000, ! Maximum number of cycles for minimization
 ncyc=4000,    ! Switch from steepest descent to conjugate gradient minimization after ncyc cycles
 ntb=1,        ! Constant volume
 ntp=0,        ! No pressure scaling
 ntf=2,        ! Complete force evaluation
 ntc=2,        ! No SHAKE
 ntpr=2000,      ! Print to mdout every ntpr steps
 ntwr=2000,    ! Write a restart file every ntwr steps
 cut=9.0,     ! Nonbonded cutoff in Angstroms
 ! Wrap coordinates when printing them to the same unit cell
 iwrap=1,
 ntwprt = $ntwprt,
 ! Set water atom/residue names for SETTLE recognition
! watnam='TIP3', ! Water residues are named TIP3
! owtnm='OH2',   ! Water oxygens are named OH2
 /">02-min.in
echo "heat the system to 300 for 200ps and then equilbriation for 200ps in nvt
&cntrl
 imin=0,irest=0,ntx=1,
 nstlim=2000000,dt=0.002,
 ntc=2,ntf=2,
 cut=9.0, ntb=1,
 ntpr=5000, ntwx=5000,
 ntt=3, gamma_ln=2.0,
 tempi=0.0, temp0=300.0,
 ntr=1, restraintmask='($map&!@H=)',
 restraint_wt=1.0,
 nmropt=1,
 ! Wrap coordinates when printing them to the same unit cell
 iwrap=1,
 ntwprt = $ntwprt,
 ! Set water atom/residue names for SETTLE recognition
 ! watnam='TIP3', ! Water residues are named TIP3
 ! owtnm='OH2',   ! Water oxygens are named OH2
 /
 &wt TYPE='TEMP0', istep1=0, istep2=1000000,
   value1=0.1, value2=300.0, /
 &wt TYPE='END' /">03-nvt.in
echo "density the system for another 200ps
&cntrl
 imin=0,        ! No minimization
 irest=1,       ! This IS a new MD simulation
 ntx=5,         ! read coordinates only
 ! Temperature control
  ntt=3,         ! Langevin dynamics
  gamma_ln=1.0,  ! Friction coefficient (ps^-1)
  tempi=300.0,   ! Initial temperature
  temp0=300.0,   ! Target temperature
  ig=-1,         ! random seed
  ! Potential energy control
  cut=10.0,       ! nonbonded cutoff, in Angstroms
  ! MD settings
  nstlim=20000000, ! simulation length
  dt=0.002,      ! time step (ps)
  ! SHAKE
  ntc=2,         ! Constrain bonds containing hydrogen
  ntf=2,         ! Do not calculate forces of bonds containing hydrogen
  ! Control how often information is printed
  ntpr=1000,     ! Print energies every 1000 steps
  ntwx=1000,     ! Print coordinates every 1000 steps to the trajectory
  ntwr=5000,    ! Print a restart file every 10K steps (can be less frequent)
  ntxo=2,        ! Write NetCDF format
  ioutfm=1,      ! Write NetCDF format (always do this!)
  ! Wrap coordinates when printing them to the same unit cell
  iwrap=1,
  ntwprt = $ntwprt,
  ! Constant pressure control. Note that ntp=3 requires barostat=1
  barostat=1,    ! Berendsen... change to 2 for MC barostat
  ntp=1,         ! 1=isotropic, 2=anisotropic, 3=semi-isotropic w/ surften
  pres0=1.0,     ! Target external pressure, in bar
  taup=0.5,      ! Berendsen coupling constant (ps)
 ! Constant surface tension (needed for semi-isotropic scaling). Uncomment
 ! for this feature. csurften must be nonzero if ntp=3 above
  !csurften=3,    ! Interfaces in 1=yz plane, 2=xz plane, 3=xy plane
  !gamma_ten=0.0, ! Surface tension (dyne/cm). 0 gives pure semi-iso scaling
  !ninterface=2,  ! Number of interfaces (2 for bilayer)
  ! Set water atom/residue names for SETTLE recognition
  !watnam='TIP3', ! Water residues are named TIP3
  !owtnm='OH2',   ! Water oxygens are named OH2
  ntr=1, restraintmask='($map&!@H=)',
  restraint_wt=1.0,
  /">04-npt.in
echo "density the system for another 200ps
&cntrl
 imin=0,        ! No minimization
 irest=1,       ! This IS a new MD simulation
 ntx=5,         ! read coordinates only
 ! Temperature control
 ntt=3,         ! Langevin dynamics
 gamma_ln=1.0,  ! Friction coefficient (ps^-1)
 tempi=300.0,   ! Initial temperature
 temp0=300.0,   ! Target temperature
 ig=-1,         ! random seed
! Potential energy control
  cut=9.0,       ! nonbonded cutoff, in Angstroms
  ! MD settings
  nstlim=500000000, ! simulation length
 dt=0.002,      ! time step (ps)
 ! SHAKE
  ntc=2,         ! Constrain bonds containing hydrogen
  ntf=2,         ! Do not calculate forces of bonds containing hydrogen
  ! Control how often information is printed
  ntpr=1000,     ! Print energies every 1000 steps
  ntwx=1000,     ! Print coordinates every 1000 steps to the trajectory
  ntwr=5000,    ! Print a restart file every 10K steps (can be less frequent)
  ntxo=2,        ! Write NetCDF format
  ioutfm=1,      ! Write NetCDF format (always do this!)
  ! Wrap coordinates when printing them to the same unit cell
  iwrap=1,
  ntwprt = $ntwprt,
  ! Constant pressure control. Note that ntp=3 requires barostat=1
  barostat=1,    ! Berendsen... change to 2 for MC barostat
  ntp=1,         ! 1=isotropic, 2=anisotropic, 3=semi-isotropic w/ surften
  pres0=1.0,     ! Target external pressure, in bar
  taup=0.5,      ! Berendsen coupling constant (ps)
  ! Constant surface tension (needed for semi-isotropic scaling). Uncomment
  ! for this feature. csurften must be nonzero if ntp=3 above
  ! csurften=3,    ! Interfaces in 1=yz plane, 2=xz plane, 3=xy plane
  ! gamma_ten=0.0, ! Surface tension (dyne/cm). 0 gives pure semi-iso scaling
  ! ninterface=2,  ! Number of interfaces (2 for bilayer)
  ! Set water atom/residue names for SETTLE recognition
 ! watnam='TIP3', ! Water residues are named TIP3
 ! owtnm='OH2',   ! Water oxygens are named OH2
  /">05-cmd.in


  
echo "GaMD equilibration simulation
 &cntrl
    imin=0,        ! No minimization
    irest=0,       ! This IS a new MD simulation
    ntx=1,         ! read coordinates only

    ! Temperature control
    ntt=3,         ! Langevin dynamics
    gamma_ln=1.0,  ! Friction coefficient (ps^-1)
    tempi=300.0,   ! Initial temperature
    temp0=300.0,   ! Target temperature
    ig=-1,         ! random seed

    ! Potential energy control
    cut=9.0,       ! nonbonded cutoff, in Angstroms

    ! MD settings
    nstlim=${nstlim}, ! simulation length
    dt=0.002,      ! time step (ps)

    ! SHAKE
    ntc=2,         ! Constrain bonds containing hydrogen
    ntf=2,         ! Do not calculate forces of bonds containing hydrogen

    ! Control how often information is printed
    ntpr=$ntwx,     ! Print energies every 1000 steps
    ntwx=$ntwx,     ! Print coordinates every 1000 steps to the trajectory
    ntwr=5000,    ! Print a restart file every 10K steps (can be less frequent)
!   ntwv=-1,       ! Uncomment to also print velocities to trajectory
!   ntwf=-1,       ! Uncomment to also print forces to trajectory
    ntxo=2,        ! Write NetCDF format
    ioutfm=1,      ! Write NetCDF format (always do this!)

    ! Wrap coordinates when printing them to the same unit cell
    iwrap=1,
    ntwprt = $ntwprt,

    ! Constant pressure control. Note that ntp=3 requires barostat=1
    barostat=1,    ! Berendsen... change to 2 for MC barostat
    ntp=1,         ! 1=isotropic, 2=anisotropic, 3=semi-isotropic w/ surften
    pres0=1.0,     ! Target external pressure, in bar
    taup=0.5,      ! Berendsen coupling constant (ps)

    ! Constant surface tension (needed for semi-isotropic scaling). Uncomment
    ! for this feature. csurften must be nonzero if ntp=3 above
!    csurften=3,    ! Interfaces in 1=yz plane, 2=xz plane, 3=xy plane
!    gamma_ten=0.0, ! Surface tension (dyne/cm). 0 gives pure semi-iso scaling
!    ninterface=2,  ! Number of interfaces (2 for bilayer)

    ! Set water atom/residue names for SETTLE recognition
    !watnam='TIP3', ! Water residues are named TIP3
    !owtnm='OH2',   ! Water oxygens are named OH2

    ! GaMD parameters
    igamd = $igamd, iE = 1, irest_gamd = 0,
    ntcmd = ${ntcmd}, nteb = ${nteb}, ntave = $ntave,
    ntcmdprep = ${ntcmdprep}, ntebprep = ${ntebprep},
    sigma0P = 6.0, sigma0D = 6.0,
 /
" > md.in
echo "GaMD production simulation
 &cntrl
    imin=0,        ! No minimization
    irest=0,       ! This IS a new MD simulation
    ntx=1,         ! read coordinates only

    ! Temperature control
    ntt=3,         ! Langevin dynamics
    gamma_ln=1.0,  ! Friction coefficient (ps^-1)
    tempi=300.0,   ! Initial temperature
    temp0=300.0,   ! Target temperature
    ig=-1,         ! random seed

    ! Potential energy control
    cut=9.0,       ! nonbonded cutoff, in Angstroms

    ! MD settings
    nstlim=500000000, ! simulation length
    dt=0.002,      ! time step (ps)

    ! SHAKE
    ntc=2,         ! Constrain bonds containing hydrogen
    ntf=2,         ! Do not calculate forces of bonds containing hydrogen

    ! Control how often information is printed
    ntpr=$ntwx,     ! Print energies every 1000 steps
    ntwx=$ntwx,     ! Print coordinates every 1000 steps to the trajectory
    ntwr=5000,    ! Print a restart file every 10K steps (can be less frequent)
!   ntwv=-1,       ! Uncomment to also print velocities to trajectory
!   ntwf=-1,       ! Uncomment to also print forces to trajectory
    ntxo=2,        ! Write NetCDF format
    ioutfm=1,      ! Write NetCDF format (always do this!)

    ! Wrap coordinates when printing them to the same unit cell
    iwrap=1,
    ntwprt = $ntwprt,

    ! Constant pressure control. Note that ntp=3 requires barostat=1
    barostat=1,    ! Berendsen... change to 2 for MC barostat
    ntp=1,         ! 1=isotropic, 2=anisotropic, 3=semi-isotropic w/ surften
    pres0=1.0,     ! Target external pressure, in bar
    taup=0.5,      ! Berendsen coupling constant (ps)

    ! Constant surface tension (needed for semi-isotropic scaling). Uncomment
    ! for this feature. csurften must be nonzero if ntp=3 above
!    csurften=3,    ! Interfaces in 1=yz plane, 2=xz plane, 3=xy plane
!    gamma_ten=0.0, ! Surface tension (dyne/cm). 0 gives pure semi-iso scaling
!    ninterface=2,  ! Number of interfaces (2 for bilayer)

    ! Set water atom/residue names for SETTLE recognition
    !watnam='TIP3', ! Water residues are named TIP3
    !owtnm='OH2',   ! Water oxygens are named OH2

    ! GaMD parameters
    igamd = $igamd, iE = 1, irest_gamd = 1,
    ntcmd = 0, nteb = 0, ntave = $ntave,
    ntcmdprep = 0, ntebprep = 0,
    sigma0P = 6.0, sigma0D = 6.0,
 /
" > gamd-restart.in
echo "GaMD restart simulation
 &cntrl
    imin=0,        ! No minimization
    irest=1,       ! This IS a new MD simulation
    ntx=5,         ! read coordinates only

    ! Temperature control
    ntt=3,         ! Langevin dynamics
    gamma_ln=1.0,  ! Friction coefficient (ps^-1)
    tempi=300.0,   ! Initial temperature
    temp0=300.0,   ! Target temperature
    ig=-1,         ! random seed

    ! Potential energy control
    cut=9.0,       ! nonbonded cutoff, in Angstroms

    ! MD settings
    nstlim=500000000, ! simulation length
    dt=0.002,      ! time step (ps)

    ! SHAKE
    ntc=2,         ! Constrain bonds containing hydrogen
    ntf=2,         ! Do not calculate forces of bonds containing hydrogen

    ! Control how often information is printed
    ntpr=$ntwx,     ! Print energies every 1000 steps
    ntwx=$ntwx,     ! Print coordinates every 1000 steps to the trajectory
    ntwr=5000,    ! Print a restart file every 10K steps (can be less frequent)
!   ntwv=-1,       ! Uncomment to also print velocities to trajectory
!   ntwf=-1,       ! Uncomment to also print forces to trajectory
    ntxo=2,        ! Write NetCDF format
    ioutfm=1,      ! Write NetCDF format (always do this!)

    ! Wrap coordinates when printing them to the same unit cell
    iwrap=1,
    ntwprt = $ntwprt,

    ! Constant pressure control. Note that ntp=3 requires barostat=1
    barostat=1,    ! Berendsen... change to 2 for MC barostat
    ntp=1,         ! 1=isotropic, 2=anisotropic, 3=semi-isotropic w/ surften
    pres0=1.0,     ! Target external pressure, in bar
    taup=0.5,      ! Berendsen coupling constant (ps)

    ! Constant surface tension (needed for semi-isotropic scaling). Uncomment
    ! for this feature. csurften must be nonzero if ntp=3 above
!    csurften=3,    ! Interfaces in 1=yz plane, 2=xz plane, 3=xy plane
!    gamma_ten=0.0, ! Surface tension (dyne/cm). 0 gives pure semi-iso scaling
!    ninterface=2,  ! Number of interfaces (2 for bilayer)

    ! Set water atom/residue names for SETTLE recognition
    !watnam='TIP3', ! Water residues are named TIP3
    !owtnm='OH2',   ! Water oxygens are named OH2

    ! GaMD parameters
    igamd = $igamd, iE = 1, irest_gamd = 1,
    ntcmd = 0, nteb = 0, ntave = $ntave,
    ntcmdprep = 0, ntebprep = 0,
    sigma0P = 6.0, sigma0D = 6.0,
 /
" > md-restart.in
echo "
#!/bin/sh

##please modify the following environment variables

#export AMBERHOME=~/software/amber18-patch
#export LD_LIBRARY_PATH=\$AMBERHOME/lib:\$LD_LIBRARY_PATH
#export PATH=\$AMBERHOME/bin:\$PATH

pmemd.cuda -O -i 01-min.in -p comp_wat.prmtop -c comp_wat.inpcrd -o 01-min.out -x 01-min.nc -ref comp_wat.inpcrd -r 01-min.rst
pmemd.cuda -O -i 02-min.in -p comp_wat.prmtop -c 01-min.rst -o 02-min.out -x 02-min.nc -ref 01-min.rst -r 02-min.rst
pmemd.cuda -O -i 03-nvt.in -p comp_wat.prmtop -c 02-min.rst -o 03-nvt.out -x 03-nvt.nc -ref 02-min.rst -r 03-nvt.rst
pmemd.cuda -O -i 04-npt.in -p comp_wat.prmtop -c 03-nvt.rst -o 04-npt.out -x 04-npt.nc -ref 03-nvt.rst -r 04-npt.rst
pmemd.cuda -O -i 05-cmd.in -p comp_wat.prmtop -c 04-npt.rst -o 05-cmd.out -x 05-cmd.nc -r 05-cmd.rst
##GaMD equilibration

">run-GaMD.sh
