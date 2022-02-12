#include <iostream>
#include <string>

#include <HW2/Grey/color_to_greyscale.cuh>

#include <opencv2/core/core.hpp>
#include <opencv2/opencv.hpp>

void Usage(char prog_name[])
{
    std::cerr<<"Usage: "<<prog_name<<" <image file path>\n";
    exit(EXIT_FAILURE);
}

int main(int argc, char** argv){
    if (argc != 2) {
        Usage(argv[0]);
    }

    std::string file_name(argv[1]);
    int width, height, channels;
    unsigned char *h_origImg, *h_resultImg;
    // open image file
    cv::Mat origImg = cv::imread(file_name);

    width = origImg.cols;
    height = origImg.rows;
    channels = origImg.channels();
    h_origImg = new unsigned char[height * width * channels];
    for(int i=0;i<height * width * channels;i++){
        h_origImg[i] = origImg.data[i];
    }
    h_resultImg = new unsigned char[width * height];
    
    CudaStudy::convertToGrey(h_origImg, h_resultImg, height, width, channels);
    cv::Mat resultImg(height, width, CV_8UC1);
    memcpy(resultImg.data, h_resultImg, width * height);

    for(int i=0;i<10;i++) std::cout<<(int)h_resultImg[i]<<std::endl;
    cv::imwrite("Grey"+file_name, resultImg);
    return 0;
}