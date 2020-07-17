/*
Author: Arzhang Rafii (arzhang.rafii@mail.utoronto.ca)

Module: packet_snooper
Description: This module is made to snoop on 8-bit AXI-stream data lines
*/
#include "ap_int.h"
#include "ap_fixed.h"
#include "hls_stream.h"
#include "float.h"

struct output_axis {
	ap_uint<64> data;
	ap_uint<1> last;
	ap_uint<8> keep;
};

struct byte_axis {
	ap_uint<8> data;
	ap_uint<1> last;
	ap_uint<1> keep;
};

struct ext_axis {
	ap_uint<512> data;
	ap_uint<1> last;
	ap_uint<64> keep;
};
