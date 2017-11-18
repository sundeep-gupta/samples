
public class EmaasGitRepository {
    String reposName 

    public EmaasGitRepository(String reposName) {
        this.reposName = reposName
        // TODO: Validate the name against valid names.
    }

    public void clone(String destDir, String branch = null) {
        String cloneUrl = "git@orahub.oraclecorp.com:emaas/${repoName}.git"

        String cloneCmd = "cd ${cloneDir.parentFile.absolutePath}; git clone ${cloneUrl} ${cloneDir}"
        
        String cloneOutput = ['sh', '-c', cloneCmd].execute().text.trim()
        if (!new File(cloneDir).exists()) {
            throw new Exception("Failed to clone repository, ${reposName}")
        }
    }
}

def version = args[0]
def repositories = ['emcdms', 'emcpdf', 'emcpsf', 'emcpssf', 'emcitas', 'emcpdm', 'emcpsm', 'emcpwd', 'emcapms', 'emclas', 'emcpdp', 'emcpsrvs', 'emctas']
// repositories = ['emcpdf']
File gitStorage = new File('/scratch/skgupta/git_storage/INTEGRATION')
if (!gitStorage.exists()) {
    gitStorage.mkdir()
}
repositories.each { repoName ->
    println "-----------------------------------------------------------------------------------------------"
    println " ${repoName}"
    println "-----------------------------------------------------------------------------------------------"

    String cloneDir = "${gitStorage.absolutePath}/${repoName}"
    EmaasGitRepository gitRepos = new EmaasGitRepository(repoName)
    try {
        print "\tCloning repository..."
        gitRepos.clone(cloneDir)
        println "OK"
    }
    catch (Exception e) {
        println " FAILED"
        println "\tIntegration run SKIPPED."
        return;
    }
    try {
        print "\tSubmitting farm for COMPONENT level LRGs."
        FarmUtils.submitJob(cloneDir, [], ['pipeline': 'COMPONENT', 'config': "ORG_GRADLE_PROJECT_testinfraVersion=${version}", 'desc': "${repoName}-${version}"])
    }
    catch(Exception e) {
        println "FAILED."
        println e.message
    }
}
