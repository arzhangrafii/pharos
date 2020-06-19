#include "hls_stream.h"
#include "ap_int.h"
#include "hls_math.h"

using namespace std;

struct gulf_axis {
	ap_uint<512> data;
	ap_uint<64> keep;
	ap_uint<16> dest;
	ap_uint<1> last;
	ap_uint<32> user;
	ap_uint<16> id;
};

struct kernel_axis {
	ap_uint<64> data;
	ap_uint<1> last;
	ap_uint<8> keep;
	ap_uint<16> user;
};

void packet_parser (
		hls::stream <gulf_axis> &out_stream,
		hls::stream <gulf_axis> &in_stream,
		hls::stream <kernel_axis> &output,
		ap_uint <32> read_frequency,
		ap_uint <64> time,
		ap_uint <64> &latency_raw,
		ap_uint <1> measure,
		ap_uint <32> remote_ip_tx,
		ap_uint <16> remote_port_tx
		) {

#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS resource core=AXI4Stream variable=out_stream
#pragma HLS resource core=AXI4Stream variable=output
#pragma HLS DATA_PACK variable=out_stream //concats the struct into one big block
#pragma HLS DATA_PACK variable=output
#pragma HLS resource core=AXI4Stream variable=in_stream
#pragma HLS DATA_PACK variable=in_stream
#pragma HLS INTERFACE ap_none port=latency_raw


	gulf_axis flit_temp;
	kernel_axis latency_temp;
	static ap_uint <64> timestamp;
	static ap_uint <64> latency = 0;
	static ap_uint <16> remote_ip_rx;
	static ap_uint <64> packet_time_sent = 0;
	static ap_uint <32> counter = 0;
	static ap_uint <32> latency_ub;
	static ap_uint <32> latency_lb;

	static enum {LATENCY, TIME} state = LATENCY;

	latency_temp.keep = 0xFF;
	latency_temp.last = 1;
	switch (state) {
	case LATENCY:
		if (measure == 1) {
			if (counter == read_frequency) {
				latency_temp.data = latency;
				latency_temp.user = remote_ip_rx;
				if (!output.full())
					output.write(latency_temp);
				counter = 0;
				state = TIME;
			}
			else {
				counter++;
			}
		}
		else {
			counter = 0;
		}
		break;
	case TIME:
		latency_temp.data = timestamp;
		latency_temp.user = remote_ip_rx;
		if (!output.full())
			output.write(latency_temp);
		state = LATENCY;
		break;
	}

	latency_raw = latency;
	if (!in_stream.empty()) { //if latency is not valid, drop the packet
		flit_temp = in_stream.read();
		packet_time_sent = flit_temp.data.range(495,432);
		latency = abs(packet_time_sent - time);
		timestamp = time;

		//capture the sender's ip address (the ip address relating to this latency value)
		remote_ip_rx = flit_temp.user;

		if (!out_stream.full()) { //send packets back towards master only when new packets still arrive
			flit_temp.last = 1;
			flit_temp.dest = remote_port_tx;
			//flit_temp.user = remote_ip_tx;
			out_stream.write(flit_temp);
		}
	}
}
