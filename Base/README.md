# FlowFabricator Base
This is the FlowFabricator Base Container image. This is a simple Debian buster-slim base image, 
with ContainerPilot added as an init and management system. There is a lot of noise on the interwebs about wether or 
not it is a good idea to have init systems in containers, and we fall on the side of "good, with some caveats".

A container is supposed to a thing. To do a thing, many applications will need some actions performed before they can run, 
especially long(er) running services and maybe also have some actions performed when they are done, or die, or are killed.

Most container runtimes run whatever is executed in their container as PID1, which is a special PID, and requires 
special handling. Many services are currently not really designed to be run as PID1. You need an init system to 
handle PID1 particulars, that properly hands off to whatever service you want to run. 

Container Pilot was designed to integrate with Hashicorps' Consul for configuration management, service discovery
and Service Mesh capabilities. To use this image, having a Consul cluster up and running is handy. 
It is possible to run without Consul but this needs to be dealt with in the configuration.

Subdirectories hold dockerfiles for runtime images that are built on the base image.     