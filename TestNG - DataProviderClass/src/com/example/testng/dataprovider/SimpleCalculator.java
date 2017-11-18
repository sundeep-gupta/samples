package com.example.testng.dataprovider;

public class SimpleCalculator implements CalculatorService {

	@Override
	public int sum(int a, int b) {
		// TODO Auto-generated method stub
		return a+b;
	}

	@Override
	public int multiply(int a, int b) {
		// TODO Auto-generated method stub
		return a * b;
	}

	@Override
	public int divide(int a, int b) {
		// TODO Auto-generated method stub
		return a/b;
	}

	@Override
	public int sub(int a, int b) {
		// TODO Auto-generated method stub
		return a-b;
	}

}
