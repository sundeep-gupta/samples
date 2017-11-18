package oracle.sysman.test.sample;

import org.testng.annotations.Test;
import static org.testng.Assert.fail;

public class Three {
	@Test(groups = {"regression"})
	public void testSix() {
		System.out.println("This test belong to 'regression' group");
	}
	
	@Test(groups = {"regression"})
	public void testSeven() {
		fail("This test belong to 'regression' group");
	}
	
	@Test(groups = {"ui"}, dependsOnGroups={"regression"})
	public void testEight() {
		System.out.println("This will be skipped.");
	}
}
