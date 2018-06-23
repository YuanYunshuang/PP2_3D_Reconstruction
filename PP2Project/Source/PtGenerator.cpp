#include "PtGenerator.h"
#include <stdio.h>  
#include <string.h> 
#include <direct.h>  
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
	origleft = imread(pImgLeft);
	origright = imread(pImgLeft);

	StereoRectifier rectifier;
	rectifier.initIntrinsics(pIntrinsics);
	rectifier.initExtrinsics(PExtrinsics);
	rectifier.rectifyImages(origleft, origright, epileft, epiright, origleft.size());
	if (saveEpiImg) {
		try {
			imwrite(pEpiLeft, epileft);
			imwrite(pEpiRight, epiright);
		}
		catch (runtime_error& ex) {
			fprintf(stderr, "Exception converting image to PNG format: %s\n", ex.what());
			return 1;
		}
	}

/*	Mat epileftsmall;
	Mat epirightsmall;
	resize(epileft, epileftsmall, epileftsmall.size(), 2.0, 2.0);
	resize(epiright, epirightsmall, epirightsmall.size(), 0.5, 0.5);
	string fnepileftsmall = "E:/PraxisProjekt2/data/IKGVAN/Scenario_1/epileftsmall/000200.png";
	string fnepirightsmall = "E:/PraxisProjekt2/data/IKGVAN/Scenario_1/epirightsmall/000200.png";
	imwrite(fnepileftsmall, epileftsmall);
	imwrite(fnepirightsmall, epirightsmall);*/


	DenseMatcher matcher;
	matcher.matchStereoPair(pEpiLeft, pEpiRight, epileft, epiright, disp, "ELAS"); //Alternative SPSS
	if (saveDisparityImg) {
		try {
			imwrite(pDisp, disp);
		}
		catch (runtime_error& ex) {
			fprintf(stderr, "Exception converting image to PNG format: %s\n", ex.what());
			return 1;
		}
	}



	disp.convertTo(disp8, CV_8UC1);

	Mat Q = rectifier.getQ();
	Mat xyz;
	Q.at<double>(3, 1) /= 0.8466;
	reprojectImageTo3D(disp, xyz, Q);
	ofstream output(pOutput);
	for (int r = 0; r < xyz.rows; r++)
	{
		for (int c = 0; c < xyz.cols; c++)
		{
			Mat disparity = disp;
			if (disparity.at<float>(r, c) > 20.0)
			{
				Vec3f currPt = xyz.at<Vec3f>(r, c);
				Vec3b currCol = epileft.at<Vec3b>(r, c);
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
	vector<string> files;//container for file names 

	_finddata_t file;
	long lf;
	//输入文件夹路径  
	if ((lf = _findfirst(cate_dir.c_str(), &file)) == -1) {
		cout << cate_dir << " not found!!!" << endl;
	}
	else {
		while (_findnext(lf, &file) == 0) {
			//输出文件名  
			//cout<<file.name<<endl;  
			if (strcmp(file.name, ".") == 0 || strcmp(file.name, "..") == 0)
				continue;
			files.push_back(file.name);
		}
	}
	_findclose(lf);

	//排序，按从小到大排序  
	sort(files.begin(), files.end());
	return files;
}