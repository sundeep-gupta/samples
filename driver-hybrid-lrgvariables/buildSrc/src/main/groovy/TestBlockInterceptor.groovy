package oracle.sysman.qatools.lrgmanager;

import org.gradle.api.tasks.testing.Test
import javax.inject.Inject;

public class TestBlockInterceptor {
	@Inject
	public TestBlockInterceptor() {
		println "TestBlockInterceptor being created."
	}
	public String message = "Hello world"
	public void beforeBlockStarts(Test block) {
		println "Hey! I'll run before you start the test block."
	}
	public void afterBlockFinish(Test block) {
		println "Hey! I'll run after the test block execution is complete."
	}
}