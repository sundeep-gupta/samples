package com.oracle.examples;

import org.testng.annotations.Test;

public class One {

	@Test(groups={"blockA"}, dependsOnMethods={"testB"})
	public void testA(){
		System.out.println("testA executed successfully.");
	}
	
	@Test(groups={"blockA"}, dependsOnGroups={"blockB"})
	public void testB() {
		System.out.println("testB executed successfully.");
	}
}
