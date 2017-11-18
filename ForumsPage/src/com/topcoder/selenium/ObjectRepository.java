/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.topcoder.selenium;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

/**
 *
 * @author skgupta
 */
class ObjectRepository {
    File reposFile;
    private Map<String, Entry> lookup;
    public static ObjectRepository getInstance(String filepath) throws TestSuiteParsingException {
        return new ObjectRepository(filepath);
    }
    private ObjectRepository(String filepath) throws TestSuiteParsingException {
        this(new File(filepath));
    }
    
    private ObjectRepository(File reposFile) throws TestSuiteParsingException {
        this.reposFile = reposFile;
        this.lookup = new HashMap<String, Entry>();
        this.parse();
    }
    
    protected void parse() throws TestSuiteParsingException {
        try {
            String sheetName = "Local Object Repository";
            // Parse the spreadsheet file
            Workbook workbook = Workbook.getWorkbook(reposFile);
            Sheet sheet = workbook.getSheet(sheetName);
            if (sheet == null) {
                throw new TestSuiteParsingException("Sheet with name " + sheetName + " not found.");
            }
            for(int rowIndex = 1; rowIndex < sheet.getRows(); rowIndex++) {
                String objName = sheet.getCell(0, rowIndex).getContents();
                String objDesc = sheet.getCell(1, rowIndex).getContents();
                String visibleText = sheet.getCell(2, rowIndex).getContents();
                this.addEntry(objName, objDesc, visibleText);
            }
        } catch (IOException | BiffException ex) {
            Logger.getLogger(TestSuiteRunner.class.getName()).log(Level.SEVERE, null, ex);
            throw new TestSuiteParsingException(null, ex);
        }
    }
    
    protected void addEntry(String objectName, String description, String visibleText) {
        lookup.put(objectName, new Entry(objectName, description, visibleText));
    }
    public Entry lookup(String objectName) throws ObjectRepositoryLookupException {
        Entry e = lookup.get(objectName);
        if (e == null) {
            throw new ObjectRepositoryLookupException("Entry for " + objectName + " not found.");
        }
        return e;
    }
    
    public String getDescriptionForId(String id) {
        return this.lookup(id).getDescription();
    }
    public static class Entry {
        String id;
        String description;
        String visibleText;
        public Entry(String objectName, String description, String visibleText) {
            this.id = objectName;
            this.description = description;
            this.visibleText = visibleText;
        }
        public String getDescription() {
            return description;
        }
        public String getVisibleText() {
            return visibleText;
        }
    }
}
