
#pragma once
#ifndef PtGenerator_h
#define PtGenerator_h

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/calib3d/calib3d.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/features2d/features2d.hpp>
#include <opencv2/xfeatures2d.hpp>
#include <opencv2/opencv.hpp>

#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <strstream>


#include "DenseMatcher.h"
#include "StereoRectifier.h"

using namespace std;

class PtGenerator
{
private:
	//paths
	string pIntrinsics;
	string PExtrinsics;
	string pImgLeft;
	string pImgRight;
	string pOutput;
	string pEpiLeft;
	string pEpiRight;
	string pEpiLeftSmall;
	string pEpiRightSmall;
	string pDisp;

	//matrix
	cv::Mat origleft;
	cv::Mat origright;
	cv::Mat epileft;
	cv::Mat epiright;
	cv::Mat disp;
	cv::Mat disp8;

public:
	PtGenerator();
	PtGenerator(string pIntr, string pExtr);
	~PtGenerator();

	bool GeneratePointCloud(bool saveEpiImg, bool saveDisparityImg);


	void setEpiPath(string pEpiL, string pEpiR);
	void setImgPath(string pImgL, string pImgR);
	void setDispPath(string pDisp);
	void setOutputPath(string out);
	vector<string> getFiles(string cate_dir);


};

#endif