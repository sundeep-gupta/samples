package com.oracle.gradle.vncserver
import javax.inject.Inject
import org.gradle.process.ProcessForkOptions
public class VNCServerTaskExtension {

    ProcessForkOptions task
    
    private String displayString

    String display

    String hostName

    @Inject
    public VNCServerTaskExtension(ProcessForkOptions task) {
        this.task = task
        this.display = 40
        this.hostName = 'slc03psl'
    }

    public String getDisplayString() {
        return hostName + ':' + display
    }

}
