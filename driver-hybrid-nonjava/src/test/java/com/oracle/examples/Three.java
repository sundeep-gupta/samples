package com.oracle.examples;

import org.testng.annotations.Test;

public class Three {
	@Test(dependsOnGroups={"internal-1"})
	public void testD(){
		System.out.println("testD executed successfully.");
	}
	
	@Test(groups={"internal-2"})
	public void testE() {
		System.out.println("testE successfully executed.");
		
	}
}
