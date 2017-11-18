package oracle.sysman.sample.testng;

import org.testng.annotations.Test;

@Test(groups={"sanity"})
public class One {
	@Test(groups="ui", dependsOnGroups="noui")
	public void testUI() {
		System.out.println("UI Sanity test.");
	}
}
