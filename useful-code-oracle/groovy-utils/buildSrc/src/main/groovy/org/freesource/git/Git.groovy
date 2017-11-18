package org.freesource.git
import groovy.util.logging.Log

@Log
public class Git {
    File gitStorage
    String repoName
    String remoteUrl
    File repoRoot

    public Git(String remoteUrl, String repoName, File gitStorage) {
        this.gitStorage = gitStorage
        this.repoName = repoName
        this.remoteUrl = remoteUrl
        this.repoRoot = new File("${gitStorage.absolutePath}/${repoName}")
    }


    String clone()  {
        String cloneUrl = "${remoteUrl}:emaas/${repoName}.git"
        String cloneDir = "${gitStorage.absolutePath}/${repoName}"

        String cloneCmd = "cd ${gitStorage.absolutePath}; git clone ${cloneUrl} ${cloneDir}"
        print "\tCloning repository..."
        log.info "\tCloning ${repoName}: $cloneCmd"
        String cloneOutput = ['sh', '-c', cloneCmd].execute().text.trim()
        log.info cloneOutput
        if (!new File(cloneDir).exists()) {
            throw new Exception("Failed to clone the git repository.")
        }
        this.repoRoot = new File(cloneDir)
    }

    void pullLatest() {
        String gitCmd = "cd ${repoRoot.absolutePath}; git pull origin master"
        log.info gitCmd
        String output = ['sh', '-c', gitCmd].execute().text.trim()
        log.info output
        println output
    }

    void uncheckoutAll() {
        String gitCmd = "cd ${repoRoot.absolutePath}; git checkout -- ."
        log.info gitCmd
        String output = ['sh', '-c', gitCmd].execute().text.trim()
        log.info output
        println output

    }

    void createBranch(String branchName) {
        String gitCmd = "cd ${repoRoot.absolutePath}; git checkout -b ${branchName}"
        log.info gitCmd
        String output = ['sh', '-c', gitCmd].execute().text.trim()
        log.info output
        println output
    }

    String add(String... files) {
        String addCmd = "git add "
        files.each { file ->
            addCmd = addCmd + file + ' '
        }
        String gitAddCmd = "cd ${repoRoot.absolutePath}; ${addCmd}"
        log.info gitAddCmd
        String output = ['sh', '-c', gitAddCmd].execute().text.trim()
        log.info output
        return
    }

    String commitAll(String message) {
        String gitCommitCmd = "cd ${repoRoot.absolutePath}; git commit -a -m '${message}'"
        log.info gitCommitCmd
        String output = ['sh', '-c', gitCommitCmd].execute().text.trim()
        log.info output
        return
    }

    String checkoutBranch(String branchName) {
        String gitCommitCmd = "cd ${repoRoot.absolutePath}; git checkout ${branchName}"
        log.info gitCommitCmd
        String output = ['sh', '-c', gitCommitCmd].execute().text.trim()
        log.info output
        return

    }
}
