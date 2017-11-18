package com.oracle.skgupta.testng.dataprovider;

import org.testng.Assert;
import org.testng.ITestResult;
import org.testng.Reporter;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import static org.testng.Assert.*;
/**
 * Created by skgupta on 6/21/2016.
 */
public class ExampleDP {
    @BeforeMethod
    public void initialize() {
        System.out.println("Before Method.");
       // Assert.fail("Force Fail");
        methodCall();
    }

    @DataProvider(name = "test1")
    public static Object[][] primeNumbers() {
        return new Object[][] {{2, true}, {6, false}, {19, true}, {22, false}, {23, true}};
    }

    // This test will run 4 times since we have 5 parameters defined
    @Test(dataProvider = "test1")
    public void testPrimeNumberChecker(Integer inputNumber, Boolean expectedResult) {
        System.out.println("Hello: " + inputNumber + " " + expectedResult);
        ITestResult res = Reporter.getCurrentTestResult();
        Reporter.log("I am in testPrimeNumber Checker");
        Reporter.log(inputNumber + " " + expectedResult);
        methodCall();

    }

   // @Test
    public void failingTest() {
        fail("Fail Forcibly");
    }

    public void methodCall() {
        Reporter.log("I am in method called by someone.");
    }
}
