FROM arm64v8/ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /iNode
COPY iNodeClient.tar.gz /iNode
COPY run.sh /iNode
RUN chmod 755 /iNode/run.sh \
&& apt update \
&& apt upgrade -y\
&& apt install -y libgtk2.0-0 libqt5widgets5 libsm6 libxext6 libxrender-dev \
&& apt install -y xvfb\
&& apt install -y x11vnc\
&& apt install krb5-user\
&& tar -xzf iNodeClient.tar.gz \
&& rm iNodeClient.tar.gz \
&& cd iNodeClient\
&& ./install_64.sh

CMD /iNode/run.sh


EXPOSE 8080
EXPOSE 8900
EXPOSE 5900