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
# Adapted from https://github.com/apache/nifi/blob/rel/nifi-1.9.2/nifi-docker/dockerhub/Dockerfile

ARG FROMIMAGE
FROM ${FROMIMAGE}
ARG IMGVERSION

LABEL maintainer="Martijn Dekkers <martijn@regulusdata.services>"
LABEL copyright="Copyright (c) 2020 Regulus Data Services"
LABEL vendor="Regulus Data Services"
LABEL version=${IMGVERSION}
LABEL site="https://www.regulusdata.services"

ARG UID=${UID}
ARG GID=${GID}

ENV NIFI_BASE_DIR=/opt/nifi
ENV NIFI_HOME ${NIFI_BASE_DIR}/nifi-current
ENV NIFI_LOG_DIR=${NIFI_HOME}/logs
ENV NIFI_PID_DIR=${NIFI_HOME}/run

# ADD --chown=nifi:nifi conf/ ${NIFI_HOME}/conf/
ADD --chown=nifi:nifi sh/ ${NIFI_BASE_DIR}/scripts/

RUN echo "#!/bin/sh\n" > $NIFI_HOME/bin/nifi-env.sh

WORKDIR ${NIFI_HOME}

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/bash", "-c", "exec ../scripts/init.sh"]
