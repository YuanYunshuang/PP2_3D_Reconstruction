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
#include <direct.h>  
#include <io.h> 



#include "DenseMatcher.h"
#include "StereoRectifier.h"
#include "PtGenerator.h"

using namespace std;

//****************************************************************************************************
int main(int argc, char* argv[])
{
	//setting paths
	string imgDirL = "G:/PP2/IKGVAN/left/";
	string imgDirR = "G:/PP2/IKGVAN/right/";
	string fnintrinsics = "E:/PraxisProjekt2/data/IKGVAN/intrinsics.txt";
	string fnextrinsics = "E:/PraxisProjekt2/data/IKGVAN/extrinsics.txt";
	string pEpileft = "G:/PP2/IKGVAN/epileftSmall/";
	string pEpiright = "G:/PP2/IKGVAN/epirightSmall/";
	string pPointCloud = "G:/PP2/IKGVAN/pointcloudSPSS/";

	//get a new Pointcloud generator handle
	PtGenerator ptg(fnintrinsics, fnextrinsics);
	vector<string> ImgNames = ptg.getFiles(imgDirL); //get the filename list

	for (int i = 0; i<ImgNames.size(); i++)
	{
		string tmp = ImgNames[i].substr(0, ImgNames[i].length() - 4)+".txt"; // delete the extend of the image name
		ptg.setOutputPath(pPointCloud+tmp);
		cout << "point cloud path:" << pPointCloud + tmp << endl;
		ptg.setEpiPath(pEpileft + ImgNames[i], pEpiright + ImgNames[i]);
		cout << "Epipolar left image path: " << pEpileft + ImgNames[i] << endl;
		ptg.setImgPath(imgDirL + ImgNames[i], imgDirR + ImgNames[i]);
		cout << "Original left image path: " << imgDirL + ImgNames[i] << endl;

		ptg.GeneratePointCloud(true, false);
		cout << "Image " << ImgNames[i] << " finished." << endl;
	}
	
	char tmp;
	cin >> tmp;
	cv::waitKey(0);
	
	return EXIT_SUCCESS;
}


