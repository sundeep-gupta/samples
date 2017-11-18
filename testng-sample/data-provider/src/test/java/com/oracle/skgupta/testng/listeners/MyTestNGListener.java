package com.oracle.skgupta.testng.listeners;

import org.testng.*;

/**
 * Created by skgupta on 7/10/2016.
 */
public class MyTestNGListener implements ITestListener, IConfigurationListener2 {

   // List<ITestResult> beforeMethodConfigurations = new ArrayList<ITestResult>();
   // List<ITestResult> afterMethodConfigurations = new ArrayList<ITestResult>();

    public void beforeConfiguration(ITestResult tr) {
        Reporter.log("Starting the configuration method " + tr.getMethod().getConstructorOrMethod().getMethod().getName() + " " + tr.hashCode());
    }

    public void onConfigurationSuccess(ITestResult tr) {
        Reporter.log("In onConfigurationSuccess " + tr.getTestName());

        //Reporter.log("In onConfigurationSuccess " + tr.getMethod().getConstructorOrMethod().getMethod().getName()  + " " + tr.hashCode());
    }

    public void onConfigurationFailure(ITestResult tr) {
        Reporter.log("In onConfigurationFailure " + tr.getTestName());
        //Reporter.log("In onConfigurationFailure " + tr.getMethod().getConstructorOrMethod().getMethod().getName());
    }

    public void onConfigurationSkip(ITestResult tr) {
        Reporter.log("In onConfigurationSkipped " + tr.getMethod().getConstructorOrMethod().getMethod().getName());
    }

    public void onStart(ITestContext context) {
        Reporter.log("In onStart");
        for(ITestNGMethod method: context.getAllTestMethods()) {
            Reporter.log("In onStart" + method.getCurrentInvocationCount());
        }
    }
    public void onFinish(ITestContext context) {
        for(ITestNGMethod method: context.getAllTestMethods()) {
            Reporter.log("In onFinish " + method.getMethodName() + " " + method.getCurrentInvocationCount());
        }
    }

    public void onTestStart(ITestResult result) {
        ITestContext context = result.getTestContext();
        String methodName = result.getMethod().getConstructorOrMethod().getMethod().getName();
        Reporter.log("ON TEST START " + methodName);
        Reporter.log("ON TEST START - " + result.getMethod().getCurrentInvocationCount() + "/" + result.getMethod().getInvocationCount());
    }
    public void onTestSuccess(ITestResult result) {
        ITestContext context = result.getTestContext();
        Reporter.log("In onTestSuccess size of getAllTestMethods() " + context.getAllTestMethods().length);
        for(ITestNGMethod method: context.getAllTestMethods()) {
            Reporter.log("In TEST SUCCESS " + method.getCurrentInvocationCount() + " SUCCESS");
        }
    }

    public void onTestFailure(ITestResult result) {
        ITestContext context = result.getTestContext();
        for(ITestNGMethod method: context.getAllTestMethods()) {
            Reporter.log("In TEST FAILURE" + method.getCurrentInvocationCount() + " FAILED");
        }
    }

    public void onTestFailedButWithinSuccessPercentage(ITestResult result) {
        ITestContext context = result.getTestContext();
        for(ITestNGMethod method: context.getAllTestMethods()) {
            Reporter.log("In onTestFailedButWithinSuccessPercentage" + method.getCurrentInvocationCount() + " FAILEDWITHSUCCESS%");
        }
    }
    public void onTestSkipped(ITestResult result) {
        ITestContext context = result.getTestContext();
        for(ITestNGMethod method: context.getAllTestMethods()) {
            Reporter.log("In onStart" + method.getCurrentInvocationCount() + " SKIPPED");
        }
    }

}
