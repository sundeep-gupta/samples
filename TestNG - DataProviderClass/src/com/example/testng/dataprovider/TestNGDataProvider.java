package com.example.testng.dataprovider;

import org.testng.annotations.DataProvider;

public class TestNGDataProvider {

	@DataProvider
	public static Object[][] testSumInput() {
		return new Object[][] { { 5, 5 }, { 10, 10 }, { 20, 20 } };
	}
	@DataProvider
	public static Object[][] testMultipleInput() {
		return new Object[][] { { 5, 5 }, { 10, 10 }, { 20, 20 } };
	}
}
