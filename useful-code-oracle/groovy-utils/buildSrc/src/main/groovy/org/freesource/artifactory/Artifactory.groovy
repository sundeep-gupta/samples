package org.freesource.artifactory

import groovy.json.*

class Artifactory {
    private static final String REST_STORAGE = 'api/storage'
    private static final String REST_SEARCH = 'api/search/artifact?'
    
    String artifactoryURL

    String authString

    String userName

    public Artifactory(String url, String userName, String password) {
        this.userName = userName
        this.artifactoryURL = url
        this.authString = "${userName}:${password}".getBytes().encodeBase64().toString()
    }

    public def restCall(String url, String method = "GET") {
        print "${method}: ${url}"
        def conn = url.toURL().openConnection()
        conn.setRequestProperty("Authorization", "Basic " + authString);
        conn.setRequestMethod(method)
        return conn
    }

    public def quickSearch(String name, String... repos) {
        String url = "${artifactoryURL}/${REST_SEARCH}name=${name}"
        if (repos.length > 0) {
            url = url + "&repos=${repos.join(',')}"
        }
        def conn = this.restCall(url)
        if (conn.responseCode != 200) {
            throw new Exception("Search failed. ${url} : ${conn.responseCode} : ${conn.responseMessage}")
        }
        println "... OK"
        return this.getJsonResponse(conn)
    }


    public void deleteItem(String repoKey, String path) {
        String url = "${artifactoryURL}/${repoKey}/${path}"
        def conn = this.restCall(url, 'DELETE')
        if( conn.responseCode != 200 && conn.responseCode != 204) {
            throw new Exception("Failed to delete the build artifacts from artifactory for ${url} : ${conn.responseCode} : ${conn.responseMessage}")
        }
        println "... OK"
    }

    public def getFolderInfo(String repoKey, String path) {
        String url = "${artifactoryURL}/${REST_STORAGE}/${repoKey}/${path}"
        def conn = this.restCall(url)
        if (conn.responseCode != 200) {
            throw new Exception("Failed to get the storage list for ${url} : ${conn.responseCode} : ${conn.responseMessage}")
        }
        println "... OK"
        def response = this.getJsonResponse(conn)
    }
    public def getRepoInfo(String repoKey) {
        String url = "${artifactoryURL}/api/repositories/${repoKey}"
        def conn = this.restCall(url)
        if (conn.responseCode != 200) {
            throw new Exception("Failed to get the storage list for ${url} : ${conn.responseCode} : ${conn.responseMessage}")
        }
        println " ... OK"
        println this.getJsonResponse(conn)
    }
    private def getJsonResponse(def conn) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuffer response = new StringBuffer();
        String inputLine;
        while ((inputLine = reader.readLine()) != null) {
            response.append(inputLine)
        }
        reader.close();
        def slurper = new JsonSlurper()
        def json = slurper.parseText(response.toString())
        return json

    }
}

