package oracle.sysman.qatools.lrgmanager;

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

public class TestNGBlock extends Test {

	String outputDir = null;
	String testngxml = null;
	TestBlockInterceptor interceptor = new TestBlockInterceptor();

	@Inject
	TestNGBlock(ListenerManager listenerManager, StyledTextOutputFactory textOutputFactory, FileResolver fileResolver,
	        Factory<WorkerProcessBuilder> processBuilderFactory, ActorFactory actorFactory,Instantiator instantiator,
    		ProgressLoggerFactory progressLoggerFactory) {
        super(listenerManager, textOutputFactory, fileResolver, processBuilderFactory, actorFactory, instantiator, progressLoggerFactory);
        environment getEnvironmentVariables();
        systemProperties getSysProperties();
        outputDir = "testng-results-" + project.lrgName + '-' + name;
	}


	@TaskAction
	public void executeTests() {
		// Operations to be performed before executing test group
		if (interceptor != null) {
			interceptor.beforeBlockStarts(this);
		}
		
		// Set the required properties for test execution
		useTestNG {
			useDefaultListeners = true
			outputDirectory =  getProject().file(outputDir)
			suites getProject().file(testngxml)
		}			
		//invoke execute
		super.executeTests(); 

        // Operations to be performed after executing actual test
        if (interceptor != null) {
			interceptor.afterBlockFinish(this);
		}	
	}
	
	Map<String, String> getEnvironmentVariables() {
		// read from files and parse them accordingly.
		Map<String, String> sp = new HashMap<String, String>()
		sp.put('T_WORK', '/scratch/skgupta/works')
		return sp;
	}

	HashMap<String, String> getSysProperties() {
		// read from files and parse them accordingly.
		
		// read from files and parse them accordingly.
		Map<String, String> sp = new HashMap<String, String>()
		sp.put('webdriver.browser.type', 'chrome')
		return sp;
	}
}	
