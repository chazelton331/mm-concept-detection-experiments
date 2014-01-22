package gr.iti.mklab.detector.featureExtraction;

import gr.iti.mklab.detector.examples.ReadFileToStringList;
import gr.iti.mklab.visual.aggregation.VladAggregatorMultipleVocabularies;
import gr.iti.mklab.visual.dimreduction.PCA;
import gr.iti.mklab.visual.extraction.AbstractFeatureExtractor;
import gr.iti.mklab.visual.extraction.SURFExtractor;
import gr.iti.mklab.visual.vectorization.ImageVectorization;
import gr.iti.mklab.visual.vectorization.ImageVectorizationResult;


import gr.iti.mklab.visual.utilities.Normalization;
import gr.iti.mklab.visual.utilities.Result;

import java.io.File;
import java.util.ArrayList;
import java.util.List;



public class SurfExtraction {


	public static double[][] featureExtraction(File imageFolder,String idfile ) throws Exception{
		// parameters
		int maxNumPixels = 1000000; // use 1024*768 for better/slower extraction
		//		int[] numCentroids = {128, 128, 128, 128};

		int[] numCentroids = {128,128,128,128};

		//		int initialLength = numCentroids.length * numCentroids[0] * AbstractFeatureExtractor.SURFLength;

		int initialLength = numCentroids.length * numCentroids[0] * AbstractFeatureExtractor.SURFLength;

		int targetLengthMax = 1024;


		String learningFolder = "\\\\iti-195/smal/dataset/codebookfiles/";


		String[] codebookFiles = { 
				learningFolder + "surf_l2_128c_0.csv",
				learningFolder + "surf_l2_128c_1.csv", 
				learningFolder + "surf_l2_128c_2.csv",
				learningFolder + "surf_l2_128c_3.csv" 
		};

		System.out.println("Codebook files loaded!");

		String pcaFile = learningFolder +"pca_surf_4x128_32768to1024.txt"; //need to be changed


		ImageVectorization.setFeatureExtractor(new SURFExtractor());
		ImageVectorization.setVladAggregator(new VladAggregatorMultipleVocabularies(codebookFiles,
				numCentroids, AbstractFeatureExtractor.SURFLength));
		if (targetLengthMax < initialLength) {
			PCA pca = new PCA(targetLengthMax, 1, initialLength, true);
			pca.loadPCAFromFile(pcaFile);
			ImageVectorization.setPcaProjector(pca);
		}
		System.out.println("PCA loaded!");

		
		List<String> ids = ReadFileToStringList.readFileToStringList(idfile); 
		double[][] surf = new double[ids.size()][targetLengthMax];
		
		for (int i=0; i<ids.size(); i++) {
			System.out.println(i);

			String imageFilename =  ids.get(i)+".jpg";


			ImageVectorization imvec = new ImageVectorization(imageFolder.toString()+"/", imageFilename, targetLengthMax, maxNumPixels);

			ImageVectorizationResult imvr = imvec.call();
			double[] vector = imvr.getImageVector();
			//add list add(vector);

			
		    for(int j=0; j<vector.length;j++) {
		    	surf[i][j] = vector[j];
		    }
			
		}

		return surf;

	}

}
