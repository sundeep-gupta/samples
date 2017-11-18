package com.oracle.skgupta.testng.firefox;

import org.testng.Assert;
import org.testng.ITestResult;
import org.testng.Reporter;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.*;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.logging.LogEntries;
import org.openqa.selenium.logging.LogEntry;
import org.openqa.selenium.logging.LogType;
import org.openqa.selenium.remote.CapabilityType;
import org.openqa.selenium.logging.LoggingPreferences;
import org.openqa.selenium.logging.LogType;
import java.util.logging.Level;
import org.openqa.selenium.remote.DesiredCapabilities;
/**
 * Created by skgupta on 6/21/2016.
 */
public class LogChecks {
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
    @Test()
    public void testPrimeNumberChecker() {
        System.setProperty("webdriver.chrome.driver", "D:\\chromedriver_win32\\chromedriver.exe");

        DesiredCapabilities caps = DesiredCapabilities.chrome();
        LoggingPreferences logPrefs = new LoggingPreferences();
        logPrefs.enable(LogType.BROWSER, Level.ALL);
        caps.setCapability(CapabilityType.LOGGING_PREFS, logPrefs);
        WebDriver driver = new ChromeDriver(caps);
        //LogEntries entries = driver.manage().logs().get(LogType.BROWSER);
        //LogEntries entries = driver.manage().logs().get(LogType.DRIVER);
        //LogEntries entries = driver.manage().logs().get(LogType.PROFILER);

        driver.get("http://www.google.com");
        WebElement element = driver.findElement(By.name("q"));
        element.sendKeys("Cheese!");
        element.submit();
        String js = "console.log(\"SKGUPTA Like Webdriver\");";
        //System.out.println("Page title is: " + driver.getTitle());
        (new WebDriverWait(driver, 10)).until(new ExpectedCondition<Boolean>() {
            public Boolean apply(WebDriver d) {
                return d.getTitle().toLowerCase().startsWith("cheese!");
            }
        });
        ((JavascriptExecutor)driver).executeScript(js);

        //System.out.println("Page title is: " + driver.getTitle());
        // LogType.BROWSER - Gives firefox logs
        // LogType.CLIENT - did not return anything
        // LogType.PERFORMANCE -`did not return anything
        //LogType.PROFILER - ? did not return anything
        // LogType.SERVER - ?
        // LogType.DRIVER -
        LogEntries entries = driver.manage().logs().get(LogType.BROWSER);
        System.out.println("Logging for " + LogType.BROWSER);
        for(LogEntry entry : entries.getAll()) {
            System.out.println(entry.getMessage());
        }
        //Close the browser
        driver.quit();

    }

    public void methodCall() {
        Reporter.log("I am in method called by someone.");
    }
}
