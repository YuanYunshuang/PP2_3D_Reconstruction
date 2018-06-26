# Set minimal cmake version
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

project(PP2Project)

# Set properties and options
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/bin)
endif()

# Find OpenCV
find_package( OpenCV REQUIRED )

# Define header and source files
file(GLOB SOURCE_FILES_DP Source/*.cpp)
file(GLOB HEADER_FILES_DP Include/*.h)

if(NOT CMAKE_DEBUG_POSTFIX)
  set(CMAKE_DEBUG_POSTFIX _d)
endif()

include_directories(
	${CMAKE_SOURCE_DIR}/include
	../lib_elasstereo/Include
	../lib_spsstereo/Include
	../lib_spsstereo	
	${OpenCV_DIR}/../opencv_main/3rdparty/libpng
)

link_directories(
	${OpenCV_DIR}/3rdparty/lib/Debug
	${OpenCV_DIR}/3rdparty/lib/Release
	)
	
add_executable(${PROJECT_NAME} 
	${SOURCE_FILES_DP}
	${HEADER_FILES_DP}
	)
	
target_link_libraries(
	${PROJECT_NAME}
	${OpenCV_LIBS}	
	
	debug			E:/PraxisProjekt2/lib_elasstereo/bin/Debug/ElasMatcher_d
	optimized		../lib_elasstereo/bin/Release/ElasMatcher
	
	debug 			E:/PraxisProjekt2/lib_spsstereo/Debug/spsstereo_d
	optimized		../lib_spsstereo/Release/spsstereo
	
	debug			libpngd
	optimized 		libpng
	
	debug			zlibd
	optimized		zlib
	)