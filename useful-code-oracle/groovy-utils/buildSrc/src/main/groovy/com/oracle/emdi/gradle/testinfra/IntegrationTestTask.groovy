package com.oracle.emdi.gradle.testinfra
import org.gradle.api.DefaultTask
import org.gradle.api.GradleException
import org.gradle.api.tasks.TaskAction

import org.freesource.gradle.*

import static org.freesource.farm.FarmUtils.*

public class IntegrationTestTask extends DefaultTask {

    def repositories = []

    String testinfraVersion 

    File gitStorage

    File logFile

    private def writer 

    @TaskAction
    public void exec() {
        if (!testinfraVersion) {
            throw new GradleException("Cannot run task, as project property ${propName} is not set.")
        }
        writer = logFile.newWriter()
        writer.println "Checking if the ${gitStorage.absolutePath} exists."
        if (gitStorage.exists()) {
            writer.println  "Deleting ${gitStorage.absolutePath}."
            gitStorage.deleteDir()
        }


        repositories.each { repoName ->
            String cloneDir
            println "-----------------------------------------------------------------------------------------------"
            println " ${repoName}"
            println "-----------------------------------------------------------------------------------------------"
            try {
                cloneDir = gitClone(repoName)
                println "OK"
                doBuild(repoName)
                println "OK"

                String jobId = submitLrgs(repoName)
                println "OK, ${jobId}"
            }
            catch (Exception e) {
                println " FAILED"
                println "\tIntegration run SKIPPED: ${e.message}"
                return
            }
        }
        writer.close()
    }

    void doBuild(String repoName) {
        String command = "gradle clean build -x test"
        print "\tRunning '${command}' (This might take some time) ..."
        String buildOutput = ["sh", "-c", command].execute().text.trim()
        writer.println buildOutput
        return
    }

    String submitLrgs(String repoName) {
        String cloneDir = gitStorage.absolutePath + '/' + repoName
        print "\tSubmitting farm for COMPONENT level LRGs."
        writer.println "Running testinfra ${testinfraVersion} on ${repoName}"
        String farmCmd = "cd ${cloneDir}; smpfarm -pipeline COMPONENT -config ORG_GRADLE_PROJECT_testinfraVersion=${testinfraVersion}" +
                " -desc '${repoName}-${testinfraVersion}'"
        writer.println"\t${farmCmd}"
        String farmOutput = ["sh", "-c", farmCmd].execute().text.trim()
        writer.println farmOutput

        def matcher = farmOutput =~ /(?ms)Recording\s+farm\s+submission\.\s+Job\s+#\s+is\s+(.*)/
        if (matcher.find()) {
            return matcher.group(1)
        }
        throw new Exception("Failed to submit farm job.")
    }

    String gitClone(String repoName)  {
        String cloneUrl = "git@orahub.oraclecorp.com:emaas/${repoName}.git"
        String cloneDir = "${gitStorage.absolutePath}/${repoName}"

        String cloneCmd = "cd ${gitStorage.absolutePath}; git clone ${cloneUrl} ${cloneDir}"
        print "\tCloning repository..."
        writer.println "\tCloning ${repoName}: $cloneCmd"
        String cloneOutput = ['sh', '-c', cloneCmd].execute().text.trim()
        writer.println cloneOutput
        if (!new File(cloneDir).exists()) {
            throw new Exception("Failed to clone the git repository.")
        }
        return cloneDir
    }
}
