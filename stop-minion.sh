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

echo "[$(date)] work dir: $WORK_DIR"

kubelet_pid=$(ps -ef | grep kubelet | grep -v grep | awk '{print $2}')
kubeproxy_pid=$(ps -ef | grep kube-proxy | grep -v grep | awk '{print $2}')

kill -9 $kubelet_pid
echo "[$(date)] kubelet stoped."
kill -9 $kubeproxy_pid
echo "[$(date)] kube-proxy stopped."

rm -f $LOG_DIR/kubelet.log
rm -f $LOG_DIR/kube-proxy.log
echo "[$(date)] log removed."

rm -rf $WORK_DIR/data
echo "[$(date)] data removed."

echo "[$(date)] start removing containers."
docker rm -f $(docker ps -a | grep -v CONTAINER | awk '{print $1}')
echo "[$(date)] all containers has been removed."
