#! /bin/sh
###############################################################
# Plot Results from Routine Processing with pysarApp.py
# Author: Zhang Yunjun, 2017-07-23
# Latest update: 2018-09-07
###############################################################


## Change to 0 if you do not want to re-plot loaded dataset again
plot_key_files=1
plot_loaded_data=1
plot_loaded_data_aux=1
plot_timeseries=1
plot_geocoded_data=1
plot_the_rest=1


# Default file name
mask_file='maskTempCoh.h5'
geo_mask_file='./GEOCODE/geo_maskTempCoh.h5'

## Log File
log_file='plot_pysarApp.log'
echo "touch log file: "$log_file
touch $log_file

## Create PIC folder
if [ ! -d "PIC" ]; then
    echo 'Create PIC folder'
    mkdir PIC
fi


## Plot Key files
opt=' --dem INPUTS/geometryRadar.h5 --mask '$mask_file' -u cm '
#opt=' --dem INPUTS/geometryRadar.h5 --mask '$mask_file' -u cm --vlim -2 2'
if [ $plot_key_files -eq 1 ]; then
    view.py --nodisplay --update velocity.h5           $opt               | tee -a $log_file
    view.py --nodisplay --update temporalCoherence.h5  -c gray --vlim 0 1 | tee -a $log_file
    view.py --nodisplay --update maskTempCoh.h5        -c gray --vlim 0 1 | tee -a $log_file
    file=INPUTS/geometryRadar.h5;  test -f $file && view.py --nodisplay --update $file | tee -a $log_file
    file=INPUTS/geometryGeo.h5;    test -f $file && view.py --nodisplay --update $file | tee -a $log_file
fi


## Loaded Dataset
if [ $plot_loaded_data -eq 1 ]; then
    view.py --nodisplay --update INPUTS/ifgramStack.h5  unwrapPhase-  --zero-mask | tee -a $log_file
    view.py --nodisplay --update INPUTS/ifgramStack.h5  coherence-    --mask no   | tee -a $log_file
fi


## Auxliary Files from loaded dataset
if [ $plot_loaded_data_aux -eq 1 ]; then
    file=avgPhaseVelocity.h5; test -f $file && view.py --nodisplay --update $file -m maskSptialCoh.h5 | tee -a $log_file
    view.py --nodisplay --update avgSpatialCoherence.h5 -c gray --vlim 0 1 | tee -a $log_file
    view.py --nodisplay --update maskSpatialCoh.h5      -c gray --vlim 0 1 | tee -a $log_file
    view.py --nodisplay --update mask.h5                -c gray --vlim 0 1 | tee -a $log_file
fi


## Time-series files
view='view.py --nodisplay --update --mask '$mask_file' --noaxis -u cm '
#view='view.py --nodisplay --update --mask '$mask_file' --noaxis -u cm --vlim -10 10 '
if [ $plot_timeseries -eq 1 ]; then
    file=timeseries.h5;                               test -f $file && $view $file | tee -a $log_file

    file=timeseries_LODcor_ECMWF.h5;                  test -f $file && $view $file | tee -a $log_file
    file=timeseries_LODcor_ECMWF_demErr.h5;           test -f $file && $view $file | tee -a $log_file
    file=timeseries_LODcor_ECMWF_demErr_ramp.h5;      test -f $file && $view $file | tee -a $log_file

    file=timeseries_ECMWF.h5;                         test -f $file && $view $file | tee -a $log_file
    file=timeseries_ECMWF_demErr.h5;                  test -f $file && $view $file | tee -a $log_file
    file=timeseries_ECMWF_demErr_ramp.h5;             test -f $file && $view $file | tee -a $log_file

    file=timeseries_demErr.h5;                        test -f $file && $view $file | tee -a $log_file
    file=timeseries_demErr_ramp.h5;                   test -f $file && $view $file | tee -a $log_file

    file=timeseries_demErr.h5;                        test -f $file && $view $file | tee -a $log_file
    file=timeseries_demErr_tropHgt.h5;                test -f $file && $view $file | tee -a $log_file
    file=timeseries_demErr_tropHgt_ramp.h5;           test -f $file && $view $file | tee -a $log_file
fi


## Geo coordinates for UNAVCO Time-series InSAR Archive Product
view='view.py --nodisplay --update --lalo-label'
if [ $plot_geocoded_data -eq 1 ]; then
    $view ./GEOCODE/geo_maskTempCoh.h5          -c gray  | tee -a $log_file
    $view ./GEOCODE/geo_temporalCoherence.h5    -c gray  | tee -a $log_file
    $view ./GEOCODE/geo_velocity.h5                      | tee -a $log_file
    file=./GEOCODE/geo_timeseries_ECMWF_demErr_ramp.h5;  test -f $file && $view $file --noaxis | tee -a $log_file
    file=./GEOCODE/geo_timeseries_ECMWF_demErr.h5;       test -f $file && $view $file --noaxis | tee -a $log_file
    file=./GEOCODE/geo_timeseries_demErr_ramp.h5;        test -f $file && $view $file --noaxis | tee -a $log_file
    file=./GEOCODE/geo_timeseries_demErr.h5;             test -f $file && $view $file --noaxis | tee -a $log_file
fi


if [ $plot_the_rest -eq 1 ]; then
    view.py velocityEcmwf.h5 -m no --nodisplay --update  | tee -a $log_file
    view.py numInvIfgram.h5  -m no --nodisplay --update  | tee -a $log_file
fi


## Move picture files to PIC folder
echo "Move *.png *.pdf into PIC folder"
mv *.png PIC/
mv *.pdf PIC/
mv *.kmz PIC/
mv $log_file PIC/

