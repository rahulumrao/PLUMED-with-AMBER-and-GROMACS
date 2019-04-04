#! /bin/bash
#!--------------------------------------------------------------------------------------------------------!
#!       THIS SCRIP IS WRITTEN TO INSTALL GROMACS IN HPC CLUSTER either HPC2010 OR HPC2013                !
#!========================================================================================================! 
#!                                     GROMACS INSTALLATION                                               !
#!========================================================================================================!
#! CREATE build DIRECTORY IN $GROMACS_HOME AND RUN THE FOLLOWING COMMAND                                  !
#! [ cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=OFF ]                                     !
#! ONCE CONFIGURATION IS COMPLETE RUN 'make' "IT WILL GIVE YOU fftw ERROR(which is required for the trick)!
#!     ".........NOW HERE IS THE TRICK TO INSTAL GROMACS............... "                                 !
#!  DOWNLOAD  fftw BY RUNNING THIS IN TERMINAL [wget http://www.fftw.org/fftw-3.3.8.tar.gz]               !
#!              "if above not works then download and copy and "                                          !
#! EXTRACT IT USING [tar -xvf fftw-3.3.8.tar.gz]                                                          !
#! GO TO $GROMACS_HOME/build/src/contrib/fftw AND THEN RENAME FFTW                                        !
#!                cp fftw-3.3.8.tar.gz fftw.tar.gz                                                        !
#! COMMENT OR REPLACE THE FOLLOWING FILE....                                                              !
#! vi $GROMACS_HOME/build/src/contrib/fftw/fftwBuild-prefix/src/fftwBuild-stamp/verify-fftwBuild.cmake    !
#! NOW RUN 'make -j8' IN $GROMACS_HOME/build/src/contrib/fftw FOLDER                                      !
#! ONCE IT DONE GO BACK TO THE build DIRECTORY AND RUN THE 'make -j8'                                     !
#! IT WILL COMPILE WITH SERIAL VERSION / TO COPILE WITH MPI YOU NEED TO FIRST SOURCE INTEL_COPILER        !
#! source /opt/software/intel/..... intel64 (wthatever the path is) THEN DO THE FOLLOWING                 !
#! RUN WITH MPI FLAG [cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=OFF -DGMX_MPI=ON]        !
#! THEN AGAIN RUN 'make -j8'                                                                              !
#!                                   "!!DONE!!"                                                           !    
#! FOR MORE DETAILS FOLLOW [ http://www.gromacs.org/Documentation/Installation_Instructions_5.0 ]         !
#!========================================================================================================!
#!                                       PLUMED INSTALLATION                                              !
#!========================================================================================================!
#! GO TO $PLUMED_HOME AND CONFIGURE PLUMED BY RUNNING FOLLOWING COMMAND                                   !
#! [ ./configure --enable-shared ] NOW RUN [make -j8]                                                     !
#! RUN [ source $PLUMED_HOME/sourceme.sh]                                                                 !
#!========================================================================================================!
#!                                   GROMACS PATCHING WITH PLUMED                                         !
#!========================================================================================================!
#! GO BACK TO $GROMACS_HOME AND RUN [ plumed-patch --shared -p ] FOLLOW THE INSTRUCTIONS                  !
#! THIS WILL MAKE plumed kernel TO LOAD IN GROMACS                                                        !
#! GO TO build DIRECTORY AND REMAKE GROMACS [make -j8]                                                    !
#!******************YEHHHH!!! YOUR GROMACS IS NOW COMPILED WITH PLUMED !! HURRAYYY !!*********************!
#!========================================================================================================!
#
gmx_file=gromacs-5.1.2
plumed_file=plumed-2.4.1
#----------------------------------------------------------------------------------------------------------
    if [ "$gmx_file" == 'gromacs-5.1.2' ]; then
       echo "***************** $gmx_file IS FOUND********************"
    else
       echo "NO GROMACS IS FOUND PLEASE DOWNLOAD THE LATEST VERSION"
    stop
    fi 
cd $gmx_file
export GMX_HOME=`pwd`
mkdir build && cd build

cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=OFF 

make -j8

cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=OFF -DGMX_MPI=ON

make -j8
#----------------------------------------------------------------------------------------------------------
echo "******************PLUMED version $plumed_file IS FOUND*****************"
#----------------------------------------------------------------------------------------------------------
cd ../../$plumed_file
./configure --enable-shared --enable-mpi

make -j8
source sourceme.sh
#----------------------------------------------------------------------------------------------------------
cd ../$gmx_file

plumed-patch --shared -p -e gromacs-5.1.2
cd build
make -j8
#=========================================================================================================
            echo "***************GROMACS IS NOW PATCHED WITH PLUMED**************"
#=========================================================================================================
