/**
 * 
 */
package com.skgupta.example.jexcelapi;

import java.io.File;
import java.io.IOException;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.Number;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;
/**
 * @author skgupta
 *
 */
public class JExcelHelloWorld {
	public static void main(String... args) throws BiffException, IOException, RowsExceededException, WriteException {
		// TODO Lets create a new xlsx file and then read another one :)
		readExcelFile();
		writeToExcelFile();
	}
	public static void readExcelFile() throws BiffException, IOException {
		
		Workbook workbook = Workbook.getWorkbook(new File("D:\\topcoder_testsuite.xlsx"));
		Sheet sheet = workbook.getSheet(0);
		Cell a1 = sheet.getCell(0,0);
		System.out.println("Value of cell 0,0 " + a1.getContents());
		
	}
	public static void writeToExcelFile() throws RowsExceededException, WriteException, IOException {
		WritableWorkbook workbook = Workbook.createWorkbook(new File("D:\\output.xls"));
		WritableSheet sheet = workbook.createSheet("First Sheet", 0);
		Label label = new Label(0, 2, "A label record"); 
		sheet.addCell(label); 
		
		Number number = new Number(3, 4, 3.1459);
		
		sheet.addCell(number);
		// All sheets and cells added. Now write out the workbook 
		workbook.write(); 
		workbook.close();
	}

	/** Testsuite for tcsdev problem
	 * 1. Launch the new browser and go to url  'tcqa1.topcoder.com'.
	 * 
2. Go to Communities -> Forums
3. Click Search link available on the top right corner
4. Click on link 'Search Tips' and verify Help Tips page opens in new browser window.
5. Without provide any input click on 'Search' button. (Expected 1)
6. Enter any invalid search string in query and click on 'Search' button. (Expected 2)
7 Enter invalid Handel name and click on 'Search' button. (Expected 3)
8. Enter valid information in all the fields except Handle. (Expected 4)
9. Enter valid search criteria in all the fields (Query, Forum, Date Range, Handel, Results Per Page) and click Search (expected 5)
10. Click on link 'sort by date' to sort the result by date and verify results are sorted correctly (expected 6)
11. Click on link 'sort by relevance' to sort the results by relevance verify results are sorted correctly (expected 7)
12. Verify number of results displaying on the page are same as provided in field 'Result Per Page'.
13. Verify links 'PREV' , 'NEXT' and page number are displaying (If number of results are more than per page limit).
14. Verify user is able to navigate to next, previous or specified page by clicking these links.
15. Click on any of the author name (expected 8)
16. Click on any of the search results (expected 9)
	 * 
	 * 2	click	btnSearchPage	
3	click	lnkSearchTips	

	 */
	/*
	 * driver.get(self.base_url + "/")
driver.find_element_by_css_selector("#mainNav > ul.root > #nav-menu-item-13129 > ul.child > #nav-menu-item-13105 > a.forums").click()
driver.find_element_by_css_selector("a.rtbcLink.search").click()
driver.find_element_by_link_text("Search Tips").click()
# ERROR: Caught exception [ERROR: Unsupported command [waitForPopUp | st | 30000]]
# ERROR: Caught exception [ERROR: Unsupported command [selectWindow | name=st | ]]
self.assertEqual("TopCoder - Error", driver.title)
# ERROR: Caught exception [ERROR: Unsupported command [selectWindow | null | ]]
driver.find_element_by_name("Search").click()
self.assertEqual("Please enter some search terms.", driver.find_element_by_css_selector("span.bigRed").text)
driver.find_element_by_id("handle").clear()
driver.find_element_by_id("handle").send_keys("sundeepharsha")
driver.find_element_by_name("Search").click()
self.assertEqual("No user exists with the specified handle.", driver.find_element_by_css_selector("span.bigRed").text)
driver.find_element_by_id("query").clear()
driver.find_element_by_id("query").send_keys("sundeepharsha")
driver.find_element_by_name("Search").click()
self.assertEqual("No search results for \"sundeepharsha\". Please try a less restrictive search.", driver.find_element_by_css_selector("td.rtbc").text)
driver.find_element_by_id("query").clear()
driver.find_element_by_id("query").send_keys("Topcoder")
Select(driver.find_element_by_id("dateRange")).select_by_visible_text(u"regexp:•\\sLast Year \\(1/1/13\\)")
Select(driver.find_element_by_id("resultSize")).select_by_visible_text("10")
driver.find_element_by_name("Search").click()
self.assertEqual("Search Results (1 - 10 of 144) (sort by date)", driver.find_element_by_css_selector("td.rtbc").text)
driver.find_element_by_id("handle").clear()
driver.find_element_by_id("handle").send_keys("jhughes")
driver.find_element_by_name("Search").click()
driver.find_element_by_link_text("(sort by date)").click()
driver.find_element_by_link_text("(sort by relevance)").click()
driver.find_element_by_link_text("(sort by date)").click()
self.assertEqual("TopCoder Forums", driver.title)
driver.find_element_by_css_selector("a.rtbcLink > b").click()
driver.back()
driver.find_element_by_link_text("jhughes").click()
self.assertEqual("jhughes", driver.find_element_by_link_text("jhughes").text)
self.assertEqual("TopCoder Member Profile", driver.title)
driver.back()
driver.find_element_by_id("handle").clear()
driver.find_element_by_id("handle").send_keys("")
driver.find_element_by_name("Search").click()
self.assertEqual("NEXT >", driver.find_element_by_link_text("NEXT >").text)
self.assertTrue(self.is_element_present(By.LINK_TEXT, "NEXT >"))
driver.find_element_by_link_text("3").click()
self.assertTrue(self.is_element_present(By.LINK_TEXT, "<< PREV"))

	 */
}
