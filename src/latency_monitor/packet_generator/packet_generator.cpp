#include "hls_stream.h"
#include "ap_int.h"


struct gulf_axis {
	ap_uint<512> data;
	ap_uint<64> keep;
	ap_uint<16> dest;
	ap_uint<1> last;
	ap_uint<32> user; //to hold the remote_ip_tx
	ap_uint<16> id;
};

void packet_generator (
		hls::stream <gulf_axis> &out_stream,
		ap_uint<64> time,
		ap_uint<1> init,
		ap_uint <64> frequency,
		ap_uint<32> remote_ip_tx,
		ap_uint<16> local_port_tx,
		ap_uint<16> remote_port_tx
		) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS resource core=AXI4Stream variable=out_stream //use this instead of INTERFACE (which is buggy)
#pragma HLS DATA_PACK variable=out_stream //concats the struct into one big block

	static ap_uint <32> cur_count = 0;
	static ap_uint <64> frequency_old; 	//PROBLEM:if during the run of this core, frequency changes to a lower value, there is a possibility of a bug:
										//it may happen that at the time that frequency is reduced, count is bigger than the new frequency
										//this will cause count to never reach the new frequency, there there will be no more outputs
										//SOLUTION: by using the "frequency_old", we track the change in frequency and will reset count everytime frequency changes
	gulf_axis flit_out;
	flit_out.data.range(511,64)= 0;
	flit_out.dest=remote_port_tx;
	flit_out.last = 1;
	flit_out.keep = 0xFFFFFFFFFFFFFFFF;
	flit_out.user = remote_ip_tx;
	flit_out.id = local_port_tx;

	if (init == 0 || (frequency_old != frequency)) {
		cur_count = 0;
	}
	else if (!out_stream.full() && init == 1) {
		if (cur_count == frequency) {
			flit_out.data.range(63,0) = time;
			out_stream.write(flit_out);
			cur_count = 0;
		}
		else
			cur_count++;
	}
	frequency_old = frequency;
}
