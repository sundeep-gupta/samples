package com.atonarp.example;
import java.io.*;
import java.util.Properties;
import java.util.SortedMap;
import java.util.*;
import static java.lang.Math.log;
public class LinearInterpolate {
	File dataFile;
	SortedMap<Double, Double> data = new TreeMap<Double, Double>();
	public LinearInterpolate(String dataFileName) throws Exception {
		dataFile = new File(dataFileName);
		
		Properties properties = new Properties();
		properties.load(new FileInputStream(dataFile));
		
		for(Object p : properties.keySet()) {    
			Double x = Double.parseDouble((String) p);
			Double y = Double.parseDouble(properties.getProperty((String)p));
			data.put(x, y);
		}
	}

	
	private Double getValueAt(Double x) {
		Double x0 = getClosestLower(x);
		Double x1 = getClosestUpper(x);
		System.out.printf("Finding values between %.3f and %.3f\n", x0, x1);

		Double y0 = data.get(x0);
		Double y1 = data.get(x1);
		System.out.printf("x0 = %.3f, y0 = %.3f\n", x0, y0);
		System.out.printf("x1 = %.3f, y1 = %.3f\n", x1, y1);
		Double y = y0 + ((x - x0) * (y1- y0) / (x1 - x0));
		System.out.printf("For x = %.3f, y = %.3f\n",  x, y);
		return y;
	}
	private Double getLogValueAt(Double x) {
		Double x0 = getClosestLower(x);
		Double x1 = getClosestUpper(x);
		System.out.printf("Finding values between %.3f and %.3f\n", x0, x1);

		Double y0 = data.get(x0);
		Double y1 = data.get(x1);
		System.out.printf("x0 = %.3f, y0 = %.3f\n", x0, y0);
		System.out.printf("x1 = %.3f, y1 = %.3f\n", x1, y1);
		Double logy = log(y0) + ((log(y1) - log(y0)) * (x - x0) / (x1 - x0));
		Double y = Math.pow(Math.E, logy);
		System.out.printf("For x = %.3f, y = %.3f\n",  x, y);
		return y;
	}
	
	private Double getClosestLower(Double x) {
		Double lowest = -1.0;
		for(Double xi : data.keySet()) {
			if (xi <= x) {
				lowest = xi;
			}
			else {
				break;
			}
		}
		
		return lowest;
	}
	

	private Double getClosestUpper(Double x) {
		Double higher = -1.0;
		for(Double xi : data.keySet()) {
			if (higher <= xi) {
				higher = xi;
			}
			if (higher > x) {
				break;
			}
			System.out.println(higher);
		}
		return higher;
	}
	public static void main(String...strings) throws Exception {
		Double x = 3.0;
		String poDoublesFile = "D:/input/linear-data.properties";
		LinearInterpolate li = new LinearInterpolate(poDoublesFile);
		li.getValueAt(x);
		li.getLogValueAt(x);
	}
}
