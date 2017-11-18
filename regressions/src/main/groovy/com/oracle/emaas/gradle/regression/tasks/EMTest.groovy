package com.oracle.emaas.gradle.regression.tasks;

import org.gradle.api.tasks.JavaExec

class EMTest extends JavaExec {
	def testngXml
	@Inject
	EMTest() {
		executable = 'java'
				
	}
	
    @TaskAction
    public void exec() {
    	// Set the classpath by default + pick test's classpath as well
    	// Set the location to store the testng results
    	// 
    }
}
