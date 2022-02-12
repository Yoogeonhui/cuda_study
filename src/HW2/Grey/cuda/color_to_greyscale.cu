#include <HW2/Grey/color_to_greyscale.cuh>
#include <stdio.h>
#include <cuda_runtime_api.h>

const int THREAD_SIZE = 16;

namespace CudaStudy{
    __global__ void cudaConvertToGrey(const unsigned char *h_cuda_origImg, unsigned char *h_cuda_resultImg, int height, int width){
        int h = blockDim.x * blockIdx.x + threadIdx.x;
        int w = blockDim.y * blockIdx.y + threadIdx.y;
        
        if(h>=height or w>=width) return;
        h_cuda_resultImg[h * width+w] = static_cast<unsigned char>(h_cuda_origImg[(h*width+w)*3] * 0.114 + h_cuda_origImg[(h*width+w)*3+1] * 0.587 + h_cuda_origImg[(h*width+w)*3+2] * 0.299);
        
    }

    void convertToGrey(const unsigned char *h_origImg, unsigned char *h_resultImg, int height, int width, int channels){
        unsigned char* h_cuda_origImg, *h_cuda_resultImg;
        cudaMalloc((void**)&h_cuda_origImg, width*height*channels * sizeof(unsigned char));
        cudaMalloc((void**)&h_cuda_resultImg, width*height*sizeof(unsigned char));
        cudaMemcpy(h_cuda_origImg, h_origImg, height*width*channels*sizeof(unsigned char), cudaMemcpyHostToDevice);

        dim3 grid((double)height/THREAD_SIZE, (double)width/THREAD_SIZE), threads(THREAD_SIZE,THREAD_SIZE);
        cudaConvertToGrey<<<grid, threads>>>(h_cuda_origImg, h_cuda_resultImg, height, width);
        cudaDeviceSynchronize();
        cudaMemcpy(h_resultImg, h_cuda_resultImg, height*width*sizeof(unsigned char), cudaMemcpyDeviceToHost);
        cudaFree(h_cuda_origImg);
        cudaFree(h_cuda_resultImg);
        return;
    }
}