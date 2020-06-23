all: pharos_IPCore bandwidth_monitor_example

pharos_IPCore:
	$(MAKE) -C ip_repo/hls_ips
	$(MAKE) -C ip_repo/vivado_ips

bandwidth_monitor_example:
	$(MAKE) -C examples/hls_ips
	$(MAKE) -C examples bandwidth_monitor

clean_all:
	$(MAKE) -C examples clean
	$(MAKE) -C ip_repo/hls_ips clean
