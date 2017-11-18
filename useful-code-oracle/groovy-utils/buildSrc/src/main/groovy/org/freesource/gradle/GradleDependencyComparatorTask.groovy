package org.freesource.gradle

import org.gradle.api.DefaultTask
import org.gradle.api.GradleException
import org.gradle.api.tasks.TaskAction

import org.freesource.gradle.*

import static org.freesource.farm.FarmUtils.*
public class GradleDependencyComparatorTask extends DefaultTask {

    String baseRun

    String targetRun

    String lrgName

    @TaskAction
    public void compare() {
        if (!baseRun) {
            throw new GradleException("Cannot run task, as 'baseRun' is not set.")
        }

        if (!targetRun) {
            throw new GradleException("Cannot run task, as 'targetRun' is not set.")
        }

        if (!lrgName) {
            throw new GradleException("Cannot run task, as 'lrgName' is not set.")
        }
        lrgName = lrgName.startsWith('lrg') ? lrgName : "lrg${lrgName}"

        def baseLrgFiles = getFilesToParse(baseRun, lrgName)
        def targetLrgFiles = getFilesToParse(targetRun, lrgName)

        GradleDependencyParser parser1 = new GradleDependencyParser(baseLrgFiles)
        GradleDependencyParser parser2 = new GradleDependencyParser(targetLrgFiles)
        GradleDependencyComparator compare = new GradleDependencyComparator(parser1, parser2)
        compare.printReport()
    }
}
