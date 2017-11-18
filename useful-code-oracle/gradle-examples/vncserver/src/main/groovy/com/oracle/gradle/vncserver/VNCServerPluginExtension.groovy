package com.oracle.gradle.vncserver

import org.gradle.api.Project
import org.gradle.process.ProcessForkOptions
public class VNCServerPluginExtension {

    private static final String TASK_EXTENSION_NAME = 'vncserver'

    Project project 

    public void applyTo(ProcessForkOptions task) {
        VNCServerTaskExtension extension = task.extensions.create(TASK_EXTENSION_NAME, VNCServerTaskExtension, task)
        task.doFirst {
            VNCServer.start(extension)
            task.environment 'DISPLAY', extension.getDisplayString()
        }
        task.doLast {
            println "Stop the VNC here..."
            VNCServer.stop(extension)
        }
    }

    public VNCServerPluginExtension(Project project) {
        this.project = project
    }
}
