import java.nio.file.Files

def validateArgs(String... args) {
    if (args.length == 0) {
        println "Script needs two arguments.\n1. Location of the maven local build from Sprint tester job.\n2. Name of the emdi branch which will be merged."
        System.exit(1)
    }
    String emdiBuild = args[0]
    if (!new File(emdiBuild).exists()) {
        throw new FileNotFoundException("Local maven location, ${emdiBuild}, not found.")   
    }
    def options = [:]
    options['landingBranch'] = args[1]
    options['emdiBuild'] = emdiBuild

    return options
}

void cloneAllRepos(def options) {
    String command = "gradle -b ${options['gradleUtils']} cloneAllRepos -PEMDI_LOCAL_REPO=${options['emdiBuild']}"
    runCommand(command)
}

void runCommand(String command, def options) {
    Process process = command.execute()
    process.consumeProcessOutput(options['out'], options['err'])
    process.waitFor()
    return
}

void moveRootDir(def options) {
    String rootDir_bkp = options['rootDir'] + '_' + new Date().format( 'yyyyMMdd' )
    if (new File(options['rootDir']).exists()) {
        print "${options['rootDir']} exists, moving it to $rootDir_bkp}"
        Files.move(new File(options['rootDir']).toPath(), new File(rootDir_bkp).toPath())
    }
}

void submitComponentLrgs(def options) {
    String command = "gradle -b ${options['gradleUtils']} submitComponentLrgs -PEMDI_LOCAL_REPO=${options['emdiBuild']}"
}

def main() {
    def options = validateArgs(args)
    options['out'] = new StringBuffer()
    options['err'] = new StringBuffer()
    options['gradleUtils'] = '/scratch/skgupta/groovy-utils/build.gradle'


    options['rootDir'] = '/scratch/skgupta/git_storage/INTEGRATION'
    // STEP 1 : Move the INTEGRATION Folder if exists.
    moveRootDir(options)

    // STEP 2: Clone all repositories 
    cloneAllRepos(options);

    // STEP 3: Submit L1 run for all repositories
    submitComponentLrgs(options);

    // STEP 4: Sumit L2 run for all OMC Repositories
    submitProductLrgs(options);

    // STEP 5: Submit emdi lrgs in ADE
    // ade useview sprint-testing -exec 'ade refreshview -latest' -exec 'smpfarm emdi_testinfra_xrepos -config ORG_GRADLE_PROJECT_PUB_MAVEN_MY_MAVEN_REPO=/net/slc11kpr/scratch/EMDI-SPRINT-TESTING/maven_home/0.0.50-20170423062437'
}

main()
