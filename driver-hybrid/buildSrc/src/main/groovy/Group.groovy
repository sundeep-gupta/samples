package org.gradle
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction
import org.gradle.api.tasks.testing.Test
import javax.inject.Inject;

public class Group extends Test {


@Inject
Group(org.gradle.listener.ListenerManager listenerManager,
           org.gradle.logging.StyledTextOutputFactory textOutputFactory,
           org.gradle.api.internal.file.FileResolver fileResolver,
           org.gradle.internal.Factory<org.gradle.process.internal.WorkerProcessBuilder> processBuilderFactory,
           org.gradle.messaging.actor.ActorFactory actorFactory,
           org.gradle.internal.reflect.Instantiator instantiator,
           org.gradle.logging.ProgressLoggerFactory progressLoggerFactory){
        super(listenerManager,textOutputFactory,fileResolver,processBuilderFactory,actorFactory,instantiator,progressLoggerFactory);
}


@TaskAction
public void executeTests() {
		// Operations to be performed before executing actual test
	         println 'Executing Test: ' + name
		 println '\n' + name + ':Pinging OMS  before test execution'

		// Set the required properties for test execution
		String group_name =  name;
		useTestNG() {
			includeGroups (group_name);
		}
			
			
		//invoke execute
		super.executeTests(); 


        // Operations to be performed after executing actual test
                println name + ': Execution Completed, Pinging OMS  After test execution'

}

}	
