//--------------------------------------------------------
// Copyright (c) 2009-2012 by Future Design Systems Co., Ltd.
// All right reserved.
//
// http://www.future-ds.com
//--------------------------------------------------------
// get_key.c
//--------------------------------------------------------
// VERSION = 2012.02.12.
//--------------------------------------------------------
#if defined(_WIN32) && !defined(_MSC_VER)
#	include <stdio.h>
#	include <conio.h>
#	ifdef _WIN32
#		include <windows.h>
#	endif

int get_key(char *c) {
    int ret;
    if (_kbhit()) {
        *c = getchar();
        ret = 1;
    } else {
        ret = 0;
    }
    return ret;
}
#elif defined(_MSC_VER)
#	include <stdio.h>
#	include <conio.h>
#	ifdef _WIN32
#		include <windows.h>
#	endif

int get_key(char *c) {
    int ret;
    if (_kbhit()) {
        *c = getchar();
        ret = 1;
    } else {
        ret = 0;
    }
    return ret;
}
//--------------------------------------------------------
#else
#	include <stdio.h>
#	include <unistd.h>
#	include <sys/time.h>
#	include <termios.h>
#	include <sys/types.h>
#	include <sys/stat.h>
#	include <fcntl.h>
#	ifdef _WIN32
#		include <windows.h>
#	endif

#define NB_ENABLE 0
#define NB_DISABLE 1

static void nonblock(int state)
{
    struct termios ttystate;

    //get the terminal state
    tcgetattr(STDIN_FILENO, &ttystate);

    if (state==NB_ENABLE)
    {
        //turn off canonical mode
        ttystate.c_lflag &= ~ICANON;
        //minimum of number input read.
        ttystate.c_cc[VMIN] = 1;
    }
    else if (state==NB_DISABLE)
    {
        //turn on canonical mode
        ttystate.c_lflag |= ICANON;
    }
    //set the terminal attributes.
    tcsetattr(STDIN_FILENO, TCSANOW, &ttystate);

}

int kbhit()
{
    struct timeval tv;
    fd_set fds;
    tv.tv_sec = 0;
    tv.tv_usec = 0;
    FD_ZERO(&fds);
    FD_SET(STDIN_FILENO, &fds); //STDIN_FILENO is 0
    select(STDIN_FILENO+1, &fds, NULL, NULL, &tv);
    return FD_ISSET(STDIN_FILENO, &fds);
}

int get_key(char *c) {
    int ret;
    nonblock(NB_ENABLE);
    if (kbhit()) {
        *c = getchar();
        ret = 1;
    } else {
        *c = 0;
        ret = 0;
    }
    nonblock(NB_DISABLE);
    return ret;
}
#endif

#if 0
/**
 Linux (POSIX) implementation of _kbhit().
 Morgan McGuire, morgan@cs.brown.edu
 */
#include <stdio.h>
#include <sys/select.h>
#include <termios.h>
#include <stropts.h>int _kbhit() {
    static const int STDIN = 0;
    static bool initialized = false;    if (! initialized) {
        // Use termios to turn off line buffering
        termios term;
        tcgetattr(STDIN, &term);
        term.c_lflag &= ~ICANON;
        tcsetattr(STDIN, TCSANOW, &term);
        setbuf(stdin, NULL);
        initialized = true;
    }    int bytesWaiting;
    ioctl(STDIN, FIONREAD, &bytesWaiting);
    return bytesWaiting;
}
#endif
//--------------------------------------------------------
// Revision History
//
// 2012.02.12: Rewirtten by Ando Ki (adki@future-ds.com)
//--------------------------------------------------------
