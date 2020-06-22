#include "hls_stream.h"
#include "ap_int.h"

using namespace std;

struct input_axis {
	ap_uint<64> data;
	ap_uint<1> last;
	ap_uint<8> keep;
	ap_uint<16> user;
};

struct output_axis {
	ap_uint<32> data;
	ap_uint<1> last;
	ap_uint<4> keep;
	ap_uint<16> user;
};

void data_stream_compressor (
		hls::stream <input_axis> in_stream,
		hls::stream <output_axis> &out_stream
		) {

#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS resource core=AXI4Stream variable=out_stream
#pragma HLS DATA_PACK variable=out_stream
#pragma HLS resource core=AXI4Stream variable=in_stream
#pragma HLS DATA_PACK variable=in_stream

	static input_axis input_temp;
	output_axis output_temp;

	static enum {OUT1, OUT2} state = OUT1;

	switch(state) {
	case OUT1:
		if (!in_stream.empty()) {
			input_temp = in_stream.read();
			output_temp.data = input_temp.data.range(63,32);
			output_temp.last = 0;
			output_temp.keep = 0xF;
			if (!out_stream.full())
				out_stream.write(output_temp);
			state = OUT2;
		}
		break;
	case OUT2:
		output_temp.data = input_temp.data.range(31,0);
		output_temp.last = input_temp.last;
		output_temp.keep = 0xF;
		if (!out_stream.full())
			out_stream.write(output_temp);
		state = OUT1;
		break;
	}

}
