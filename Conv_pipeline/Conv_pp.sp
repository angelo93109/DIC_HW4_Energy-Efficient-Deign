.title Conv 2x2

***LIBRARY***
.protect
.include '7nm_TT.pm'
.include "asap7sc7p5t_SIMPLE_RVT.sp"
.include "asap7sc7p5t_INVBUF_RVT.sp"
.include "asap7sc7p5t_SEQ_RVT.sp"
.include "Convolution_pp_HSPICE.sp" 
.unprotect

.vec pattern_pp.vec

***VOLTAGE SOURCE***
.global VDD GND CLK 
Vsource VDD GND 0.7V
VCLK CLK GND PULSE (0v 0.7v 490ps 10ps 10ps 490ps 1000ps)

*****MAIN CIRCUIT ((.SUBCKT Convolution_pipeline VSS VDD  clk rst_n in_valid In_IFM_1[3] In_IFM_1[2] In_IFM_1[1] In_IFM_1[0] In_IFM_2[3] In_IFM_2[2] In_IFM_2[1] In_IFM_2[0] In_IFM_3[3] In_IFM_3[2] In_IFM_3[1] In_IFM_3[0] In_IFM_4[3] In_IFM_4[2] In_IFM_4[1] In_IFM_4[0] In_Weight_1[3] In_Weight_1[2] In_Weight_1[1] In_Weight_1[0] In_Weight_2[3] In_Weight_2[2] In_Weight_2[1] In_Weight_2[0] In_Weight_3[3] In_Weight_3[2] In_Weight_3[1] In_Weight_3[0] In_Weight_4[3] In_Weight_4[2] In_Weight_4[1] In_Weight_4[0] Out_OFM[11] Out_OFM[10] Out_OFM[9] Out_OFM[8] Out_OFM[7] Out_OFM[6] Out_OFM[5] Out_OFM[4] Out_OFM[3] Out_OFM[2] Out_OFM[1] Out_OFM[0]
XConv_pp GND VDD CLK rst invalid N190 N371 inIFM1_3 inIFM1_2 inIFM1_1 inIFM1_0 inIFM2_3 inIFM2_2 inIFM2_1 inIFM2_0 inIFM3_3 inIFM3_2 inIFM3_1 inIFM3_0 inIFM4_3 inIFM4_2 inIFM4_1 inIFM4_0 inW1_3 inW1_2 inW1_1 inW1_0 inW2_3 inW2_2 inW2_1 inW2_0 inW3_3 inW3_2 inW3_1 inW3_0 inW4_3 inW4_2 inW4_1 inW4_0 output_11 output_10 output_9 output_8 output_7 output_6 output_5 output_4 output_3 output_2 output_1 output_0 Convolution_pipeline


.trans 10ps 16ns  *trans for delay
.param VDD1=0.7
.meas tran Tpd TRIG v(N190) val=“VDD1*0.5” rise=2 TARG v(N371) val=”VDD1*0.5” fall=2
.meas tran pwr AVG POWER
.option post
.option probe
.probe v(*) i(*)
.option captab
.TEMP 25
.END