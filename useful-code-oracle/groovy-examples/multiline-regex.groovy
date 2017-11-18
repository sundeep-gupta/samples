def farmOutput = """
smpfarm 1.3.273
Copyright (c) 2006, 2015, Oracle and/or its affiliates. All rights reserved.
--------------------------------------------------------------------------------
farm command used:
    /usr/local/bin/farm submit -config "ORG_GRADLE_PROJECT_testinfraVersion=115.1+" -desc "emcpdf-115.1+" lrgemcpdf_dashboard_uitest_3n lrgemcpdf_dev_test_3n lrgemcpdf_qa_test_3n
    --------------------------------------------------------------------------------

    Submitting your farm job now ...
    Farm Command Line - 2.9
    Command used: -config ORG_GRADLE_PROJECT_testinfraVersion=115.1+ -desc emcpdf-115.1+ lrgemcpdf_dashboard_uitest_3n lrgemcpdf_dev_test_3n lrgemcpdf_qa_test_3n
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                       Dload  Upload   Total   Spent    Left  Speed
                                       111   444  111   444    0     0   1623      0 --:--:-- --:--:-- --:--:--  6166
                                         % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                                                          Dload  Upload   Total   Spent    Left  Speed
                                                                            0    28    0    28    0     0    110      0 --:--:-- --:--:-- --:--:--   518

                                                                            Submission Metadata:
                                                                            Repo Origin = git@orahub.oraclecorp.com:emaas/emcpdf.git
                                                                            Repo Name   = emcpdf
                                                                            Current Branch  = master
                                                                            Commit ID   = 7eac58bb2d5bb8bc9b056ee31683c0e743d2bbcd
                                                                            Commit Author = emrel_us@oracle.com
                                                                            Commit Date = 2015-05-27 23:09:17
                                                                            Parent Branch   = master
                                                                            Parent Commit ID    = d89c1c7314d8ee0b2fa071fc9e5a76d86d8ba270
                                                                            Parent Commit Author = miao.yu@oracle.com
                                                                            Parent Commit Date = 2015-05-25 18:20:01
                                                                            Commit Series   = EMCPDF_MASTER_LINUX.X64
                                                                            Commit Name = EMCPDF_MASTER_LINUX.X64_150525.182001
                                                                            REPO_ROOT: /scratch/skgupta/git_storage/INTEGRATION/emcpdf
                                                                            INFO: Executing "gradle verify_lrg -Plrgs=lrgemcpdf_dashboard_uitest_3n" from /scratch/skgupta/git_storage/INTEGRATION/emcpdf
                                                                            Applying codeCoverage.gradle... (#V: Wed Jul 09 2014#)
                                                                            Creating properties on demand (a.k.a. dynamic properties) has been deprecated and is scheduled to be removed in Gradle 2.0. Please read http://gradle.org/docs/current/dsl/org.gradle.api.plugins.ExtraPropertiesExtension.html for information on the replacement for dynamic properties.
                                                                            Deprecated dynamic property: "ccEnv" on "root project 'emcpdf'", value: "test".
                                                                            Deprecated dynamic property: "ccSettings" on "root project 'emcpdf'", value: "{sonarHost=http://slc0...".
                                                                            * Using CC Sonar server: http://slc07dsz.us.oracle.com:9000
                                                                            Deprecated dynamic property: "destPath" on "task ':mergeData'", value: "/scratch/skgupta/git_s...".
                                                                            Deprecated dynamic property: "transitive" on "project ':dashboards-entities'", value: "false".
                                                                            Deprecated dynamic property "transitive" created in multiple locations.
                                                                            Deprecated dynamic property: "environment" on "project ':dashboards-ee'", value: "dev".
                                                                            Deprecated dynamic property: "appServerconfig" on "project ':dashboards-ee'", value: "{serverName=slc00bqs.u...".
                                                                            Files copied successfully to /scratch/skgupta/git_storage/INTEGRATION/emcpdf/dist/opt/ORCLemaas/Applications/emaas-applications-dashboards/0.1-SNAPSHOT/emaas-applications-dashboards-schema
                                                                            Deprecated dynamic property "environment" created in multiple locations.
                                                                            Deprecated dynamic property "appServerconfig" created in multiple locations.
                                                                            Cannot publish pom for project ':dashboardscommon-ui:dashboardscommon-ui-ee' since it does not contain the Maven plugin install task and task ':dashboardscommon-ui:dashboardscommon-ui-ee:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboardscommon-ui' since it does not contain the Maven plugin install task and task ':dashboardscommon-ui:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-schema' since it does not contain the Maven plugin install task and task ':dashboards-schema:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboardscommon-ui:dashboardscommon-ui-web' since it does not contain the Maven plugin install task and task ':dashboardscommon-ui:dashboardscommon-ui-web:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ee' since it does not contain the Maven plugin install task and task ':dashboards-ee:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ui:dashboardsui-webutils' since it does not contain the Maven plugin install task and task ':dashboards-ui:dashboardsui-webutils:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ui:dashboardsui-web' since it does not contain the Maven plugin install task and task ':dashboards-ui:dashboardsui-web:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ui' since it does not contain the Maven plugin install task and task ':dashboards-ui:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ui:dashboardsui-ee' since it does not contain the Maven plugin install task and task ':dashboards-ui:dashboardsui-ee:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-entities' since it does not contain the Maven plugin install task and task ':dashboards-entities:artifactoryPublish' does not specify a custom pom path.
                                                                            :verify_lrg
                                                                            LRG, lrgemcpdf_dashboard_uitest_3n, is a valid lrg.

                                                                            BUILD SUCCESSFUL

                                                                            Total time: 4.667 secs

                                                                            INFO: LRG lrgemcpdf_dashboard_uitest_3n is Valid.
                                                                            REPO_ROOT: /scratch/skgupta/git_storage/INTEGRATION/emcpdf
                                                                            INFO: Executing "gradle verify_lrg -Plrgs=lrgemcpdf_dev_test_3n" from /scratch/skgupta/git_storage/INTEGRATION/emcpdf
                                                                            Applying codeCoverage.gradle... (#V: Wed Jul 09 2014#)
                                                                            Creating properties on demand (a.k.a. dynamic properties) has been deprecated and is scheduled to be removed in Gradle 2.0. Please read http://gradle.org/docs/current/dsl/org.gradle.api.plugins.ExtraPropertiesExtension.html for information on the replacement for dynamic properties.
                                                                            Deprecated dynamic property: "ccEnv" on "root project 'emcpdf'", value: "test".
                                                                            Deprecated dynamic property: "ccSettings" on "root project 'emcpdf'", value: "{sonarHost=http://slc0...".
                                                                            * Using CC Sonar server: http://slc07dsz.us.oracle.com:9000
                                                                            Deprecated dynamic property: "destPath" on "task ':mergeData'", value: "/scratch/skgupta/git_s...".
                                                                            Deprecated dynamic property: "transitive" on "project ':dashboards-entities'", value: "false".
                                                                            Deprecated dynamic property "transitive" created in multiple locations.
                                                                            Deprecated dynamic property: "environment" on "project ':dashboards-ee'", value: "dev".
                                                                            Deprecated dynamic property: "appServerconfig" on "project ':dashboards-ee'", value: "{serverName=slc00bqs.u...".
                                                                            Files copied successfully to /scratch/skgupta/git_storage/INTEGRATION/emcpdf/dist/opt/ORCLemaas/Applications/emaas-applications-dashboards/0.1-SNAPSHOT/emaas-applications-dashboards-schema
                                                                            Deprecated dynamic property "environment" created in multiple locations.
                                                                            Deprecated dynamic property "appServerconfig" created in multiple locations.
                                                                            Cannot publish pom for project ':dashboards-ee' since it does not contain the Maven plugin install task and task ':dashboards-ee:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-schema' since it does not contain the Maven plugin install task and task ':dashboards-schema:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ui:dashboardsui-ee' since it does not contain the Maven plugin install task and task ':dashboards-ui:dashboardsui-ee:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboardscommon-ui' since it does not contain the Maven plugin install task and task ':dashboardscommon-ui:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ui' since it does not contain the Maven plugin install task and task ':dashboards-ui:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ui:dashboardsui-webutils' since it does not contain the Maven plugin install task and task ':dashboards-ui:dashboardsui-webutils:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ui:dashboardsui-web' since it does not contain the Maven plugin install task and task ':dashboards-ui:dashboardsui-web:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboardscommon-ui:dashboardscommon-ui-ee' since it does not contain the Maven plugin install task and task ':dashboardscommon-ui:dashboardscommon-ui-ee:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-entities' since it does not contain the Maven plugin install task and task ':dashboards-entities:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboardscommon-ui:dashboardscommon-ui-web' since it does not contain the Maven plugin install task and task ':dashboardscommon-ui:dashboardscommon-ui-web:artifactoryPublish' does not specify a custom pom path.
                                                                            :verify_lrg
                                                                            LRG, lrgemcpdf_dev_test_3n, is a valid lrg.

                                                                            BUILD SUCCESSFUL

                                                                            Total time: 5.267 secs

                                                                            INFO: LRG lrgemcpdf_dev_test_3n is Valid.
                                                                            REPO_ROOT: /scratch/skgupta/git_storage/INTEGRATION/emcpdf
                                                                            INFO: Executing "gradle verify_lrg -Plrgs=lrgemcpdf_qa_test_3n" from /scratch/skgupta/git_storage/INTEGRATION/emcpdf
                                                                            Applying codeCoverage.gradle... (#V: Wed Jul 09 2014#)
                                                                            Creating properties on demand (a.k.a. dynamic properties) has been deprecated and is scheduled to be removed in Gradle 2.0. Please read http://gradle.org/docs/current/dsl/org.gradle.api.plugins.ExtraPropertiesExtension.html for information on the replacement for dynamic properties.
                                                                            Deprecated dynamic property: "ccEnv" on "root project 'emcpdf'", value: "test".
                                                                            Deprecated dynamic property: "ccSettings" on "root project 'emcpdf'", value: "{sonarHost=http://slc0...".
                                                                            * Using CC Sonar server: http://slc07dsz.us.oracle.com:9000
                                                                            Deprecated dynamic property: "destPath" on "task ':mergeData'", value: "/scratch/skgupta/git_s...".
                                                                            Deprecated dynamic property: "transitive" on "project ':dashboards-entities'", value: "false".
                                                                            Deprecated dynamic property "transitive" created in multiple locations.
                                                                            Deprecated dynamic property: "environment" on "project ':dashboards-ee'", value: "dev".
                                                                            Deprecated dynamic property: "appServerconfig" on "project ':dashboards-ee'", value: "{serverName=slc00bqs.u...".
                                                                            Files copied successfully to /scratch/skgupta/git_storage/INTEGRATION/emcpdf/dist/opt/ORCLemaas/Applications/emaas-applications-dashboards/0.1-SNAPSHOT/emaas-applications-dashboards-schema
                                                                            Deprecated dynamic property "environment" created in multiple locations.
                                                                            Deprecated dynamic property "appServerconfig" created in multiple locations.
                                                                            Cannot publish pom for project ':dashboards-ee' since it does not contain the Maven plugin install task and task ':dashboards-ee:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboardscommon-ui:dashboardscommon-ui-web' since it does not contain the Maven plugin install task and task ':dashboardscommon-ui:dashboardscommon-ui-web:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ui:dashboardsui-ee' since it does not contain the Maven plugin install task and task ':dashboards-ui:dashboardsui-ee:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-entities' since it does not contain the Maven plugin install task and task ':dashboards-entities:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboardscommon-ui' since it does not contain the Maven plugin install task and task ':dashboardscommon-ui:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ui:dashboardsui-webutils' since it does not contain the Maven plugin install task and task ':dashboards-ui:dashboardsui-webutils:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ui:dashboardsui-web' since it does not contain the Maven plugin install task and task ':dashboards-ui:dashboardsui-web:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-ui' since it does not contain the Maven plugin install task and task ':dashboards-ui:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboards-schema' since it does not contain the Maven plugin install task and task ':dashboards-schema:artifactoryPublish' does not specify a custom pom path.
                                                                            Cannot publish pom for project ':dashboardscommon-ui:dashboardscommon-ui-ee' since it does not contain the Maven plugin install task and task ':dashboardscommon-ui:dashboardscommon-ui-ee:artifactoryPublish' does not specify a custom pom path.
                                                                            :verify_lrg
                                                                            LRG, lrgemcpdf_qa_test_3n, is a valid lrg.

                                                                            BUILD SUCCESSFUL

                                                                            Total time: 4.32 secs

                                                                            INFO: LRG lrgemcpdf_qa_test_3n is Valid.
                                                                            LRG list: lrgemcpdf_dashboard_uitest_3n,lrgemcpdf_dev_test_3n,lrgemcpdf_qa_test_3n.
                                                                            Logging in ... done
                                                                            get_farm_scheduler:SCHED_ZONE: UCF; EXEC_ZONE: UCF
                                                                            Submitting ... done
                                                                            Your submission ID (on LINUX.X64) is EMCPDF_MASTER_LINUX.X64_T14643245. Job # is 14643245
                                                                            Recording farm submission. Job # is 14643245
""".trim()
   // def matcher = farmOutput =~ /(?m)Recording\s+farm\s+submission\.\s+Job\s+#\s+\s+is\s+/
    String regex = "Recording"
    //Pattern p = Pattern.compile(regex, Pattern.MULTILINE)

    def matcher = farmOutput =~ /(?ms)Recording\s+farm\s+submission\.\s+Job\s+#\s+is\s+(.*)/
    if (matcher.find()) {
        println "OK, ${matcher.group(1)}"
        return
    }
    println "FAILED."
