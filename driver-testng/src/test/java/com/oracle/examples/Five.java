package com.oracle.examples;


import org.testng.annotations.Test;
public class Five {
	@Test(dependsOnGroups="blockB", groups="blockD")
	public void testG() {
		System.out.println("TODO: TestG is a perl script.");
	}
}
