Perf_Monitor_IPCore:
	$(MAKE) -C ip_repo/hls_ips
	$(MAKE) -C ip_repo/vivado_ips

clean_all:
	$(MAKE) -C hls_ips clean
