struct kernel_axis {
	ap_uint<512> data;
	ap_uint<1> last;
	ap_uint<64> keep;
};
