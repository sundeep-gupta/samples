package com.bubble.examples.itext;
import java.io.*;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
public class PasswordProtectPDF {    
    public static byte[] UserPassword= "UserPassword".getBytes();    
    public static byte[] OwnerPassword = "OwnerPassword".getBytes();
    public static void main(String[] args){
        try {
            String filename=new String();
            filename="D:\\Hello.pdf";
            Document Document_For_Protection = new Document();
            PdfWriter EncryptPDF= PdfWriter.getInstance(Document_For_Protection, new FileOutputStream(filename));
            EncryptPDF.setEncryption(UserPassword, OwnerPassword,
            PdfWriter.ALLOW_PRINTING, PdfWriter.STANDARD_ENCRYPTION_128);
            EncryptPDF.createXmpMetadata();
            Document_For_Protection.open();
            Document_For_Protection.add(new Paragraph("Some Contents for Password Protection"));
            Document_For_Protection.close();
            UserPassword = OwnerPassword = "007601517065".getBytes();
            UserPassword = null;
            //PdfReader reader = new PdfReader("D:\\data\\Google Drive\\Bank Statements\\FY 2013-14\\Harsha\\Axis Bank - Apr 2013.pdf", OwnerPassword);
            PdfReader reader = new PdfReader("D:\\Password.pdf", OwnerPassword);
            PdfEncryptor.encrypt(reader, new 
            		FileOutputStream("D:\\ICICI.pdf"), OwnerPassword, OwnerPassword, 
            		PdfWriter.ALLOW_PRINTING, true);
            //PdfStamper stamper = new PdfStamper(reader, 
             //new FileOutputStream("D:\\Axis.pdf")); 
            //stamper.close();  	
        }
        catch (Exception i)
        {
            System.out.println(i);
            i.printStackTrace();
        }
    }
}