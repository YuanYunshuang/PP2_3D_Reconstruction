
#include "VoxelGridFilter.h"

#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>
#include <pcl/filters/voxel_grid.h>
#include<fstream>  
#include <string>  
#include <vector>  
#include <stdio.h>  
#include <direct.h>  
#include <dirent.h>
#include <io.h>


using namespace std;
vector<string> getFiles(string cate_dir)
{
	int len;
	vector<string> files;//container for file names 
	struct dirent *pDirent;
	DIR *pDir;

	pDir = opendir(cate_dir.c_str());
	if (pDir == NULL) {
		printf("Cannot open directory '%s'\n", cate_dir);
	}

	while ((pDirent = readdir(pDir)) != NULL) {
		//cout<< string(pDirent->d_name)<<endl;
		if((pDirent->d_name[0])!='.')
			files.push_back(string(pDirent->d_name));
	}
	closedir(pDir);
	//sort(files.begin(), files.end());
	return files;
}


int main (int argc, char** argv)
{


	string path2pc = "D:\\PP2\\test";
	string savePath = "D:\\PP2";
	vector<string> filenames = getFiles(path2pc);
	string input = "";
	string output = "";
	VoxelGridFilter vg_filter;

	for (int i = 0; i < filenames.size(); i++) {
		cout << "----------------i=" << i << "----------------" << endl;
		input = path2pc +"\\"+ filenames[i];
		cout << input << endl;
		output = savePath + "\\" + filenames[i];
		cout << output << endl;
		vg_filter.Filter(input.c_str(), output.c_str());
	}

	system("pause");
	return (0);
}


