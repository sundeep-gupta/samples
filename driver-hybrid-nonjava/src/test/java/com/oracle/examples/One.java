package com.oracle.examples;

import org.testng.annotations.Test;

public class One {

	@Test(dependsOnMethods={"testB"})
	public void testA(){
		System.out.println("testA executed successfully.");
	}
	
	@Test
	public void testB() {
		System.out.println("testB executed successfully.");
	}
}
