#include "hls_stream.h"
#include "ap_int.h"
#include "../include/packet_snooper.h"

void packet_snooper_8 (
		hls::stream <byte_axis> in_stream,
		hls::stream <output_axis> &number_of_flits,
		hls::stream <output_axis> &cycle_count,
		ap_uint <1> measure, //used to start and stop measurements
		ap_uint <64> &packet_size,
		ap_uint <1> &packet_size_valid
		//add Beta variable
					) {
#pragma HLS INTERFACE ap_none port=packet_size
#pragma HLS INTERFACE ap_none port=packet_size_valid
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS resource core=AXI4Stream variable=in_stream
#pragma HLS DATA_PACK variable=in_stream
#pragma HLS resource core=AXI4Stream variable=number_of_flits
#pragma HLS DATA_PACK variable=number_of_flits
#pragma HLS resource core=AXI4Stream variable=cycle_count
#pragma HLS DATA_PACK variable=cycle_count

	byte_axis input_flit_temp;
	output_axis output_flit_temp;
	static ap_uint <64> counter = 0;
	static ap_uint <64> num_of_flits = 0;
	static ap_uint <64> bytes_in_flit = 0;
	static ap_uint <64> number_of_bytes = 0;
	static ap_uint <64> packet_size_reg = 0;
	static ap_uint <1> packet_size_valid_reg = 0;
	static ap_uint <1> flit_keep;
	static ap_uint <1> measure_old = measure;

	packet_size = packet_size_reg;
	packet_size_valid = packet_size_valid_reg;

	//reset values on new measurement
	if (measure_old == 0 && measure == 1) {
		counter = 0;
		num_of_flits = 0;
	}

	output_flit_temp.keep = 0xFF;
	output_flit_temp.last = 1;
	output_flit_temp.data = counter;
	//on the falling edge of the measure signal
	if (measure_old == 1 && measure == 0) {
		if (!cycle_count.full()) {
			cycle_count.write(output_flit_temp);
		}
	}

	//write the number of flits to the output
	output_flit_temp.data = num_of_flits;
	if (measure_old == 1 && measure == 0) {
		if (!number_of_flits.full()) {
			number_of_flits.write(output_flit_temp);
		}
	}


	//start measurement
	if (measure == 1) {
		counter++;

		//if in_stream is not empty and
		//read can be done, then valid and
		//ready are both high
		if (!in_stream.empty()) {
			input_flit_temp = in_stream.read();

			flit_keep = input_flit_temp.keep; //extract the keep side channel
			num_of_flits++; //increment the number of flits

			//create a mux to count # of 1s in the keep side channel
			switch (flit_keep) {
			case 0:
				bytes_in_flit = 0;
				break;
			case 1:
				bytes_in_flit = 1;
				break;
			}

			if (input_flit_temp.last == 1) {
				number_of_bytes += bytes_in_flit;
				packet_size_reg = number_of_bytes;
				number_of_bytes = 0;
				packet_size_valid_reg = 1;
			}
			else {
				number_of_bytes += bytes_in_flit;
				packet_size_valid_reg = 0;
			}
		} //end of measurement
	}
	measure_old = measure;
}
