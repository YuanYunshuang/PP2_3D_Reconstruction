# Set minimal cmake version
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

project(VoxelGridFiltering)

# Set properties and options
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/bin)
endif()

# Find PCL
find_package(PCL 1.2 REQUIRED)

# Define header and source files
file(GLOB SOURCE_FILES_DP Source/*.cpp)
file(GLOB HEADER_FILES_DP Include/*.h)

if(NOT CMAKE_DEBUG_POSTFIX)
  set(CMAKE_DEBUG_POSTFIX _d)
endif()

include_directories(
	${CMAKE_SOURCE_DIR}/include
	${PCL_INCLUDE_DIRS})
link_directories(${PCL_LIBRARY_DIRS})
add_definitions(${PCL_DEFINITIONS})

add_executable(${PROJECT_NAME} 
	${SOURCE_FILES_DP}
	${HEADER_FILES_DP}
	)
target_link_libraries (${PROJECT_NAME} ${PCL_LIBRARIES})