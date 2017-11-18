package com.example.testng.listeners;

import org.testng.IConfigurationListener2;
import org.testng.ITestResult;

public class SkipConfiguration implements IConfigurationListener2 {

	@Override
	public void onConfigurationSuccess(ITestResult itr) {
		System.out.println("Successful run of the configuration.");
		
	}

	@Override
	public void onConfigurationFailure(ITestResult itr) {

		System.out.println("Failure of the configuration.");
		
	}

	@Override
	public void onConfigurationSkip(ITestResult itr) {

		System.out.println("Skip of the configuration.");
	}

	@Override
	public void beforeConfiguration(ITestResult tr) {
		// TODO Auto-generated method stub
		System.out.println("Asking to skip the configuration.");
		tr.setStatus(ITestResult.SKIP);
	}

}
