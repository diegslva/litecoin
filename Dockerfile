FROM ubuntu:18.04

COPY ./medicoin.conf /root/.medicoin/medicoin.conf

COPY . /medicoin
WORKDIR /medicoin

#shared libraries and dependencies
RUN apt update
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
RUN apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev

#BerkleyDB for wallet support
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev

#upnp
RUN apt-get install -y libminiupnpc-dev

#ZMQ
RUN apt-get install -y libzmq3-dev

# permissions
RUN chmod 764  ./config.guess
RUN chmod 764  ./config.sub
RUN chmod +x  ./autogen.sh
RUN find ./ -type f -iname "*.sh" -exec chmod +x {} \;

#build medicoin source
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

#open service port
EXPOSE 9777 19777

CMD ["medicoind", "--printtoconsole"]
