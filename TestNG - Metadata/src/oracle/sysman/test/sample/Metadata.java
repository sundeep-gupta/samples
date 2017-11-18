package oracle.sysman.test.sample;
import org.testng.annotations.Test;


public class Metadata {
	@Test
	@TestMetadata (
			description="This test is to check the successful login.",
			steps = {"Open login page", "Enter username", "Enter password", "Click login button"},
			expectedResults = {"Login succeeds."}
	)
	public void doLogin() {
		// My login test code here
	}

}
