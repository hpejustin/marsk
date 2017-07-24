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

WORK_DIR=$(pwd)
LOG_DIR=/var/kube/log

if [ ! -d $LOG_DIR ];then
    mkdir -p $LOG_DIR
fi

$WORK_DIR/etcd \
    --listen-client-urls=http://127.0.0.1:2379,http://127.0.0.1:4001 \
    --advertise-client-urls=http://127.0.0.1:2379,http://127.0.0.1:4001 \
    --data-dir=$WORK_DIR/data/etcd >> $LOG_DIR/etcd.log 2>&1 &

echo "[$(date)] etcd stated."

$WORK_DIR/kube-apiserver \
    --service-cluster-ip-range=10.0.0.1/24 \
    --insecure-bind-address=0.0.0.0 \
    --insecure-port=8080 \
    --etcd-servers=http://127.0.0.1:2379 \
    --admission-control=NamespaceLifecycle,LimitRanger,ResourceQuota \
    --allow-privileged=true --v=2 >> $LOG_DIR/apiserver.log 2>&1 &

echo "[$(date)] apiserver stated."

$WORK_DIR/kube-controller-manager \
     --master=127.0.0.1:8080 \
     --v=2 >> $LOG_DIR/controller-manager.log 2>&1 &

echo "[$(date)] controller-manager stated."

$WORK_DIR/kube-scheduler \
    --master=127.0.0.1:8080 \
    --v=2 >> $LOG_DIR/scheduler.log 2>&1 &

echo "[$(date)] scheduler stated."
