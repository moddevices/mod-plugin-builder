FROM debian:bookworm
LABEL maintainer="Filipe Coelho <falktx@mod.audio>"
ENV DEBIAN_FRONTEND noninteractive

# platform argument must be provided, e.g. --build-arg platform=moddwarf-new
ARG platform=moddwarf-new

# optional argument for specifying build target
ARG target=full

# enable i386, armhf and arm64
RUN dpkg --add-architecture i386
RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture arm64

# update and upgrade system
RUN apt-get update && apt-get upgrade -qqy && apt-get clean

# install packages for buildroot
RUN apt-get install -qqy qemu-user-static && \
    apt-get install -qqy libc6:i386 libstdc++6:i386 zlib1g:i386 && \
    apt-get install -qqy libc6:armhf libstdc++6:armhf zlib1g:armhf && \
    apt-get install -qqy libc6:arm64 libstdc++6:arm64 zlib1g:arm64 && \
    apt-get install -qqy locales acl bash bash-completion bc curl cvs git mercurial rsync subversion sudo wget dosfstools && \
    apt-get install -qqy bison bundler bzip2 cpio flex gawk gperf gzip help2man nano perl patch tar texinfo unzip && \
    apt-get install -qqy python-is-python3 python3-dev python3-setuptools && \
    apt-get install -qqy automake binutils build-essential device-tree-compiler premake4 sunxi-tools libtool-bin ncurses-dev jq && \
    apt-get install -qqy libfreetype6-dev libx11-dev libxcursor-dev libxinerama-dev libxrandr-dev pkg-config && \
    apt-get clean

# install old premake
RUN if test "$(dpkg-architecture -qDEB_TARGET_ARCH)" = "arm64"; then \
        wget http://ports.ubuntu.com/ubuntu-ports/pool/universe/p/premake/premake_3.7-1_arm64.deb && \
        dpkg -i premake_3.7-1_arm64.deb && \
        rm premake_3.7-1_arm64.deb; \
    else \
        wget http://archive.ubuntu.com/ubuntu/pool/universe/p/premake/premake_3.7-1_amd64.deb && \
        dpkg -i premake_3.7-1_amd64.deb && \
        rm premake_3.7-1_amd64.deb; \
    fi

# misc stuff
RUN locale-gen en_US.UTF-8
RUN echo "source /etc/bash_completion" >> /root/.bashrc

# rust support
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --no-modify-path --profile minimal --default-toolchain stable
RUN if test "$platform" = "modduo" || test "$platform" = "modduo-new" || test "$platform" = "modduo-static"; then \
        ~/.cargo/bin/rustup target add armv7-unknown-linux-gnueabihf; \
    elif test "$platform" = "modduox" || test "$platform" = "modduox-new" || test "$platform" = "modduox-static"; then \
        ~/.cargo/bin/rustup target add aarch64-unknown-linux-gnu; \
    elif test "$platform" = "moddwarf" || test "$platform" = "moddwarf-new"; then \
        ~/.cargo/bin/rustup target add aarch64-unknown-linux-gnu; \
    else \
        ~/.cargo/bin/rustup target add x86_64-unknown-linux-gnu; \
    fi

# mod-plugin-builder settings
ENV MPB_GIT_URL https://github.com/moddevices/mod-plugin-builder

# ct-ng settings
ENV CT_ALLOW_BUILD_AS_ROOT_SURE y

# checkout mod-build-system
WORKDIR /root
RUN git clone $MPB_GIT_URL
WORKDIR mod-plugin-builder
RUN ./bootstrap.sh $platform $target && ./.clean-install.sh $platform

# CMD
CMD ["bash"]
