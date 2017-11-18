        def testNGResults = new XmlSlurper().parse(new File('plugins/TestInfraPlugin/src/integTest/resources/testparser/single-test-results.xml'))
        def m = [:]
        // point to test-method
        testNGResults.suite.test.each { testNode ->
            testNode.'class'.'test-method'.each { m[it.@name.text()] = 1; print it.@name.text() + " "}
        }
        println m.keySet().size()
    println "-------------------------------------------"
        m = [:]
        testNGResults = new XmlSlurper().parse(new File('plugins/TestInfraPlugin/src/integTest/resources/testparser/multi-test-results.xml'))
        // point to test-method
        testNGResults.suite.test.each { testNode ->
            testNode.'class'.'test-method'.each { m[it.@name.text()] = 1; print it.@name.text() + " "}
        }
        println m.keySet().size()
