package oracle.sysman.sample.test.testng;

import org.testng.annotations.Test;

public class Standalone {
	public void testOne() {
		System.out.println("This test is not dependent on any other test/group");
	}
}
