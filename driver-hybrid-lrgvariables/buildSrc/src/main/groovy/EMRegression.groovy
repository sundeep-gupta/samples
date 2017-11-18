package org.gradle

import org.gradle.api.Project

import org.gradle.api.Plugin
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction
import org.gradle.api.tasks.testing.Test
import javax.inject.Inject;

public class EMRegression implements Plugin<Project> {
	void apply (Project project) {
		String[] taskNames = project.getGradle().getStartParameter().getTaskNames();
		String lrgName = taskNames[0];
		String globalProps = 'global-test.properties'
		Properties gProps = new Properties();
		gProps.load(new FileInputStream(new File(globalProps)))
		project.ext.lrgEnv = gProps;
	}

}	
