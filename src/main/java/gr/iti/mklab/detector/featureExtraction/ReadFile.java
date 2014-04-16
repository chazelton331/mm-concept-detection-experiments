package gr.iti.mklab.detector.featureExtraction;

import java.io.BufferedReader;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;


public class ReadFile {

	static int[][] coordinates;
	static double[][] sift;
	static int numVectors ;
	static int descriptorLength;
	
	/**
	 * ReadFile vectorFile reads a file which contains keypoints from an image with their coordinates 
	 * as have been extracted from colordescriptor exe
	 * 
	 * @param descriptor
	 * @param coordinates
	 * @param numVectors --> the number of keypoints/image
	 * @param descriptorLength  -->128 for sift, 64 for surf etc
	 */
	public ReadFile(double[][] descriptor, int[][] coordinates, int numVectors, int descriptorLength)  {

		this.coordinates = coordinates;
		this.sift = descriptor;
		this.numVectors = numVectors;
		this.descriptorLength = descriptorLength;
	}	
	
	
	public ReadFile(double[][] sift, int numVectors, int descriptorLength)  {

		this.sift = sift;
		this.numVectors = numVectors;
		this.descriptorLength = descriptorLength;
	}
	
	public double[][] getSift(){
		return sift;
	}
	public int[][] getCoordinates(){
		return coordinates;	
	}
	
	public int getnumVectors(){
		return numVectors;
	}
	
	public int getdescriptorLength(){
		return descriptorLength;
	}
		
	public static ReadFile vectorFile(String filename) throws IOException{	
		
		BufferedReader inArff = new BufferedReader(new FileReader(new File(filename)));

 		String[] numbers = new String[3];
		for (int i = 0; i < 3 ; i++) {
			numbers [i] =inArff.readLine();    
      	}

		numVectors = Integer.parseInt(numbers[2]);
		descriptorLength = Integer.parseInt(numbers[1]);
		String line = null;
		coordinates = new int[numVectors][2];
		sift = new double[numVectors][descriptorLength];
		
		int num = 0;
		while (( line = inArff.readLine())!=null)
		{
			int numCoord=0;
			String[] values = line.split(";");
			String part1 = values[1];
			String[] values1 = part1.trim().split(" ");
			String part0 = values[0];
			String[] tmp_coord = part0.split(" ");
		
			for (int j = 0; j < descriptorLength; j++) {		
				sift[num][j] = Double.parseDouble(values1[j]);
//				System.out.print(sift[a][j]+" ");	
			}
			
//			System.out.println();
				for(int k=1;k<3;k++){
					coordinates[num][numCoord] = Integer.parseInt(tmp_coord[k]);
					numCoord++;
				}
			num++;	
		}

		inArff.close();
		return new ReadFile(sift,coordinates,numVectors,descriptorLength);
	}
	
	

}
