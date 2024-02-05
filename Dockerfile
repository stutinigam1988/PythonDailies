ARG PYTHON_VERSION=3.9.10
FROM --platform=linux/amd64 python:$PYTHON_VERSION
USER root
WORKDIR /opt
RUN if [ "$(arch)" = "aarch64" ] ; then ARCHITECTURE="aarch64" ; else ARCHITECTURE="x64"; fi && \
    wget -O OpenJDK.tar.gz https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11%2B9/OpenJDK11U-jdk_${ARCHITECTURE}_linux_hotspot_11.0.11_9.tar.gz && \
    wget -O scala.tgz https://downloads.lightbend.com/scala/2.13.5/scala-2.13.5.tgz && \
    wget -O spark-hadoop.tgz https://archive.apache.org/dist/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz
RUN tar xzf OpenJDK.tar.gz && \
    tar xvf scala.tgz && \
    tar xvf spark-hadoop.tgz
ENV PATH="/opt/jdk-11.0.11+9/bin:/opt/scala-2.13.5/bin:/opt/spark-3.2.1-bin-hadoop3.2/bin:$PATH"

RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:${PATH}"
RUN poetry config virtualenvs.in-project false

#TODO : Change the user to non root user
#USER 185
WORKDIR /app

COPY ./pyproject.toml /app/pyproject.toml

RUN poetry install