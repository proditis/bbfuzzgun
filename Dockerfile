FROM ghcr.io/echoctf/base-buster:latest
LABEL org.opencontainers.image.source=https://github.com/proditis/bbfuzzgun \
      maintainer="echothrust solutions <info@echothrust.com>" \
      description="BBFuzzGun"

ENV TZ=UTC
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV APT_LISTCHANGES_FRONTEND=none
ENV GOPATH=/tools
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

ENV FQDN=gixy.local
ENV IPV4=127.0.0.1
ENV URL=https://${IPV4}
ENV HEADER="Host: ${FQDN}"

COPY --chown=root:root ./files/start.sh /tools/bin/
COPY --chown=root:root ./files/atemplate /tools/bin/
COPY --chown=root:root ./files/ansible.cfg /etc/ansible/

WORKDIR /wordlists
WORKDIR /tools/src
WORKDIR /usr/src


ADD https://raw.githubusercontent.com/afwu/leaky-paths/main/leaky-misconfigs.txt /wordlists/
ADD https://raw.githubusercontent.com/afwu/leaky-paths/main/juicy-paths.txt /wordlists/
ADD https://raw.githubusercontent.com/afwu/leaky-paths/main/cve-paths.txt /wordlists/
ADD https://raw.githubusercontent.com/afwu/leaky-paths/main/all-files.txt /wordlists/

ADD https://raw.githubusercontent.com/gwen001/pentest-tools/master/smuggler.py /tools/bin/
ADD https://codeload.github.com/devanshbatham/ParamSpider/tar.gz/refs/heads/master /usr/src/paramspider.tar.gz
#https://github.com/anshumanpattnaik/http-request-smuggling
#ADD https://codeload.github.com/anshumanpattnaik/http-request-smuggling/tar.gz/refs/heads/master /usr/src/http-request-smuggling.tar.gz

ADD https://codeload.github.com/ffuf/ffuf/tar.gz/refs/heads/master /usr/src/ffuf.tar.gz
ADD https://dl.google.com/go/go1.18.linux-amd64.tar.gz /usr/src/
RUN set -ex; \
  apt-get update; \
  apt-get install --install-recommends -y git python3 python3-setuptools python3-pip; \
  update-alternatives --install /usr/bin/python python /usr/bin/python3.7 2 ; \
  update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1 ; \
  tar zxpf go1.18.linux-amd64.tar.gz ;\
  chown -R root:root ./go ; \
  mv go /usr/local; \
  rm go1.18.linux-amd64.tar.gz; \
  tar zxf ffuf.tar.gz ; \
  cd ffuf-master ; go get ; go build; go install; cd .. ; \
  tar zxf paramspider.tar.gz -C /tools/src; \
  cd /tools/src/ParamSpider-master ; \
  pip3 install -r requirements.txt ; \
  ln -sf /tools/src/ParamSpider-master/paramspider.py /tools/bin/paramspider.py ;\
#  go install github.com/m4dm0e/dirdar@latest ; \
#  go install github.com/subfinder/subfinder@latest; \
#  go install github.com/tomnomnom/assetfinder@latest; \
#  go install github.com/lc/gau@latest ;\
#  go install github.com/jaeles-project/gospider@latest ;\
#  go install github.com/haccer/subjack@latest ; \
#  go install github.com/tomnomnom/httprobe@latest ;\
  echo "localhost" > /etc/ansible/hosts ; \
  pip3 install wheel; \
  pip3 install colored; \
  pip3 install gixy==0.1.20 pyparsing==2.4.7; \
  pip3 install wheel; \
  pip3 install arjun

RUN chmod +x /tools/bin/*
WORKDIR /checks
#CMD python3 paramspider.py --domain echoctf.local
#CMD gixy /etc/nginx/participantUI.conf
#CMD gixy /etc/nginx/moderatorUI.conf
#CMD ffuf -t 2 -p 0.5  -w /wordlists/seclists/Fuzzing/fuzz-Bo0oM.txt  -H "Host: echoctf.local" -recursion -recursion-depth 2 -u https://192.168.1.25/FUZZ -mc 500,501,502,503,504,505
#ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/start.sh"]