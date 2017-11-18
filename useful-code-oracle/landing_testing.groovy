String localEmdiBuild = '/net/slc11kpr/scratch/EMDI-SPRINT-TESTING/maven_home/0.0.50-20170817235454'
String buildFile = '/scratch/skgupta/groovy-utils/build.gradle'
String cloneAllRepos = "gradle -b ${buildFile} cloneAllRepos -PEMDI_LOCAL_REPO=${localEmdiBuild}"
String submitComponentLrgs = "gradle -b ${buildFile} cloneAllRepos -PEMDI_LOCAL_REPO=${localEmdiBuild} submitComponentLrgs"
String refreshView = "ade useview sprint-testing -exeex 'ade refreshview -latest'"
//String linuxLrgs = "ade useview 
cloneAllRepos.execute()
submitComponentLrgs.execute()

