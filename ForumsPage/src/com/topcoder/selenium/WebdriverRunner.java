/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.topcoder.selenium;

import java.lang.reflect.InvocationTargetException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;


/**
 *
 * @author skgupta
 */
class WebdriverRunner {
    WebDriver driver;
    private WebdriverRunner() {
        // TODO : This is where the instance of webdriver will be created.
        this.driver = new FirefoxDriver();
        System.out.println("Driver created successfully.");
    }
    public static WebdriverRunner getInstance() {
        return new WebdriverRunner();
    }

    public void startBrowser() {
        System.out.println("Start the corresponding browser here.");
        driver.get("http://tcqa1.topcoder.com");
    }

    public void execute(SeleniumTestcase.TestStep testStep) throws NoSuchMethodException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {
        // TODO: Execute the webdriver here.
        System.out.println("    " + testStep);
        System.out.println("        " + testStep.getDescription());
        
        WebElement e = driver.findElement(By.cssSelector(testStep.getDescription()));
        System.out.println(e.isDisplayed());
        WebElement.class.getMethod(testStep.getAction()).invoke(e);
    }
    public void quit() throws NoSuchMethodException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {
        System.out.println("Calling quit using reflection");
        this.driver.getClass().getMethod("quit").invoke(driver); 
        
        //this.driver.quit();

    }
}
