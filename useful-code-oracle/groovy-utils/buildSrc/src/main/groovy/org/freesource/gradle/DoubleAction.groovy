package org.freesource.gradle
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction

public class DoubleAction extends DefaultTask {

    public DoubleAction() {
    }

    public void generate() { println " Generate called last." }

    @TaskAction
    public void defg() {
        doLast {
            generate()
        }
        println "I am in defg"
    }
    @TaskAction
    public void h() { println "I am in h" }

    @TaskAction
    public void ijk() { println "I am in ijk" }
    @TaskAction
    public void abc() {
        println "I am in abc"
    }

}
