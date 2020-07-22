SHELL=/bin/sh

TARGET ?= test
CID    ?= 0

SRC     =\
        main.c\
        arg_parser.c\
        trx_axi_api.c\
        gpio_api.c\
        test_bench.c

all: pre $(TARGET)

run:
	./$(TARGET)

include ../Makefile.in
