all: packet_source paket_sink

packet_source: scripts/packet_source/* ../../src/packet_source/*
	rm -rf packet_source
	mkdir -p packet_source
	vivado_hls scripts/packet_source/packet_source.tcl
	rm -f vivado_hls.log

packet_sink: scripts/packet_sink/* ../../src/packet_sink/*
	rm -rf packet_sink
	mkdir -p packet_sink
	vivado_hls scripts/packet_sink/packet_sink.tcl
	rm -f vivado_hls.log

clean:
	packet_source packet_sink
