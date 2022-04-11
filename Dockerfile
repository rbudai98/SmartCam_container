FROM ubuntu:latest

RUN apt-get update

RUN mkdir -p /home/HELLOWORLD

RUN cp -r . /home/HELLOWORLD

CMD echo robi >> test.txt
