package oracle.sysman.qatool.testng;

import java.util.ArrayList;
import java.util.List;

import org.testng.IMethodInstance;
import org.testng.IMethodInterceptor;
import org.testng.ITestContext;

public class MethodInterceptor implements IMethodInterceptor {

	@Override
	public List<IMethodInstance> intercept(List<IMethodInstance> methods,
			ITestContext context) {
		List<IMethodInstance> methods2 = new ArrayList<IMethodInstance>();
		System.out.println("intercept called" + context.getOutputDirectory());
		return methods;
	}

}
