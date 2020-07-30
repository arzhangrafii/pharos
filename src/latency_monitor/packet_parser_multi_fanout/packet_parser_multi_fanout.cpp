#include "hls_stream.h"
//#include <stdlib.h>
#include "ap_int.h"
#include "hls_math.h"

using namespace std;

#define MAX_NUM_OF_ELEMENTS 65536
typedef ap_ufixed<64,32> ap_f;

struct gulf_axis {
	ap_uint	<512> data;
	ap_uint	<64> keep;
	ap_uint	<16> dest;
	ap_uint	<1> last;
	ap_uint	<32> user;
	ap_uint <16> id;
};

struct kernel_axis {
	ap_uint	<64> data;
	ap_uint	<1> last;
	ap_uint	<8> keep;
	ap_uint	<16> user;
};

struct connected_node {
	ap_uint <1> connected = 0;
	ap_f latency_EMA = 0;
	ap_f latency_EMA_prev = 0;
	ap_uint <64> latency = 0;
};

void packet_parser_multi_fanout (
		hls::stream <gulf_axis> &out_stream,
		hls::stream <gulf_axis> &in_stream,
		hls::stream <kernel_axis> &output,
		ap_uint <32> read_out_period,
		ap_uint <64> time,
		ap_uint <64> &latency_raw,
		ap_uint <64> &time_sent, //the time being read here, for debug purposes
		ap_uint <32> &counter_out, //for test
		ap_uint <32> &state_out, //for test
		ap_uint <16> &a_e_out, //for test
		ap_uint <64> &current_connection_out, //for test
		ap_uint <16> &index_out, //for test
		ap_uint <16> &connection_index_out, //for test
		ap_uint <1> &element_connected_out, //for test
		ap_uint <1> measure,
		ap_uint <32> remote_ip_tx,
		ap_uint <16> remote_port_tx,
		ap_f Beta,
		ap_f &internal_EMA
		) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS resource core=AXI4Stream variable=out_stream
#pragma HLS resource core=AXI4Stream variable=output
#pragma HLS DATA_PACK variable=out_stream //concats the struct into one big block
#pragma HLS DATA_PACK variable=output
#pragma HLS resource core=AXI4Stream variable=in_stream
#pragma HLS DATA_PACK variable=in_stream
#pragma HLS INTERFACE ap_none port=internal_EMA
#pragma HLS INTERFACE ap_none port=latency_raw
#pragma HLS INTERFACE ap_none port=counter_out
#pragma HLS INTERFACE ap_none port=state_out
#pragma HLS INTERFACE ap_none port=current_connection_out
#pragma HLS INTERFACE ap_none port=index_out
#pragma HLS INTERFACE ap_none port=connection_index_out
#pragma HLS INTERFACE ap_none port=a_e_out
#pragma HLS INTERFACE ap_none port=element_connected_out
#pragma HLS INTERFACE ap_none port=time_sent

	gulf_axis flit_temp;
	kernel_axis latency_temp;
	static ap_uint <64> timestamp;
	static ap_uint <64> latency = 0;
	ap_uint <16> remote_ip_rx;
	static ap_uint <64> packet_time_sent = 0;
	static ap_uint <32> counter = 0;
	static ap_uint <64> current_connection = 0;
	ap_f EMA_prev = 0;
	ap_f EMA;

	static ap_uint <64> connections [MAX_NUM_OF_ELEMENTS]; // this array holds the indeces of the connected elements
	static ap_uint <16> active_elements = 0;
	static connected_node elements [MAX_NUM_OF_ELEMENTS];	//an array containing data for each element.
															//an element is a packet generator that sends packets to this packet parser
															//elements are stored in array cell indeces that correspond to their tdest
	ap_uint <16> element_index; // will hold the tdest of the incoming data
	static ap_uint <16> connection_index = 0; // to travrse the connections array
	static ap_uint <16> index = 0;

	connected_node element_temp;
	ap_uint <1> element_connected;


	static enum {IDLE, NODE, LATENCY} state = IDLE;

	counter_out = counter;
	current_connection_out = current_connection;
	index_out = index;
	connection_index_out = connection_index;
	state_out = state;
	a_e_out = active_elements;
	element_connected_out = element_connected;


	internal_EMA = EMA;
	latency_raw = latency;
	time_sent = packet_time_sent;

	/***********************/
	/*****WRITE OUTPUTS*****/
	/***********************/
	//This FSM writes latency and their corresponding nodes to the outputs
	latency_temp.keep = 0xFF;
	latency_temp.last = 1;
	switch (state) {
	case IDLE:
		index = 0;
		if (measure == 1) {
			if (counter == read_out_period) {
				counter = 0;
				connection_index = 0;

				if (active_elements <= 0)
					state = IDLE;
				else
					state = NODE;
			}
			else {
				if (!in_stream.empty()) {
					/*********************/
					/*****READ INPUTS*****/
					/*********************/
					flit_temp = in_stream.read();

					if (!out_stream.full()) { //send packets back towards master only when new packets still arrive
						flit_temp.last = 1;
						flit_temp.user = remote_ip_tx;
						flit_temp.dest = flit_temp.id; //send it back to its sender
						out_stream.write(flit_temp);
					}


					//capture the sender's ip address (the ip address relating to this latency value)
					remote_ip_rx = flit_temp.id;
					element_index = flit_temp.id;

					element_temp = elements[element_index];
					element_connected = element_temp.connected;

					//mark the node as connected. add its tdest to the connections array
					if (element_connected == 0) { //check if this node is new
						//elements[element_index].connected = 1;
						element_connected = 1;
						connections[connection_index] = remote_ip_rx; //put the tdest of new incoming nodes into the connections array
						active_elements++;
						connection_index++;
					}

					packet_time_sent = flit_temp.data.range(63,0);
					latency = packet_time_sent - time > 0 ? packet_time_sent - time  : time - packet_time_sent;
					element_temp.latency = latency;
					timestamp = time;

					/*******************************************************/
					//calculate the exponential moving average of the latency

					// at the end of the averaging frame, update the EMA of latency to the value of latency
					// this is done to avoid averaging over very long periods (that can contain very sparse data)
					/*if (counter == read_out_period)
						element_temp.latency_EMA_prev = element_temp.latency;
						//elements[element_index].latency_EMA_prev = elements[element_index].latency;
					else {*/
						/*EMA_prev = elements[element_index].latency_EMA_prev;
						EMA = (ap_f(1.0)-Beta)*(EMA_prev) + (Beta)*(ap_f(latency)); //calculate exponential moving average
						elements[element_index].latency_EMA = EMA;
						elements[element_index].latency_EMA_prev = EMA; //store the previous value*/
						EMA_prev = element_temp.latency_EMA_prev;
						EMA = (ap_f(1.0)-Beta)*(EMA_prev) + (Beta)*(ap_f(latency)); //calculate exponential moving average
						element_temp.latency_EMA = EMA;
						element_temp.latency_EMA_prev = EMA; //store the previous value
					//}
					element_temp.connected = element_connected;
					elements[element_index] = element_temp;
				}
				counter++;
			}
		}
		else
		{
			counter = 0;
		}
		break;
	case NODE: //output the node's tdest
		latency_temp.data = connections[index]; //output the address of the node that sent timestamped packets
		if (!output.full())
			output.write(latency_temp);
		state = LATENCY;
		current_connection = connections[index];
		counter++;
		break;
	case LATENCY: //output the moving averages
		latency_temp.data = elements[current_connection].latency_EMA;
		if (!output.full())
			output.write(latency_temp);
		elements[current_connection].connected = 0; //mark element as inactive
		index++;
		active_elements--;
		if (active_elements <= 0)
			state = IDLE;
		else
			state = NODE;
		counter++;
		break;
	}
}
