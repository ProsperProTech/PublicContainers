FROM flowfabricator/base:2.1.1

LABEL org.label-schema.name="Regulus Data Services HTTPBIN Container"
LABEL org.label-schema.description="HTTPBIN Echo Service. This requires Consul and Vault to work."
LABEL org.label-schema.vcs-url="https://github.com/RegulusDataServices/PublicContainers/tree/master/httpbin"
LABEL org.label-schema.vendor="Regulus Data Services"
LABEL org.label-schema.version="1.0.0"
LABEL services.regulusdata.maintainer="Martijn Dekkers <martijn@regulusdata.services>"
LABEL services.regulusdata.copyright="Copyright (c) 2020 Regulus Data Services"

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update -y && apt-get install python3-pip git -y && pip3 install --no-cache-dir pipenv

ADD Pipfile Pipfile.lock /httpbin/
WORKDIR /httpbin
RUN /bin/bash -c "pip3 install --no-cache-dir -r <(pipenv lock -r)"

ADD . /httpbin
ADD init.sh /init.sh

RUN pip3 install --no-cache-dir /httpbin

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["/bin/bash", "-c", "exec /init.sh"]
