#include "hls_stream.h"
#include "ap_int.h"
#include "hls_math.h"
#include "../include/packet_source.h"

using namespace std;

void packet_sink (
		hls::stream <kernel_axis> in_stream
		) {

#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS resource core=AXI4Stream variable=in_stream
#pragma HLS DATA_PACK variable=in_stream


	kernel_axis flit_temp;

	if (!in_stream.empty())
		flit_temp = in_stream.read();
}
