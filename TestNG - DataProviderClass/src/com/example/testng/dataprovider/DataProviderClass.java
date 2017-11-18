package com.example.testng.dataprovider;
import org.testng.Assert;
import org.testng.ITest;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.example.testng.dataprovider.TestNGDataProvider;
/**
* Example to demonstrate use of dataProviderClass and dataProvide attributes of TestNG framework
*
* @author Jagadeesh Motamarri
* @version 1.0
*/

public class DataProviderClass {

public CalculatorService service;
	@BeforeClass
	public void init() {
		System.out.println("@BeforeClass: The annotated method will be run before the first test method in the current class is invoked.");
		System.out.println("init service");
		service = new SimpleCalculator();
	}
	@Test(dataProviderClass = TestNGDataProvider.class, dataProvider = "testSumInput")
	public void testSum(int a, int b) {
		System.out.println("@Test : testSum()");
		int result = service.sum(a, b);
		Assert.assertEquals(result, a + b);
	}
	@Test(dataProviderClass = TestNGDataProvider.class, dataProvider = "testMultipleInput")
	public void testMultiple(int a, int b) {
		System.out.println("@Test : testMultiple()");
		int result = service.multiply(a, b);
		Assert.assertEquals(result, a * b);
	}
	
	
}