#include "ap_int.h"
#include "ap_fixed.h"
#include "hls_stream.h"
#include "float.h"
#include "../include/packet_snooper.h"

typedef ap_ufixed<32,16> ap_f;
typedef ap_ufixed<8,1> ap_fs;

void packet_size_EMA (
		ap_uint <1> measure,
		ap_fs Beta,
		ap_uint <64> packet_size,
		ap_uint <1> packet_size_valid,
		hls::stream <output_axis> &packet_size_average,
		ap_uint <32> read_frequency
			) {
	
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS resource core=AXI4Stream variable=packet_size_average
#pragma HLS DATA_PACK variable=packet_size_average
#pragma HLS INTERFACE ap_none port=packet_size
#pragma HLS INTERFACE ap_none port=packet_size_valid
#pragma HLS INTERFACE ap_none port=Beta

	static ap_f EMA_old = 0;
	static ap_f EMA;
	static ap_uint <64> counter = 0;
	ap_f dummy;

	output_axis output_temp;

	//the following line do absolutely nothing.
	//but without them the latency goes from 0 to 1
	//very strange
	dummy = EMA;

	if (measure == 1) {
		if (packet_size_valid) {
			EMA = (ap_f(1.0)-ap_f(Beta))*(EMA_old) + ap_f(Beta)*(ap_f(packet_size));
			EMA_old = EMA;
		}
		//output the EMA value
		if (counter == read_frequency) {
			output_temp.data = EMA;
			output_temp.last = 1;
			output_temp.keep = 0xFF;
			if (!packet_size_average.full())
				packet_size_average.write(output_temp);
			counter = 0;
		}
		else
			counter++;
	}

	else {
		counter = 0;
		EMA = 0;
		EMA_old = 0;
	}
}
