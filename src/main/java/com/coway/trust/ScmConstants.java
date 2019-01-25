package com.coway.trust;

public class ScmConstants {
	private ScmConstants() {
		
	}
	
	//	interface type
	public static final String IF_OTD_SO				= "151";
	public static final String IF_OTD_GI				= "152";
	public static final String IF_OTD_PP				= "153";
	public static final String IF_SAP_TO_SCM_PO			= "156";
	public static final String IF_SAP_TO_SCM_GR			= "160";
	public static final String IF_ORDER					= "161";
	public static final String IF_ISSUE					= "162";
	public static final String IF_OVERDUE				= "163";
	public static final String IF_INVEN					= "164";
	public static final String IF_FILTER				= "165";
	public static final String IF_SUPP_RTP				= "166";
	
	//	interface cycle
	public static final String HOURLY				= "10";
	public static final String DAILY				= "20";
	public static final String WEEKLY				= "30";
	public static final String MONTHLY				= "40";
	
	//	interface status
	public static final String SUCCESS				= "10";
	public static final String FAIL					= "20";
	
	//	status
	public static final String FILE_EMPTY			= "The File is empty.";
	public static final String FILE_DOES_NOT_EXIST	= "The File does not exist.";
	public static final String EXEC_ZERO			= "Executed result is zero.";
	
	//	error
	public static final String UNKNOWN_ERR			= "Unknown Error";
	public static final String FTP_CONN_ERR			= "Ftp Server connection error.";
	public static final String FTP_FILE_READ_ERR		= "Ftp File read error.";
	public static final String SUPPLY_PLAN_RTP_ERR		= "Supply Plan & RTP batch unknown error.";
}