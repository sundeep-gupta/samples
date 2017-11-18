package oracle.sysman.sample.test.testng;

import org.testng.annotations.Test;

public class StandaloneTwo {
	@Test (groups={"standalone"})
	public void testOne() {
		System.out.println("This test is not dependent on any other test/group");
	}
	@Test(dependsOnGroups = {"standalone"})
	public void testTwo() {
		System.out.println("This test is run after 'standalone' group.");
	}
}
