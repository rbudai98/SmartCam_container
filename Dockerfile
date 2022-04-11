FROM ubuntu:latest

RUN apt-get update

RUN mkdir -p /home/HELLOWORLD

RUN git clone https://github.com/analogdevicesinc/aditof_sdk.git

RUN mv -r aditof_sdk /home/HELLOWORLD

CMD mkdir /home/HELLOWORLD/aditof_sdk/build 
CMD cd /home/HELLOWORLD/aditof_sdk/build
CMD cmake ..
CMD make -j8
