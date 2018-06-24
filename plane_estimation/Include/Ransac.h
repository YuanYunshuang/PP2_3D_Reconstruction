#pragma once
#ifndef Ransac_h
#define Ransac_h

#include <iostream>
#include <pcl/ModelCoefficients.h>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>
#include <pcl/sample_consensus/method_types.h>
#include <pcl/sample_consensus/model_types.h>
#include <pcl/segmentation/sac_segmentation.h>
#include <pcl/filters/extract_indices.h> 
#include<fstream>  
#include <string>  
#include <vector>  
#include<direct.h>

using namespace std;



class Ransac
{
public:
	Ransac();
	virtual ~Ransac();

		
	
	void write2txt(const char* filename, pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud);
	int PlaneEstimation(pcl::PointCloud<pcl::PointXYZRGB>::Ptr, int, pcl::ModelCoefficients::Ptr, const char*);
	void PlanesEstimation(const char* filename, const char* outputpath);

};


#endif // !Ransac_h