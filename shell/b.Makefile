CC = gcc
LD = gcc

#CFLAGS := -Wall -c -Dgliethttp -I../include -L lib_path
CFLAGS := -O2 -g -Wall -Wno-unused-parameter -c -Dgliethttp
CFLAGS += -I . -I ./include -I /home/apuser/works/sprdroid6.0_trunk_k318_dev/system/core/include/

LDFLAGS = -lpthread
#LDFLAGS := -lrt -lpthread -ldl -lz -lcrypto

SRCS = main.c hello.c
OBJS = $(patsubst %c, %o, $(SRCS))
TARGET = hello

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%o: %c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f *.o $(TARGET)
