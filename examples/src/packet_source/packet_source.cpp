#include "hls_stream.h"
#include "ap_int.h"
#include "hls_math.h"
#include "../include/packet_source.h"

using namespace std;

void packet_source (
		hls::stream <kernel_axis> &out_stream,
		ap_uint <1> init
		) {

#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS resource core=AXI4Stream variable=out_stream
#pragma HLS DATA_PACK variable=out_stream

	kernel_axis flit_out;
	flit_out.data = 0x8BADF00D;
	flit_out.last = 1;
	flit_out.keep = 0xFFFFFFFF;

	if (init == 1) {
		if (!out_stream.full())
			out_stream.write(flit_out);
	}
}
