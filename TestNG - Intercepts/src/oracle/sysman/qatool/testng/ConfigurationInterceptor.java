package oracle.sysman.qatool.testng;

import org.testng.IConfigurationListener;
import org.testng.ITestResult;

public class ConfigurationInterceptor implements IConfigurationListener {

	@Override
	public void onConfigurationSuccess(ITestResult itr) {
		System.out.println("OnConfigurationSuccess " + itr.getStatus());
		//itr.setStatus(ITestResult.SKIP);
	}

	@Override
	public void onConfigurationFailure(ITestResult itr) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onConfigurationSkip(ITestResult itr) {
		// TODO Auto-generated method stub

	}

}
