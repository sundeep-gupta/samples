package com.skgupta.examples.java.colln;

import java.util.Deque;
import java.util.LinkedList;

public class DeQueExample {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Deque<String> deque = new LinkedList<String>();
		deque.addFirst("Sundeep");
		deque.addFirst("Harsha");
		deque.offerLast("Abeer");
		deque.offerFirst("Hardik");
		
		for(String s: deque) {
			System.out.println(s);
		}
				

	}

}
