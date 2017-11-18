package org.gradle
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.Exec
import org.gradle.api.tasks.TaskAction
import org.gradle.api.tasks.testing.Test

public class CliTest extends DefaultTask {


@TaskAction
void run() {
         println 'Executing Test: ' + name
	 // Operations to be performed before executing actual test
	println '\n' + name + ':Pinging OMS  before test execution'

	// Execute the test

	project.exec { 
			
			commandLine  './' + name + '.sh'
			  
                } 

	// Operations to be performed after executing actual test
        	println name + ': Execution Completed, Pinging OMS  After test execution'

    }
	

}
