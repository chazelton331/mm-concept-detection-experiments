package gr.iti.mklab.detector.updateTrainingParams;


import java.io.IOException;

import smal.smalDetector;

import com.mathworks.extern.java.MWStructArray;
import com.mathworks.toolbox.javabuilder.MWArray;
import com.mathworks.toolbox.javabuilder.MWException;
import com.mathworks.toolbox.javabuilder.MWNumericArray;

public class UpdateParameters {



	static smalDetector smal = null;
	static Object[] parameters = null;

	static MWStructArray updateParams = null;
	static MWNumericArray MWuutrain = null;


	static double[][] ddtrain;
	static double[][] uutrain;
	static double[][] bins_out;
	static double[][] uu1;
	static double[][] jj;
	static double[][] trainLabels;


	public static double[][] ComputeConceptDetector(double[][] vlVector) throws IOException{

		try {
			smal = new smalDetector();

			/**
			 * update the parameters, which are necessary to implement SMaL.
			 * We run this process when we want to add new training samples
			 * or concepts.
			 * Input: 
			 * feature space: vlad vector matrix of new samples
			 * filaname: a folder name to same the updated parameters. The name of
			 * the .mat file containing the parameters is "twitter_training_params.mat"
			 * You can also use the parameters immediatly, taking the outputs of
			 * the matlab implementation.
			 * Output:
			 * ddtrain: eigenvalues  (optional)
			 * uutrain: eigenvectors
			 * bins_out, uu1, jj: parameters (optional)
			 * trainLabels: a matrix of nxc size, where n: the number of samples and c:the number of concepts (types) (optional)
			 */

			/*
			 * Initialize parameters
			 * import parameters in matlab methods
			 */
			String[] ParamsStructFieldsIncremental={"vtrain","file"};
			updateParams= new MWStructArray(1,1, ParamsStructFieldsIncremental);
			updateParams.set("vtrain",1,vlVector);
			updateParams.set("file",1,System.getProperty("user.dir")); // folder to save the "twitter_training_params.mat" file

			/*
			 * get the results
			 */

			parameters = smal.inremental(5, updateParams);

			/*
			 * the training eigenvector matrix is returned
			 */

			MWuutrain = (MWNumericArray)parameters[1];
			uutrain = (double[][]) MWuutrain.toArray(); 


			/*
			 * you can get the optional values bellow
			 * 
			 */
			MWNumericArray MWddtrain = (MWNumericArray)parameters[0];
			ddtrain = (double[][])MWddtrain.toArray();

			MWNumericArray MWbins_out = (MWNumericArray)parameters[2];
			bins_out = (double[][])MWbins_out.toArray();

			MWNumericArray MWuu1 = (MWNumericArray)parameters[3];
			uu1 = (double[][])MWuu1.toArray();

			MWNumericArray MWjj = (MWNumericArray)parameters[4];
			jj = (double[][])MWjj.toArray();

			MWNumericArray MWtrainLabels = (MWNumericArray)parameters[5];
			trainLabels = (double[][])MWtrainLabels.toArray();


		} catch (MWException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			// free native resources
			smal.dispose();
			MWArray.disposeArray(updateParams);
			MWArray.disposeArray(parameters);
			MWArray.disposeArray(MWuutrain);
			MWArray.disposeArray(uutrain);
			MWArray.disposeArray(ddtrain);
			MWArray.disposeArray(bins_out);
			MWArray.disposeArray(uu1);
			MWArray.disposeArray(jj);
			MWArray.disposeArray(trainLabels);
		}
		return uutrain;

	}



}
