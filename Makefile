DEBUG ?= 1
ifeq ($(DEBUG),1)
	TARGET := DEBUG
	BUILDDIR := build/
else
	TARGET := RELEASE
	BUILDDIR := release/
endif

CC=gcc
CXX=g++

DEBUG_CFLAGS    := -Wno-format -g -DDEBUG -Werror -O0 -DDEBUG_STOMP -DBOOST_ASIO_ENABLE_BUFFER_DEBUGGING
RELEASE_CFLAGS  := -Wall -Wno-unknown-pragmas -Wno-format -O3 -DNDEBUG
CFLAGS	:= -c $($(TARGET)_CFLAGS) -fPIC

DEBUG_LDFLAGS	:= -g
RELEASE_LDFLAGS := 
LDFLAGS	:= $($(TARGET)_LDFLAGS) -lboost_system -lboost_thread -lpthread

SUBDIR := BoostStomp/
SUBOBJS := $(addprefix $(SUBDIR), BoostStomp.o StompFrame.o helpers.o)

INCLUDES := -I. -I./$(SUBDIR)

OBJS := $(addprefix $(BUILDDIR), Main.o $(SUBOBJS))

.PHONEY:all
all: | $(BUILDDIR)
all: $(BUILDDIR)stompagent 

$(BUILDDIR)%.o : %.cpp
	$(CXX) $(CFLAGS) $(INCLUDES) -o $@ $<

$(BUILDDIR)%.o : %.c 
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $<

$(BUILDDIR)stompagent: $(OBJS)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS)

.PHONEY:$(BUILDDIR)
$(BUILDDIR):
	mkdir -p $(BUILDDIR)$(SUBDIR)

.PHONY: clean
clean:
	rm $(BUILDDIR)stompagent $(BUILDDIR)*.o $(BUILDDIR)$(SUBDIR)*.o
