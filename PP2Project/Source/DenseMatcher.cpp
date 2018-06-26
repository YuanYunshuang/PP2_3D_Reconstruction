#include "DenseMatcher.h"

#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <strstream>

#include "ElasMatcher.h"
#include "SPSStereo.h"
#include "defParameter.h"
//====================================================================================================
DenseMatcher::DenseMatcher()
{

}

//====================================================================================================
DenseMatcher::~DenseMatcher()
{

}

//====================================================================================================
bool DenseMatcher::matchStereoPair(string fnEpi1, string fnEpi2, cv::Mat &img1, cv::Mat &img2, cv::Mat &disp12, string matcherType)
{
	bool ret = true;
	img1 = cv::imread(fnEpi1);
	img2 = cv::imread(fnEpi2);
	if (matcherType == "ELAS")
	{
		cv::Mat disp21;
		ElasMatcher matcher;
		if (!matcher.match(img1, img2, disp12, disp21)) { ret = false; cerr << "Error calculating disparity image" << endl; return ret; }		// calculate disparity image

	}
	else if (matcherType == "SPSS")
	{
		SPSStereo sps; 
		png::image<png::rgb_pixel> leftImage(fnEpi1);
		png::image<png::rgb_pixel> rightImage(fnEpi2);
		
		sps.setIterationTotal(outerIterationTotal, innerIterationTotal);
		sps.setWeightParameter(lambda_pos, lambda_depth, lambda_bou, lambda_smo);
		sps.setInlierThreshold(lambda_d);
		sps.setPenaltyParameter(lambda_hinge, lambda_occ, lambda_pen);

		png::image<png::gray_pixel_16> segmentImage;
		png::image<png::gray_pixel_16> disparityImage;
		std::vector< std::vector<double> > disparityPlaneParameters;
		std::vector< std::vector<int> > boundaryLabels;
		sps.compute(superpixelTotal, leftImage, rightImage, segmentImage, disparityImage, disparityPlaneParameters, boundaryLabels);
		int nRows = disparityImage.get_height();
		int nCols = disparityImage.get_width();

		disp12.create(nRows, nCols, CV_32FC1);
		for (int i = 0; i < nRows; i++)
		{
			for (int j = 0; j < nCols; j++)
			{
				disp12.at<float>(i, j) = float(disparityImage.get_pixel(j, i) / 256.0);				
			}
		}
	}
	else
	{
		ret = false;
		cerr << "Unknown matcherType: " << matcherType << " does not fit to ELAS or SPSS" << endl;
	}
	return ret;
}