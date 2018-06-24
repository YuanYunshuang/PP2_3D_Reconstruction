#include "VoxelGridFilter.h"



VoxelGridFilter::VoxelGridFilter()
{
}


VoxelGridFilter::~VoxelGridFilter()
{
}

typedef struct tagPOINT_3D
{
	double x;  //m world coordinate x  
	double y;  //m world coordinate y  
	double z;  //m world coordinate z  
	unsigned char r;
	unsigned char g;
	unsigned char b;
}POINT_WORLD;

void VoxelGridFilter::write2txt(const char* filename, pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud) {

	ofstream output(filename);
	cout << "Writing filtered point cloud to txt file." << endl;
	for (int i = 0; i < cloud->points.size(); i++)
	{

		// unpack rgb into r/g/b
		uint32_t rgb = *reinterpret_cast<int*>(&cloud->points[i].rgb);
		uint8_t r = (rgb >> 16) & 0x0000ff;
		uint8_t g = (rgb >> 8) & 0x0000ff;
		uint8_t b = (rgb) & 0x0000ff;
		output << std::fixed << std::setprecision(6) << cloud->points[i].x + 548800.0 << " ";
		output << std::fixed << std::setprecision(6) << cloud->points[i].y + 5804500.0 << " ";
		output << std::fixed << std::setprecision(6) << cloud->points[i].z << " ";
		output << (int)r << " " << (int)g << " " << (int)b << endl;
	}
	output.close();

}

int VoxelGridFilter::Filter(const char* filename, const char* filtered_filename)
{
	int number_Txt;
	FILE *fp_txt;
	tagPOINT_3D TxtPoint;
	vector<tagPOINT_3D> m_vTxtPoints;
	fp_txt = fopen(filename, "r");

	if (fp_txt)
	{
		while (fscanf(fp_txt, "%lf %lf %lf %d %d %d", &TxtPoint.x, &TxtPoint.y, &TxtPoint.z, &TxtPoint.r, &TxtPoint.g, &TxtPoint.b) != EOF)
		{
			TxtPoint.x = TxtPoint.x - 548800.0;
			TxtPoint.y = TxtPoint.y - 5804500.0;
			m_vTxtPoints.push_back(TxtPoint);
			//cout << TxtPoint.x << "," << TxtPoint.y << "," << TxtPoint.z << endl;
		}
	}
	else {
		cout << "Reading txt data failed!" << endl;
	}


	number_Txt = m_vTxtPoints.size();
	pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZRGB>);


	// Fill in the cloud data  
	cloud->width = number_Txt;
	cloud->height = 1;
	cloud->is_dense = false;
	cloud->points.resize(cloud->width * cloud->height);


	for (size_t i = 0; i < cloud->points.size(); ++i)
	{
		cloud->points[i].x = m_vTxtPoints[i].x;
		cloud->points[i].y = m_vTxtPoints[i].y;
		cloud->points[i].z = m_vTxtPoints[i].z;
		// pack r/g/b into rgb
		uint8_t r = m_vTxtPoints[i].r, g = m_vTxtPoints[i].g, b = m_vTxtPoints[i].b;
		uint32_t rgb = ((uint32_t)r << 16 | (uint32_t)g << 8 | (uint32_t)b);
		cloud->points[i].rgb = *reinterpret_cast<float*>(&rgb);
	}
	//pcl::PCLPointCloud2::Ptr cloud (new pcl::PCLPointCloud2 ());
	pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud_filtered(new pcl::PointCloud<pcl::PointXYZRGB>);


	std::cerr << "PointCloud before filtering: " << cloud->width * cloud->height
		<< " data points (" << pcl::getFieldsList(*cloud) << ")." << endl;

	// Create the filtering object
	pcl::VoxelGrid<pcl::PointXYZRGB> sor;
	sor.setInputCloud(cloud);
	sor.setLeafSize(0.5f, 0.5f, 0.5f);
	sor.filter(*cloud_filtered);

	std::cerr << "PointCloud after filtering: " << cloud_filtered->width * cloud_filtered->height
		<< " data points (" << pcl::getFieldsList(*cloud_filtered) << ")." << endl;

	write2txt(filtered_filename, cloud_filtered);
	//system("pause");
	return (1);
}

