Usage call '/caffe/DOME/demo.m' to run the demo and for more description of the arguments you will see in the deom.m files.
1. we put the trained model in GoogleCloud: 
https://drive.google.com/file/d/1ralkG_9f12mYMkl90UzwxOrsIpHrh406/view?usp=sharing. 
You should download it first, and then put it into the file '/caffe/DEMO'.

2. put your video frames and the optical flow in the '/caffe/DOME/IMG/' and '/caffe/DEMO/opp/', respectivel. Besides, the optical flow is computed using LDOF method.

3. the saliency maps will save in the folder: '/caffe/DEMO/Results/';


Note:Follow the official websites of the Caffe framework and install the whole toolbox (necessary Matlab wrappers). Besides, this software was developed under 64-bit ubuntu14.04 with Matlab R2014a. 

