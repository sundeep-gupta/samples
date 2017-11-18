package oracle.sysman.test.sample;

import static org.testng.Assert.fail;

import org.testng.annotations.Test;

@Test(groups ={"four"}, dependsOnGroups={"sanity"})
public class Four {
	public void testNine() {
		System.out.println("This test belong to 'four' group");
	}
	
	public void testTen() {
		System.out.println("This test belong to 'four' group");
	}
	
	public void testEleven() {
		System.out.println("testEleven");
	}
}
