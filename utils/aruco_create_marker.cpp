/*****************************
Copyright 2011 Rafael Muñoz Salinas. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are
permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice, this list of
      conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice, this list
      of conditions and the following disclaimer in the documentation and/or other materials
      provided with the distribution.

THIS SOFTWARE IS PROVIDED BY Rafael Muñoz Salinas ''AS IS'' AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Rafael Muñoz Salinas OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those of the
authors and should not be interpreted as representing official policies, either expressed
or implied, of Rafael Muñoz Salinas.
********************************/
#include <opencv2/opencv.hpp>
#include <iostream>
#include <aruco/aruco.h>
#include <aruco/arucofidmarkers.h>
using namespace cv;
using namespace std;
 
int main(int argc,char **argv)
{
try{
  if (argc!=4 && argc != 7){
    
    //You can also use ids 2000-2007 but it is not safe since there are a lot of false positives.
    cerr<<"Usage: <makerid(0:1023)> outfile.jpg sizeInPixels"<<endl;
    return -1;
  } 
  Mat marker=aruco::FiducidalMarkers::createMarkerImage(atoi(argv[1]),atoi(argv[3]));
  if(argc == 4)
    cv::imwrite(argv[2],marker);
  else if(argc == 7)
  {
    Mat3b marker_colored(marker.rows, marker.cols);
    for(int i = 0; i < marker.rows; i++)
    {
      for(int j = 0; j < marker.cols; j++)
      {
        if(marker.at<uint8_t>(i,j))
        {
          marker_colored(i,j)[0] = 255;
          marker_colored(i,j)[1] = 255;
          marker_colored(i,j)[2] = 255;
        } 
        else
        {
          marker_colored(i,j)[0] = atoi(argv[6]);
          marker_colored(i,j)[1] = atoi(argv[5]);
          marker_colored(i,j)[2] = atoi(argv[4]);
        }
      }
    }
    cv::imwrite(argv[2], marker_colored);
  }

}
catch(std::exception &ex)
{
    cout<<ex.what()<<endl;
}

}

