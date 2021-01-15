IMAGE_NAME=192.168.2.100:5000/atlas/ubuntu-runtime:v1.0
CONTAINER_NAME=osmagic
DEVICE_NAME=/dev/davinci1
EXCUTEABLE_SCRIPT=`pwd`/run.sh
WORK_PATH=`pwd`

start(){
      if [ ! -d /home/fastdfs ]
      then
            mkdir /home/fastdfs
      fi

    set -x
    docker run -d \
    --net=host \
    --restart=always \
    --device=$DEVICE_NAME \
    --device=/dev/davinci_manager \
    --device=/dev/devmm_svm \
    --device=/dev/hisi_hdc \
    -v /usr/local/dcmi:/usr/local/dcmi \
    -v /usr/local/sbin/npu-smi:/usr/local/sbin/npu-smi \
    -v /lib64:/lib64 \
    -v /var/log/npu/slog/container/container_name:/var/log/npu/slog \
    -v /var/log/npu/conf/slog/slog.conf:/var/log/npu/conf/slog/slog.conf \
    -v /usr/local/Ascend/driver/lib64:/usr/local/Ascend/driver/lib64 \
    -v /usr/local/Ascend/driver/tools:/usr/local/Ascend/driver/tools \
    -v /home/fastdfs:/home/fastdfs \
    -v $EXCUTEABLE_SCRIPT:/usr/local/bin/run.sh \
    -v $WORK_PATH:/home/HwHiAiUser/koala/osmagic \
    --name $CONTAINER_NAME $IMAGE_NAME
}

stop(){
    docker stop $CONTAINER_NAME &&\
    docker rm $CONTAINER_NAME
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        stop
        start
        ;;
  *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
esac
