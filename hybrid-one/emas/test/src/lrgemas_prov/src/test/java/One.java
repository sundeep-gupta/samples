package oracle.sysman.test.sample;

import org.testng.annotations.Test;

public class One {
	
	@Test(groups = {"sanity", "ui"})
	public void testOne() {
		System.out.println("This test belong to sanity & ui groups");
		System.out.println("Value of T_WORK is :" + System.getProperty("tWork"));
		System.out.println("Value of EM_HOST is :" + System.getProperty("emHost"));
		System.out.println("Value of LRG_EM_USER is :" + System.getProperty("lrgEmUser"));
                System.out.println("Value of EXT_ROLE is :" + System.getProperty("extRole"));
	}
	
	@Test(groups = {"sanity", "backend"})
	public void testTwo() {
		System.out.println("This is backend and sanity test");
	}
	
	@Test(groups = {"regression"})
	public void testThree() {
		System.out.println("This test belong to 'regression' group");
	}
}

