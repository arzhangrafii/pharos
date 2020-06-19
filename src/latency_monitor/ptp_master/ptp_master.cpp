#include "hls_stream.h"
#include "ap_int.h"

struct gulf_axis {
	ap_uint<512> data;
	ap_uint<64> keep;
	ap_uint<16> dest;
	ap_uint<1> last;
	ap_uint<32> user; //hold the remote ip, feed into remote_ip_tx
};


void ptp_master (
			ap_uint <64> current_time,
			hls::stream <gulf_axis> &packet_out,
			hls::stream <gulf_axis> packet_in,
			ap_uint <16> remote_port_tx
		) {

#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS resource core=AXI4Stream variable=packet_out
#pragma HLS DATA_PACK variable=packet_out
#pragma HLS resource core=AXI4Stream variable=packet_in
#pragma HLS DATA_PACK variable=packet_in


	gulf_axis packet_local;

	if (!packet_in.empty()) { //a sync request is received. send time back
		packet_local = packet_in.read();
		if (packet_local.data == 1) {
			packet_local.data.range(63,0) = current_time;
			packet_local.data.range(511,64) = 0;
			packet_local.dest = remote_port_tx;
			packet_local.keep = 0xFFFFFFFFFFFFFFFF;
			packet_local.last = 1;
			if (!packet_out.full())
				packet_out.write(packet_local);
				//the user field will be the one received, we're not changing it.
				//user field will come from the remote_ip_rx of GULF stream (slave's ip addr)
		}
	}
}

