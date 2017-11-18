package org.gradle
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction
import org.gradle.api.tasks.testing.Test

public class SeleniumTest extends DefaultTask {


// Logic to handle and run Selenium test should go here
void run() {
         println 'Executing Test: ' + name
	// Operations to be performed before executing actual test
	println '\n' + name + ':Pinging OMS  before test execution'

        project.exec {

			commandLine  './' + name + '.sh'
                }

        // Operations to be performed after executing actual test
                println name + ': Execution Completed, Pinging OMS  After test execution'

    }


}	
	
