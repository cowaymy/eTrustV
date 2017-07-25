package com.coway.trust.web.sales;

public class SalesConstants {
	
	public static final String DEFAULT_DATE = "01/01/1900";	
	public static final String DEFAULT_DATE_FORMAT1 = "dd/MM/yyyy";	
	public static final String DEFAULT_DATE_FORMAT2 = "yyyy-MM-dd";
			
	//COMMON CODE : PST_TRANSIT_TYPE(CODEMASTERID = 93)
	public static final int SALES_PSTREQ = 1144;
	public static final int SALES_PSTDO  = 1145;
	public static final int SALES_PSTCAN = 1146;
	
	//STATUS CODE
	public static final String APP_TYPE_CODE_RENTAL = "REN"; //Rental
	public static final String APP_TYPE_CODE_INSTALLMENT = "INS"; //Installment
	public static final String APP_TYPE_CODE_OUTRIGHTPLUS = "OUTPLS"; //Outright Plus
}
