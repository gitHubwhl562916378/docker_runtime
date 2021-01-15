From ubuntu:18.04

ADD cxx_so.tar.gz /root/
ADD sources.list /etc/apt/
ADD jdk1.8.0_231.tar.gz /usr/lib/jvm
RUN cd /usr/bin && \
    ln -s /usr/lib/jvm/jdk1.8.0_231/bin/java java

# ssl必须安装ca-certificates， 有配置文件
RUN apt update || true && \
    apt install -y --no-install-recommends ca-certificates

VOLUME ["/home/HwHiAiUser/koala/osmagic", "/usr/local/bin/run.sh"]

ENV LD_LIBRARY_PATH=\
/usr/local/Ascend/ascend-toolkit/latest/acllib_linux.arm64/lib64:\
/usr/local/Ascend/driver/lib64:\
/usr/local/Ascend/add-ons:\
/usr/local/lib:\
/root/cxx_so:\
/home/HwHiAiUser/koala/osmagic

ENTRYPOINT run.sh
