package com.example.testng.test;

import org.testng.annotations.Test;

public class GroupValidatorTest {
	@Test
	public void noGroupTest() {
		System.out.println("nogrouptest");
	}
	@Test(groups="ui") 
	public void validGroupNameTest() {
		System.out.println("Validgroupnametest");
	}
	
	@Test(groups="ui")
	public void invalidGroupNameTest() {
		System.out.println("This will cause failure of suite.");
	}
	
}
