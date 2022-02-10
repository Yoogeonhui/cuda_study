#include <iostream>
#include <string>

#include <opencv2/core/core.hpp>
#include <opencv2/opencv.hpp>

void Usage(char prog_name[])
{
    std::cerr<<"Usage: "<<prog_name <<" <image file path>\n";
    exit(EXIT_FAILURE);
}

int main(int argc, char** argv){
    if (argc != 2) {
        Usage(argv[0]);
    }

    std::string file_name(argv[1]);
    int width, height, channels;
    unsigned char* h_origImg, * h_resultImg;
    // open image file
    cv::Mat origImg = cv::imread(file_name);

    width = origImg.cols;
    height = origImg.rows;
    channels = origImg.channels();
    return 0;
}