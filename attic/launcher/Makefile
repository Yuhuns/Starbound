# Compiler
CXX := clang++
# Flags
CXXFLAGS := -std=c++17 -Wall -Wextra
# Qt installation path
QT_ROOT := /opt/homebrew/opt/qt@5
# Qt include directories
QT_INCLUDE := -I$(QT_ROOT)/include
# Qt libraries
QT_LIBS := -F$(QT_ROOT)/lib -framework QtCore -framework QtGui -framework QtWidgets -framework QtWebEngineWidgets
# Source files
SRCS := main.cpp commands.cpp launcher.cpp
# Object files
OBJS := $(SRCS:.cpp=.o)
# Executable name
TARGET := launcher

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $(QT_LIBS) $^ -o $@

%.o: %.cpp launcher.hpp
	$(CXX) $(CXXFLAGS) $(QT_INCLUDE) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)
