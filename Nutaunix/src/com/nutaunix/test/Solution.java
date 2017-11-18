package com.nutaunix.test;

public class Solution {

	public static void nutanixSequence(Long number, int nth) {
		String strNum = number.toString();
		for (int i = 1; i < nth; i++) {
			String strNext = "";
			char currentChar = '\0';
			int counter = 0;
			for(char c : strNum.toCharArray()) {
				if (currentChar == '\0') {
					currentChar = c;
					counter = 0;
				}
				else if (currentChar != c) {
					strNext += currentChar + "" + counter;
					System.out.println(strNext);
					currentChar = c;
					counter = 0;
				}
				counter++;
			}
			strNext += currentChar + "" + counter;
			strNum = strNext;
		}
		System.out.println(strNum);
	}

	public static void main(String...strings) {
		nutanixSequence(500055L, 3);
	}
}
