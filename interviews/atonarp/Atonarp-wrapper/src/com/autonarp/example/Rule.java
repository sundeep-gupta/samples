package com.autonarp.example;

public class Rule {
	
	private double startValue;
	private double endValue;
	private double delta;
	private double currentValue;
	String operation = null;

	public Rule(String rulePattern) throws Exception {
		int hyphenAt = rulePattern.indexOf("-");
		int atAt = rulePattern.indexOf("@");
		int ampAt = rulePattern.indexOf("&");
		this.startValue = Double.parseDouble(rulePattern.substring(0, hyphenAt));
		this.endValue = Double.parseDouble(rulePattern.substring(hyphenAt + 1, atAt));
		this.currentValue = startValue;
		this.delta = Double.parseDouble(rulePattern.substring(atAt + 1, ampAt));
		this.operation = rulePattern.substring(ampAt + 1, rulePattern.length());
		if (!operation.equals("plus") && !"minus".equals(operation)) {
			throw new Exception("Rule creation failure. Invalid operatoin '" + operation + "'");
		}
	}
	
	public double nextValue() throws Exception {
		if (operation.equals("plus")) {
			currentValue = currentValue + delta;
			if (currentValue > endValue ) {
				throw new Exception("Exceeded maximum value " );
			}
			
		}
		if (operation.equals("minus")) {
			currentValue = currentValue - delta;
			if (currentValue < endValue ) {
				throw new Exception("Exceeded minimum value " );
			}
		}
		return currentValue;
	}

	public boolean isApplicable() {
		if(operation.equals("plus")) {
			System.out.println(currentValue + " < " + this.endValue);
			return this.currentValue < this.endValue;
		}
		if (operation.equals("minus")) {
			System.out.println(this.currentValue + " >= " + this.endValue);
			return this.currentValue > this.endValue;
		}
		System.err.println("Operation mismatch : " + operation);
		return false;
	}
}
