#pragma once
namespace CudaStudy{
    void convertToGrey(const unsigned char *h_origImg, unsigned char *h_resultImg, int height, int width, int channels);
}