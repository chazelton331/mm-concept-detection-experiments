package gr.iti.mklab.detector.examples;

import gr.iti.mklab.detector.featureExtraction.SurfExtraction;
import gr.iti.mklab.detector.smal.Detector;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;


public class Example {

	public static void main(String[] args) throws Exception {

		
					
		
		File imageFolder = new File("D:/lena/Datasets/Yahoo Grand Challenge/images/train");
		String idfile = "testImageIds.txt";

		System.out.println("Start Feature Extraction");
		double[][] descriptors = SurfExtraction.featureExtraction(imageFolder, idfile );


		//		for (int row = 0; row < descriptor.length; row++) {
		//	        for (int column = 0; column < descriptor[row].length; column++) {
		//	            System.out.print(descriptor[row][column] + " ");
		//	        }
		//	        System.out.println();
		//	    }

		System.out.println("Classify images");
		double[][] con = Detector.ComputeConceptDetector(descriptors);


		double[] concepts = new double[con.length];

		for(int i=0; i<con.length;i++) {
			concepts[i] = con[i][0];
		}

		for (int j=0;j<con.length;j++){
			System.out.println(concepts[j]);
		}

		//		IOUtil matStructure = IOUtil.readingMatlabFile();

		//		matStructure.gettestLabels();

	}

}