SHELL=/bin/sh

TARGET ?= test
CID    ?= 0

SRC     =\
        main.c\
        arg_parser.c\
        trx_axi_api.c\
        mem_api.c\
        test_bench.c

all: pre $(TARGET)

run:
	./$(TARGET) -c $(CID) -m 0x00000000:0x400 -l 3 -v 3

include ../Makefile.in
