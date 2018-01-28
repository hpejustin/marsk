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
LOG_DIR=$WORK_DIR/log
MASTER=172.17.101.27
NODE_IP=172.17.101.27

echo "[$(date)] work dir: $WORK_DIR"
echo "[$(date)] log dir: $LOG_DIR"

if [ ! -d $LOG_DIR ]; then
    mkdir -p $LOG_DIR
fi

$WORK_DIR/kubelet \
  --address=$NODE_IP \
  --port=10250 \
  --hostname_override=$NODE_IP \
  --cluster_dns=172.17.1.10 \
  --cluster_domain=cluster.local \
  --api-servers=http://$MASTER:8080 \
  --v=2 >> $LOG_DIR/kubelet.log 2>&1 &

echo "[$(date)] kubelet stated successfully."

$WORK_DIR/kube-proxy \
  --master=http://$MASTER:8080 \
  --v=2 >> $LOG_DIR/kube-proxy.log 2>&1 &

echo "[$(date)] kube-proxy started successfully."
echo "[$(date)] minion $NODE_IP started."