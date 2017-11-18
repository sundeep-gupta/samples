apply plugin: 'java'

task transform(type: Test) {
    //testClassesDir = new File(System.env.REPO_ROOT + "/samples/lrgtest/build/classes/integTest")
    // classpath = files(testClassesDir, '/scratch/skgupta/bin/gradle/lib/plugins/testng-6.3.1.jar')
    /* outputs.upToDateWhen { 
        println "Setting UPTO-DATE to false."
      false 
    }
    */
    doFirst {
        println "First called."
    }
    doLast {
        println "Last Called"
    }
    testClassesDir = new File(System.env.T_WORK)
    println "Configuration happening"
    print testClassesDir.path
    ignoreFailures = true
}
tasks.transform.doFirst {
    println "First called again."
}

task another  {
    doFirst {
        println "Another doFirst"
    }
    doLast {
        println "Another doLast"
    }
}
