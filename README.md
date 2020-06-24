# pharos

performance monitoring instrumentation for multi-FPGA systems

## Contents

/src contains all the hls and vivado source files
/ip_repo contains the tcl scripts that generate the hls and vivado ips
/examples contains the example projects. There are some extra ip cores that are made for the sake of the example projects. These cores can be found in example/hls_ips

## Make

*To make pharos ip repository

> make pharos_IPCore

*To make bandwidth monitor example

> make bandwidth_monitor_example

*To make the ip repository and example projects

> make all
