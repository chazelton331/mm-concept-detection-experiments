mm-concept-detection-experiments
================================

###A framework for various multimedia concept detection experiments from social networks.




We make available a dataset of Flickr [1a] and Twitter [1b] images and a set of Matlab and Java scripts that enable the multimedia detection. More specifically, from the datasets users may extract SIFT/color-SIFT descriptos (Dense sampling) with VLAD encoding and can reduce their dimensionality by PCA. Then, the descriptors are used to compute the eigenfunctions and top-k eigenvalues [4]. Approximate Laplacian Eigenmaps are derived improving the time complexity. Finally, these Laplacian Eigenmaps are used as new feature vectors to a classifier. The prediction scores are ranked according to various accuracy metrics (ex. mean Average Precision, AUC curves, F1-score etc.) 

are ranked and presented to the user in accordance to three factors; stability, persistence and community centrality. The user can browse through these communities in which the users are also ranked in accordance to their own specific snapshot centrality. The PageRank algorithm [3] is used to measure the feature of centrality.

* The master branch of this repository contains ongoing matlab and java files which form the current stable version of the framework. 

[1] Datasets collected using a set of manually selected groups [1a] or hashtags[1b]. Datasets are password protected (password: socialsensor). 
[1a] http://www.socialsensor.eu/datasets/mm-concept-detection-dataset-2013/mm-concept-detection-datasets.zip
_Alternatively_, users can use the _"flickr2013-image-urls.txt"_ file to download the Flickr dataset from the Urls.
[1b] http://www.socialsensor.eu/datasets/mm-concept-detection-dataset-2013/mm-concept-detection-twitter2013-images.zip	
[2] E. Mantziou, S. Papadopoulos, Y. Kompatsiaris. "Large-Scale Semi-Supervised Learning by Approximate Laplacian Eigenmaps, VLAD and Pyramids". In Proceedings of WIA2MIS 2013, Paris, France.  
[3] E. Mantziou, S. Papadopoulos, Y. Kompatsiaris. "Scalable Training with Approximate Incremental Laplacian Eigenmaps and PCA". In Proceedings of ACM Yahoo Grand Challenge 2013, ACM Multimedia MM'13, Barcelona, Spain.
[4] R. Fergus and Y. Weiss. "Semi-supervised Learning in Gigantic Image Collections". Neural Information Processing Systems (NIPS), 2009.
