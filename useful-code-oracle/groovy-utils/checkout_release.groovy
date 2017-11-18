String dir = '/scratch/skgupta/git_storage/OMC_ROOT'
String release = 'master'
new File(dir).eachDir { file -> 
        println "${file.name}"
        String absPath = file.absolutePath;
        //String cmd = "cd ${absPath} && git checkout RELEASE_1.20.0"
        String cmd = "cd ${absPath} && git checkout -- . && git fetch && git checkout ${release} && git pull origin ${release}"
        def stdout = new StringBuilder(); def stderr = new StringBuilder(); def exitCode = 1
        def proc = new ProcessBuilder("bash", "-c", cmd).start()
        proc.waitForProcessOutput(stdout, stderr); exitCode = proc.exitValue()
        println stdout
    }
