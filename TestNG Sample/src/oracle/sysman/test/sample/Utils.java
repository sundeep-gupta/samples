package oracle.sysman.test.sample;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

public class Utils {
	/**
	 * Basic implementaton of the perl wrapper. This method takes the script
	 * to be run, with its parameters as argument and runs it as perl program.
	 * 
	 *  It then returns the STDOUT output as String.
	 * 
	 * There is lot scope to enhance this utility method. The better option
	 * is to have a separate PerlExecutor class using builder pattern.
	 * 
	 * @param args
	 * @return
	 * @throws IOException
	 */
	public static String executePerl(String args) throws IOException {
		String line;
		Process p = Runtime.getRuntime().exec("perl " + args);
		BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));
		StringBuilder output = new StringBuilder();
		while ((line = input.readLine()) != null) {
			output.append(line);
		}
		return output.toString();
	}

	/**
	 * Basic implementation of how filename extension abstraction can be achieved
	 * in testng framework
	 * 
	 * @param abstractName binary without extension.
	 * @return actual file name with extension if found, else returns the same abstractName
	 * 
	 */
	public static String getBinary(String abstractName) {
		if (System.getProperty("os.family").equals("Win32")) {
			if (new File(abstractName + ".exe").canExecute()) {
				return abstractName + ".exe";
			}
			if (new File(abstractName + ".bat").canExecute()) {
				return abstractName + ".bat";
			}
		}
		else {
			if (new File(abstractName + ".sh").canExecute()) {
				return abstractName + ".sh";
			}
		}
		return abstractName;
	}
}
