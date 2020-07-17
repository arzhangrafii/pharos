all: event_logger packet_snooper packet_snooper_8 packet_snooper_512 packet_size_EMA master_timer slave_timer packet_generator packet_parser packet_parser_multi_fanout ptp_master ptp_slave

event_logger: scripts/traffic_monitor/event_logger/* ../../src/traffic_monitor/event_logger/*
	rm -rf event_logger
	mkdir -p traffic_monitor
	mkdir -p traffic_monitor/event_logger
	vivado -mode tcl -source scripts/traffic_monitor/event_logger/event_logger.tcl -nolog -nojournal
	rm -f vivado_hls.log

packet_snooper: scripts/traffic_monitor/packet_snooper/* ../../src/traffic_monitor/packet_snooper/*
	rm -rf packet_snooper
	mkdir -p traffic_monitor
	mkdir -p traffic_monitor/packet_snooper
	vivado -mode tcl -source scripts/traffic_monitor/packet_snooper/packet_snooper.tcl -nolog -nojournal
	rm -f vivado_hls.log

packet_snooper_8: scripts/traffic_monitor/packet_snooper_8/* ../../src/traffic_monitor/packet_snooper_8/*
	rm -rf packet_snooper_8
	mkdir -p traffic_monitor
	mkdir -p traffic_monitor/packet_snooper_8
	vivado_hls scripts/traffic_monitor/packet_snooper_8/packet_snooper_8.tcl
	rm -f vivado_hls.log

packet_snooper_512: scripts/traffic_monitor/packet_snooper_512/* ../../src/traffic_monitor/packet_snooper_512/*
	rm -rf packet_snooper_512
	mkdir -p traffic_monitor
	mkdir -p traffic_monitor/packet_snooper_512
	vivado_hls scripts/traffic_monitor/packet_snooper_512/packet_snooper_512.tcl
	rm -f vivado_hls.log

packet_size_EMA: scripts/traffic_monitor/packet_size_EMA/* ../../src/traffic_monitor/packet_size_EMA/*
	rm -rf packet_size_EMA
	mkdir -p traffic_monitor
	mkdir -p traffic_monitor/packet_size_EMA
	vivado_hls scripts/traffic_monitor/packet_size_EMA/packet_size_EMA.tcl
	rm -f vivado_hls.log

master_timer: scripts/latency_monitor/master_timer/* ../../src/latency_monitor/master_timer/*
	rm -rf master_timer
	mkdir -p latency_monitor
	mkdir -p latency_monitor/master_timer
	vivado_hls scripts/latency_monitor/master_timer/master_timer.tcl
	rm -f vivado_hls.log

slave_timer: scripts/latency_monitor/slave_timer/* ../../src/latency_monitor/slave_timer/*
	rm -rf slave_timer
	mkdir -p latency_monitor
	mkdir -p latency_monitor/slave_timer
	vivado_hls scripts/latency_monitor/slave_timer/slave_timer.tcl
	rm -f vivado_hls.log

packet_generator: scripts/latency_monitor/packet_generator/* ../../src/latency_monitor/packet_generator/*
	rm -rf packet_generator
	mkdir -p latency_monitor
	mkdir -p latency_monitor/packet_generator
	vivado_hls scripts/latency_monitor/packet_generator/packet_generator.tcl
	rm -f vivado_hls.log

packet_parser: scripts/latency_monitor/packet_parser/* ../../src/latency_monitor/packet_parser/*
	rm -rf packet_parser
	mkdir -p latency_monitor
	mkdir -p latency_monitor/packet_parser
	vivado_hls scripts/latency_monitor/packet_parser/packet_parser.tcl
	rm -f vivado_hls.log

packet_parser_multi_fanout: scripts/latency_monitor/packet_parser_multi_fanout/* ../../src/latency_monitor/packet_parser_multi_fanout/*
	rm -rf packet_parser_multi_fanout
	mkdir -p latency_monitor
	mkdir -p latency_monitor/packet_parser_multi_fanout
	vivado_hls scripts/latency_monitor/packet_parser_multi_fanout/packet_parser_multi_fanout.tcl
	rm -f vivado_hls.log

ptp_master: scripts/latency_monitor/ptp_master/* ../../src/latency_monitor/ptp_master/*
	rm -rf ptp_master
	mkdir -p latency_monitor
	mkdir -p latency_monitor/ptp_master
	vivado_hls scripts/latency_monitor/ptp_master/ptp_master.tcl
	rm -f vivado_hls.log

ptp_slave: scripts/latency_monitor/ptp_slave/* ../../src/latency_monitor/ptp_slave/*
	rm -rf ptp_slave
	mkdir -p latency_monitor
	mkdir -p latency_monitor/ptp_slave
	vivado_hls scripts/latency_monitor/ptp_slave/ptp_slave.tcl
	rm -f vivado_hls.log

clean:
	rm -rf event_logger packet_snooper packet_snooper_8 packet_snooper_512 packet_size_EMA master_timer slave_timer packet_generator packet_parser packet_parser_multi_fanout ptp_master ptp_slave
