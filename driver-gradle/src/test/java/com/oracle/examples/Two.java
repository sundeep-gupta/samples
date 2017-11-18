package com.oracle.examples;

import org.testng.annotations.Test;

public class Two {
	@Test(dependsOnGroups="blockB")
	public void testC() {
		System.out.println("testC successfully executed.");
	}
}
