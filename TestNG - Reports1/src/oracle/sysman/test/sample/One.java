package oracle.sysman.test.sample;

import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

@Test(description="id:z01939")
public class One {
	@BeforeMethod
	public void beforeMe() {
		System.out.println("Getting called - config method.");
		//throw new RuntimeException("Forceful failing of config method.");
	}
	public void testOne() {
		System.out.println("This is test one..");
	}
	
	public void testTwo() {
		System.out.println("This is test two..");
	}
}
