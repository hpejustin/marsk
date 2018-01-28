#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

WORK_DIR=$(pwd)
DATA_DIR=$WORK_DIR/data
LOG_DIR=$WORK_DIR/log
MASTER=172.17.101.27

echo "[$(date)] work dir: $WORK_DIR"
echo "[$(date)] data dir: $DATA_DIR"
echo "[$(date)] log dir: $LOG_DIR"

if [ ! -d $LOG_DIR ]; then
    mkdir -p $LOG_DIR
fi

$WORK_DIR/etcd \
    --listen-client-urls=http://0.0.0.0:2379 \
    --advertise-client-urls=http://$MASTER:2379 \
    --data-dir=$DATA_DIR/etcd >> $LOG_DIR/etcd.log 2>&1 &

echo "[$(date)] etcd stated successfully."

$WORK_DIR/kube-apiserver \
    --insecure-bind-address=0.0.0.0 \
    --service-cluster-ip-range=172.17.0.0/16 \
    --insecure-port=8080 \
    --service-node-port-range=8000-10000 \
    --etcd-servers=http://$MASTER:2379 \
    --admission-control=NamespaceLifecycle,LimitRanger,ResourceQuota \
    --allow-privileged=true --v=2 >> $LOG_DIR/apiserver.log 2>&1 &

echo "[$(date)] apiserver started successfully."

$WORK_DIR/kube-controller-manager \
     --master=127.0.0.1:8080 \
     --v=2 >> $LOG_DIR/controller-manager.log 2>&1 &

echo "[$(date)] controller-manager stated successfully."

$WORK_DIR/kube-scheduler \
    --master=127.0.0.1:8080 \
    --v=2 >> $LOG_DIR/scheduler.log 2>&1 &

echo "[$(date)] scheduler stated successfully."