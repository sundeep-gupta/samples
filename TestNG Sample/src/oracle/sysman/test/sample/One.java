package oracle.sysman.test.sample;

import org.testng.annotations.Test;
@Test(groups="mygroup")
public class One {
	
	@Test(groups = {"sanity", "ui", "data"})
	public void testOne() {
		System.out.println("This test belong to sanity & ui groups");
	}
	
	@Test(groups = {"sanity", "backend"})
	public void testTwo() {
		System.out.println("This is backend and sanity test");
	}
	
	@Test(groups = {"regression"})
	public void testThree() {
		System.out.println("This test belong to 'regression' group");
	}
	
	public void testFour() {
		
	}
}
