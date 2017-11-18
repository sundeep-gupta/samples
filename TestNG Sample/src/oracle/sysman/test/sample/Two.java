package oracle.sysman.test.sample;

import org.testng.annotations.Test;

public class Two {
	@Test
	public void testFour() {
		System.out.println("This test only belong to 'sanity' group");
	}
	
	@Test(groups = {"regression", "ui"})
	public void testFive() {
		System.out.println("This test only belong to 'regression' and 'ui' groups");
	}
}
