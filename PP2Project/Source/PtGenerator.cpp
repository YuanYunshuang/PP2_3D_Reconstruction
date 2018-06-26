#include "PtGenerator.h"
#include <stdio.h>  
#include <string.h> 
#include <direct.h>   
#include <dirent.h>
#include <io.h>


PtGenerator::PtGenerator()
{

}

PtGenerator::PtGenerator(string pIntr, string pExtr)
{
	pIntrinsics = pIntr;
	PExtrinsics = pExtr;
}


PtGenerator::~PtGenerator()
{
}




bool PtGenerator::GeneratePointCloud(bool saveEpiImg, bool saveDisparityImg) {
	origleft = cv::imread(pImgLeft);
	origright = cv::imread(pImgLeft);
	double resizefactor = 0.5;
	StereoRectifier rectifier;
	rectifier.initIntrinsics(pIntrinsics);
	rectifier.initExtrinsics(PExtrinsics);
	rectifier.rectifyImages(origleft, origright, epileft, epiright, origleft.size());
/*	if (saveEpiImg) {
		try {
			cv::imwrite(pEpiLeft, epileft);
			cv::imwrite(pEpiRight, epiright);
		}
		catch (runtime_error& ex) {
			fprintf(stderr, "Exception converting image to PNG format: %s\n", ex.what());
			return 1;
		}
	}*/

	cv::Mat epileftsmall;
	cv::Mat epirightsmall;
	cv::resize(epileft, epileftsmall, epileftsmall.size(), resizefactor, resizefactor);
	cv::resize(epiright, epirightsmall, epirightsmall.size(), resizefactor, resizefactor);
	if (saveEpiImg) {
		try {
			cv::imwrite(pEpiLeft, epileftsmall);
			cv::imwrite(pEpiRight, epirightsmall);
		}
		catch (runtime_error& ex) {
			fprintf(stderr, "Exception converting image to PNG format: %s\n", ex.what());
			return 1;
		}
	}


	DenseMatcher matcher;
	matcher.matchStereoPair(pEpiLeft, pEpiRight, epileftsmall, epirightsmall, disp, "SPSS"); //Alternative SPSS
	if (saveDisparityImg) {
		try {
			cv::imwrite(pDisp, disp8);
		}
		catch (runtime_error& ex) {
			fprintf(stderr, "Exception converting image to PNG format: %s\n", ex.what());
			return 1;
		}
	}

	disp.convertTo(disp8, CV_8UC1);

	cv::Mat Q = rectifier.getQ();
	cv::Mat xyz;
	Q.at<double>(3, 1) /= 0.8466;
	Q.at<double>(0, 3) *= resizefactor;
	Q.at<double>(1, 3) *= resizefactor;
	Q.at<double>(2, 3) *= resizefactor;
	reprojectImageTo3D(disp, xyz, Q);
	double B = 0.8466;
	double f = Q.at<double>(2, 3);
	double sigma_z = 1.5;
	double d_min = sqrt((-f*B) / (sigma_z));
	double z = (-f*B) / d_min;

	ofstream output(pOutput);
	for (int r = 0; r < xyz.rows; r++)
	{
		for (int c = 0; c < xyz.cols; c++)
		{
			//Mat disparity = disp;
			if (disp.at<float>(r, c) > d_min)
			{
				cv::Vec3f currPt = xyz.at<cv::Vec3f>(r, c);
				cv::Vec3b currCol = epileft.at<cv::Vec3b>(r, c);
				output << currPt.val[0] << " " << currPt.val[1] << " " << currPt.val[2] << " " << int(currCol.val[0]) << " " << int(currCol.val[1]) << " " << int(currCol.val[2]) << endl;
			}
		}
	}
	output.close();
	return true;
}

void PtGenerator::setEpiPath(const string pEpiL, const string pEpiR) {
	pEpiLeft = pEpiL;
	pEpiRight = pEpiR;
}

void PtGenerator::setImgPath(string pImgL, string pImgR) {
	pImgLeft = pImgL;
	pImgRight = pImgR;
}


void PtGenerator::setDispPath(string pDispa) {
	pDisp = pDispa;
}

void PtGenerator::setOutputPath(string out) {
	pOutput = out;
}

vector<string> PtGenerator::getFiles(string cate_dir)
{
	int len;
	vector<string> files;//container for file names 
	struct dirent *pDirent;
	DIR *pDir;

	pDir = opendir(cate_dir.c_str());
	if (pDir == NULL) {
		printf("Cannot open directory '%s'\n", cate_dir.c_str());
	}

	while ((pDirent = readdir(pDir)) != NULL) {
		//cout<< string(pDirent->d_name)<<endl;
		if ((pDirent->d_name[0]) != '.')
			files.push_back(string(pDirent->d_name));
	}
	closedir(pDir);
	//sort(files.begin(), files.end());
	return files;
}