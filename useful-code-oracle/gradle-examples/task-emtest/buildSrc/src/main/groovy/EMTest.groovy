package org.gradle
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction
import org.gradle.api.tasks.testing.Test
import javax.inject.Inject;

import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction
import org.gradle.api.tasks.testing.Test
import javax.inject.Inject;
import org.gradle.listener.ListenerManager;
import org.gradle.logging.StyledTextOutputFactory;
import org.gradle.api.internal.file.FileResolver;
import org.gradle.internal.Factory;
import org.gradle.process.internal.WorkerProcessBuilder;
import org.gradle.messaging.actor.ActorFactory;
import org.gradle.internal.reflect.Instantiator;
import org.gradle.logging.ProgressLoggerFactory;

public class EMTest extends Test {

    String outputDir = null;
    String testngxml = null;
 //   TestBlockInterceptor interceptor = new TestBlockInterceptor();

    @Inject
    EMTest(ListenerManager listenerManager, StyledTextOutputFactory textOutputFactory, FileResolver fileResolver,
            Factory<WorkerProcessBuilder> processBuilderFactory, ActorFactory actorFactory,Instantiator instantiator,
            ProgressLoggerFactory progressLoggerFactory) {
        super(listenerManager, textOutputFactory, fileResolver, processBuilderFactory, actorFactory, instantiator, progressLoggerFactory);
     //   environment getEnvironmentVariables();
      //  systemProperties getSysProperties();
        
        outputDir = "testng-results-" + project.lrgName + '-' + name;
    }


    @TaskAction
    public void executeTests() {
        // Operations to be performed before executing actual test
        println 'Executing Test: ' + name
        println '\n' + name + ':Pinging OMS  before test execution'
        // Set the required properties for test execution
        // Set the required properties for test execution
        useTestNG {
            useDefaultListeners = true
            outputDirectory =  getProject().file(outputDir)
            suites getProject().file(testngxml)
        }           
        
       
        //invoke execute
        super.executeTests(); 
        // Operations to be performed after executing actual test
        println name + ': Execution Completed, Pinging OMS  After test execution'
    }
}   

