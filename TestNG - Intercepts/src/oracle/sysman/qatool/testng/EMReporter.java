package oracle.sysman.qatool.testng;

import org.testng.IReporter;
import org.testng.ISuite;
import org.testng.ISuiteResult;
import org.testng.ITestContext;
import org.testng.ITestNGMethod;
import org.testng.Reporter;
import org.testng.internal.Utils;
import org.testng.reporters.XMLReporterConfig;
import org.testng.reporters.XMLStringBuffer;
import org.testng.reporters.XMLSuiteResultWriter;
import org.testng.xml.XmlSuite;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

/**
 * The main entry for the XML generation operation
 *
 * @author 
 */
public class EMReporter implements IReporter {

  private final XMLReporterConfig config = new XMLReporterConfig();
  private XMLStringBuffer rootBuffer;

  @Override
  public void generateReport(List<XmlSuite> xmlSuites, List<ISuite> suites, String outputDirectory) {
	  // if output directory not set, then set it.
	  System.out.println("Sundeep the directory s " + config.getOutputDirectory() + outputDirectory);
    if (Utils.isStringEmpty(config.getOutputDirectory())) {
      config.setOutputDirectory(outputDirectory);
    }

    rootBuffer = new XMLStringBuffer("");
    rootBuffer.push(XMLReporterConfig.TAG_TESTNG_RESULTS);
     writeReporterOutput(rootBuffer);
    for (int i = 0; i < suites.size(); i++) {
      writeSuite(suites.get(i).getXmlSuite(), suites.get(i));
    }
    
    rootBuffer.pop();
    Utils.writeUtf8File(config.getOutputDirectory(), "abeer-results.xml", rootBuffer.toXML());
  }

  	private void writeReporterOutput(XMLStringBuffer xmlBuffer) {
  		//TODO: Cosmin - maybe a <line> element isn't indicated for each line
  		xmlBuffer.push(XMLReporterConfig.TAG_REPORTER_OUTPUT);
  		List<String> output = Reporter.getOutput();
  		for (String line : output) {
  			if (line != null) {
  				xmlBuffer.push(XMLReporterConfig.TAG_LINE);
  				xmlBuffer.addCDATA(line);
  				xmlBuffer.pop();
  			}
  		}
  		xmlBuffer.pop();
  	}

  	private void writeSuite(XmlSuite xmlSuite, ISuite suite) {
  		System.out.println("Value of FF" + config.getFileFragmentationLevel());
  		switch (config.getFileFragmentationLevel()) {
  		case XMLReporterConfig.FF_LEVEL_NONE:
  			writeSuiteToBuffer(rootBuffer, suite);
  			break;
  		case XMLReporterConfig.FF_LEVEL_SUITE:
  		case XMLReporterConfig.FF_LEVEL_SUITE_RESULT:
  			File suiteFile = referenceSuite(rootBuffer, suite);
  			writeSuiteToFile(suiteFile, suite);
  		}
  	}

  	private void writeSuiteToFile(File suiteFile, ISuite suite) {
  		XMLStringBuffer xmlBuffer = new XMLStringBuffer("");
  		writeSuiteToBuffer(xmlBuffer, suite);
  		File parentDir = suiteFile.getParentFile();
  		if (parentDir.exists() || suiteFile.getParentFile().mkdirs()) {
  			Utils.writeFile(parentDir.getAbsolutePath(), "testng-results.xml", xmlBuffer.toXML());
  		}
  	}

  private File referenceSuite(XMLStringBuffer xmlBuffer, ISuite suite) {
    String relativePath = suite.getName() + File.separatorChar + "testng-results.xml";
    File suiteFile = new File(config.getOutputDirectory(), relativePath);
    Properties attrs = new Properties();
    attrs.setProperty(XMLReporterConfig.ATTR_URL, relativePath);
    xmlBuffer.addEmptyElement(XMLReporterConfig.TAG_SUITE, attrs);
    return suiteFile;
  }

  private void writeSuiteToBuffer(XMLStringBuffer xmlBuffer, ISuite suite) {
    xmlBuffer.push(XMLReporterConfig.TAG_SUITE, getSuiteAttributes(suite));
    writeSuiteGroups(xmlBuffer, suite);
    
    Map<String, ISuiteResult> results = suite.getResults();
    XMLSuiteResultWriter suiteResultWriter = new XMLSuiteResultWriter(config);
    for (Map.Entry<String, ISuiteResult> result : results.entrySet()) {
      suiteResultWriter.writeSuiteResult(xmlBuffer, result.getValue());
    }

    xmlBuffer.pop();
  }

  private void writeSuiteGroups(XMLStringBuffer xmlBuffer, ISuite suite) {
    xmlBuffer.push(XMLReporterConfig.TAG_GROUPS);
    Map<String, Collection<ITestNGMethod>> methodsByGroups = suite.getMethodsByGroups();
    for (String groupName : methodsByGroups.keySet()) {
      Properties groupAttrs = new Properties();
      //groupAttrs.setProperty(XMLReporterConfig.ATTR_NAME, groupName);
      xmlBuffer.push(XMLReporterConfig.TAG_GROUP, groupAttrs);
      Set<ITestNGMethod> groupMethods = getUniqueMethodSet(methodsByGroups.get(groupName));
      System.out.println("Group Lengths is  " + groupName + groupMethods.size());
      for (ITestNGMethod groupMethod : groupMethods) {
        Properties methodAttrs = new Properties();
        methodAttrs.setProperty(XMLReporterConfig.ATTR_NAME, groupMethod.getMethodName());    
        
        oracle.sysman.qatool.testng.EMTest t = groupMethod.getMethod().getAnnotation( oracle.sysman.qatool.testng.EMTest.class);
        methodAttrs.setProperty("testCaseDesc", t.description());
        // methodAttrs.setProperty(XMLReporterConfig.ATTR_METHOD_SIG, "abeer");
        xmlBuffer.push(XMLReporterConfig.TAG_METHOD, methodAttrs);
        xmlBuffer.pop();
        
      }
      xmlBuffer.pop();
    }
    xmlBuffer.pop();
  }

  private Properties getSuiteAttributes(ISuite suite) {
    Properties props = new Properties();
    props.setProperty(XMLReporterConfig.ATTR_NAME, suite.getName());

    // Calculate the duration
    Map<String, ISuiteResult> results = suite.getResults();
    Date minStartDate = new Date();
    Date maxEndDate = null;
    // TODO: We could probably optimize this in order not to traverse this twice
    for (Map.Entry<String, ISuiteResult> result : results.entrySet()) {
      ITestContext testContext = result.getValue().getTestContext();
      Date startDate = testContext.getStartDate();
      Date endDate = testContext.getEndDate();
      if (minStartDate.after(startDate)) {
        minStartDate = startDate;
      }
      if (maxEndDate == null || maxEndDate.before(endDate)) {
        maxEndDate = endDate != null ? endDate : startDate;
      }
    }

    // The suite could be completely empty
    if (maxEndDate == null) maxEndDate = minStartDate;
    addDurationAttributes(config, props, minStartDate, maxEndDate);
    return props;
  }

  /**
   * Add started-at, finished-at and duration-ms attributes to the <suite> tag
   */
  public static void addDurationAttributes(XMLReporterConfig config, Properties attributes,
      Date minStartDate, Date maxEndDate) {
    SimpleDateFormat format = new SimpleDateFormat(config.getTimestampFormat());
    String startTime = format.format(minStartDate);
    String endTime = format.format(maxEndDate);
    long duration = maxEndDate.getTime() - minStartDate.getTime();

   // attributes.setProperty(XMLReporterConfig.ATTR_STARTED_AT, startTime);
  //  attributes.setProperty(XMLReporterConfig.ATTR_FINISHED_AT, endTime);
  //  attributes.setProperty(XMLReporterConfig.ATTR_DURATION_MS, Long.toString(duration));
  }

  private Set<ITestNGMethod> getUniqueMethodSet(Collection<ITestNGMethod> methods) {
    Set<ITestNGMethod> result = new LinkedHashSet<ITestNGMethod>();
    for (ITestNGMethod method : methods) {
      result.add(method);
    }
    return result;
  }

  
}