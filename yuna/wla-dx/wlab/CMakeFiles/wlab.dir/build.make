# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.7

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/bin/cmake

# The command to remove a file.
RM = /usr/local/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/supper/prog/yuna/yuna/wla-dx

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/supper/prog/yuna/yuna/wla-dx

# Include any dependencies generated for this target.
include wlab/CMakeFiles/wlab.dir/depend.make

# Include the progress variables for this target.
include wlab/CMakeFiles/wlab.dir/progress.make

# Include the compile flags for this target's objects.
include wlab/CMakeFiles/wlab.dir/flags.make

wlab/CMakeFiles/wlab.dir/main.c.o: wlab/CMakeFiles/wlab.dir/flags.make
wlab/CMakeFiles/wlab.dir/main.c.o: wlab/main.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object wlab/CMakeFiles/wlab.dir/main.c.o"
	cd /home/supper/prog/yuna/yuna/wla-dx/wlab && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wlab.dir/main.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/wlab/main.c

wlab/CMakeFiles/wlab.dir/main.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wlab.dir/main.c.i"
	cd /home/supper/prog/yuna/yuna/wla-dx/wlab && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/wlab/main.c > CMakeFiles/wlab.dir/main.c.i

wlab/CMakeFiles/wlab.dir/main.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wlab.dir/main.c.s"
	cd /home/supper/prog/yuna/yuna/wla-dx/wlab && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/wlab/main.c -o CMakeFiles/wlab.dir/main.c.s

wlab/CMakeFiles/wlab.dir/main.c.o.requires:

.PHONY : wlab/CMakeFiles/wlab.dir/main.c.o.requires

wlab/CMakeFiles/wlab.dir/main.c.o.provides: wlab/CMakeFiles/wlab.dir/main.c.o.requires
	$(MAKE) -f wlab/CMakeFiles/wlab.dir/build.make wlab/CMakeFiles/wlab.dir/main.c.o.provides.build
.PHONY : wlab/CMakeFiles/wlab.dir/main.c.o.provides

wlab/CMakeFiles/wlab.dir/main.c.o.provides.build: wlab/CMakeFiles/wlab.dir/main.c.o


# Object files for target wlab
wlab_OBJECTS = \
"CMakeFiles/wlab.dir/main.c.o"

# External object files for target wlab
wlab_EXTERNAL_OBJECTS =

binaries/wlab: wlab/CMakeFiles/wlab.dir/main.c.o
binaries/wlab: wlab/CMakeFiles/wlab.dir/build.make
binaries/wlab: wlab/CMakeFiles/wlab.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable ../binaries/wlab"
	cd /home/supper/prog/yuna/yuna/wla-dx/wlab && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/wlab.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
wlab/CMakeFiles/wlab.dir/build: binaries/wlab

.PHONY : wlab/CMakeFiles/wlab.dir/build

# Object files for target wlab
wlab_OBJECTS = \
"CMakeFiles/wlab.dir/main.c.o"

# External object files for target wlab
wlab_EXTERNAL_OBJECTS =

wlab/CMakeFiles/CMakeRelink.dir/wlab: wlab/CMakeFiles/wlab.dir/main.c.o
wlab/CMakeFiles/CMakeRelink.dir/wlab: wlab/CMakeFiles/wlab.dir/build.make
wlab/CMakeFiles/CMakeRelink.dir/wlab: wlab/CMakeFiles/wlab.dir/relink.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking C executable CMakeFiles/CMakeRelink.dir/wlab"
	cd /home/supper/prog/yuna/yuna/wla-dx/wlab && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/wlab.dir/relink.txt --verbose=$(VERBOSE)

# Rule to relink during preinstall.
wlab/CMakeFiles/wlab.dir/preinstall: wlab/CMakeFiles/CMakeRelink.dir/wlab

.PHONY : wlab/CMakeFiles/wlab.dir/preinstall

wlab/CMakeFiles/wlab.dir/requires: wlab/CMakeFiles/wlab.dir/main.c.o.requires

.PHONY : wlab/CMakeFiles/wlab.dir/requires

wlab/CMakeFiles/wlab.dir/clean:
	cd /home/supper/prog/yuna/yuna/wla-dx/wlab && $(CMAKE_COMMAND) -P CMakeFiles/wlab.dir/cmake_clean.cmake
.PHONY : wlab/CMakeFiles/wlab.dir/clean

wlab/CMakeFiles/wlab.dir/depend:
	cd /home/supper/prog/yuna/yuna/wla-dx && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/supper/prog/yuna/yuna/wla-dx /home/supper/prog/yuna/yuna/wla-dx/wlab /home/supper/prog/yuna/yuna/wla-dx /home/supper/prog/yuna/yuna/wla-dx/wlab /home/supper/prog/yuna/yuna/wla-dx/wlab/CMakeFiles/wlab.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : wlab/CMakeFiles/wlab.dir/depend

