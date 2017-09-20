package com.coway.trust.web.sales;

public class SalesConstants {
	
	public static final int IS_FALSE = 0;
	public static final int IS_TRUE  = 1;
	
	public static final String DEFAULT_DATE = "01/01/1900";	
	public static final String DEFAULT_DATE2 = "1900-01-01";	
	public static final String DEFAULT_DATE3 = "19000101";	
	public static final String DEFAULT_TM = "00:00:00";	
	public static final String DEFAULT_DATE_FORMAT1 = "dd/MM/yyyy";	
	public static final String DEFAULT_DATE_FORMAT2 = "yyyy-MM-dd";
	public static final String DEFAULT_DATE_FORMAT3 = "yyyyMMdd";

	//COMMON CODE : Rental Verify(CODEMASTERID = 9)
	public static final int SALES_AEON_CODEID = 121;
	public static final String SALES_AEON_CODE = "AEON";
	public static final int SALES_CCP_CODEID = 122;
	public static final String SALES_CCp_CODE = "CCP";

	//COMMON CODE : PST_TRANSIT_TYPE(CODEMASTERID = 93)
	public static final int SALES_PSTREQ_CODEID = 1144;
	public static final int SALES_PSTDO_CODEID  = 1145;
	public static final int SALES_PSTCAN_CODEID = 1146;
	
	//STATUS CODE
	public static final String APP_TYPE_CODE_RENTAL         = "REN"; //Rental
	public static final String APP_TYPE_CODE_OUTRIGHT       = "OUT"; //Outright
	public static final String APP_TYPE_CODE_INSTALLMENT    = "INS"; //Installment
	public static final String APP_TYPE_CODE_DONATION       = "DON"; //Donation 
	public static final String APP_TYPE_CODE_GIFT           = "GRT"; //Gift 
	public static final String APP_TYPE_CODE_SPONSOR        = "SPN"; //Sponsor 
	public static final String APP_TYPE_CODE_SERVICE        = "SRV"; //Service 
	public static final String APP_TYPE_CODE_EDUCATION      = "EDU"; //Education  
	public static final String APP_TYPE_CODE_FREE_TRIAL     = "TRL"; //Free Trial  
	public static final String APP_TYPE_CODE_PROJECT_SALES  = "PST"; //Project Sales
	public static final String APP_TYPE_CODE_POINT_O_FSALES = "POS"; //Point of Sales
	public static final String APP_TYPE_CODE_ITEM_BANK      = "ITB"; //Item Bank
	public static final String APP_TYPE_CODE_OUTRIGHTPLUS   = "OUTPLS"; //Outright Plus
	
	public static final String APP_TYPE_CODE_RENTAL_FULL         = "Rental"; //Rental
	public static final String APP_TYPE_CODE_OUTRIGHT_FULL       = "Outright"; //Outright
	public static final String APP_TYPE_CODE_INSTALLMENT_FULL    = "Installment"; //Installment
	public static final String APP_TYPE_CODE_DONATION_FULL       = "Donation"; //Donation 
	public static final String APP_TYPE_CODE_GIFT_FULL           = "Gift"; //Gift 
	public static final String APP_TYPE_CODE_SPONSOR_FULL        = "Sponsor "; //Sponsor 
	public static final String APP_TYPE_CODE_SERVICE_FULL        = "Service "; //Service 
	public static final String APP_TYPE_CODE_EDUCATION_FULL      = "Education  "; //Education  
	public static final String APP_TYPE_CODE_FREE_TRIAL_FULL     = "Free Trial  "; //Free Trial  
	public static final String APP_TYPE_CODE_PROJECT_SALES_FULL  = "Project Sales"; //Project Sales
	public static final String APP_TYPE_CODE_POINT_O_FSALES_FULL = "Point of Sales"; //Point of Sales
	public static final String APP_TYPE_CODE_ITEM_BANK_FULL      = "Item Bank"; //Item Bank
	public static final String APP_TYPE_CODE_OUTRIGHTPLUS_FULL   = "Outright Plus"; //Outright Plus
	
	public static final int APP_TYPE_CODE_ID_RENTAL         = 66;   //Rental          
    public static final int APP_TYPE_CODE_ID_OUTRIGHT       = 67;   //Outright        
    public static final int APP_TYPE_CODE_ID_INSTALLMENT    = 68;   //Installment     
    public static final int APP_TYPE_CODE_ID_DONATION       = 140;  //Donation        
    public static final int APP_TYPE_CODE_ID_GIFT           = 141;  //Gift            
    public static final int APP_TYPE_CODE_ID_SPONSOR        = 142;  //Sponsor         
    public static final int APP_TYPE_CODE_ID_SERVICE        = 143;  //Service         
    public static final int APP_TYPE_CODE_ID_EDUCATION      = 144;  //Education       
    public static final int APP_TYPE_CODE_ID_FREE_TRIAL     = 145;  //Free Trial      
    public static final int APP_TYPE_CODE_ID_PROJECT_SALES  = 863;  //Project Sales   
    public static final int APP_TYPE_CODE_ID_POINT_O_FSALES = 1254; //Point of Sales  
    public static final int APP_TYPE_CODE_ID_ITEM_BANK      = 1255; //Item Bank     
    public static final int APP_TYPE_CODE_ID_OUTRIGHTPLUS   = 1412; //Outright Plus 
	
    //Promotion Application
	public static final int PROMO_APP_TYPE_CODE_ID_REN    = 2284; //Rental
    public static final int PROMO_APP_TYPE_CODE_ID_OUT    = 2285; //Outright
    public static final int PROMO_APP_TYPE_CODE_ID_INS    = 2286; //Installment
    public static final int PROMO_APP_TYPE_CODE_ID_OUTPLS = 2287; //Outright Plus
    public static final int PROMO_APP_TYPE_CODE_ID_OSVM   = 2288; //Outright SVM
    public static final int PROMO_APP_TYPE_CODE_ID_RSVM   = 2289; //Rental SVM
    public static final int PROMO_APP_TYPE_CODE_ID_FIL    = 2290; //Expired Filter
    
	//STATUS CODE
	public static final int STATUS_CODE_ID_ACT = 1; //ACT
	public static final String STATUS_CODE_NAME_ACT = "ACT"; //ACT
	
	
	//Customer Type(Master Code : 8) 
	public static final int CUST_TYPE_CODE_ID_IND = 964; //Individual
	public static final String CUST_TYPE_CODE_NM_IND = "IND"; //Individual
	
	//CCP Scheme(Master Code : 53) 
	public static final int CCP_SCHEME_TYPE_CODE_ID_ICS = 969; //Individual CCP Scheme
	public static final String CCP_SCHEME_TYPE_CODE_NM_ICS = "ICS"; //Individual CCP Scheme
	public static final int CCP_SCHEME_TYPE_CODE_ID_CCS = 970; //Company CCP scheme
	public static final String CCP_SCHEME_TYPE_CODE_NM_CCS = "CCS"; //Company CCP scheme
	
	//Document Submission Type(Master Code : 16) 
	public static final int CCP_DOC_SUB_CODE_ID_ICS = 248; //CCP Document Submission
	public static final String CCP_DOC_SUB_CODE_NM_ICS = "CCPDOC"; //CCP Document Submission
	
	//CCP
	public static final String  AGREEMENT_CODEID = "51"; // Agreement
	public static final String  RENT_MEM_CODEID = "146"; // Rent Membership
	public static final String  AGREEMENT_TRUE = "true";
	public static final String  AGREEMENT_FALSE = "false";
	public static final String 	CONSIGNMENT_HAND = "H";
	public static final String 	CONSIGNMENT_COURIER = "C";
	public static final String CONTRACT_RENTAL_STATUS_APPROVE = "REG";
	public static final String CONTRACT_RENTAL_STATUS_CANCEL = "CAN";
	public static final String SRV_PRD_REM = "Cooperate Customer - System Activated."; 
	public static final int SRV_CNTRCT_STUSID = 4;
	public static final int  SRV_PRD_STUS_IDENTIFY = 8;
	public static final int TRMNAT_STUS_ID = 4;
	public static final String  TRMNAT_REASON_ID = "2127";  //TerminationReasonID
	public static final String TRMNAT_REM =  "CCP REJECTED - RENTAL MEMBERSHIP";// TerminationRemark  
	public static final int TRMNAT_OBLIGATION_PERIOD = 12;   //TerminationObligationPeriod = 12;
	public static final int TRMNAT_PENALTY = 0;	//terminate.TerminationPenalty = 0;
	public static final int TRMNAT_CONTRACT_SUB_PERIOD = 3;	//terminate.TerminationContractSubPeriod = 3;
	public static final String CATEGORY_TYPE_ID = "212";
	public static final String CATEGORY_MASTER_ID = "2";
	
	//Order Investigation
	public static final String  INVEST_CODEID = "73"; // Investigation (Get DocNo)
	
	//Order Edit Type
	public static final String ORDER_EDIT_TYPE_CD_BSC = "BSC"; //Basic Info
	public static final String ORDER_EDIT_TYPE_CD_MAL = "MAL"; //Mailing Address
	public static final String ORDER_EDIT_TYPE_CD_CNT = "CNT"; //Contact Person
	public static final String ORDER_EDIT_TYPE_CD_NRC = "NRC"; //Customer NRIC
	public static final String ORDER_EDIT_TYPE_CD_INS = "INS"; //Install Info
	public static final String ORDER_EDIT_TYPE_CD_PAY = "PAY"; //Payment Channel
	public static final String ORDER_EDIT_TYPE_CD_PRM = "PRM"; //Promotion
	public static final String ORDER_EDIT_TYPE_CD_DOC = "DOC"; //Documents Submission
	public static final String ORDER_EDIT_TYPE_CD_GST = "GST"; //GST Certification
	public static final String ORDER_EDIT_TYPE_CD_RFR = "RFR"; //Referrals Info
}
