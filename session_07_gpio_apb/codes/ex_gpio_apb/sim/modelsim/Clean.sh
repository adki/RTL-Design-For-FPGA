#!/bin/bash

if [ -d work                 ]; then \rm -rf work;                fi
if [ -f transcript           ]; then \rm -f transcript;           fi
if [ -f wave.vcd             ]; then \rm -f wave.vcd;             fi
if [ -f vish_stacktrace.vstf ]; then \rm -f vish_stacktrace.vstf; fi
