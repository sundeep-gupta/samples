package com.oracle.examples;

import org.testng.annotations.Test;

public class Four {

	@Test(groups={"blockB"}, dependsOnGroups="blockBa")
	public void testF() {
		System.out.println("testF successfully executed.");
	}
}
