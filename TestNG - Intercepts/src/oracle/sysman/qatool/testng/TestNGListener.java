/**
 * 
 */
package oracle.sysman.qatool.testng;

import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;
import org.testng.SkipException;

/**
 * @author skgupta
 *
 */
public class TestNGListener implements ITestListener {

	/* (non-Javadoc)
	 * @see org.testng.ITestListener#onTestStart(org.testng.ITestResult)
	 */
	@Override
	public void onTestStart(ITestResult result) {
		// TODO Auto-generated method stub
		System.out.println("Starting test");
		//throw new SkipException("Skipping test forcibly");
	}

	/* (non-Javadoc)
	 * @see org.testng.ITestListener#onTestSuccess(org.testng.ITestResult)
	 */
	@Override
	public void onTestSuccess(ITestResult result) {
		// TODO Auto-generated method stub
		System.out.println(ITestResult.SKIP);
		result.setStatus(ITestResult.FAILURE);
		System.out.println(result.getStatus());
	}

	/* (non-Javadoc)
	 * @see org.testng.ITestListener#onTestFailure(org.testng.ITestResult)
	 */
	@Override
	public void onTestFailure(ITestResult result) {

	}

	/* (non-Javadoc)
	 * @see org.testng.ITestListener#onTestSkipped(org.testng.ITestResult)
	 */
	@Override
	public void onTestSkipped(ITestResult result) {
		// TODO Auto-generated method stub
		System.out.println("tests are getting skipped");
	}

	/* (non-Javadoc)
	 * @see org.testng.ITestListener#onTestFailedButWithinSuccessPercentage(org.testng.ITestResult)
	 */
	@Override
	public void onTestFailedButWithinSuccessPercentage(ITestResult result) {
		// TODO Auto-generated method stub

	}

	/* (non-Javadoc)
	 * @see org.testng.ITestListener#onStart(org.testng.ITestContext)
	 */
	@Override
	public void onStart(ITestContext context) {
		// TODO Auto-generated method stub

	}

	/* (non-Javadoc)
	 * @see org.testng.ITestListener#onFinish(org.testng.ITestContext)
	 */
	@Override
	public void onFinish(ITestContext context) {
		// TODO Auto-generated method stub

	}

}
