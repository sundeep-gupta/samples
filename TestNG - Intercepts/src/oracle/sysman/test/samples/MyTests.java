package oracle.sysman.test.samples;

import org.testng.annotations.Test;
import oracle.sysman.qatool.testng.EMTest;

public class MyTests {
	@Test(dependsOnGroups="one")
	public void test1() {
		System.out.println("One");
	}
	@Test(groups="one")
	@EMTest(description="this is test2")
	public void test2() {
		System.out.println("Two");
	}
}

