package gr.iti.mklab.detector.featureExtraction;


import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import gr.iti.mklab.visual.utilities.Normalization;
import gr.iti.mklab.visual.dimreduction.PCA;
import gr.iti.mklab.visual.aggregation.*;

import gr.iti.mklab.detector.utilIOmat.IOUtil;

/**
 * Create Spatial pyramids with 8 bins
 * as described in E. Mantziou, S. Papadopoulos, Y. Kompatsiaris. "Large-Scale Semi-Supervised Learning by Approximate
 * Laplacian Eigenmaps, VLAD and Pyramids". In Proceedings of WIA2MIS 2013, Paris, France.
 * 
 * @author lenaki_7
 *
 */

public class SpatialPyramids {
	
	private static PCA PCA;
	private static final int codebooklength = 128;
	private static final int numCentroids = 64;
	private static final int descriptorlength = 128; //sift=128, RGBSift=384, Surf=64
	private static int numPrincipalComponents =1024; //vector dimension by applying pca 
	private static int vectorLength =8* descriptorlength*numCentroids; //8 bins of pyramid vector
	private static VladAggregator VLAD;
	
	
	/**
	 * Transforms a set of descriptors into a vector
	 */
	public double[] transformToVector(double[][] descriptors) throws Exception {
		// next the descriptors are aggregated
		double[] vladVector = VLAD.aggregate(descriptors);
		return vladVector;
	}
	
	public SpatialPyramids(String codebookFileName) throws Exception {

		// initialize the VLAD object
		if (codebookFileName != null) {
			double[][] codebook = AbstractFeatureAggregator.readQuantizer(codebookFileName, numCentroids, codebooklength);
			VLAD = new VladAggregator(codebook);
		}
	}
	
	
	public static double[] pyramids(String filename, String codebookFileName) throws Exception{
	
		double power = 0.5;
		/**
		 * Compute pyramids and doing PCA @  initial SIFT 
		 * 
		 */
		boolean pcaAtSift = false;
		ReadSpatialPyramids vecResult = ReadSpatialPyramids.ReadPyramids(filename, codebookFileName,pcaAtSift);
		
		double[] vector1 = vecResult.getvector1();
		double[] vector2 = vecResult.getvector2();
		double[] vector3 = vecResult.getvector3();
		double[] vector4 = vecResult.getvector4();
		double[] vector5 = vecResult.getvector5();
		double[] vector6 = vecResult.getvector6();
		double[] vector7 = vecResult.getvector7();
		double[] vector8 = vecResult.getvector8();
		
		
		/**
		 * Normalize after VLAD encoding
		 * 
		 */
//		vector1 = Normalization.normalizePower(vector1, power);
//		vector2 = Normalization.normalizePower(vector2, power);
//		vector3 = Normalization.normalizePower(vector3, power);
//		vector4 = Normalization.normalizePower(vector4, power);
//		vector5 = Normalization.normalizePower(vector5, power);
//		vector6 = Normalization.normalizePower(vector6, power);
//		vector7 = Normalization.normalizePower(vector7, power);
//		vector8 = Normalization.normalizePower(vector8, power);
		
		
		vector1 = Normalization.normalizeL2(vector1);
		vector2 = Normalization.normalizeL2(vector2);
		vector3 = Normalization.normalizeL2(vector3);
		vector4 = Normalization.normalizeL2(vector4);
		vector5 = Normalization.normalizeL2(vector5);
		vector6 = Normalization.normalizeL2(vector6);
		vector7 = Normalization.normalizeL2(vector7);
		vector8 = Normalization.normalizeL2(vector8);

		
		/**
		 * Concatenate All the pyramids 
		 * to extract final Vector
		 * Standard Step
		 */

		double[] finalVector=ReadSpatialPyramids.concat(vector1, vector2, vector3, vector4, vector5, vector6, vector7, vector8);
		finalVector =Normalization.normalizePower(finalVector, power);
		finalVector =Normalization.normalizeL2(finalVector);

		return finalVector;
		
	}
	
	
	 public static void prepareSIFTVLADPyramidsFeatures(String idListFile, String directory, String projectionFile, String codebookFileName, String outputFeatureFile) throws Exception {

	    	BufferedWriter writer = new BufferedWriter(new FileWriter(outputFeatureFile));
	    	List<String> ids = IOUtil.readFileToStringList(idListFile); 
		    if (ids == null) {
		    	System.out.println("Either dir does not exist or is not a directory");
		    } else {
		    	System.out.println("vlad calculation started!");
				long start = System.currentTimeMillis();
				
				if(numPrincipalComponents<descriptorlength){
					vectorLength = descriptorlength;
				}
				PCA = new PCA(numPrincipalComponents, 1, vectorLength);
			    PCA.loadPCAFromFile(projectionFile);
			    
		    	for (int i=0; i<ids.size(); i++) {
		    		System.out.println(i);
		            String filename = directory + ids.get(i) + ".bin"; //folder of saved descriptors
        
		            /**
		             * Do SPATIAL PYRAMIDS
		             */
		            double[] vladVector = SpatialPyramids.pyramids(filename, codebookFileName);
		            
		          
		            double[] pcaReducedVector = PCA.sampleToEigenSpace(vladVector);
					pcaReducedVector = Normalization.normalizeL2(pcaReducedVector);
					
		            writer.append(ids.get(i));
		            writer.append("\t");
		            for (int x = 0; x < vladVector.length; x++) {
		            	writer.append("\t" + String.valueOf(vladVector[x]));
		            	//System.out.print(String.valueOf(vladVector[x])+"  ");
		            }
		            //System.out.println();
		            writer.newLine();
		         }
		      	writer.close();
		    	System.out.println("ok");
		    	long end = System.currentTimeMillis();
				System.out.println("vlad calculation and write to file completed in " + (end - start) + " ms");
		    }
		    	
	    }
	 	 
		public static PCA getPCA(){
			return PCA;
		}
		
		public static int getnumPrincipalComponents(){
			return numPrincipalComponents;
		}
	 	 
		/**
		 * @param args
		 * @throws Exception
		 */
		public static void main(String[] args) throws Exception {	 
			/**
			 * train paramaters
			 */
			String idListFile =  "ImagesIds.txt";
			String codebookFileName = "codebook.txt";
			String directory = "/lmantziou/images/";			
			String projectionFile = "projection_pyramids_5000_"+numPrincipalComponents+".txt";
			String outputFile = "sift"+"_dense_VLAD_pyramids_pca_at_"+numPrincipalComponents+".txt";
			
	    	try {
	    		prepareSIFTVLADPyramidsFeatures(idListFile, directory,projectionFile, codebookFileName, outputFile);	    		
		    } catch (IOException e){
		    	e.printStackTrace();
		    }
		}	
}
		
	
	
	
