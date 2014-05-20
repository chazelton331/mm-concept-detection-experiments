package gr.iti.mklab.detector.examples;

import gr.iti.mklab.detector.smal.ConceptDetector;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class Example {

	public static void main(String[] args) throws Exception {

		
					
		ConceptDetector detector = new ConceptDetector("./src/main/resources/twitter_training_params.mat");
		//File imageFolder = new File("/home/manosetro/git/mm-concept-detection-experiments/images");
		//String idfile = "./testImageIds.txt";

		//System.out.println("Start Feature Extraction");
		//double[][] descriptors = SurfExtraction.featureExtraction(imageFolder, idfile);
		
		//writeVector(descriptors, "./descriptors.txt");
		
		double[][] descriptors = readVector("./descriptors.txt");
		System.out.println(descriptors.length + " x " + descriptors[0].length);
		
		System.out.println("Classify images");
		double[][] concepts = detector.detect(descriptors);

		for (int j=0;j<concepts.length;j++){
			System.out.println(concepts[j][0] + " : " + concepts[j][1]);
		}

		//		IOUtil matStructure = IOUtil.readingMatlabFile();

		//		matStructure.gettestLabels();

	}

	public static void writeVector(double[][] vector, String filename) throws IOException {

		  BufferedWriter writer = new BufferedWriter(new FileWriter(filename));

		  //              System.out.print("id "+ids.get(i)+" ");
		  for (int i = 0; i < vector.length; i++) {
		   for(int j=0; j<vector[0].length;j++){
		    writer.append(String.valueOf(vector[i][j])+"\t");
		   }  

		   writer.newLine();
		  }
		  writer.close();
		 }



		 public static double[][] readVector(String filename) throws NumberFormatException, IOException{


		  BufferedReader inArff = new BufferedReader(new FileReader(new File(filename)));


		  String line = null;

		  List<List<Double>> temp = new ArrayList<List<Double>>();
		  while (( line = inArff.readLine())!=null) {
		   		String[] values = line.split("\t");
		   		
		   		List<Double> descriptor = new ArrayList<Double>();
		   		for (int j = 0; j < values.length; j++) {  
		   			descriptor.add(Double.parseDouble(values[j]));
		   		}
		   		temp.add(descriptor); 
		  }

		  inArff.close();

		  double[][] descriptors = new double[temp.size()][];
		  int i = 0;
		  for(List<Double> desc : temp) {
			  descriptors[i] = new double[desc.size()];
			  int j=0;
			  for(double d : desc) {
				  descriptors[i][j++] = d;
			  }
			  i++;
		  }
		  return descriptors;
		 }
}