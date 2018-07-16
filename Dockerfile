FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y wget bash zip rsync git curl build-essential software-properties-common libopenblas-dev swig apt-utils
ENV BLASLDFLAGS /usr/lib/libopenblas.so.0

RUN add-apt-repository ppa:jonathonf/python-3.6 && \
    apt-get update && \
    apt-get install -y python3.6 python3-venv python3-dev

RUN curl https://bootstrap.pypa.io/get-pip.py | python3.6

RUN pip install python-config numpy --no-cache-dir && \
    ln -s /usr/bin/python3.6 /usr/bin/python && \
    ln -s /usr/bin/python3-config /usr/bin/python-config

RUN git clone https://github.com/facebookresearch/faiss && \
    cp /faiss/example_makefiles/makefile.inc.Linux /faiss/makefile.inc
WORKDIR /faiss

RUN ./configure && \
    make && \
    make install && \
    make misc/test_blas && \
    ./misc/test_blas

RUN make py && cd python/ && pip install -U .

ENTRYPOINT ["python", "-c", "import faiss"]
