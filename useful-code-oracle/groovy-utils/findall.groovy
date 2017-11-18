def results = ['/net/slcnas551/export/farm_results/EMDICSI_MASTER_LINUX.X64_T20763433', 
    '/net/slcnas551/export/farm_results/EMDICSI_MASTER_LINUX.X64_T20764949']
results.each { res ->
    println '-----------------------------------------------------------------------------'
    println res
    println '-----------------------------------------------------------------------------'
    File sf = new File(res)
    long consoleSize = 0;
    long browserLog = 0;
    long testClassesSize = 0
    long firefoxSize = 0
    sf.eachFileRecurse { f ->
    /*
        if (f.name.equals('console.log')) {
            consoleSize += f.size();
        }
        else if (f.name.equals('firefox_browser.log')) {
            browserLog += f.size();
        }
        else if (f.name.equals('testClasses') && f.isDirectory()) {
            testClassesSize += directorySize(f)
        } else
        */
        if (f.name.equals('firefox') && f.parentFile.parentFile.absolutePath.equals(res) && f.isDirectory()) {
            firefoxSize += directorySize(f)
        }
    }

    println "Size of console logs " + consoleSize
    println "Size of browser logs " + browserLog
    println "Size of testClasses " + testClassesSize
    println "Size of firefox " + firefoxSize
    println "\n"
}

long directorySize(File f) {
    long s = 0;
    f.eachFileRecurse { it ->
        if (it.isFile()) { s+= it.size() }
    
    }
    return s
}
