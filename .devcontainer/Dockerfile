FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# 플러터 설치에 필요한 프로그램 설치
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends curl git unzip xz-utils zip libglu1-mesa wget

# sdk 환경 생성
ENV FLUTTER_HOME=/opt/flutter
RUN mkdir -p ${FLUTTER_HOME}

# flutter 다운로드
ARG FLUTTER_URL=https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.35.6-stable.tar.xz
RUN wget -O /tmp/flutter.tar.xz "${FLUTTER_URL}" && \
    tar -xf /tmp/flutter.tar.xz -C /opt && \
    mv /opt/flutter ${FLUTTER_HOME} || true && \
    rm -f /tmp/flutter.tar.xz

# PATH
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

# Firebase 설치
RUN git config --global --add safe.directory /opt/flutter
RUN curl -sL https://firebase.tools | bash