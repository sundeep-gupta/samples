package org.freesource.artifactory

import groovy.json.*
import org.freesource.artifactory.Artifactory
import org.gradle.api.DefaultTask
import org.gradle.api.GradleException
import org.gradle.api.tasks.TaskAction

class RemoveArtifact extends DefaultTask {
    String group

    String artifactId
    
    String version

    List<String> dependencies = []

    boolean removeDependencies = false

    String artifactoryRepoKey

    def json = [:]

    protected void deleteArtifact(def entry, boolean keepLatest = false) {
        String prefix = group.tokenize('.').join('/')
        println "Removing all artifacts of ${artifactId} built on ${entry.key}"
        entry.value.each { path ->
            try {
                project.artifactory.deleteItem(artifactoryRepoKey, "${prefix}/${path}")
            }
            catch(Exception e) {
                println "... FAILED [${e.message}]"
            }
        }
    }

    protected def findAll() {
        def timestamps = [:]

        json[artifactId].children.each { node ->
            logger.debug "Checking ${node.uri}"
            if (node.uri.startsWith("/${version}.") || node.uri.startsWith("/${version}-")) {
                logger.debug "Match Found ${node.uri}"
                timestamps.put(node.uri.tokenize('-').toArray()[1], ["${artifactId}${node.uri}"])
            }
        }
        dependencies.each { depName ->
            json[depName].children.each { node ->
                def ts = node.uri.tokenize('-').toArray()[1]
                if (timestamps.containsKey(ts)) {
                    logger.debug "Match Found ${node.uri}"
                    timestamps[ts].add("${depName}${node.uri}")
                }
            }
        }
        return timestamps
    }
    
    /**
     * Task to remove the given artifact and its dependencies from the artifactory
     */
    @TaskAction
    public void removeArtifact() {
        if (!project.extensions.findByName('artifactory')) {
            throw new GradleException ("artifactory{} not configured correctly in build.gradle.")
        }
        if (!group) {
            throw new GradleException("Property, 'group' cannot be null or empty.")
        }
        if (!artifactId) {
            throw new GradleException("Property, 'artifactId' cannot be null or empty.")
        }
        if (!version) {
            throw new GradleException("Property, 'version', cannot be null or empty.")
        }
        def path = group.tokenize('.').join('/')
        this.json[artifactId] = project.artifactory.getFolderInfo(artifactoryRepoKey, "${path}/${artifactId}")
        println this.json[artifactId]
        dependencies.each { depName ->
            this.json[depName] = project.artifactory.getFolderInfo(artifactoryRepoKey, "${path}/${depName}")
        }
        def match = this.findAll()
        match.each {
            this.deleteArtifact(it)
        }
    }
}
