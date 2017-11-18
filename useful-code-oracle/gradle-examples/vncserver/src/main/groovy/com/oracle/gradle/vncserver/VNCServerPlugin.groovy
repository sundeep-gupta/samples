package com.oracle.gradle.vncserver

import org.gradle.api.Project
import org.gradle.api.Plugin

class VNCServerPlugin implements Plugin<Project> {
    Project project

    @Override
    public void apply(Project project) {
        this.project = project
        println "This plugin will now add plugin extension"
        VNCServerPluginExtension extension = project.extensions.create('vncserver', VNCServerPluginExtension, project)
    }
}
