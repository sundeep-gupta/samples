/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.topcoder.selenium;

import com.topcoder.selenium.ObjectRepository.Entry;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 *
 * @author skgupta
 */
class SeleniumTestcase implements Iterable {
    private List<TestStep> steps;
    private String name;
    @Override
    public Iterator<TestStep> iterator() {
       
        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
        return steps.iterator();
    }
    
    class TestStep {
        private String action;
        private String objectId;
        private String type;
        private String data;
        private Entry objEntry;
        
        public TestStep(String action, String objectId, String type, String data, Entry objEntry) {
            this.action = action;
            this.objectId = objectId;
            this.type = type;
            this.data = data;
            this.objEntry = objEntry;
        }
        @Override
        public String toString() {
            return action + " " + objectId + " " + type + " " + data;
        }
        public String getAction() {
            return action;
        }
        public String getObjectId() {
            return this.objectId;
        }
        public String getType() {
            return this.type;
            
        }
        public String getData() {
            return this.data;
        }
        public String getDescription() {
            return objEntry.getDescription();
        }
    }
    public SeleniumTestcase(String name) {
        this.name = name;
        steps = new ArrayList<TestStep>();
    }
            
    public void addStep(String action, String objectId, String type, Entry objEntry) {
        steps.add(new TestStep(action, objectId, type, null, objEntry));
    }
    public void addStep(String action, String objectId, String type, String data, Entry objEntry) {
        steps.add(new TestStep(action, objectId, type, data, objEntry));
    }
    
    public String getName() {
        return this.name;
    }
}
