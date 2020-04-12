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
    && rm /tmp/containerpilot.tar.gz \
    && curl -Lso /tmp/consul.zip "https://releases.hashicorp.com/consul/1.7.2/consul_1.7.2_linux_amd64.zip" \
    && echo "5ab689cad175c08a226a5c41d16392bc7dd30ceaaf90788411542a756773e698 /tmp/consul.zip" | sha256sum -c \
    && unzip /tmp/consul.zip -d /usr/local/bin \
    && rm /tmp/consul.zip \
    && curl -Lso /tmp/vault.zip "https://releases.hashicorp.com/vault/1.4.0/vault_1.4.0_linux_amd64.zip" \
    && echo "8f739c4850bab35e971e27c8120908f48f247b07717d19aabad1110e9966cded /tmp/vault.zip" | sha256sum -c \
    && unzip /tmp/vault.zip -d /usr/local/bin \
    && rm /tmp/vault.zip \
    && curl -Lso /tmp/consul-template.zip "https://releases.hashicorp.com/consul-template/0.24.1/consul-template_0.24.1_linux_arm64.zip" \
    && echo "3556e9d7b2a4f5f964d7282b8b226a1aee713627505b00c1f81c35fab78757a2 /tmp/consul-template.zip" | sha256sum -c \
    && unzip /tmp/consul-template.zip -d /usr/local/bin \
    && rm /tmp/consul-template.zip