# Set minimal cmake version
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

project(ElasMatcher)

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
)

link_directories(
	
	)
	
add_library(${PROJECT_NAME} 
	${SOURCE_FILES_DP}
	${HEADER_FILES_DP}
	)
	
target_link_libraries(
	${PROJECT_NAME}
	${OpenCV_LIBS}	
	
	)