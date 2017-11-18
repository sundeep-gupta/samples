package com.example.testng.dataprovider;

import java.lang.reflect.InvocationTargetException;

import org.testng.ITestResult;
import org.testng.TestListenerAdapter;

public class MyListener extends TestListenerAdapter {

	@Override
	public void onTestSuccess(ITestResult r) {
		int cnt = r.getMethod().getCurrentInvocationCount() -1 ;
		System.out.println("Checking test result attributes");
		Class dpc = r.getMethod().getConstructorOrMethod().getMethod().getAnnotation(org.testng.annotations.Test.class).dataProviderClass();
		String dp = r.getMethod().getConstructorOrMethod().getMethod().getAnnotation(org.testng.annotations.Test.class).dataProvider();
		try {
			Object[][] data = (Object[][]) dpc.getMethod(dp,  null).invoke(null);
			System.out.println("Successfully got the data");
			for (Object o: data[cnt]) {
				System.out.println("    " + o);
			}
		} catch (IllegalAccessException | IllegalArgumentException
				| InvocationTargetException | NoSuchMethodException
				| SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		for(String attrs: r.getTestContext().getAttributeNames()) {
			System.out.println(attrs + ":" + r.getAttribute(attrs));
		}
	}
}
