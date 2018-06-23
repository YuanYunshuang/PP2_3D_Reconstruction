#Project
cmake_minimum_required(VERSION 2.4)
project(spsstereo)

# Flags
set(CMAKE_CXX_FLAGS_RELEASE "-Wall -O3 -msse4.2")
if (APPLE)
set(CMAKE_CXX_FLAGS_RELEASE "-Wall -O3 -msse4.2 -stdlib=libstdc++")
endif (APPLE)
set(CMAKE_BUILD_TYPE Release)

# Find OpenCV
find_package( OpenCV REQUIRED )

if(NOT CMAKE_DEBUG_POSTFIX)
  set(CMAKE_DEBUG_POSTFIX _d)
endif()

include_directories(	
	${CMAKE_SOURCE_DIR}
	${CMAKE_SOURCE_DIR}/Include
	${OpenCV_DIR}/../opencv_main/3rdparty/libpng	
	)
	
link_directories(
	${OpenCV_DIR}/3rdparty/lib/Debug
	${OpenCV_DIR}/3rdparty/lib/Release	
	)

# SPS-Stereo
file(GLOB SPSSTEREO_SRC_FILES "Source/*.cpp")
file(GLOB SPSSTEREO_INC_FILES "Include/*.h")

add_library(${PROJECT_NAME} 
	${SPSSTEREO_SRC_FILES}
	${SPSSTEREO_INC_FILES}
	)

target_link_libraries(${PROJECT_NAME} 
	debug		libpngd
	optimized 	libpng
	
	debug 		zlibd
	optimized	zlib
	)
