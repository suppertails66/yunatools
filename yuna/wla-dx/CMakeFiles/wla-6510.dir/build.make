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
include CMakeFiles/wla-6510.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/wla-6510.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/wla-6510.dir/flags.make

op_tbl_gen/opcodes_6510_tables.c:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Generating op_tbl_gen/opcodes_6510_tables.c"
	op_tbl_gen/gen-6510 /home/supper/prog/yuna/yuna/wla-dx/op_tbl_gen/opcodes_6510_tables.c

CMakeFiles/wla-6510.dir/main.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/main.c.o: main.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object CMakeFiles/wla-6510.dir/main.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/main.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/main.c

CMakeFiles/wla-6510.dir/main.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/main.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/main.c > CMakeFiles/wla-6510.dir/main.c.i

CMakeFiles/wla-6510.dir/main.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/main.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/main.c -o CMakeFiles/wla-6510.dir/main.c.s

CMakeFiles/wla-6510.dir/main.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/main.c.o.requires

CMakeFiles/wla-6510.dir/main.c.o.provides: CMakeFiles/wla-6510.dir/main.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/main.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/main.c.o.provides

CMakeFiles/wla-6510.dir/main.c.o.provides.build: CMakeFiles/wla-6510.dir/main.c.o


CMakeFiles/wla-6510.dir/crc32.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/crc32.c.o: crc32.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object CMakeFiles/wla-6510.dir/crc32.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/crc32.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/crc32.c

CMakeFiles/wla-6510.dir/crc32.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/crc32.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/crc32.c > CMakeFiles/wla-6510.dir/crc32.c.i

CMakeFiles/wla-6510.dir/crc32.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/crc32.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/crc32.c -o CMakeFiles/wla-6510.dir/crc32.c.s

CMakeFiles/wla-6510.dir/crc32.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/crc32.c.o.requires

CMakeFiles/wla-6510.dir/crc32.c.o.provides: CMakeFiles/wla-6510.dir/crc32.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/crc32.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/crc32.c.o.provides

CMakeFiles/wla-6510.dir/crc32.c.o.provides.build: CMakeFiles/wla-6510.dir/crc32.c.o


CMakeFiles/wla-6510.dir/hashmap.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/hashmap.c.o: hashmap.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building C object CMakeFiles/wla-6510.dir/hashmap.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/hashmap.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/hashmap.c

CMakeFiles/wla-6510.dir/hashmap.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/hashmap.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/hashmap.c > CMakeFiles/wla-6510.dir/hashmap.c.i

CMakeFiles/wla-6510.dir/hashmap.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/hashmap.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/hashmap.c -o CMakeFiles/wla-6510.dir/hashmap.c.s

CMakeFiles/wla-6510.dir/hashmap.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/hashmap.c.o.requires

CMakeFiles/wla-6510.dir/hashmap.c.o.provides: CMakeFiles/wla-6510.dir/hashmap.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/hashmap.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/hashmap.c.o.provides

CMakeFiles/wla-6510.dir/hashmap.c.o.provides.build: CMakeFiles/wla-6510.dir/hashmap.c.o


CMakeFiles/wla-6510.dir/parse.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/parse.c.o: parse.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building C object CMakeFiles/wla-6510.dir/parse.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/parse.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/parse.c

CMakeFiles/wla-6510.dir/parse.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/parse.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/parse.c > CMakeFiles/wla-6510.dir/parse.c.i

CMakeFiles/wla-6510.dir/parse.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/parse.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/parse.c -o CMakeFiles/wla-6510.dir/parse.c.s

CMakeFiles/wla-6510.dir/parse.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/parse.c.o.requires

CMakeFiles/wla-6510.dir/parse.c.o.provides: CMakeFiles/wla-6510.dir/parse.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/parse.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/parse.c.o.provides

CMakeFiles/wla-6510.dir/parse.c.o.provides.build: CMakeFiles/wla-6510.dir/parse.c.o


CMakeFiles/wla-6510.dir/include_file.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/include_file.c.o: include_file.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building C object CMakeFiles/wla-6510.dir/include_file.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/include_file.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/include_file.c

CMakeFiles/wla-6510.dir/include_file.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/include_file.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/include_file.c > CMakeFiles/wla-6510.dir/include_file.c.i

CMakeFiles/wla-6510.dir/include_file.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/include_file.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/include_file.c -o CMakeFiles/wla-6510.dir/include_file.c.s

CMakeFiles/wla-6510.dir/include_file.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/include_file.c.o.requires

CMakeFiles/wla-6510.dir/include_file.c.o.provides: CMakeFiles/wla-6510.dir/include_file.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/include_file.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/include_file.c.o.provides

CMakeFiles/wla-6510.dir/include_file.c.o.provides.build: CMakeFiles/wla-6510.dir/include_file.c.o


CMakeFiles/wla-6510.dir/pass_1.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/pass_1.c.o: pass_1.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building C object CMakeFiles/wla-6510.dir/pass_1.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/pass_1.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/pass_1.c

CMakeFiles/wla-6510.dir/pass_1.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/pass_1.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/pass_1.c > CMakeFiles/wla-6510.dir/pass_1.c.i

CMakeFiles/wla-6510.dir/pass_1.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/pass_1.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/pass_1.c -o CMakeFiles/wla-6510.dir/pass_1.c.s

CMakeFiles/wla-6510.dir/pass_1.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/pass_1.c.o.requires

CMakeFiles/wla-6510.dir/pass_1.c.o.provides: CMakeFiles/wla-6510.dir/pass_1.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/pass_1.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/pass_1.c.o.provides

CMakeFiles/wla-6510.dir/pass_1.c.o.provides.build: CMakeFiles/wla-6510.dir/pass_1.c.o


CMakeFiles/wla-6510.dir/pass_2.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/pass_2.c.o: pass_2.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building C object CMakeFiles/wla-6510.dir/pass_2.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/pass_2.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/pass_2.c

CMakeFiles/wla-6510.dir/pass_2.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/pass_2.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/pass_2.c > CMakeFiles/wla-6510.dir/pass_2.c.i

CMakeFiles/wla-6510.dir/pass_2.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/pass_2.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/pass_2.c -o CMakeFiles/wla-6510.dir/pass_2.c.s

CMakeFiles/wla-6510.dir/pass_2.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/pass_2.c.o.requires

CMakeFiles/wla-6510.dir/pass_2.c.o.provides: CMakeFiles/wla-6510.dir/pass_2.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/pass_2.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/pass_2.c.o.provides

CMakeFiles/wla-6510.dir/pass_2.c.o.provides.build: CMakeFiles/wla-6510.dir/pass_2.c.o


CMakeFiles/wla-6510.dir/pass_3.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/pass_3.c.o: pass_3.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Building C object CMakeFiles/wla-6510.dir/pass_3.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/pass_3.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/pass_3.c

CMakeFiles/wla-6510.dir/pass_3.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/pass_3.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/pass_3.c > CMakeFiles/wla-6510.dir/pass_3.c.i

CMakeFiles/wla-6510.dir/pass_3.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/pass_3.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/pass_3.c -o CMakeFiles/wla-6510.dir/pass_3.c.s

CMakeFiles/wla-6510.dir/pass_3.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/pass_3.c.o.requires

CMakeFiles/wla-6510.dir/pass_3.c.o.provides: CMakeFiles/wla-6510.dir/pass_3.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/pass_3.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/pass_3.c.o.provides

CMakeFiles/wla-6510.dir/pass_3.c.o.provides.build: CMakeFiles/wla-6510.dir/pass_3.c.o


CMakeFiles/wla-6510.dir/pass_4.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/pass_4.c.o: pass_4.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_10) "Building C object CMakeFiles/wla-6510.dir/pass_4.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/pass_4.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/pass_4.c

CMakeFiles/wla-6510.dir/pass_4.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/pass_4.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/pass_4.c > CMakeFiles/wla-6510.dir/pass_4.c.i

CMakeFiles/wla-6510.dir/pass_4.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/pass_4.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/pass_4.c -o CMakeFiles/wla-6510.dir/pass_4.c.s

CMakeFiles/wla-6510.dir/pass_4.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/pass_4.c.o.requires

CMakeFiles/wla-6510.dir/pass_4.c.o.provides: CMakeFiles/wla-6510.dir/pass_4.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/pass_4.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/pass_4.c.o.provides

CMakeFiles/wla-6510.dir/pass_4.c.o.provides.build: CMakeFiles/wla-6510.dir/pass_4.c.o


CMakeFiles/wla-6510.dir/stack.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/stack.c.o: stack.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_11) "Building C object CMakeFiles/wla-6510.dir/stack.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/stack.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/stack.c

CMakeFiles/wla-6510.dir/stack.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/stack.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/stack.c > CMakeFiles/wla-6510.dir/stack.c.i

CMakeFiles/wla-6510.dir/stack.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/stack.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/stack.c -o CMakeFiles/wla-6510.dir/stack.c.s

CMakeFiles/wla-6510.dir/stack.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/stack.c.o.requires

CMakeFiles/wla-6510.dir/stack.c.o.provides: CMakeFiles/wla-6510.dir/stack.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/stack.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/stack.c.o.provides

CMakeFiles/wla-6510.dir/stack.c.o.provides.build: CMakeFiles/wla-6510.dir/stack.c.o


CMakeFiles/wla-6510.dir/listfile.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/listfile.c.o: listfile.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_12) "Building C object CMakeFiles/wla-6510.dir/listfile.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/listfile.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/listfile.c

CMakeFiles/wla-6510.dir/listfile.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/listfile.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/listfile.c > CMakeFiles/wla-6510.dir/listfile.c.i

CMakeFiles/wla-6510.dir/listfile.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/listfile.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/listfile.c -o CMakeFiles/wla-6510.dir/listfile.c.s

CMakeFiles/wla-6510.dir/listfile.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/listfile.c.o.requires

CMakeFiles/wla-6510.dir/listfile.c.o.provides: CMakeFiles/wla-6510.dir/listfile.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/listfile.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/listfile.c.o.provides

CMakeFiles/wla-6510.dir/listfile.c.o.provides.build: CMakeFiles/wla-6510.dir/listfile.c.o


CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o: op_tbl_gen/opcodes_6510_tables.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_13) "Building C object CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/op_tbl_gen/opcodes_6510_tables.c

CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/op_tbl_gen/opcodes_6510_tables.c > CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.i

CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/op_tbl_gen/opcodes_6510_tables.c -o CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.s

CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o.requires

CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o.provides: CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o.provides

CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o.provides.build: CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o


CMakeFiles/wla-6510.dir/opcodes_6510.c.o: CMakeFiles/wla-6510.dir/flags.make
CMakeFiles/wla-6510.dir/opcodes_6510.c.o: opcodes_6510.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_14) "Building C object CMakeFiles/wla-6510.dir/opcodes_6510.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/wla-6510.dir/opcodes_6510.c.o   -c /home/supper/prog/yuna/yuna/wla-dx/opcodes_6510.c

CMakeFiles/wla-6510.dir/opcodes_6510.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/wla-6510.dir/opcodes_6510.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/supper/prog/yuna/yuna/wla-dx/opcodes_6510.c > CMakeFiles/wla-6510.dir/opcodes_6510.c.i

CMakeFiles/wla-6510.dir/opcodes_6510.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/wla-6510.dir/opcodes_6510.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/supper/prog/yuna/yuna/wla-dx/opcodes_6510.c -o CMakeFiles/wla-6510.dir/opcodes_6510.c.s

CMakeFiles/wla-6510.dir/opcodes_6510.c.o.requires:

.PHONY : CMakeFiles/wla-6510.dir/opcodes_6510.c.o.requires

CMakeFiles/wla-6510.dir/opcodes_6510.c.o.provides: CMakeFiles/wla-6510.dir/opcodes_6510.c.o.requires
	$(MAKE) -f CMakeFiles/wla-6510.dir/build.make CMakeFiles/wla-6510.dir/opcodes_6510.c.o.provides.build
.PHONY : CMakeFiles/wla-6510.dir/opcodes_6510.c.o.provides

CMakeFiles/wla-6510.dir/opcodes_6510.c.o.provides.build: CMakeFiles/wla-6510.dir/opcodes_6510.c.o


# Object files for target wla-6510
wla__6510_OBJECTS = \
"CMakeFiles/wla-6510.dir/main.c.o" \
"CMakeFiles/wla-6510.dir/crc32.c.o" \
"CMakeFiles/wla-6510.dir/hashmap.c.o" \
"CMakeFiles/wla-6510.dir/parse.c.o" \
"CMakeFiles/wla-6510.dir/include_file.c.o" \
"CMakeFiles/wla-6510.dir/pass_1.c.o" \
"CMakeFiles/wla-6510.dir/pass_2.c.o" \
"CMakeFiles/wla-6510.dir/pass_3.c.o" \
"CMakeFiles/wla-6510.dir/pass_4.c.o" \
"CMakeFiles/wla-6510.dir/stack.c.o" \
"CMakeFiles/wla-6510.dir/listfile.c.o" \
"CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o" \
"CMakeFiles/wla-6510.dir/opcodes_6510.c.o"

# External object files for target wla-6510
wla__6510_EXTERNAL_OBJECTS =

binaries/wla-6510: CMakeFiles/wla-6510.dir/main.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/crc32.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/hashmap.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/parse.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/include_file.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/pass_1.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/pass_2.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/pass_3.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/pass_4.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/stack.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/listfile.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/opcodes_6510.c.o
binaries/wla-6510: CMakeFiles/wla-6510.dir/build.make
binaries/wla-6510: CMakeFiles/wla-6510.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_15) "Linking C executable binaries/wla-6510"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/wla-6510.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/wla-6510.dir/build: binaries/wla-6510

.PHONY : CMakeFiles/wla-6510.dir/build

# Object files for target wla-6510
wla__6510_OBJECTS = \
"CMakeFiles/wla-6510.dir/main.c.o" \
"CMakeFiles/wla-6510.dir/crc32.c.o" \
"CMakeFiles/wla-6510.dir/hashmap.c.o" \
"CMakeFiles/wla-6510.dir/parse.c.o" \
"CMakeFiles/wla-6510.dir/include_file.c.o" \
"CMakeFiles/wla-6510.dir/pass_1.c.o" \
"CMakeFiles/wla-6510.dir/pass_2.c.o" \
"CMakeFiles/wla-6510.dir/pass_3.c.o" \
"CMakeFiles/wla-6510.dir/pass_4.c.o" \
"CMakeFiles/wla-6510.dir/stack.c.o" \
"CMakeFiles/wla-6510.dir/listfile.c.o" \
"CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o" \
"CMakeFiles/wla-6510.dir/opcodes_6510.c.o"

# External object files for target wla-6510
wla__6510_EXTERNAL_OBJECTS =

CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/main.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/crc32.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/hashmap.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/parse.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/include_file.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/pass_1.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/pass_2.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/pass_3.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/pass_4.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/stack.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/listfile.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/opcodes_6510.c.o
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/build.make
CMakeFiles/CMakeRelink.dir/wla-6510: CMakeFiles/wla-6510.dir/relink.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/supper/prog/yuna/yuna/wla-dx/CMakeFiles --progress-num=$(CMAKE_PROGRESS_16) "Linking C executable CMakeFiles/CMakeRelink.dir/wla-6510"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/wla-6510.dir/relink.txt --verbose=$(VERBOSE)

# Rule to relink during preinstall.
CMakeFiles/wla-6510.dir/preinstall: CMakeFiles/CMakeRelink.dir/wla-6510

.PHONY : CMakeFiles/wla-6510.dir/preinstall

CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/main.c.o.requires
CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/crc32.c.o.requires
CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/hashmap.c.o.requires
CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/parse.c.o.requires
CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/include_file.c.o.requires
CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/pass_1.c.o.requires
CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/pass_2.c.o.requires
CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/pass_3.c.o.requires
CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/pass_4.c.o.requires
CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/stack.c.o.requires
CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/listfile.c.o.requires
CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/op_tbl_gen/opcodes_6510_tables.c.o.requires
CMakeFiles/wla-6510.dir/requires: CMakeFiles/wla-6510.dir/opcodes_6510.c.o.requires

.PHONY : CMakeFiles/wla-6510.dir/requires

CMakeFiles/wla-6510.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/wla-6510.dir/cmake_clean.cmake
.PHONY : CMakeFiles/wla-6510.dir/clean

CMakeFiles/wla-6510.dir/depend: op_tbl_gen/opcodes_6510_tables.c
	cd /home/supper/prog/yuna/yuna/wla-dx && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/supper/prog/yuna/yuna/wla-dx /home/supper/prog/yuna/yuna/wla-dx /home/supper/prog/yuna/yuna/wla-dx /home/supper/prog/yuna/yuna/wla-dx /home/supper/prog/yuna/yuna/wla-dx/CMakeFiles/wla-6510.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/wla-6510.dir/depend

