#include <iostream>
#include <string>
#include <iostream>
#include <HW2/Fractal/julia_fractal.cuh>

#include <opencv2/core/core.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/videoio.hpp>

const int W = 512, H = 512, FRAMES = 60*20;

int main(int argc, char** argv){
    // open image file
    
    std::vector<cv::Mat> images;

    unsigned char* h_resultImg = new unsigned char[H*W*FRAMES];
    
    CudaStudy::juliaFractal(h_resultImg, H, W, FRAMES);
    for(int i=0;i<FRAMES;i++){
        int offset = W*H*i;
        
        cv::Mat tempResult(H, W, CV_8UC1);
        memcpy(tempResult.data, &h_resultImg[offset], W * H * sizeof(unsigned char));
        images.push_back(tempResult);
    }
    cv::VideoWriter videoWriter;
    videoWriter.open("Fractal.avi", cv::VideoWriter::fourcc('H', '2', '6', '4'), 
		60 , cv::Size(W, H), false);

    for(int i=0;i<FRAMES;i++){
        videoWriter<<images[i];
    }
    std::cout<<"Writing Sucessful"<<std::endl;
    return 0;
}