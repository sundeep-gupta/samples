package oracle.sysman.test.sample;

import org.testng.annotations.Test;

public class One {
	
	@Test(groups = {"sanity", "ui"}, dependsOnGroups = {"backend"})
	public void testOne() {
		System.out.println("This test belong to sanity & ui groups");
	}
	
	@Test(groups = {"backend"})
	public void testTwo() {
		System.out.println("This is backend test");
	}
	
	@Test(groups = {"regression"})
	public void testThree() {
		System.out.println("This test belong to 'regression' group");
	}
}
