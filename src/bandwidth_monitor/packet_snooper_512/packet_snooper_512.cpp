#include "hls_stream.h"
#include "ap_int.h"
#include "../include/packet_snooper.h"

void packet_snooper_512 (
		hls::stream <ext_axis> in_stream,
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

	ext_axis input_flit_temp;
	output_axis output_flit_temp;
	static ap_uint <64> counter = 0;
	static ap_uint <64> num_of_flits = 0;
	 ap_uint <64> bytes_in_flit = 0;
	 ap_uint <64> number_of_bytes = 0;
	static ap_uint <64> packet_size_reg = 0;
	static ap_uint <1> packet_size_valid_reg = 0;
	static ap_uint <64> flit_keep;
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
			case 3:
				bytes_in_flit = 2;
				break;
			case 7:
				bytes_in_flit = 3;
				break;
			case 15:
				bytes_in_flit = 4;
				break;
			case 31:
				bytes_in_flit = 5;
				break;
			case 63:
				bytes_in_flit = 6;
				break;
			case 127:
				bytes_in_flit = 7;
				break;
			case 255:
				bytes_in_flit = 8;
				break;
			case 511:
				bytes_in_flit = 9;
				break;
			case 1023:
				bytes_in_flit = 10;
				break;
			case 2047:
				bytes_in_flit = 11;
				break;
			case 4095:
				bytes_in_flit = 12;
				break;
			case 8191:
				bytes_in_flit = 13;
				break;
			case 16383:
				bytes_in_flit = 14;
				break;
			case 32767:
				bytes_in_flit = 15;
				break;
			case 65535:
				bytes_in_flit = 16;
				break;
			case 131071:
				bytes_in_flit = 17;
				break;
			case 262143:
				bytes_in_flit = 18;
				break;
			case 524287:
				bytes_in_flit = 19;
				break;
			case 1048575:
				bytes_in_flit = 20;
				break;
			case 2097151:
				bytes_in_flit = 21;
				break;
			case 4194303:
				bytes_in_flit = 22;
				break;
			case 8388607:
				bytes_in_flit = 23;
				break;
			case 16777215:
				bytes_in_flit = 24;
				break;
			case 33554431:
				bytes_in_flit = 25;
				break;
			case 67108863:
				bytes_in_flit = 26;
				break;
			case 134217727:
				bytes_in_flit = 27;
				break;
			case 268435455:
				bytes_in_flit = 28;
				break;
			case 536870911:
				bytes_in_flit = 29;
				break;
			case 1073741823:
				bytes_in_flit = 30;
				break;
			case 2147483647:
				bytes_in_flit = 31;
				break;
			case 4294967295:
				bytes_in_flit = 32;
				break;
			case 8589934591:
				bytes_in_flit = 33;
				break;
			case 17179869183:
				bytes_in_flit = 34;
				break;
			case 34359738367:
				bytes_in_flit = 35;
				break;
			case 68719476735:
				bytes_in_flit = 36;
				break;
			case 137438953471:
				bytes_in_flit = 37;
				break;
			case 274877906943:
				bytes_in_flit = 38;
				break;
			case 549755813887:
				bytes_in_flit = 39;
				break;
			case 1099511627775:
				bytes_in_flit = 40;
				break;
			case 2199023255551:
				bytes_in_flit = 41;
				break;
			case 4398046511103:
				bytes_in_flit = 42;
				break;
			case 8796093022207:
				bytes_in_flit = 43;
				break;
			case 17592186044415:
				bytes_in_flit = 44;
				break;
			case 35184372088831:
				bytes_in_flit = 45;
				break;
			case 70368744177663:
				bytes_in_flit = 46;
				break;
			case 140737488355327:
				bytes_in_flit = 47;
				break;
			case 281474976710655:
				bytes_in_flit = 48;
				break;
			case 562949953421311:
				bytes_in_flit = 49;
				break;
			case 1125899906842623:
				bytes_in_flit = 50;
				break;
			case 2251799813685247:
				bytes_in_flit = 51;
				break;
			case 4503599627370495:
				bytes_in_flit = 52;
				break;
			case 9007199254740991:
				bytes_in_flit = 53;
				break;
			case 18014398509481983:
				bytes_in_flit = 54;
				break;
			case 36028797018963967:
				bytes_in_flit = 55;
				break;
			case 72057594037927935:
				bytes_in_flit = 56;
				break;
			case 144115188075855871:
				bytes_in_flit = 57;
				break;
			case 288230376151711743:
				bytes_in_flit = 58;
				break;
			case 576460752303423487:
				bytes_in_flit = 59;
				break;
			case 1152921504606846975:
				bytes_in_flit = 60;
				break;
			case 2305843009213693951:
				bytes_in_flit = 61;
				break;
			case 4611686018427387903:
				bytes_in_flit = 62;
				break;
			case 9223372036854775807:
				bytes_in_flit = 63;
				break;
			case 18446744073709551615:
				bytes_in_flit = 64;
				break;
			case 18446744073709551614:
				bytes_in_flit = 63;
				break;
			case 18446744073709551612:
				bytes_in_flit = 62;
				break;
			case 18446744073709551608:
				bytes_in_flit = 61;
				break;
			case 18446744073709551600:
				bytes_in_flit = 60;
				break;
			case 18446744073709551584:
				bytes_in_flit = 59;
				break;
			case 18446744073709551552:
				bytes_in_flit = 58;
				break;
			case 18446744073709551488:
				bytes_in_flit = 57;
				break;
			case 18446744073709551360:
				bytes_in_flit = 56;
				break;
			case 18446744073709551104:
				bytes_in_flit = 55;
				break;
			case 18446744073709550592:
				bytes_in_flit = 54;
				break;
			case 18446744073709549568:
				bytes_in_flit = 53;
				break;
			case 18446744073709547520:
				bytes_in_flit = 52;
				break;
			case 18446744073709543424:
				bytes_in_flit = 51;
				break;
			case 18446744073709535232:
				bytes_in_flit = 50;
				break;
			case 18446744073709518848:
				bytes_in_flit = 49;
				break;
			case 18446744073709486080:
				bytes_in_flit = 48;
				break;
			case 18446744073709420544:
				bytes_in_flit = 47;
				break;
			case 18446744073709289472:
				bytes_in_flit = 46;
				break;
			case 18446744073709027328:
				bytes_in_flit = 45;
				break;
			case 18446744073708503040:
				bytes_in_flit = 44;
				break;
			case 18446744073707454464:
				bytes_in_flit = 43;
				break;
			case 18446744073705357312:
				bytes_in_flit = 42;
				break;
			case 18446744073701163008:
				bytes_in_flit = 41;
				break;
			case 18446744073692774400:
				bytes_in_flit = 40;
				break;
			case 18446744073675997184:
				bytes_in_flit = 39;
				break;
			case 18446744073642442752:
				bytes_in_flit = 38;
				break;
			case 18446744073575333888:
				bytes_in_flit = 37;
				break;
			case 18446744073441116160:
				bytes_in_flit = 36;
				break;
			case 18446744073172680704:
				bytes_in_flit = 35;
				break;
			case 18446744072635809792:
				bytes_in_flit = 34;
				break;
			case 18446744071562067968:
				bytes_in_flit = 33;
				break;
			case 18446744069414584320:
				bytes_in_flit = 32;
				break;
			case 18446744065119617024:
				bytes_in_flit = 31;
				break;
			case 18446744056529682432:
				bytes_in_flit = 30;
				break;
			case 18446744039349813248:
				bytes_in_flit = 29;
				break;
			case 18446744004990074880:
				bytes_in_flit = 28;
				break;
			case 18446743936270598144:
				bytes_in_flit = 27;
				break;
			case 18446743798831644672:
				bytes_in_flit = 26;
				break;
			case 18446743523953737728:
				bytes_in_flit = 25;
				break;
			case 18446742974197923840:
				bytes_in_flit = 24;
				break;
			case 18446741874686296064:
				bytes_in_flit = 23;
				break;
			case 18446739675663040512:
				bytes_in_flit = 22;
				break;
			case 18446735277616529408:
				bytes_in_flit = 21;
				break;
			case 18446726481523507200:
				bytes_in_flit = 20;
				break;
			case 18446708889337462784:
				bytes_in_flit = 19;
				break;
			case 18446673704965373952:
				bytes_in_flit = 18;
				break;
			case 18446603336221196288:
				bytes_in_flit = 17;
				break;
			case 18446462598732840960:
				bytes_in_flit = 16;
				break;
			case 18446181123756130304:
				bytes_in_flit = 15;
				break;
			case 18445618173802708992:
				bytes_in_flit = 14;
				break;
			case 18444492273895866368:
				bytes_in_flit = 13;
				break;
			case 18442240474082181120:
				bytes_in_flit = 12;
				break;
			case 18437736874454810624:
				bytes_in_flit = 11;
				break;
			case 18428729675200069632:
				bytes_in_flit = 10;
				break;
			case 18410715276690587648:
				bytes_in_flit = 9;
				break;
			case 18374686479671623680:
				bytes_in_flit = 8;
				break;
			case 18302628885633695744:
				bytes_in_flit = 7;
				break;
			case 18158513697557839872:
				bytes_in_flit = 6;
				break;
			case 17870283321406128128:
				bytes_in_flit = 5;
				break;
			case 17293822569102704640:
				bytes_in_flit = 4;
				break;
			case 16140901064495857664:
				bytes_in_flit = 3;
				break;
			case 13835058055282163712:
				bytes_in_flit = 2;
				break;
			case 9223372036854775808:
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
