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
echo "[$(date)] log dir: $LOG_DIR"

api_server_pid=$(ps -ef | grep kube-apiserver | grep -v grep | awk '{print $2}')
controller_manager_pid=$(ps -ef | grep kube-controller-manager | grep -v grep | awk '{print $2}')
scheduler_pid=$(ps -ef | grep kube-scheduler | grep -v grep | awk '{print $2}')
etcd_pid=$(ps -ef | grep etcd | grep -v grep | grep -v kube-apiserver | awk '{print $2}')

kill -9 $api_server_pid
echo "[$(date)] apiserver stopped."
kill -9 $controller_manager_pid
echo "[$(date)] controller manager stopped."
kill -9 $scheduler_pid
echo "[$(date)] scheduler stopped."
kill -9 $etcd_pid
echo "[$(date)] etcd stopped."

rm -rf $LOG_DIR/*
echo "[$(date)] log removed."