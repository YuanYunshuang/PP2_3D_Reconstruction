#pragma once
#ifndef VoxelGridFilter_h
#define VoxelGridFilter_h

#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>
#include <pcl/filters/voxel_grid.h>
#include<fstream>  
#include <string>  
#include <vector>  

using namespace std;



class VoxelGridFilter
{
public:
	VoxelGridFilter();
	virtual ~VoxelGridFilter();

	int Filter(const char* filename, const char* filtered_filename);
	
	void write2txt(const char*, pcl::PointCloud<pcl::PointXYZRGB>::Ptr);
};


#endif // !VoxelGridFilter_h

