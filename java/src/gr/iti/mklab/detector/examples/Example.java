package gr.iti.mklab.detector.examples;

import gr.iti.mklab.detector.featureExtraction.SurfExtraction;
import gr.iti.mklab.detector.smal.Detector;

import gr.iti.mklab.detector.utilIOmat.IOUtil;

import java.io.File;


public class Example {

	public static void main(String[] args) throws Exception {


		File imageFolder = new File("D:/lmantziou/Datasets/twitter2013/");
		String idfile = "testImageIds.txt";

		System.out.println("Start Feature Extraction");
		double[][] descriptor = SurfExtraction.featureExtraction(imageFolder, idfile );


		//		for (int row = 0; row < descriptor.length; row++) {
		//	        for (int column = 0; column < descriptor[row].length; column++) {
		//	            System.out.print(descriptor[row][column] + " ");
		//	        }
		//	        System.out.println();
		//	    }

		System.out.println("Classify images");
		double[][] con = Detector.ComputeConceptDetector(descriptor);


		double[] concept = new double[con.length];

		for(int i=0; i<con.length;i++) {
			concept[i] = con[i][0];
		}

		for (int j=0;j<con.length;j++){
			System.out.println(concept[j]);
		}

		//		IOUtil matStructure = IOUtil.readingMatlabFile();

		//		matStructure.gettestLabels();

	}

}