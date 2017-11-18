package com.skgupta.examples.java.colln;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

public class MapExample {
	public static void main(String...strings ){
		String a = new String("Sundeep");
		String b = new String("Sundeep");
		Map<String, String> map = new HashMap<String,String>();
		map.put(a, "Harsha");
		System.out.println(map.containsKey(b));
		
		Hashtable<String, String> ht = new Hashtable<String, String>();
		ht.put("Sundeep", "Harsha");
		ht.put("Sundeep", "Abeer & Hardik");
		System.out.println(ht.get("Sundeep"));
		System.out.println(java.util.Objects.requireNonNull(MapExample.class.getProtectionDomain().getCodeSource(), "CodeSOURCE IS NULL").getLocation());
	}
}
