package com.oracle.example.agile.bdd;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

import cucumber.api.PendingException;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for simple App.
 */
public class AppTest
{
	@Given("^The application is launched and available\\.$")
	public void the_application_is_launched_and_available() throws Throwable {
		System.out.println("I am opening the gmail page...");
	}

	@When("^User login to the app with the username and password$")
	public void user_login_to_the_app_with_the_username_and_password() throws Throwable {
		System.out.println("Entered the username and passwrodd.;");
	}

	@Then("^Verify the user login$")
	public void verify_the_user_login() throws Throwable {
		System.out.println("Successfully logged in.");
	}


}
