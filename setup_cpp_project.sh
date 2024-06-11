#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 <project_name> [<absolute_path_to_directory>]"
    exit 1
}

# Check if the project name is provided
if [ -z "$1" ]; then
    usage
fi

PROJECT_NAME=$1
PROJECT_DIR=${2:-$(pwd)}

# Check if the provided project directory is an absolute path
if [[ $PROJECT_DIR != /* ]]; then
    echo "Error: Project directory must be an absolute path."
    usage
fi

# Create the project directory if it doesn't exist
mkdir -p $PROJECT_DIR/$PROJECT_NAME

# Navigate to the project directory
cd $PROJECT_DIR/$PROJECT_NAME

# Check if the CMakeLists.txt file exists, create it if not
if [ ! -f "CMakeLists.txt" ]; then
    echo "CMakeLists.txt not found. Creating a new one..."
    cat <<EOF > CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project($PROJECT_NAME)

set(CMAKE_CXX_STANDARD 17)
add_executable(main main.cpp)
EOF
fi

# Create a sample main.cpp file if it doesn't exist
if [ ! -f "main.cpp" ]; then
    echo "Creating a sample main.cpp file..."
    cat <<EOF > main.cpp
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOF
fi

# Create build directory if it doesn't exist
mkdir -p build
cd build

# Generate build files with CMake
cmake ..

# Generate compile_commands.json with correct include paths
cat <<EOF > compile_commands.json
[
  {
    "directory": "$PROJECT_DIR/$PROJECT_NAME",
    "command": "/usr/bin/clang++ -I/usr/include/c++/11 -I/usr/include/x86_64-linux-gnu/c++/11 -I/usr/include/c++/11/backward -I/usr/lib/gcc/x86_64-linux-gnu/11/include -I/usr/local/include -I/usr/include/x86_64-linux-gnu -I/usr/include -o main main.cpp",
    "file": "main.cpp"
  }
]
EOF

# Print success message
echo "Project setup for $PROJECT_DIR/$PROJECT_NAME completed."
echo "You can now open the project in Vim and start coding!"
