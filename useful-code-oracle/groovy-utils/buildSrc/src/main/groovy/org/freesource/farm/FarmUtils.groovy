
package org.freesource.farm
public class FarmUtils {
    public static def getFilesToParse(String jobId, String lrgName) {
        
        File resultLocFile = FarmUtils.getResultLocation(jobId)
        def lrgLoc = new File(resultLocFile, lrgName)
        if (!lrgLoc.exists()) {
            println "ERROR: LRG ${lrgName} did not run in farm job ${jobId}"
            System.exit(1)
        }

        def lrgFiles = [new File("${resultLocFile.absolutePath}/${lrgName}/${lrgName}.farm.out"), new File("${resultLocFile.absolutePath}/${lrgName}/${lrgName}-gradle.out")]
        return lrgFiles
    }

    public static def submitJob(String cloneDir, List<String> lrgList, def options) {
        String opts = ""
        options.each { key, value ->
            opts = opts + " '-${key}' '${value}' "
        }
        String lrg = lrgList.join(' ')
        String farmCmd = "cd ${cloneDir}; smpfarm ${lrg} ${opts}"
        String farmOutput = ["sh", "-c", farmCmd].execute().text.trim()
        def matcher = farmOutput =~ /(?ms)Recording\s+farm\s+submission\.\s+Job\s+#\s+is\s+(.*)/
        if (matcher.find()) {
            return matcher.group(1)
        }
        throw new Exception(farmOutput)
    }

    public static File getResultLocation(String jobId) {
        String command  = "farm showdiffs -job ${jobId} | grep 'Results in' | cut -f3 -d' '"
        String resultLoc = ["sh", "-c", command].execute().text.trim()
        File resultLocFile = new File(resultLoc)
        if (!resultLocFile.exists()) {
            println "ERROR : Failed to get the result location of ${jobId}"
            System.exit(1)
        }
    }
}
