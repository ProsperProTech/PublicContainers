# Copyright (c) 2020 Regulus Data Services.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Adapted from https://github.com/containous/traefik-library-image

ARG FROMIMAGE
FROM ${FROMIMAGE}
ARG IMGVERSION
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.label-schema.name="Regulus Data Services Traefik Container"
LABEL org.label-schema.description="Traefik Cloud Native Edge Router. This requires Consul and Vault to work."
LABEL org.label-schema.vcs-url="https://github.com/RegulusDataServices/PublicContainers/tree/master/Traefik"
LABEL org.label-schema.vendor="Regulus Data Services"
LABEL org.label-schema.version="1.0.0"
LABEL services.regulusdata.maintainer="Martijn Dekkers <martijn@regulusdata.services>"
LABEL services.regulusdata.copyright="Copyright (c) 2020 Regulus Data Services"

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update -y \
    && apt-get upgrade -y \
    && wget --quiet -O /tmp/traefik.tar.gz "https://github.com/containous/traefik/releases/download/v2.2.0/traefik_v2.2.0_linux_amd64.tar.gz" \
    && tar xzvf /tmp/traefik.tar.gz -C /usr/local/bin traefik \
    && rm -f /tmp/traefik.tar.gz \
    && chmod +x /usr/local/bin/traefik

ADD init.sh /init.sh

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["/bin/bash", "-c", "exec /init.sh"]
