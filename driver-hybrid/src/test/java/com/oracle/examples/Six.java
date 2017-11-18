package com.oracle.examples;

import org.testng.annotations.Test;
import static org.testng.Assert.assertEquals;
public class Six {
	@Test
	public void testH() {
		assertEquals(System.getProperty("webdriver.browser.type"), "chrome", "Property is not set or set incorrectly.");
	}
	
	@Test
	public void testI() {
		assertEquals(System.getenv("T_WORK"), "/scratch/skgupta/works","Env vars setting is not working.");
	}
	@Test
	public void testJ() {
		
	}
}
