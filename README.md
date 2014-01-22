mm-concept-detection-experiments
================================

###A framework (SMaL) for various multimedia concept detection experiments from social networks.

We make available a dataset of Flickr [1a] and Twitter [1b] images and a set of Matlab and Java scripts that enable the multimedia detection. More specifically, from the datasets users may extract SIFT/color-SIFT descriptos (Dense sampling) with VLAD encoding and can reduce their dimensionality by PCA. Then, the descriptors are used to compute the eigenfunctions and top-k eigenvalues [4]. Approximate Laplacian Eigenmaps are derived improving the time complexity. Finally, these Laplacian Eigenmaps are used as new feature vectors to a classifier [2]. Furthemore, if the test set is unknown user can use an Incremental method to combine both the training and test data and extract the Laplacian Eigenmaps [3]. The prediction scores are ranked according to various accuracy metrics (ex. mean Average Precision, AUC curves, F1-score etc.). 

* The master branch of this repository contains ongoing matlab and java files which form the current stable version of the framework. 

[1] Datasets collected using a set of manually selected groups [1a] or hashtags [1b]. Datasets are password protected (password: socialsensor).	 
[1a] http://www.socialsensor.eu/datasets/mm-concept-detection-dataset-2013/mm-concept-detection-datasets.zip	
[1b] http://www.socialsensor.eu/datasets/mm-concept-detection-dataset-2013/mm-concept-detection-twitter2013-images.zip	
[2] E. Mantziou, S. Papadopoulos, Y. Kompatsiaris. "Large-Scale Semi-Supervised Learning by Approximate Laplacian Eigenmaps, VLAD and Pyramids". In Proceedings of WIA2MIS 2013, Paris, France.  
[3] E. Mantziou, S. Papadopoulos, Y. Kompatsiaris. "Scalable Training with Approximate Incremental Laplacian Eigenmaps and PCA". In Proceedings of ACM Yahoo Grand Challenge 2013, ACM Multimedia MM'13, Barcelona, Spain.	
[4] R. Fergus and Y. Weiss. "Semi-supervised Learning in Gigantic Image Collections". Neural Information Processing Systems (NIPS), 2009.

##Distribution Information##
This distribution contains the following:  
* a readme.txt file with instructions on how to use the different parts of the framework;
* a set of Matlab scripts (in the /matlab folder) that are used to conduct SMaL.
* a set of java scripts (in the /java folder) that are used to conduct SMaL and a set of Java and Matlab scripts that are used to extract the features in a "Matlab friendly" form.


##SMaL using Matlab##

* Features	
Any new features to be analyzed should be placed in the _../results/features/"collectionFolder"_ [\*] folder. Preferably, feature data should be in matlab format (*.mat) of the form:	

				vec1 vec2 vec3.....vecn	
				
* Necessary Data	
Any data like groundtruth or lists refering to ids indeces to split a dataset of images should be place in _..results/data/"collectionFolder"_ [\*] folder. Preferably, these data should be in matlab format (*.mat). Groundtruth should be of the form:

				label_class1 label_class2 ......label_classn

[*] CollectionFolder should be a name given to a dataset. For example, for Flikcr dataset we have set the CollectionFolder as flick2013. 

* Results	
Any results should be place in _results/predictions_ folder	

###More Semantics for Running the Code###
The matlab code consists of 4 files which can work as standalone scripts and 4 folders which contains functions, which include algorithm scripts or scripts to run the Demos.   
These 4 files are:  
* <code>smalDemo.m</code>  
    This .m file extracts the SMaL framework by computing the Laplacian Eigenmaps for different features. 
* <code>smalDemoFusion.m</code>  
    This .m file extracts the SMaL framework by computing the Laplacian Eigenmaps and by fusioning them.  
* <code>smalIncrementalDemo.m</code>  
    This .m file extracts the SMaL framework by computing the training Laplacian Eigenmaps and then with Incremental method compute the test Laplacian Eigenmaps in batches for different features.
* <code>smalIncrementalDemoFusion.m</code>  
    This .m file extracts the SMaL framework by computing the training Laplacian Eigenmaps and then with Incremental method compute the test Laplacian Eigenmaps in batches by fusioning them.  

The 4 included folders  are:
* ale: implementation of  Approximate Laplacian Eigenmaps as described in [4].	
* gsf: implementation of Laplacian Eigenmaps by using Spectral Clustering. This Framework is known as _Graph Structure Features_, and is used in ImageCLEF2012 competition in photo Annotation task and as state-of-the-art in [2].	In this folder 2 .m files are included:
* <code>gsfDemo.m</code>  This .m file extracts the Laplacian Eigenmaps for different features
* <code>gsfFusionDemo.m</code>  This .m file extracts the Laplacian Eigenmaps by fusioning them. In order to run this .m file, users should first run the _gsfDemo_ file.	
* incremental: functions used in incremental computation 
* utility: general functions used many times in the procedure. 	

_Used Libraries_	
In order to make possible to run the aforementioned demos you must insert in matlab path the libraries bellow:

1. Liblinear - http://www.csie.ntu.edu.tw/~cjlin/liblinear/	
2. Libsvm - http://www.csie.ntu.edu.tw/~cjlin/libsvm/	
3. SocioDim - http://leitang.net/social_dimension.html	
4. vlFeat - http://www.vlfeat.org/	

###Matlab Results###
The final outcome from the aforementioned files is the prediction scores from each descriptor in _../results/predictions/"collectionFolder"/"nameOfDescriptor"/predictionScore\_ [num]split\_[num].mat_ 
and some accuracy metrics like mean Interpolated Average precision in
_../results/predictions/"collectionFolder"/"nameOfDescriptor"/mIAP.mat_. 
The results from fusionDemos are in
_../results/predictions/"collectionFolder"/Fusion/predictionScore\_[num]split\_[num].mat_ and _../results/predictions/"collectionFolder"/Fusion/mIAP.mat_. 
Finally, the results from IncrementalDemos are in _../results/predictions/"collectionFolder"/Incremental/"nameOfDescriptor"/predictionScore\_[num]split\_[num].mat_ 
and _../results/predictions/"collectionFolder"/Incremental/"nameOfDescriptor"/mIAP.mat_.	

In _../results/images_ users can include the images from a dataset in case they want to extract test results according to top-k precision of images/concept. Optionally, users can extract graphical statistics from the results.	



##SMaL using Java##
You can use the Example file to run a tutorial from SMaL writtern in Java. More specifically, we have implemented the above matlab code to java and read matlab files from java. You can only implement the incremental procedure [3].

* Features	
To extract features you need to configure in your build path the following code, available in github:

	           https://github.com/socialsensor/multimedia-indexing

With this code you can extract SURF and SIFT (from BoofCV) descriptors with VLAD encoding and reduce dimension of vector by applying PCA.

* Necessary Data	
The file _twitter\_\training\_\params.mat_ includes variables from twitter2013 dataset which are necessary to resume the incremental procedure.
You can upadate these variables by implementing the code below.


###More Semantics for Running the Code ###
The matlab code consists of 4 files which can work as standalone scripts and 4 folders which contains functions, which include algorithm scripts or scripts to run the Demos.   
These 4 files are:  
* <code>SurfExtraction</code>  
    <!-- This file extracts the SMaL framework by computing the Laplacian Eigenmaps for different features.  -->
* <code>Detector</code>  
    <!-- This file extracts the SMaL framework by computing the Laplacian Eigenmaps and by fusioning them.   -->
* <code>UpdateParameters</code>  
    <!-- This file extracts the SMaL framework by computing the training Laplacian Eigenmaps and then with Incremental method compute the test Laplacian Eigenmaps in batches for different features. -->
You can extract your statistics (Average Precision, 11-point Interpolated Precision) using the classes of the
<code>gr.iti.mklab.detector.statistics</code> package.

_Used Libraries_	
In order to make possible to run the aforementioned demos you must insert in matlab path the libraries bellow:

1. jamtio - http://sourceforge.net/projects/jmatio/	
2. javabuilder (matlab R2012a 7.17) - http://www.mathworks.com/products/compiler/mcr/
3. smal - 
	







