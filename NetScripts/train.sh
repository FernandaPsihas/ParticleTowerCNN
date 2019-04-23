#!/bin/bash

# Example script to train/evaluate

########################################################
#                    Library Setup                     #
########################################################

# Requires:
# $CAFFE_BINARY_PATH pointing to caffe.bin
# $LD_LIBRARY_PATH pointing to caffe/1.0/build/lib

########################################################
#                    Naming Inputs                     #
########################################################

export NETWORK_NAME=4TowerSiameseNet_train
export SOLVER_NAME=standard4T_solver
export TRAINING_DATASET_NAME=4view_input
export LOGNAME=${TRAINING_DATASET_NAME}_${NETWORK_NAME}_${SOLVER_NAME}
export LOGFILE_NAME=${LOGNAME}_$(date +\%Y_\%m_\%d_\%H_\%M)


########################################################
#                 Full Directory Paths                 #
########################################################

export DEEP_LEARNING_DIR=/path/to/deep/learning/directory
export NETWORK_PATH=${DEEP_LEARNING_DIR}/Networks/${NETWORK_NAME}.prototxt
export SOLVER_PATH=${DEEP_LEARNING_DIR}/Solvers/${SOLVER_NAME}.prototxt
export LOGFILE_PATH=${DEEP_LEARNING_DIR}/Logs/${LOGFILE_NAME}.log
export TRAIN_PATH=${DEEP_LEARNING_DIR}/Dataset/${TRAINING_DATASET}/Train/
export TEST_PATH=${DEEP_LEARNING_DIR}/Dataset/${TRAINING_DATASET}/Test/
export SNAPSHOT_PATH=${DEEP_LEARNING_DIR}/Snapshots

export SOLVER_PATH_TEMP=${DEEP_LEARNING_DIR}/solvers/${SOLVER_NAME}_TEMP.prototxt
export NETWORK_PATH_TEMP=${DEEP_LEARNING_DIR}/Networks/${NETWORK_NAME}_TEMP.prototxt

cp $SOLVER_PATH $SOLVER_PATH_TEMP
cp $NETWORK_PATH $NETWORK_PATH_TEMP

sed -i "s#CVN_TRAIN_PATH#$NETWORK_PATH_TEMP#" $SOLVER_PATH_TEMP
sed -i "s#CVN_SNAPSHOT_PATH#$SNAPSHOT_PATH#" $SOLVER_PATH_TEMP
sed -i "s#CVN_TRAINSAMPLE_PATH#$TRAIN_PATH#" $NETWORK_PATH_TEMP
sed -i "s#CVN_TESTSAMPLE_PATH#$TEST_PATH#" $NETWORK_PATH_TEMP

########################################################
#                        Train!                        #
########################################################

cd ${DEEP_LEARNING_DIR}

${CAFFE_BINARY_PATH} train --solver=${SOLVER_PATH_TEMP} >& ${LOGFILE_PATH}
