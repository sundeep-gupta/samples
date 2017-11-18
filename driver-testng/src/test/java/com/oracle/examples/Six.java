package com.oracle.examples;

import org.testng.annotations.Test;

public class Six {
	@Test(groups="blockC", dependsOnGroups="blockB")
	public void testH() {
		
	}
	
	@Test(groups="blockC", dependsOnGroups="blockB")
	public void testI() {
		
	}
	@Test(groups="blockC", dependsOnGroups="blockB")
	public void testJ() {
		
	}
}
