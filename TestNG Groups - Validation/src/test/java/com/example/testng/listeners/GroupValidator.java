package com.example.testng.listeners;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.testng.IMethodInstance;
import org.testng.IMethodInterceptor;
import org.testng.ITestContext;
import org.testng.ITestNGMethod;

public class GroupValidator implements IMethodInterceptor {
	/**
	 * Checks if the group names of the list of tests being run are valid.
	 */
	@Override
	public List<IMethodInstance> intercept(List<IMethodInstance> methods,
			ITestContext context) {
		/* Put your valid group names in a map so that it is easy to validate
		 * One can also put the list in an external file and read it here.
		 */
		Map<String, Boolean> validGroupNames = new HashMap<String, Boolean>();
		validGroupNames.put("ui", true);
		for(IMethodInstance mInstance: methods) {
			ITestNGMethod method = mInstance.getMethod();
			if (method.isTest()) {
				System.out.println("Validating: " + method.getMethodName());
				for(String group : method.getGroups()) {
					if (! validGroupNames.containsKey(group)) {
						throw new RuntimeException("Group name validation failed. Cannoot run the tests");
					}
				}
			}
		}
		return methods;
	}
}
