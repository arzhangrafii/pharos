#include "hls_stream.h"
#include "ap_int.h"
//#define SYNC_PERIOD 100000
#define TIME_OUT 100000000

struct gulf_axis {
	ap_uint<512> data;
	ap_uint<64> keep;
	ap_uint<16> dest;
	ap_uint<1> last;
	ap_uint <16> id;
	ap_uint<32> user; //this will feed into remote_ip_tx of gulf stream
	//local_ip will be sent by GULF stream
	// can later add another field (such as id) to include the remote_ip_tx
};

void ptp_slave (
			ap_uint <1> init,
			ap_uint <64> current_time,
			ap_uint <64> &new_time,
			ap_uint <1> &set_time,
			hls::stream <gulf_axis> packet_in,
			hls::stream <gulf_axis> &packet_out,
			ap_uint <4> &state_out,
			ap_uint <32> remote_ip_tx,
			ap_uint <16> remote_port_tx,
			ap_uint <16> local_port_tx,
			ap_uint <64> &sync_req_time_out,
			ap_uint <64> &network_time_out,
			ap_uint <32> sync_period
		) {

#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_none port=set_time
#pragma HLS INTERFACE ap_none port=new_time
#pragma HLS INTERFACE ap_none port=state_out
#pragma HLS INTERFACE ap_none port=sync_req_time_out
#pragma HLS INTERFACE ap_none port=network_time_out
#pragma HLS resource core=AXI4Stream variable=packet_in
#pragma HLS DATA_PACK variable=packet_in
#pragma HLS resource core=AXI4Stream variable=packet_out
#pragma HLS DATA_PACK variable=packet_out

	gulf_axis packet_local;
	static ap_uint<64> sync_req_time;
	static ap_uint<64> network_time;
	static ap_uint<64> last_time = 0;
	
	network_time_out = network_time;
	sync_req_time_out = sync_req_time;

	static enum {IDLE, SYNC_REQ, SYNC} state = IDLE;

	state_out = state;

	if (init == 1) {
		switch (state) {
		case IDLE:
			set_time = 0;
			if (!packet_out.full()) {
				packet_local.dest = remote_port_tx;
				packet_local.user = remote_ip_tx;
				packet_local.id = local_port_tx;
				packet_local.data = 1;
				packet_local.keep = 0xFFFFFFFFFFFFFFFF;
				packet_local.last = 1;
				packet_out.write(packet_local);
				sync_req_time = current_time;
				state = SYNC;
			}
			break;
		case SYNC_REQ: //request a new time synchronization
			set_time = 0;
			if (!packet_out.full()) {
				if (current_time - last_time >= sync_period) {
					packet_local.dest = remote_port_tx;
					packet_local.user = remote_ip_tx;
					packet_local.id = local_port_tx;
					packet_local.data = 1;
					packet_local.keep = 0xFFFFFFFFFFFFFFFF;
					packet_local.last = 1;
					packet_out.write(packet_local);
					sync_req_time = current_time;
					state = SYNC;
				}
			}
			break;
		case SYNC:
			if ((current_time - sync_req_time) >= TIME_OUT) {
				set_time = 0;
				state = SYNC_REQ;
			}
			else if (!packet_in.empty()) {
				packet_local = packet_in.read();
				new_time = packet_local.data.range(63,0);
				network_time = (current_time - sync_req_time)/2;
				new_time = new_time + network_time;
				set_time = 1;
				last_time = new_time;
				state = SYNC_REQ;
			}
			else
				set_time = 0;
			break;
		}
	}
	else {
		state = SYNC_REQ;
		set_time = 0;
	}
}

