package oracle.sysman.sample.testng;

import org.testng.annotations.Test;

@Test(groups={"sanity"})
public class Two {
	@Test(groups="noui")
	public void testNonUI() {
		System.out.println("Non UI Sanity test.");
		
	}
	
}
