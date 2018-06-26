#include "StereoRectifier.h"

//====================================================================================================
StereoRectifier::StereoRectifier()
{

}

//====================================================================================================
StereoRectifier::~StereoRectifier()
{

}

//====================================================================================================
bool StereoRectifier::initIntrinsics(string fnIntrinsics)
{
	bool ret = true;
	cv::FileStorage fs1(fnIntrinsics, cv::FileStorage::READ);

	if (!fs1.isOpened()) return false;
	cv::Mat q1, q2;
	int stat1, stat2;
	cv::Size s1, s2;

	fs1["M1"] >> this->K1;
	fs1["D1"] >> this->d1;
	fs1["Cov1"] >> q1;
	fs1["s1"] >> stat1;
	fs1["w1"] >> s1.width;
	fs1["h1"] >> s1.height;

	fs1["M2"] >> this->K2;
	fs1["D2"] >> this->d2;
	fs1["Cov2"] >> q2;
	fs1["s2"] >> stat2;
	fs1["w2"] >> s2.width;
	fs1["h2"] >> s2.height;

	fs1.release();
	return ret;
}

//====================================================================================================
bool StereoRectifier::initExtrinsics(string fnExtrinsics)
{
	bool ret = true;
	cv::FileStorage fs1(fnExtrinsics, cv::FileStorage::READ);

	if (!fs1.isOpened()) return false;
	cv::Mat q1, q2;
	//int stat1, stat2;
	cv::Size s1, s2;

	fs1["R1"] >> this->R1;
	fs1["R2"] >> this->R2;
	fs1["P1"] >> this->P1;
	fs1["P2"] >> this->P2;
	fs1["Q"]  >> this->Q;


	fs1.release();
	return ret;
}

//====================================================================================================
bool StereoRectifier::calcRelativeOrientation(cv::Mat &imgLeft, cv::Mat &imgRight, string FeatureDescriptor, cv::Mat &R, cv::Mat &T, bool visualizeKeypts)
{
	bool ret = true;

	// Get feature extractor
	cv::Ptr<cv::Feature2D> f2d;
	if (FeatureDescriptor == "SIFT")		f2d = cv::xfeatures2d::SIFT::create();
	else if (FeatureDescriptor == "SURF")	f2d = cv::xfeatures2d::SURF::create();
	else if (FeatureDescriptor == "ORB")	f2d = cv::ORB::create();
	else { ret = false; cerr << "No valid feature descriptor" << endl; }

	// detect the keypoints	
	vector<cv::KeyPoint> kpleft, kpright;
	f2d->detect(imgLeft, kpleft);
	f2d->detect(imgRight, kpright);

	// get the descriptors
	cv::Mat desleft, desright;
	f2d->compute(imgLeft, kpleft, desleft);
	f2d->compute(imgRight, kpright, desright);

	// match the keypoints
	cv::BFMatcher matcher;
	vector<cv::DMatch > matches;
	matcher.match(desleft, desright, matches);
	vector<cv::Point2d> imgPtsLeft, imgPtsRight;
	imgPtsLeft.reserve(matches.size());
	imgPtsRight.reserve(matches.size());
	for (int i = 0; i < matches.size(); i++)
	{
		int leftIdx = matches[i].queryIdx;
		int rightIdx = matches[i].trainIdx;
		imgPtsLeft.push_back(cv::Point2d(kpleft[leftIdx].pt));
		imgPtsRight.push_back(cv::Point2d(kpright[rightIdx].pt));
	}

	// undistort keypoints --> undistorted points will have f = 1.0 and pp = (0.0, 0.0)
	vector<cv::Point2d> imgPtsLeftUndist, imgPtsRightUndist;

	undistortPoints(imgPtsLeft, imgPtsLeftUndist, K1, d1);
	undistortPoints(imgPtsRight, imgPtsRightUndist, K2, d2);

	// find essential matrix
	double confidence = 0.999;
	double reprojThreshold = 3.0;
	vector<uchar> inliers;
	cv::Mat E = findEssentialMat(imgPtsLeftUndist, imgPtsRightUndist, 1.0, cv::Point2d(0.0, 0.0), cv::RANSAC, confidence, reprojThreshold / K1.at<double>(0, 0), inliers);
	vector<cv::Point2d> imgPtsLeftInliers, imgPtsRightInliers;
	vector<int> inlierIdx;
	inlierIdx.reserve(imgPtsLeft.size());
	imgPtsLeftInliers.reserve(imgPtsLeft.size());
	imgPtsRightInliers.reserve(imgPtsRight.size());
	for (int i = 0; i < inliers.size(); i++)
	{
		if (int(inliers[i]) > 0)
		{
			imgPtsLeftInliers.push_back(imgPtsLeftUndist[i]);
			imgPtsRightInliers.push_back(imgPtsRightUndist[i]);
			inlierIdx.push_back(i);
		}
	}

	// recover pose from essential matrix			
	recoverPose(E, imgPtsLeftInliers, imgPtsRightInliers, R, T);

	if (visualizeKeypts)
	{
		cv::Mat imgKeypts = imgLeft.clone();
		for (int i = 0; i < inlierIdx.size(); i++)
		{
			int currIdx = inlierIdx[i];
			circle(imgKeypts, imgPtsLeft[currIdx], 2, cv::Scalar(0.0, 0.0, 255.0), 1);
		}
		cv::namedWindow("Keypoints", cv::WINDOW_AUTOSIZE);
		cv::imshow("Keypoints", imgKeypts);
		cv::waitKey(0);
	}

	return ret;
}

//====================================================================================================
bool StereoRectifier::calcRectification(cv::Mat &R, cv::Mat &T, cv::Size &imgsize, cv::Mat &R1, cv::Mat &R2, cv::Mat &P1, cv::Mat &P2, cv::Mat &Q)
{
	bool ret = true;
	cv::Size newImgSize = imgsize;
	stereoRectify(this->K1, this->d1, this->K2, this->d2, imgsize, R, T, R1, R2, P1, P2, Q, cv::CALIB_ZERO_DISPARITY, 0.0, newImgSize);
	return ret;
}

//====================================================================================================
bool StereoRectifier::rectifyImages(cv::Mat &img1, cv::Mat &img2, cv::Mat &imgR1, cv::Mat &imgR2, cv::Mat &Rrect1, cv::Mat &Rrect2, cv::Mat &Knew1, cv::Mat &Knew2, cv::Size &imgSize)
{
	bool ret = true;
	cv::Mat rmap[2][2];
	initUndistortRectifyMap(K1, d1, Rrect1, Knew1, imgSize, CV_16SC2, rmap[0][0], rmap[0][1]);
	initUndistortRectifyMap(K2, d2, Rrect2, Knew2, imgSize, CV_16SC2, rmap[1][0], rmap[1][1]);
	remap(img1, imgR1, rmap[0][0], rmap[0][1], cv::INTER_LINEAR);
	remap(img2, imgR2, rmap[1][0], rmap[1][1], cv::INTER_LINEAR);

	return ret;
}

//====================================================================================================
bool StereoRectifier::rectifyImages(cv::Mat &img1, cv::Mat &img2, cv::Mat &imgR1, cv::Mat &imgR2, cv::Size &imgSize)
{
	bool ret = true;
	if (this->R1.empty() || this->R2.empty())
	{
		ret = false;
		cerr << "Error rectifying images: Extrinsics need to be initialized" << endl;
	}
	rectifyImages(img1, img2, imgR1, imgR2, this->R1, this->R2, this->P1, this->P2, imgSize);
	return ret;
}

//====================================================================================================
bool StereoRectifier::calcEulerAngles(cv::Mat &R, cv::Vec3f &eulerangles)
{
	bool ret = true;

	// check if R is rotation matrix
	cv::Mat Rt;
	transpose(R, Rt);
	cv::Mat shouldBeIdentity = Rt * R;
	cv::Mat I = cv::Mat::eye(3, 3, shouldBeIdentity.type());

	ret = norm(I, shouldBeIdentity) < 1e-6;

	if (ret)
	{
		float sy = sqrt(R.at<double>(0, 0) * R.at<double>(0, 0) + R.at<double>(1, 0) * R.at<double>(1, 0));

		bool singular = sy < 1e-6; // If

		float x, y, z;
		if (!singular)
		{
			x = atan2(R.at<double>(2, 1), R.at<double>(2, 2));
			y = atan2(-R.at<double>(2, 0), sy);
			z = atan2(R.at<double>(1, 0), R.at<double>(0, 0));
		}
		else
		{
			x = atan2(-R.at<double>(1, 2), R.at<double>(1, 1));
			y = atan2(-R.at<double>(2, 0), sy);
			z = 0;
		}
		eulerangles = cv::Vec3f(x, y, z);
	}
	return ret;
}