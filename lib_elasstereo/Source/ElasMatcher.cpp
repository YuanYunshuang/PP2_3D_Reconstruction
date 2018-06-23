#include "ElasMatcher.h"
#include "image.h"

#include <opencv2/imgproc/imgproc.hpp>
using namespace cv;

#include <iostream>
using namespace std;

//====================================================================================================

ElasMatcher::ElasMatcher() 
{

}

//====================================================================================================

ElasMatcher::~ElasMatcher() 
{

}

//====================================================================================================
 
bool ElasMatcher::match(Elas::parameters &pars, const cv::Mat &leftImage, const cv::Mat &rightImage, cv::Mat &disp12, cv::Mat &disp21)
{
	bool ret = true;
		
	if ((leftImage.cols <= 0) || (leftImage.rows <= 0) || (rightImage.cols <= 0) || (rightImage.rows <= 0) ||
		(leftImage.cols != rightImage.cols) || (leftImage.rows != rightImage.rows))
	{
		cout << "ERROR: Images must be of same size, but" << endl;
		cout << "       I1: " << leftImage.cols  <<  " x " << leftImage.rows << 
					 ", I2: " << rightImage.cols <<  " x " << rightImage.rows << endl;
		ret = false;    
	}
	else
	{
		image<uchar> *pI1 = new image<uchar>(leftImage.cols, leftImage.rows, false);
		image<uchar> *pI2 = new image<uchar>(rightImage.cols, rightImage.rows, false);
	
		if ((pI1 == NULL) || (pI2 == NULL)) ret = false;
		else
		{
			
			getImageELAS(leftImage, pI1->access);
			getImageELAS(rightImage, pI2->access);

			// allocate memory for disparity images
			float *pData1 = new float[pI1->width() * pI1->height()];
			float *pData2 = new float[pI1->width() * pI1->height()];

			Elas elas(pars);

			const int32_t dims[3] = { pI1->width(), pI1->height(), pI1->width() }; // bytes per line = pI1->width()

			elas.process(pI1->data, pI2->data, pData1, pData2, dims);
	
			disp12 = convertImageELAS(pData1, pI1->width(), pI1->height());
			disp21 = convertImageELAS(pData2, pI1->width(), pI1->height());

			// free memory for disparity images
			delete [] pData1;
			delete [] pData2;
		}
		

		if (pI1 != NULL) delete pI1;
		if (pI2 != NULL) delete pI2;
	}

	return ret;
};
  
//====================================================================================================

bool ElasMatcher::match(const cv::Mat &leftImage, const cv::Mat &rightImage, cv::Mat &disp12, cv::Mat &disp21)
{
	Elas::parameters param;
	param.postprocess_only_left = false;
	return this->match(param, leftImage, rightImage, disp12, disp21);
};

//====================================================================================================

void ElasMatcher::getImageELASOneBand(const cv::Mat &img, unsigned char **pImgDat)
{
	for (int r = 0; r < img.rows; ++r)
	{
		const unsigned char *pRowOld = img.ptr<unsigned char>(r);
		unsigned char *pRowNew = pImgDat[r];
		for (int c = 0; c < img.cols; ++c)
		{
			pRowNew[c] = pRowOld[c];
		}
	}
};

//====================================================================================================

void ElasMatcher::getImageELAS(const cv::Mat &img, unsigned char **pImgDat)
{
	if ((img.rows > 0) && (img.cols > 0))
	{
		if (img.channels() > 1)
		{
			Mat imgCopy; 
			cv::cvtColor(img, imgCopy, CV_RGB2GRAY);
			getImageELASOneBand(imgCopy, pImgDat);
		}
		else getImageELASOneBand(img, pImgDat);
	};
};

//====================================================================================================

cv::Mat ElasMatcher::convertImageELAS(float *data, int32_t width, int32_t height)
{
	Mat results(height, width, CV_32FC1);

	unsigned long i = 0;
	for (int r = 0; r < results.rows; ++r)
	{
		float *pRow = results.ptr<float>(r);
		for (int c = 0; c < results.cols; ++c)
		{
			pRow[c] = data[i];
			++i;
		}
	}

	return results;
}

//====================================================================================================
