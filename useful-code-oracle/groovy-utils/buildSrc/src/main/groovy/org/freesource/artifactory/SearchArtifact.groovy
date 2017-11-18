package org.freesource.artifactory

import groovy.json.*
import org.gradle.api.DefaultTask
import org.gradle.api.GradleException
import org.gradle.api.tasks.TaskAction

public class SearchArtifact extends DefaultTask {

    String search

    List<String> reposToSearch = []

    @TaskAction
    public void search() {
        if (!search) {
            throw new GradleException("Cannot run task, as project property no search string is set.")
        }
        def jsonResponse
        if (reposToSearch && reposToSearch.size() > 0) {
            jsonResponse = project.artifactory.quickSearch(project.property('find'), (String[]) reposToSearch.toArray())
        }
        else {
            jsonResponse = project.artifactory.quickSearch(project.property('find'))
        }
        jsonResponse.results.each {
            println it.uri
        }
    }
}
