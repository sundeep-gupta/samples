import groovy.lang.Binding;
import groovy.util.GroovyScriptEngine;

String[] roots =  { "/home/skgupta/" };
GroovyScriptEngine gse = new GroovyScriptEngine(roots);
Binding binding = new Binding("one");
// binding.setVariable("input", "world");
try {
    // Set the stdout and stderr to different files.
    gse.run("groovy-examples/mapex.groovy", binding);
    println "Successfully completed the execution." 
}
catch (ArrayIndexOutOfBoundsException e) {
    println "Script mapex.groovy failed : " + e.message;
}
