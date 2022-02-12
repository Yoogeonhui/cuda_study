#include <HW2/Fractal/julia_fractal.cuh>
#include <cuda_runtime_api.h>
#include <cmath>

const double R = 2.0;
const int THREAD_SIZE = 16;
const int FRAME_SIZE = 4;
const int MAX_ITER = 256;

namespace CudaStudy{
    __global__ void getFractal(unsigned char* resVid, int height, int width, int frames){
        int frame = blockDim.z * blockIdx.z + threadIdx.z;
        int x = blockDim.x * blockIdx.x + threadIdx.x;
        int y = blockDim.y * blockIdx.y + threadIdx.y;
        if(frame>=frames or x>=height or y>=width) return;
        double zx = 4*(static_cast<double>(x) / height)-2;
        double zy = 4*(static_cast<double>(y) / width)-2;
        double frame_to_pi = 2 * M_PI * ((double)frame/frames);
        double cx = 0.7885 * sin(frame_to_pi);
        double cy = 0.7885 * cos(frame_to_pi);
        int iteration = 0;
        while(iteration < MAX_ITER and zx * zx + zy * zy < R*R){
            double xtemp = zx * zx - zy * zy;
            zy = 2 * zx * zy + cy;
            zx = xtemp + cx;
            iteration++;
        }
        int offset = frame*(width*height) + (x*width + y);
        resVid[offset] = (unsigned char)(iteration);
    }

    void juliaFractal(unsigned char *resVid, int height, int width, int frames){
        unsigned char *cudaVid;
        cudaMalloc((void**)&cudaVid, width * height * frames * sizeof(unsigned char));
        dim3 grid(ceil((double)height/THREAD_SIZE), ceil((double)width/THREAD_SIZE), ceil((double)frames/FRAME_SIZE)), thread(THREAD_SIZE, THREAD_SIZE, FRAME_SIZE);
        getFractal<<<grid, thread>>>(cudaVid, height, width, frames);
        cudaMemcpy(resVid, cudaVid, sizeof(unsigned char) * height * width * frames, cudaMemcpyDeviceToHost);
        cudaFree(cudaVid);
    }
}