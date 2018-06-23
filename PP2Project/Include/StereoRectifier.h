#pragma once
#ifndef StereoRectifier_h
#define StereoRectifier_h

#include "stdafx.h"
#include "opencv2/xfeatures2d.hpp"

using namespace std;
using namespace cv;

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

	inline Mat getK1() { return this->K1; }
	inline Mat getK2() { return this->K2; }
	inline Mat getP1() { return this->P1; }
	inline Mat getP2() { return this->P2; }
	inline Mat getQ() { return this->Q; }

	/*
	// calculates the relative orientation by estimating and decomposing the essential matrix
	// FeatureDescriptor = "SIFT" or "SURF" or "ORB" 
	// return R and T
	*/
	bool calcRelativeOrientation(Mat &imgLeft, Mat &imgRight, string FeatureDescriptor, Mat &R, Mat &T, bool visualizeKeypts = false);

	/*
	// calculates the rectifying rotation matrices R1 and R2 for left and right image
	// Input: relative orientation R and T
	// output:	R1, R2	---> rectifying rotation matrices 
	//			P1, P2	---> new Projection matrices
	//			Q		---> matrix needed for 3D reprojection
	*/
	bool calcRectification(Mat &R, Mat &T, Size &imgsize, Mat &R1, Mat &R2, Mat &P1, Mat &P2, Mat &Q);

	/*
	// calculates the rectified image
	// Input:	img		---> original distorted unrectified image
	//			Rrect	--> rectifying rotation matrix
	//			Knew	---> new camera matrix (can be P)
	//			imgSize	---> new image size
	// Output:	imgR	---> rectified and undistorted image
	*/
	bool rectifyImages(Mat &img1, Mat &img2, Mat &imgR1, Mat &imgR2, Mat &Rrect1, Mat &Rrect2, Mat &Knew1, Mat &Knew2, Size &imgSize);
	bool rectifyImages(Mat &img1, Mat &img2, Mat &imgR1, Mat &imgR2, Size &imgSize);

	// calculates the three euler angles from a rotation matrix R
	bool calcEulerAngles(Mat &R, Vec3f &eulerangles);

	//====================================================================================================
private:
	// intrinsics
	Mat K1, K2, d1, d2;

	//extrinsics
	Mat R1, R2, P1, P2, Q;
	
	//====================================================================================================
protected:
	

};
#endif
