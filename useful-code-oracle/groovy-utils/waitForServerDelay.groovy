import groovy.time.*;

File resultLocation = new File('/net/slcnas552/export/farm_base_results/EMDICSI_MASTER_LINUX.X64_170718.091041')
def resultLocations = [
        '20458059': '/net/slcnas552/export/farm_base_results/EMDICSI_MASTER_LINUX.X64_170718.091041',
        '20462277': '/net/slcnas552/export/farm_base_results/EMDICSI_MASTER_LINUX.X64_170718.211016']
resultLocations = [ '1235' : '/net/slcnas551/export/farm_results/EMCPDF_MASTER_LINUX.X64_T20457338']
resultLocations.each { jobid, location -> 
    println "Scanning for ${jobid}"
    resultLocation = new File(location)
    repoMap = getRepoWiseTime(resultLocation)
    File jobResult = new File(jobid)
    jobResult.withWriter { writer ->
       repoMap.each { lrgName, time ->
            if (time > 0) {
                writer.println "${lrgName},${time/1000}"
            }
        }
    }
}

    
Map<String, Long> getRepoWiseTime(File resultLocation) {
    def timeMap = [:]
    def repoMap = [:]
    resultLocation.eachDir { lrg -> 
        // Check if latest firefox
        if (!new File(lrg, 'firefox/45.9.0').exists()) {
            println "SKIPPING as ${lrg.absolutePath}/firefox/45.9.0 does not exist."
            return
        }
        long lrgTime = 0
        timeMap[lrg.name] = [:]
        lrg.eachFile { file ->
            if (!file.name.endsWith('-webdriver.log')) {
                return
            }
            long fileTime = findImplicitTimeInWaitForServer(file)
            timeMap[lrg.name][file.name] = fileTime
 //           println "${lrg.name} : ${file.name} : ${fileTime}"
            lrgTime += fileTime
        }
        repoMap[lrg.name]  = lrgTime
        println "Total additional time from ${lrg.name} ${lrgTime}"
    }
    return repoMap;
}
long findImplicitTimeInWaitForServer(File file) {
    long fileTime = 0L
    String startTime = null
    file.eachLine { line ->
        if (line.contains('Checking if the element with locator')) {
            startTime = line.tokenize('[')[0].trim()
            return
        }
        if (startTime != null && 
                (line.contains('isLoadingDone: Element with locator, busyind not present') || line.contains('isLoadingDone: Element with locator, busyind not present'))) {
            endTime = line.tokenize('[')[0].trim()
            def s = Date.parse("DD/MM/YYYY HH:mm:ss.SSS", startTime)
            def e = Date.parse("DD/MM/YYYY HH:mm:ss.SSS", endTime)
            long timeTaken = TimeCategory.minus(e, s).toMilliseconds()
            if (timeTaken > 1000) {
                fileTime += timeTaken
            }
        }
        startTime = null
    }
    return  fileTime
}

