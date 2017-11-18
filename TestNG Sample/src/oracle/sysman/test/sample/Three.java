package oracle.sysman.test.sample;

import org.testng.annotations.Test;

@Test(groups = {"regression"})
public class Three {
	public void testSix() {
		System.out.println("This test belong to 'regression' group");
	}
	
	@Test(groups = {"ui"})
	public void testSeven() {
		System.out.println("This test belong to 'regression' group and also 'ui' group");
	}

}
