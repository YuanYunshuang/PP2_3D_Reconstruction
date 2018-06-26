#pragma once
#ifndef StereoRectifier_h
#define StereoRectifier_h

#include "stdafx.h"
#include "opencv2/xfeatures2d.hpp"

using namespace std;
//using namespace cv;

//******************************************************************************************
/*
// Class for Stereo Rectification
*/
class StereoRectifier
{
public:
	//====================================================================================================
	// Constructors
	StereoRectifier();

	// Destructor
	~StereoRectifier();	

	bool initIntrinsics(string fnIntrinsics); //Intrinsics Pfad

	bool initExtrinsics(string fnExtrinsics);

	inline cv::Mat getK1() { return this->K1; }
	inline cv::Mat getK2() { return this->K2; }
	inline cv::Mat getP1() { return this->P1; }
	inline cv::Mat getP2() { return this->P2; }
	inline cv::Mat getQ() { return this->Q; }

	/*
	// calculates the relative orientation by estimating and decomposing the essential matrix
	// FeatureDescriptor = "SIFT" or "SURF" or "ORB" 
	// return R and T
	*/
	bool calcRelativeOrientation(cv::Mat &imgLeft, cv::Mat &imgRight, string FeatureDescriptor, cv::Mat &R, cv::Mat &T, bool visualizeKeypts = false);

	/*
	// calculates the rectifying rotation matrices R1 and R2 for left and right image
	// Input: relative orientation R and T
	// output:	R1, R2	---> rectifying rotation matrices 
	//			P1, P2	---> new Projection matrices
	//			Q		---> matrix needed for 3D reprojection
	*/
	bool calcRectification(cv::Mat &R, cv::Mat &T, cv::Size &imgsize, cv::Mat &R1, cv::Mat &R2, cv::Mat &P1, cv::Mat &P2, cv::Mat &Q);

	/*
	// calculates the rectified image
	// Input:	img		---> original distorted unrectified image
	//			Rrect	--> rectifying rotation matrix
	//			Knew	---> new camera matrix (can be P)
	//			imgSize	---> new image size
	// Output:	imgR	---> rectified and undistorted image
	*/
	bool rectifyImages(cv::Mat &img1, cv::Mat &img2, cv::Mat &imgR1, cv::Mat &imgR2, cv::Mat &Rrect1, cv::Mat &Rrect2, cv::Mat &Knew1, cv::Mat &Knew2, cv::Size &imgSize);
	bool rectifyImages(cv::Mat &img1, cv::Mat &img2, cv::Mat &imgR1, cv::Mat &imgR2, cv::Size &imgSize);

	// calculates the three euler angles from a rotation matrix R
	bool calcEulerAngles(cv::Mat &R, cv::Vec3f &eulerangles);

	//====================================================================================================
private:
	// intrinsics
	cv::Mat K1, K2, d1, d2;

	//extrinsics
	cv::Mat R1, R2, P1, P2, Q;
	
	//====================================================================================================
protected:
	

};
#endif
