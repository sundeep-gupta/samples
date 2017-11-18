package com.oracle.examples;

import org.testng.annotations.Test;

public class Three {
	@Test(groups={"blockB"}, dependsOnMethods={"testF"})
	public void testD(){
		System.out.println("testD executed successfully.");
	}
	
	@Test(groups={"blockBa", "blockB"})
	public void testE() {
		System.out.println("testE successfully executed.");
		
	}
}
