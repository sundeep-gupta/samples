package oracle.sysman.test.sample;

import org.testng.annotations.Test;

public class Two {
	@Test(groups = {"sanity"}, dependsOnGroups = {"ui"})
	public void testFour() {
		System.out.println("This test only belong to 'sanity' group");
	}
	
	@Test(groups = {"regression", "ui"}, dependsOnGroups= {"backend"})
	public void testFive() {
		System.out.println("This test only belong to 'regression' and 'ui' groups");
	}
	@Test(groups = {"backend"}, dependsOnGroups= {"sanity"})
	public void testSix() {
		System.out.println("This test only belong to 'regression' and 'ui' groups");
	}
}
