package com.oracle.skgupta.testng.config;
import org.testng.Reporter;
import org.testng.annotations.*;

/**
 * Created by skgupta on 7/12/2016.
 */
public class ExampleConfig {
    @BeforeTest
    public void beforeTest() {
        Reporter.log("Hello, I am in beforeTest");
    }
    @BeforeClass
    public void beforeClass() {
        Reporter.log("Hello, I am in beforeClass");
    }

    @BeforeMethod
    public void beforeMethod() {
        //org.testng.Assert.fail("Force fail beforeMethod");
        Reporter.log("Hello, I am in beforeMethod");
    }

    @Test
    public void myTest() throws Exception {

        Thread.sleep(1000);
        Reporter.log("Hello, I am in myTest!");
    }

    @Test
    public void myTest2() throws Exception{
        Thread.sleep(1000);

        Reporter.log("Hello, I am in myTest!");
    }


    public void failingTest() throws Exception{
        Thread.sleep(1000);
        org.testng.Assert.fail("Force Failing the test");
    }

    @AfterMethod
    public void afterMethod() throws Exception {
        Thread.sleep(1000);
        Reporter.log("Hello!, I am in afterMethod");
        org.testng.Assert.fail("Failing afterMethod to check if all tests skip.");
    }

    @AfterClass
    public void afterClass() {
        Reporter.log("Hello, I am in afterClass");
    }

    @AfterTest
    public void afterTest() { Reporter.log("Hello, I am in afterTest");}
}
