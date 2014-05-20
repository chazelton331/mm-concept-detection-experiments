package gr.iti.mklab.detector.utilIOmat;

import java.io.File;
import java.io.IOException;

import com.jmatio.io.MatFileReader;
import com.jmatio.types.MLDouble;
import com.jmatio.types.MLStructure;

public class IOUtil {

	/**
	 * the training eigenvalues array, size 500x500
	 */
	public static double[][] ddtrain; 
	/**
	 * the training eigenvectors table, size nx500
	 */
	public static double[][] uutrain; 
	/**
	 * number of bins (def. 50) used to build the histogram of distribution p{x}, size 50x500
	 */
	public static double[][] bins_out; 
	/**
	 * the eigenfunctions array, used for interpolate all data to compute the eigenvectors, size 50x500
	 */
	public static double[][] uu1; 
	/**
	 * number of  dimensions of best eigenfunctions to compute the top-k (500) eigenvectors, size 500x1
	 */
	public static double[] jj; //
	/**
	 *  groundtruth for training set, size nxnClasses (ex. ~14000x6)
	 */
	public static double[][] trainLabels; //
	
	public static double[][] testLabels; //
	
	
	public IOUtil(double[][] ddtrain,double[][] uutrain,double[][] bins_out,double[][] uu1,double[] jj,double[][] trainLabels,double[][] testLabels) {
		this.ddtrain = ddtrain;
		this.uutrain = uutrain;
		this.bins_out = bins_out;
		this.uu1 = uu1;
		this.jj = jj;
		this.trainLabels = trainLabels;
		this.testLabels = testLabels;
	}	


	public static IOUtil readingMatlabFile(String matlabFile) throws IOException{


		//array name
		File file = new File(matlabFile);
		MatFileReader reader = new MatFileReader( file );

		//read array form file
		MLStructure mlArrayRetrived = (MLStructure)reader.getMLArray( "param" );

		// take the arrays from matlab structure
		MLDouble mlddtrain = (MLDouble)mlArrayRetrived.getField("ddtrain");
		MLDouble mluutrain = (MLDouble)mlArrayRetrived.getField("uutrain");
		MLDouble mlbins_out = (MLDouble)mlArrayRetrived.getField("bins_out");
		MLDouble mluu1 = (MLDouble)mlArrayRetrived.getField("uu1");
		MLDouble mljj = (MLDouble)mlArrayRetrived.getField("jj");
		MLDouble mltrainLabels = (MLDouble)mlArrayRetrived.getField("trainLabels");
		
		/*
		 * only for validation purposes
		 */
		
//		MLDouble mltestLabels = (MLDouble)mlArrayRetrived.getField("testLabels");


		/**
		 * convert from MLDouble to Double
		 */
		// ddtrain
		ddtrain = new double[mlddtrain.getM()][mlddtrain.getN()];
		ddtrain = mlddtrain.getArray();

		// uutrain
		uutrain = new double[mluutrain.getM()][mluutrain.getN()];
		uutrain= mluutrain.getArray();


		// bins_out
		bins_out = new double[mlbins_out.getM()][mlbins_out.getN()];
		bins_out= mlbins_out.getArray();


		// uu1
		uu1 = new double[mluu1.getM()][mluu1.getN()];
		uu1= mluu1.getArray();


		// jj
		jj = new double[mljj.getSize()];
		for (int i=0; i<jj.length;i++){
			jj[i] = mljj.get(i);
			//			System.out.println(String.valueOf(jj[i]));
		}

		trainLabels = new double[mltrainLabels.getM()][mltrainLabels.getN()];
		trainLabels=  mltrainLabels.getArray();
		
		/*
		 * only for validation purposes
		 */
//		testLabels = new double[mltestLabels.getM()][mltestLabels.getN()];
//		testLabels=  mltestLabels.getArray();
		
		testLabels = null;

//		for (int i=0; i<mltrainLabels.getM();i++){
//			for(int j=0;j<mltrainLabels.getN();j++){
//
//				System.out.print(String.valueOf(trainLabels[i][j])+" ");
//
//			}
//			System.out.println();
//		}

		return new IOUtil(ddtrain,uutrain,bins_out,uu1,jj,trainLabels,testLabels);

	}

	public double[][] getddtrain(){
		return ddtrain;
	}
	
	public double[][] getuutrain(){
		return uutrain;
	}
	
	public double[][] getbins_out(){
		return bins_out;
	}
	
	public double[][] getuu1(){
		return uu1;
	}
	
	public double[] getjj(){
		return jj;
	}
	
	public double[][] gettrainLabels(){
		return trainLabels;
	}
	
	public double[][] gettestLabels(){
		return testLabels;
	}
	
}
