package oracle.sysman.qatool.testng;

import static java.lang.annotation.ElementType.CONSTRUCTOR;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.TYPE;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

/**
 * Mark a class or a method as part of the test.
 *
 * @author 
 */
@Retention(java.lang.annotation.RetentionPolicy.RUNTIME)
@Target({METHOD, TYPE, CONSTRUCTOR})
public @interface EMTest {
 

  /**
   * The description for this method.  The string used will appear in the
   * HTML report and also on standard output if verbose >= 2.
   */
  public String abc() default "";
  
  public String description() default "";

}