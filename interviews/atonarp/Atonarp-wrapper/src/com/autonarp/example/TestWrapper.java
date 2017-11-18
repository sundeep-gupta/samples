package com.autonarp.example;
import java.io.*;

import org.ini4j.Ini;
import org.ini4j.Profile;
import org.ini4j.InvalidFileFormatException;

public class TestWrapper {
	File inputConfigFile = null;
	File ruleFile = null;
		
	public static void main(String... args) throws Exception {
		/*

		if (args.length != 2) {
			System.err.println("The program requires two inputs :\n1. The rules file.\n2. The input config file.");
		}
		String ruleFile = args[0];
		String configFile = args[1];
		*/
		String ruleFile = "D:/input/test_wrapper.cfg";
		String configFile = "D:/input/test.cfg";
		TestWrapper wp = new TestWrapper(ruleFile, configFile);
		wp.generateConfigFiles();
		wp.runTestFiles();
	}
	private void runTestFiles() {
		// TODO Auto-generated method stub
		
	}
	public TestWrapper(String ruleFile, String configFile) throws Exception {
		this.inputConfigFile = new File(configFile);
		if (!inputConfigFile.exists()) {
			throw new FileNotFoundException("File " + configFile + " does not exist!");
		}
		this.ruleFile = new File(ruleFile);
		if (!this.ruleFile.exists()) {
			throw new FileNotFoundException("File " + ruleFile + " does not exist!");
		}
		validateContent();
	}
	
	private void validateContent() throws Exception {
		Ini configIni = new Ini(this.inputConfigFile);
		Ini ruleIni = new Ini(this.ruleFile);
		// if ruleIni contains a section which is not defined in the inputConfi .. throw exception
		for(String section : ruleIni.keySet()) {
			Profile.Section inputFileSection = configIni.get(section);
			if (inputFileSection == null) {
				throw new Exception("Validation failed: Section " + section + " is not defined in the input config file.");
			}
			// validate keys
			for(String ruleKey: ruleIni.get(section).keySet()) {
				if (!inputFileSection.containsKey(ruleKey)) {
					throw new Exception("Validation failed: Input key " + ruleKey + " does not exist in input config file.");
				}
			}
		}
	}
	
	private void generateConfigFiles() throws Exception {
		RuleSet ruleSet = new RuleSet(new Ini(this.ruleFile));
		Ini currentFile = new Ini(this.inputConfigFile);
		int index = 0;
		System.out.println("Calling isApplicable");
		while (ruleSet.isApplicable(currentFile)) {
			ruleSet.update(currentFile);
			System.out.print("Creating " + index);
			currentFile.store(new File("D:/output/input-file-" + index + ".cfg"));
			index++;
		}
		
	}
}
