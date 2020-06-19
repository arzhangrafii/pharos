#include "ap_int.h"

void slave_timer (ap_uint<64> &time, ap_uint<64> new_time, ap_uint<1> set_time) {
#pragma HLS LATENCY max=0 min=0
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_none port=time
#pragma HLS INTERFACE ap_none port=new_time
#pragma HLS INTERFACE ap_none port=set_time

	static ap_uint<64> count = 0;
	time = count;

	if (set_time == 1)
		count = new_time;

	count++;
}
