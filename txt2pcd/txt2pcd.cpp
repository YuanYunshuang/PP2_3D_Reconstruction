#include<iostream>  
#include<fstream>  
#include <string>  
#include <vector>  
#include <pcl/io/pcd_io.h>  
#include <pcl/point_types.h>  

using namespace std;

typedef struct tagPOINT_3D
{
	double x;  //m world coordinate x  
	double y;  //m world coordinate y  
	double z;  //m world coordinate z  
	unsigned char r;
	unsigned char g;
	unsigned char b;
}POINT_WORLD;

int main()
{ 
	int number_Txt;
	FILE *fp_txt;
	tagPOINT_3D TxtPoint;
	vector<tagPOINT_3D> m_vTxtPoints;
	fp_txt = fopen("E:\\PraxisProjekt2\\data\\IKGVAN\\scenario_1\\voxelGridBox\\90402.txt", "r");

	if (fp_txt)
	{
		while (fscanf(fp_txt, "%lf %lf %lf %d %d %d", &TxtPoint.x, &TxtPoint.y, &TxtPoint.z, &TxtPoint.r, &TxtPoint.g, &TxtPoint.b) != EOF)
		{
			m_vTxtPoints.push_back(TxtPoint);
		}
	}
	else
		cout << "reading txt data failed£¡" << endl;
	number_Txt = m_vTxtPoints.size();
	pcl::PointCloud<pcl::PointXYZRGB> cloud;


	// Fill in the cloud data  
	cloud.width = number_Txt;
	cloud.height = 1;
	cloud.is_dense = false;
	cloud.points.resize(cloud.width * cloud.height);


	for (size_t i = 0; i < cloud.points.size(); ++i)
	{
		cloud.points[i].x = m_vTxtPoints[i].x;
		cloud.points[i].y = m_vTxtPoints[i].y;
		cloud.points[i].z = m_vTxtPoints[i].z;
		// pack r/g/b into rgb
		uint8_t r = m_vTxtPoints[i].r, g = m_vTxtPoints[i].g, b = m_vTxtPoints[i].b;
		uint32_t rgb = ((uint32_t)r << 16 | (uint32_t)g << 8 | (uint32_t)b);
		cloud.points[i].rgb = *reinterpret_cast<float*>(&rgb);
	}
	pcl::io::savePCDFileASCII("..\\90402.pcd", cloud);
	std::cerr << "Saved " << cloud.points.size() << " data points to 90402.pcd." << std::endl;


	//for (size_t i = 0; i < cloud.points.size(); ++i)
	//	std::cerr << "    " << cloud.points[i].x << " " << cloud.points[i].y << " " << cloud.points[i].z << std::endl;


	system("pause");
	return 0;
}