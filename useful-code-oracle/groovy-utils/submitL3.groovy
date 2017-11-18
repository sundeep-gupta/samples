String jobid = args[0]
String localMavenRepo = args[1]

String command = "farm showjobs -d -j ${jobid}"
def stdout = new StringBuilder(); def stderr = new StringBuilder(); def exitCode = 1
def proc = new ProcessBuilder("sh", "-c", command).start()
proc.waitForProcessOutput(stdout, stderr); exitCode = proc.exitValue()
List<String> configs = []
stdout.toString().split("\n").each { line ->
    if (line.contains('-config option')) {
        configs = line.split(':')[1]?.trim()?.split(';')
        configs.each { kv ->
            println kv
        }
    }
}

String submitFarm = "smpfarm -pipeline STAGE -config '" + configs.join(';') + "ORG_GRADLE_PROJECT_PUB_MAVEN_MY_MAVEN_REPO=${localMavenRepo}'";
println submitFarm
proc = new ProcessBuilder("sh", "-c", submitFarm).start()
stdout = new StringBuilder(); stderr = new StringBuilder()
proc.waitForProcessOutput(stdout, stderr);

println stdout


