package com.oracle.examples;

import org.testng.annotations.Test;

public class Four {

	@Test(groups={"internal-1"}, dependsOnGroups="internal-2")
	public void testF() {
		System.out.println("testF successfully executed.");
	}
}
