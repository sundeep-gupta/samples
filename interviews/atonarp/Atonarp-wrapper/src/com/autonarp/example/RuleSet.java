package com.autonarp.example;

import org.ini4j.Ini;
import java.io.*;

import java.util.*;
public class RuleSet {
	Map<String, Rule> rules = new HashMap<String, Rule>();
	public RuleSet(Ini ruleFile) throws Exception {
		for(String section : ruleFile.keySet()) {
			for(String key: ruleFile.get(section).keySet()) {
				String value = ruleFile.get(section, key);
				rules.put(section + "/" + key, new Rule(value));
			}
		}
	}
	public boolean isApplicable(Ini currentFile) {
		for (String sectionKey : rules.keySet() ) {
			String s = sectionKey.substring(0, sectionKey.indexOf("/"));
			String k = sectionKey.substring(sectionKey.indexOf("/") + 1, sectionKey.length());
			String currentValue = currentFile.get(s, k);
			boolean applicable = rules.get(sectionKey).isApplicable();
			if (!applicable) {
				return false;
			}
		}
		return true;
	}
	public void update(Ini currentFile) throws Exception  {
		for (String sectionKey : rules.keySet() ) {
			String s = sectionKey.substring(0, sectionKey.indexOf("/"));
			String k = sectionKey.substring(sectionKey.indexOf("/") + 1, sectionKey.length());
			try {
				double nextValue = rules.get(sectionKey).nextValue();
				currentFile.put(s, k, String.format("%.2f", nextValue));
			}
			catch (Exception e) {
				System.err.println("Exception occured in nextValue" );
			}
			
			
		}	
	}
}
