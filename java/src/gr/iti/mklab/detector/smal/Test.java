package gr.iti.mklab.detector.smal;



import gr.iti.mklab.detector.utilIOmat.IOUtil;
import java.io.File;
import java.io.IOException;

import com.jmatio.io.MatFileReader;

import com.jmatio.types.MLDouble;
import com.jmatio.types.MLStructure;



public class Test extends IOUtil {



	public static void main(String[] args)  throws IOException {

		
	//	readingMatlabFile();
		
		
//		//array name
		File file = new File("twitter_training_params.mat");
		MatFileReader reader = new MatFileReader( file );

//		MLArray mlArray = reader.getMLArray( "param" );
//
//		//        List<MLArray> towrite =  Arrays.asList( mlArray );
//
//        //read array form file
//       
        MLStructure mlArrayRetrived = (MLStructure)reader.getMLArray( "param" );
//              
//        
        MLDouble j = (MLDouble)mlArrayRetrived.getField("jj");
//        
//        
        double x[] = new double[j.getSize()];
//        
        for (int i=0; i<x.length;i++){
        	x[i] = j.get(i);
        	System.out.println(String.valueOf(x[i]));
        }
        
//        System.out.println(mlArrayRetrived.getField("jj"));
        

		

        

	}
}
