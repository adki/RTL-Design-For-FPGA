@ECHO off
SET dev_name=xc3s5000-fg900-4
SET inc_dir={"..\..\rtl\verilog"^
}
SET top=dma_axi_simple
SET design=xst_list.txt

@FOR %%T IN (%top%) DO @(
    @IF EXIST xst RMDIR /S/Q xst
    SET top_name=%%T
    IF EXIST %%T.ngc DEL /Q %%T.ngc
    xst -ifn xst_option.txt -ofn %%T.log 
    IF NOT EXIST %%T.ngc (
       ECHO %%T.ngc not found.
       GOTO END
    )
)

:END
pause
