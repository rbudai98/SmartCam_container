ARG DEBIAN_FRONTEND=noninteractive
FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y cmake
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y g++

# Installing glog for sdk

RUN git clone --branch v0.3.5 --depth 1 https://github.com/google/glog
RUN mkdir build_glog
RUN cmake /build_glog -DWITH_GFLAGS=off -DCMAKE_INSTALL_PREFIX=/opt/glog /glog/
RUN make /build_glog -j4 && make install

# Install libwebsocket for sdk

RUN apt-get install libssl-dev
RUN git clone --branch v3.2.3 --depth 1 https://github.com/warmcat/libwebsockets
RUN mkdir build_libwebsockets
RUN cmake /build_libwebsockets -DLWS_STATIC_PIC=ON -DCMAKE_INSTALL_PREFIX=/opt/websockets /libwebsockets/
RUN make /build_libwebsockets -j4 && make install

# Install protobuf for the sdk

RUN git clone --branch v3.9.0 --depth 1 https://github.com/protocolbuffers/protobuf
RUN mkdir build_protobuf
RUN cmake /build_protobuf -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX=/opt/protobuf /protobuf/
RUN make /build_protobuf -j4 && make install

# Build the sdk
RUN git clone https://github.com/analogdevicesinc/aditof_sdk.git
RUN cd aditof_sdk
RUN mkdir build && cd build
RUN cmake -DWITH_EXAMPLES=off -DCMAKE_PREFIX_PATH="/opt/glog;/opt/protobuf;/opt/websockets" /aditof_sdk
RUN make -j4
