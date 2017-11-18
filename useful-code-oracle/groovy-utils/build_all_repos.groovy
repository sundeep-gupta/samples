//def allRepos = ['emcpdp', 'emcpevms', 'emcplcm', 'emcpsf', 'emcpsm', 'emcpsrvs', 'emcpssf', 'emcpwd', 'emctas']
    def allRepos = ['emcapms', 'emcdms', 'emcitas', 'emclas', 'emcpa', 'emcpcs', 'emcpdf', 'emcpdm', 'emcpdp', 'emcpevms', 'emcplcm', 'emcpsf', 'emcpsm', 'emcpsrvs', 'emcpssf', 'emcpwd', 'emctas', 'emdist', 'emdicpi', 'emdi']

allRepos.each {
    StringBuffer out = new StringBuffer()
    StringBuffer err = new StringBuffer()
    println "Building ${it}"
    def proc = "gradle -p ${it} build pTMMR -x test -PlrgMetadata=1 -PBuildID=skgupta_test_lrgmetadata".execute()
    proc.waitForProcessOutput(out, err)
    println " Writing output file for ${it}"
    def f =new File("${it}.out")
    f << out

    println "Writing error file for ${it}"
    def fe = new File("${it}.err")
    fe << err
}


public buidAllRepos() {
allRepos.each {
    StringBuffer out = new StringBuffer()
    StringBuffer err = new StringBuffer()
    println "Building ${it}"
    def proc = "gradle -p ${it} clean build -x test -PtestinfraVersion=1113.1.+".execute()
    proc.waitForProcessOutput(out, err)
    println " Writing output file for ${it}"
    def f =new File("${it}.out")
    f << out

    println "Writing error file for ${it}"
    def fe = new File("${it}.err")
    fe << err
}
}


