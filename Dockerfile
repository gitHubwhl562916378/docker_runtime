From ubuntu:18.04

ARG NNRT_PKG
ARG ASCEND_BASE=/usr/local/Ascend
ARG HWHIAIUSER_UID
ARG HWHIAIUSER_GID

ADD cxx_so.tar.gz /root/
ADD $NNRT_PKG /root/
ADD sources.list /etc/apt/
ADD jdk1.8.0_231.tar.gz /usr/lib/jvm
RUN cd /usr/bin && \
    ln -s /usr/lib/jvm/jdk1.8.0_231/bin/java java

# ssl必须安装ca-certificates， 有配置文件
RUN apt update || true && \
    apt install -y ca-certificates

RUN umask 0022 && \
    if [ "$(uname -m)" = "aarch64" ] && [ ! -d "/lib64" ]; \
    then \
        mkdir /lib64 && ln -sf /lib/ld-linux-aarch64.so.1 /lib64/ld-linux-aarch64.so.1; \
    fi && \
    groupadd HwHiAiUser && \
    useradd -g HwHiAiUser -d /home/HwHiAiUser -m HwHiAiUser && \
    groupmod -g $HWHIAIUSER_GID HwHiAiUser && \
    usermod -u $HWHIAIUSER_UID HwHiAiUser && \
    cd /root && ./${NNRT_PKG} --quiet --install && \
    rm ${NNRT_PKG}

RUN umask 0022 && \
    mkdir -p /usr/slog && \
    mkdir -p /var/log/npu/slog/slogd && \
    chown -Rf HwHiAiUser:HwHiAiUser  /usr/slog && \
    chown -Rf HwHiAiUser:HwHiAiUser  /var/log/npu/slog

VOLUME ["/home/HwHiAiUser/koala/osmagic", "/usr/local/bin/run.sh"]

ENV LD_LIBRARY_PATH=\
/usr/lib/aarch64-linux-gnu:\
$ASCEND_BASE/driver/lib64:\
$ASCEND_BASE/add-ons:\
$ASCEND_BASE/nnrt/latest/acllib_linux.arm64/lib64:\
/root/cxx_so:\
/home/HwHiAiUser/koala/osmagic

WORKDIR /home/HwHiAiUser/koala/osmagic

ENTRYPOINT run.sh
