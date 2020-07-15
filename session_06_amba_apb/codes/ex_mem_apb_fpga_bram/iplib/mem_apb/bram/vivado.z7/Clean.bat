@ECHO OFF

SET TOPS=bram_32x8KB

@FOR %%F in ( %TOPS% ) DO @ (
     ECHO *** %%F
     IF EXIST %%F                RMDIR /Q/S  %%F
     IF EXIST %%F.edn            DEL   /Q    %%F.edn
     IF EXIST %%F.gise           DEL   /Q    %%F.gise
     IF EXIST %%F.ise            DEL   /Q    %%F.ise
     IF EXIST %%F.veo            DEL   /Q    %%F.veo
     IF EXIST %%F.xise           DEL   /Q    %%F.xise
     IF EXIST %%F.xncf           DEL   /Q    %%F.xncf
     IF EXIST %%F.asy            DEL   /Q    %%F.asy
     IF EXIST %%F_flist.txt      DEL   /Q    %%F_flist.txt
     IF EXIST %%F_readme.txt     DEL   /Q    %%F_readme.txt
     IF EXIST %%F_xmdf.tcl       DEL   /Q    %%F_xmdf.tcl
     IF EXIST %%F_xdb            RMDIR /Q/S  %%F_xdb
)
IF EXIST coregen.cgc          DEL   /Q    coregen.cgc
IF EXIST coregen.log          DEL   /Q    coregen.log
IF EXIST ngc2edif.log         DEL   /Q    ngc2edif.log 
IF EXIST tmp                  RMDIR /Q/S  tmp
IF EXIST _xmsgs               RMDIR /Q/S  _xmsgs
IF EXIST xlnx_auto_0_xdb      RMDIR /Q/S  xlnx_auto_0_xdb
IF EXIST .lso                 RMDIR /Q    .lso
IF EXIST xil_*.in             DEL   /Q    xil_*.in
IF EXIST xil_*.out            DEL   /Q    xil_*.out
IF EXIST get_initp_pfile.tmp  DEL   /Q    get_initp_pfile.tmp
IF EXIST summary.log          DEL   /Q    summary.log
