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
public class UsecaseTest {

    @Test
    public void hemanth() {
        DesiredCapabilities caps = DesiredCapabilities.chrome();
        WebDriver driver = new ChromeDriver(caps);
        driver.get("https://adc00pkh.us.oracle.com:4443/emsaasui/apmUislc07qxe/index.html");
        Thread.sleep(60000);
        driver.findElement(By
    }
}