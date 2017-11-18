def list = ['file:/scratch/skgupta/git_storage/emdi/maven-home/emaas-branch-sandbox-local/skgupta_jira-emdi-3586_cbf_cutover/','file:/scratch/skgupta/git_storage/emdi/maven-home/emaas-branch-sandbox-local/skgupta_jira-emdi-3586_cbf_cutover/']

def str = '/scratch/skgupta/git_storage/emdi/maven-home/emaas-branch-sandbox-local/skgupta_jira-emdi-3586_cbf_cutover'

list.each { 
    print it  + '   ' 
    println it.contains(str)
}
