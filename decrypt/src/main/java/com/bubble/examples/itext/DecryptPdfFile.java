/**
 * 
 */
package com.bubble.examples.itext;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Image;
import com.itextpdf.text.pdf.PdfEncryptor;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfWriter;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

/**
 * @author skgupta
 *
 */
public class DecryptPdfFile {
	public static void main(String... args) {
		String fileName = "D:\\Form16.pdf";
		String outFilename = "D:\\Form17.pdf";
		byte[] password = null;
		try {
			password = "AJIPG8136E11031982".getBytes("US-ASCII");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		PdfReader reader;
		try {
			
			reader = new PdfReader(fileName, password);
			System.out.println(reader.computeUserPassword());
			/**
			Document document = new Document();
		    PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(outFilename));
		    for(int i = 1; i <= pdf.getNumberOfPages(); i++) {
		    	PdfImportedPage page = writer.getImportedPage(pdf, i);
		    	Image instance = Image.getInstance(page);
		    	document.add(instance);
		    }
		    document.close();
		    writer.close();
		    pdf.close();
			System.out.println("Lenght of pdf is " + pdf.getFileLength());
			*/
			//PdfReader reader = new PdfReader(inF, password.getBytes());
			 
		      System.out.println("Unlocking...");
		 /*
		      PdfEncryptor.encrypt(reader, new FileOutputStream(outFilename), null,
		         null, PdfWriter.AllowAssembly | PdfWriter.AllowCopy
		         | PdfWriter.AllowDegradedPrinting | PdfWriter.AllowFillIn
		         | PdfWriter.AllowModifyAnnotations | PdfWriter.AllowModifyContents
		         | PdfWriter.AllowPrinting | PdfWriter.AllowScreenReaders, false);
		   */
		        PdfStamper stamper = new PdfStamper(reader, new FileOutputStream(outFilename));
		        stamper.close();
		        reader.close();
		      System.out.println("PDF Unlocked!");
		} catch (IOException | DocumentException ioe) {
			System.out.println(ioe.getMessage() + new String(password));
			ioe.printStackTrace();
		}
	}

}
