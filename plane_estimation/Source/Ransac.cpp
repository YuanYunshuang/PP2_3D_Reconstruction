#include "Ransac.h"

char* c = "..\\log.txt";
ofstream errorLog;

Ransac::Ransac()
{
}


Ransac::~Ransac()
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

void Ransac::write2txt(const char* filename, pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud) {

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

void Ransac::PlanesEstimation(const char* filename, const char* outputpath)
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
			TxtPoint.x = TxtPoint.x ;//- 548800.0
			TxtPoint.y = TxtPoint.y ;//- 5804500.0
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
	
	std::size_t pos1 = string(filename).find_last_of("/\\");
	std::size_t pos2 = string(filename).find_last_of(".");
	string name(string(filename).substr(pos1 + 1,pos2- pos1-1));
	string savepath = string(outputpath) + "\\" + name;
	string planeParams = savepath + "\\" + name + ".txt";
	mkdir(savepath.c_str());
	int count = 1;
	pcl::ModelCoefficients::Ptr model_coefficients(new pcl::ModelCoefficients);
	ofstream output(planeParams.c_str());

	int planes = 0;
	while (cloud->points.size() > number_Txt/2) {
		planes = planes + PlaneEstimation(cloud, count, model_coefficients, savepath.c_str());
		if (planes > 0) {
			output << std::fixed << std::setw(6) << name << " ";
			output << std::fixed << std::setprecision(4) << model_coefficients->values[0] << " ";
			output << std::fixed << std::setprecision(4) << model_coefficients->values[1] << " ";
			output << std::fixed << std::setprecision(4) << model_coefficients->values[2] << " ";
			output << std::fixed << std::setprecision(4) << model_coefficients->values[3] << endl;
			count++;
		}
		else {
			break;
		}
	}
	output.close();
	
}

int Ransac::PlaneEstimation(pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud, 
	int count, pcl::ModelCoefficients::Ptr model_coefficients,
	const char* outputpath) {
	// Create the segmentation object
	pcl::SACSegmentation<pcl::PointXYZRGB> seg;
	pcl::PointIndices::Ptr inliers(new pcl::PointIndices);
	// Optional
	seg.setOptimizeCoefficients(true);
	// Mandatory
	seg.setModelType(pcl::SACMODEL_PLANE);
	seg.setMethodType(pcl::SAC_RANSAC);
	seg.setDistanceThreshold(0.3);
	seg.setMaxIterations(400);
	//seg.setProbability(p);

	seg.setInputCloud(cloud);
	seg.segment(*inliers, *model_coefficients);

	if (inliers->indices.size() == 0)
	{
		PCL_ERROR("Could not estimate a planar model for the given dataset.");
		std::size_t pos = string(outputpath).find_last_of("/\\");
		string name(string(outputpath).substr(pos));
		errorLog << name << endl;
		return 0;
	}

	pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud_plane(new pcl::PointCloud<pcl::PointXYZRGB>);
	pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud_outliers(new pcl::PointCloud<pcl::PointXYZRGB>);
	// Extract the planar inliers from the input cloud  
	pcl::ExtractIndices<pcl::PointXYZRGB> extract;
	extract.setInputCloud(cloud);
	extract.setIndices(inliers);
	// Get the points associated with the planar surface  
	extract.filter(*cloud_plane);
	string fn = string(outputpath) + "\\plane" +to_string(count) + ".txt";
	write2txt(fn.c_str(), cloud_plane);

	extract.setNegative(true);
	//cloud->clear();
	extract.filter(*cloud_outliers);
	*cloud = *cloud_outliers;
	return 1;
}

