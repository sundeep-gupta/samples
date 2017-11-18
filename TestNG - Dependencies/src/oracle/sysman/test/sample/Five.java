package oracle.sysman.test.sample;

import org.testng.annotations.Test;

public class Five {
	private int counter = 0;
	@Test(groups = {"group1"})
	public void testOne() {
		System.out.println("Counter value in group1:" + counter);
	}
	
	@Test(groups = {"group2"})
	public void testTwo() {
		counter++;
		System.out.println("Counter value in group2 :" + counter);
	}
}
