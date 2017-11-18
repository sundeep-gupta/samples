/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.topcoder.selenium;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;
import com.topcoder.selenium.ObjectRepository.Entry;
/**
 *
 * @author skgupta
 */
public class ExcelSeleniumTestSuite implements SeleniumTestSuite {
    File suiteFile;
    List<SeleniumTestcase> testcases;
    private ObjectRepository objRepos;
    public static ExcelSeleniumTestSuite getInstance(String filePath, ObjectRepository objRepos) throws TestSuiteParsingException {
        return new ExcelSeleniumTestSuite(filePath, objRepos);
    }
    public ExcelSeleniumTestSuite(String suiteFilepath, ObjectRepository objRepos) throws TestSuiteParsingException  {
        this(new File(suiteFilepath), objRepos);
        
    }
    public ExcelSeleniumTestSuite(File suiteFile, ObjectRepository objRepos) throws TestSuiteParsingException {
        this.suiteFile = suiteFile;
        this.objRepos = objRepos;
        this.testcases = new ArrayList<SeleniumTestcase>();
        this.parseAndRetrieveTestcases();
    }
    private void parseAndRetrieveTestcases() throws TestSuiteParsingException {
        try {
            // Parse the spreadsheet file
            Workbook workbook = Workbook.getWorkbook(suiteFile);
            for(Sheet sheet : workbook.getSheets()) {
                if (sheet.getName().equals("Local Object Repository")) {
                    System.out.println("Local Object Repository skipped");
                    break;
                }
                SeleniumTestcase testcase = new SeleniumTestcase(sheet.getName());
                // TODO : Not sure if -1 is required or we just need to check for blank and break
                for(int rowIndex = 1; rowIndex < sheet.getRows(); rowIndex++) {
                    String action = sheet.getCell(1, rowIndex).getContents();
                    String objectId = sheet.getCell(2, rowIndex).getContents();
                    String type = sheet.getCell(3, rowIndex).getContents();
                    String text = sheet.getCell(4, rowIndex).getContents();
                    Entry objEntry = objRepos.lookup(objectId);
                    testcase.addStep(action, objectId, type, text, objEntry);
                }
                testcases.add(testcase);
            }
            // TODO : Fail if there are no testcase found
        } catch (IOException | BiffException ex) {
            Logger.getLogger(TestSuiteRunner.class.getName()).log(Level.SEVERE, null, ex);
            throw new TestSuiteParsingException(null, ex);
        }
    }

    @Override
    public Iterator<SeleniumTestcase> iterator() {
        return this.testcases.iterator();
    }
}
