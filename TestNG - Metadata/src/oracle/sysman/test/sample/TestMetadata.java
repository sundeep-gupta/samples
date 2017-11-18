package oracle.sysman.test.sample;

public @interface TestMetadata {
	String description();
	String[] steps();
	String[] expectedResults();
}
