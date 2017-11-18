import com.oracle.emdi.tools.testparser.ParseNGXML
def resultsXmlFile = new File('/home/skgupta/emdi-2978/testng-results.xml')
ParseNGXML parseTestNG = new ParseNGXML()
def testResults = parseTestNG.parse(resultsXmlFile.absolutePath)
testResults.testMethods.each {
    println it.key + ' ' + it.value.tmStatus + ' ' + it.value.tmSignature + ' ' + it.value.tmClassPath
}

