#!/bin/bash

#验证npu-smi工具的安装
#npu-smi info

#启动slogd守护进程
#su HwHiAiUser --command "/usr/local/Ascend/driver/tools/slogd &"
#ps -ef | grep -v grep | grep "tools/slogd"

cd /home/HwHiAiUser/koala/osmagic

#java
java -jar city-ai-0.0.1-SNAPSHOT.jar --server.port=25040

#http_server_hv
#./http_server_hv

#http_server
#./http_server
