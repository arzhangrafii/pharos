#include "ap_int.h"

void master_timer (ap_uint<64> &time) {
#pragma HLS LATENCY max=0 min=0
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_none port=time

	static ap_uint<64> count = 0;
	time = count;

	count++;
}
