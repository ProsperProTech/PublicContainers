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

FROM debian:buster-slim

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    curl \
    dirmngr \
		gnupg \
		wget \
		ca-certificates \
		p11-kit \
		unzip; \
		rm -rf /var/lib/apt/lists/*

RUN curl -Lso /tmp/containerpilot.tar.gz "https://github.com/joyent/containerpilot/releases/download/3.8.0/containerpilot-3.8.0.tar.gz" \
    && echo "84642c13683ddae6ccb63386e6160e8cb2439c26 /tmp/containerpilot.tar.gz" | sha1sum -c \
    && tar zxf /tmp/containerpilot.tar.gz -C /usr/local/bin \
    && rm /tmp/containerpilot.tar.gz
