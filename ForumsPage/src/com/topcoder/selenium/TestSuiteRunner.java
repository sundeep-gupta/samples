/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.topcoder.selenium;

import com.topcoder.selenium.SeleniumTestcase.TestStep;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

/**
 *
 * @author skgupta
 */
public class TestSuiteRunner {
    public static void main(String... args) throws TestSuiteParsingException, NoSuchMethodException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {
        String path = "D:\\searchforumtests.xls";
        ObjectRepository objRepos = ObjectRepository.getInstance(path);
        SeleniumTestSuite suite = ExcelSeleniumTestSuite.getInstance(path, objRepos);
        // TODO: Pass browser type as argument here.
        WebdriverRunner webdriver = WebdriverRunner.getInstance();
        // TODO: Ensure to start the browser... see if this is needed or wd does it automatically ?
        webdriver.startBrowser();
        for(Object tmpTc: suite) {
            SeleniumTestcase testcase = (SeleniumTestcase) tmpTc;
            System.out.println("Executing testcase : " + testcase.getName());
            for(Object tmpStep : testcase) {
                System.out.println("Steps of testcase");
                webdriver.execute((TestStep)tmpStep);
            }
        }
        webdriver.quit();
        System.out.println("Successfully run the suite.");
    }
    
}
