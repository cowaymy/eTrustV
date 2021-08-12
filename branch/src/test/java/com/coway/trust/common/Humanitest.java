package com.coway.trust.common;

public class Humanitest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String no = "ham010001";
		no = no.replaceAll("ham" , "");
		int serial = Integer.parseInt(no);
		for (int i = 1 ; i <= 10 ; i ++){
			String suffix = String.format("%0"+no.length()+"d", (serial + i));
			System.out.println(suffix);
		}
	}
	
	
	
}
