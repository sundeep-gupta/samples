package com.oracle.skgupta.testng.dataprovider;
import org.testng.annotations.Factory;
import java.util.List;
import java.util.ArrayList;

/**
 * Created by skgupta on 7/26/2016.
 */
public class FactoryTest {
    @Factory
    public Object[] getInstances() {
        List<ExampleDP> tests = new ArrayList<ExampleDP>();
        tests.add(new ExampleDP());
        tests.add(new ExampleDP());
        tests.add(new ExampleDP());
        return tests.toArray();
    }
}
