#pragma once

#include "elas.h"

#include <opencv2/core/core.hpp>

/*!
Class ElasMatcher
*/

class ElasMatcher
{

/** Public methods: */
  public:
	  // Constructor:
	  ElasMatcher();  
	
//====================================================================================================

	  // Destructor
	  ~ElasMatcher();  
	
//====================================================================================================

	  bool match(Elas::parameters &pars, const cv::Mat &leftImage, const cv::Mat &rightImage, cv::Mat &disp12, cv::Mat &disp21);

	  bool match(const cv::Mat &leftImage, const cv::Mat &rightImage, cv::Mat &disp12, cv::Mat &disp21);

//====================================================================================================

  protected:

	  void getImageELAS(const cv::Mat &img, unsigned char **pImgDat);

	  void getImageELASOneBand(const cv::Mat &img, unsigned char **pImgData);

	  cv::Mat convertImageELAS(float *data, int32_t width, int32_t height);

//====================================================================================================

};


