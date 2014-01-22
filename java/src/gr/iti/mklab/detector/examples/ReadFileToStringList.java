package gr.iti.mklab.detector.examples;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class ReadFileToStringList {
	
	
	public static List<String> readFileToStringList(String textFile){
		List<String> stringList = new ArrayList<String>();
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(
					new InputStreamReader(new FileInputStream(textFile), StringConstants.UTF8));
			String line = null;
			while ( (line = reader.readLine()) != null){
				stringList.add(line);
			}
			reader.close();
		} catch (IOException e){
			e.printStackTrace();
			if (reader != null){
				try {
					reader.close();
				} catch (IOException ex){
					ex.printStackTrace();
				}
			}
		}
		return stringList;
	}

	public class StringConstants {

		public static final String UTF8 = "UTF8";
	}

}
