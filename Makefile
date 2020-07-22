#DIRS	= $(subst /,, $(dir $(wildcard */codes/Makefile)))
DIRS	= $(dir $(wildcard */codes/Makefile))

all:

clean cleanup clobber cleanupall:
	for D in $(DIRS); do\
		echo $$D;\
		if [ -f $$D/Makefile ] ; then \
			echo "make -C $$D -s $@";\
			make -C $$D -s $@;\
		fi;\
	done

.PHONY: all clean cleanup clobber cleanupall
