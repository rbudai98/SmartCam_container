ARG DEBIAN_FRONTEND=noninteractive
FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y cmake

# Installing glog for sdk

RUN git clone --branch v0.3.5 --depth 1 https://github.com/google/glog
RUN cd glog
RUN mkdir build_0_3_5 && cd build_0_3_5
RUN cmake -DWITH_GFLAGS=off -DCMAKE_INSTALL_PREFIX=/opt/glog ..
RUN sudo make -j4 && sudo make install
RUN cd ../..

# Install libwebsocket for sdk

RUN sudo apt-get install libssl-dev
RUN git clone --branch v3.2.3 --depth 1 https://github.com/warmcat/libwebsockets
RUN cd libwebsockets
RUN mkdir build_3_2_3 && cd build_3_2_3
RUN cmake -DLWS_STATIC_PIC=ON -DCMAKE_INSTALL_PREFIX=/opt/websockets ..
RUN sudo make -j4 && sudo make install
RUN cd ../..

# Install protobuf for the sdk

RUN git clone --branch v3.9.0 --depth 1 https://github.com/protocolbuffers/protobuf
RUN cd protobuf
RUN mkdir build_3_9_0 && cd build_3_9_0
RUN cmake -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX=/opt/protobuf ../cmake
RUN sudo make -j4 && sudo make install
RUN cd ../..

# Build the sdk
RUN git clone https://github.com/analogdevicesinc/aditof_sdk.git
RUN cd aditof_sdk
RUN mkdir build && cd build
RUN cmake -DWITH_EXAMPLES=off -DCMAKE_PREFIX_PATH="/opt/glog;/opt/protobuf;/opt/websockets" ..
RUN make -j4
