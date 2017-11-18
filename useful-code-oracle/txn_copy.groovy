def f = new File(args[0])
f.eachLine { line -> 
    println line
    if (new File("${System.env.EMDI_ROOT}/${line}").exists()) {
        runCommand("cp ${System.env.EMDI_ROOT}/${line} ${line}")
        runCommand("git add ${line}")
    }
    else {
        runCommand("git rm ${line}");
    }
}

def runCommand(def command) {
    def proc = new ProcessBuilder("sh", "-c", command).start()
    def stdout = new StringBuilder(); def stderr = new StringBuilder(); def exitCode = 1
    proc.waitForProcessOutput(stdout, stderr); exitCode = proc.exitValue()

}
