#pragma once
#ifndef DenseMatcher_h
#define DenseMatcher_h

#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <strstream>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/calib3d/calib3d.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;
using namespace std;

//******************************************************************************************
/*
// Class for Dense Matching of Epipolar Images
// supports:
// - Dense Matching (ELAS)
// - Dense Matching (SPSS)
*/
class DenseMatcher
{
public:
	//====================================================================================================
	// Constructors
	DenseMatcher();

	// Destructor
	~DenseMatcher();
	
	/*
	// function for dense matching of two rectified stereo images
	// Input:	fnEpi1 and fnEpi2		--> filenames incl. the path of image1 and image2
	//			matcherType				--> either "ELAS" or "SPSS"
	// Return:	img1 and img2			--> the two rectified epipolar images
	//			disp12					--> the disparity map (Type CV_32FC1)
	*/
	bool matchStereoPair(string fnEpi1, string fnEpi2, Mat &img1, Mat &img2, Mat &disp12, string matcherType);	

	//====================================================================================================
private:
	
	//====================================================================================================
protected:
	

};
#endif
