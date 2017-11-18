
package com.oracle.gradle.vncserver

class VNCServer {

    public static void start(VNCServerTaskExtension config) throws Exception {
        println "Code to start the VNC here... at " + config.getDisplayString()
    }

    public static void stop(VNCServerTaskExtension config) {
        println "Code to stop the VNC here..." + config.getDisplayString()
    }

}

