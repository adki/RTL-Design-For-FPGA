@ECHO OFF

DEL   /Q   top.wdb
DEL   /Q   wave.vcd
DEL   /Q   webtalk_*.backup.jou
DEL   /Q   webtalk_*.backup.log
DEL   /Q   webtalk.jou
DEL   /Q   webtalk.log
DEL   /Q   xelab.log
DEL   /Q   xelab.pb
DEL   /Q   xsim_*.backup.jou
DEL   /Q   xsim_*.backup.log
DEL   /Q   xsim.jou
DEL   /Q   xsim.log
DEL   /Q   xvlog.log
DEL   /Q   xvlog.pb
DEL   /Q   fft_power_fixed.txt  fft_result_fixed.txt
DEL   /Q   data_fixed.txt  data_float.txt  fft_fixed.txt  fft_float.txt
DEL   /Q   ifft_fixed.txt  ifft_float.txt
DEL   /Q   twiddle_table.txt signal_data_fixed.txt signal_fft_fixed.txt
RMDIR /S/Q .Xil
RMDIR /S/Q xsim.dir
