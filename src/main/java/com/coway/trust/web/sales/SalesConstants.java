package com.coway.trust.web.sales;

public class SalesConstants {
	
	public static final String SALES_GSTEURCERET_SUBPATH = "/GSTEURCertificate";
	
	public static final int IS_FALSE = 0;
	public static final int IS_TRUE  = 1;
	
	public static final int STATUS_ACTIVE = 1;
	public static final int STATUS_INACTIVE  = 8;
	public static final int STATUS_CANCELLED = 10;
		
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
	public static final String CATEGORY_TYPE_ID_ORD = "212";
	public static final String CATEGORY_TYPE_ID_ROS = "213";
	public static final String CATEGORY_TYPE_ID_SUS = "216";
	public static final String CATEGORY_TYPE_ID_CUST = "210";
	public static final String CATEGORY_MASTER_ID_COMPANY = "2";
	public static final String CATEGORY_MASTER_ID_INDIVIDUAL = "1";
	public static final String RENTAL_STATUS_SUS = "SUS";
	public static final String RENTAL_STATUS_TER = "TER";
	public static final String APPLICANT_TYPE_ID_INDIVIDUAL = "964";
	public static final String APPLICANT_TYPE_ID_COMPANY = "965";
	public static final String CCP_ITM_STUS_UPD = "8"; //
	public static final String CCP_ITM_STUS_INS = "1";
	public static final String ORD_STATUS_UPD = "10";
	public static final String ORD_REM = "CCP Reject Cancel";
	public static final String ORD_SYNC_CHK = "0";
	public static final String SO_REQ_STATUS_ID = "32"; //SOReqStatusID
	public static final String SO_REQ_CUR_STATUS_ID = "24";   
	public static final String SO_REQ_CUR_STATUS_ID_SEC = "25";   
	public static final String SO_REQ_REASON_ID = "1996";  //SOReqReasonID
	public static final String SO_REQ_PREV_CALL_ENTRY_ID = "0"; 
	public static final String SO_REQ_CUR_CALL_ENTRY_ID = "0";
	public static final String SO_REQ_CANCEL_PENALTY_AMT = "0";  //soReqCancelPenaltyAmt
	public static final String SO_REQ_CANCEL_OB_PERIOD = "0";  //soReqCancelObPeriod
	public static final String SO_REQ_CANCEL_IS_UNDER_COOL_PERIOD = "0"; //soReqCancelIsUnderCoolPeriod
	public static final String SO_REQ_CANCEL_TOTAL_USE_PERIOD = "0";  //soReqCancelTotalUsePeriod
	public static final String SO_REQ_NO = ""; //soReqNo
	public static final String SO_REQ_CANCEL_ADJUSTMENT_AMT = "0"; //soReqCancelAdjustmentAmt
	public static final String SO_REQ_REQUESTOR = "0"; //soRequestor
	public static final String CALL_ENTRY_TYPE_ID = "259";  //callEntryTypeId
	public static final String CALL_ENTRY_TYPE_ID_APPROVED = "257";  //callEntryTypeId
	public static final String CALL_ENTRY_MASTER_STUS_CODE_ID = "32"; //CallEntryMaster.StatusCodeID = 32;
	public static final String CALL_ENTRY_MASTER_STUS_CODE_ID_APPROVED = "1";
	public static final String CALL_ENTRY_MASTER_RESULT_ID = "0"; // CallEntryMaster.ResultID = 0; //NEED UPDATE
	public static final String CALL_ENTRY_MASTER_IS_WAIT_FOR_CANCEL = "0";// CallEntryMaster.IsWaitForCancel = false;
	public static final String CALL_ENTRY_MASTER_HAPPY_CALL_ID = "0"; //CallEntryMaster.HappyCallerID = 0;
	public static final String CALL_RESULT_DETAILS_CALL_STATUS_ID = "32"; //allResultDetails.CallStatusID = 32;
	public static final String CALL_RESULT_DETAILS_CALL_FEEDBACK_ID = "1996"; //  CallResultDetails.CallFeedBackID = 1996;
	public static final String CALL_RESULT_DETAILS_CALL_CT_ID = "0"; // CallResultDetails.CallCTID = 0;
	public static final String CALL_RESULT_DETAILS_CALL_REM = "CCP Reject Cancel"; //  CallResultDetails.CallRemark = "CCP Reject Cancel";
	public static final String CALL_RESULT_DETAILS_CREATE_BY_DEPT = "0";//	CallResultDetails.CallCreateByDept = 0;
	public static final String CALL_RESULT_DETAILS_CALL_HC_ID = "0"; //    CallResultDetails.CallHCID = 0;
	public static final String CALL_RESULT_DETAILS_CALL_ROS_AMT = "0"; //    CallResultDetails.CallROSAmt = 0;
	public static final String CALL_RESULT_DETAILS_CALL_SMS = "0"; //CallResultDetails.CallSMS = false;
	public static final String CALL_RESULT_DETAILS_CALL_SMS_REM = ""; // CallResultDetails.CallSMSRemark = "";
	public static final String SALES_ORDER_LOG_PRGID_CANCEL = "13";
	public static final String SALES_ORDER_LOG_PRGID_APPROVED = "2";
	public static final String SALES_ORDER_IS_LOCK_CANCEL = "0";
	public static final String SALES_ORDER_IS_LOCK_APPROVED = "1";
	public static final String SALES_ORDER_REF_ID = "0";
	
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
	
	//POS
	public static final int POS_DETAIL_NON_RECEIVE = 96;   //96 == nonReceive
	public static final int POS_SALES_STATUS_ACTIVE = 1;    //1  == Active
	public static final int POS_SALES_STATUS_NON_RECEIVE = 96;    //96  == Non Receive
	
	public static final String POS_SALES_TYPE_FILTER = "1352"; //Filter Type
	public static final String POS_SALES_TYPE_ITMBANK = "1353"; //Filter Type
	public static final String POS_SALES_TYPE_OTHER_INCOME = "1357"; //Filter Type
	public static final String POS_SALES_TYPE_ITMBANK_HQ = "1358"; //Filter Type
	public static final String POS_SALES_MODULE_TYPE_POS_SALES = "2390"; //POS Sales
	public static final String POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION = "2391"; //Deduction Commission
	
	public static final int POS_DRACC_ID_FILTER = 540;  //Filter - DR
	public static final int POS_CRACC_ID_FILTER = 541;  //Filter - CR
	public static final int POS_DRACC_ID_ITEMBANK = 540;  //Filter - CR
	public static final int POS_CRACC_ID_ITEMBANK = 549;  //Filter - CR
	public static final int POS_DRACC_ID_OTH_HQ_BANK = 548;
	public static final int POS_CRACC_ID_OTH_HQ_BANK = 549;  
	
	public static final int POS_ITM_TAX_CODE_ID = 32;
	public static final int POS_DOC_NO_PSN_NO = 144;   // PSN No.
	public static final int POS_DOC_NO_INVOICE_NO = 143; // Invoice No. BR68
	public static final int POS_DOC_NO_VOID_NO = 112;  //Void No.
	public static final int POS_DOC_NO_RD_NO = 18;   //RD no.
	public static final int POS_DOC_NO_CN_NEW_NO = 134; //CN-NEW no.
	public static final String POS_CUST_ID = "107205"; // ASIS  //posM.POSCustomerID
	
	public static final int POS_BILL_ID = 0;  //pos Bill Id
	public static final int POS_BILL_TYPE_ID =  569;
	public static final String POS_ORD_BILL_TYPE_ID = "1159";  // posOrdBillTypeId
	public static final String POS_ORD_BILL_MODE_ID = "1351";  // posOrdBillModeId
	public static final int POS_ORD_BILL_TAX_CODE_ID = 32;    //posOrdBillTaxCodeId
	public static final int POS_ORD_BILL_TAX_RATE = 6;  //6  posOrdBillTaxRate
	
	public static final String POS_TAX_INVOICE_TYPE = "142";  //142 posTaxInvType
	public static final int POS_INV_ITM_GST_RATE = 6; //InvoiceItemGSTRate // 6
	
	public static final String POS_STOCK_TYPE_FILTER = "62";
	public static final String POS_STOCK_TYPE_PARTS = "63";
	public static final int POS_INV_STK_TYPE_ID = 571; //invStkCard.TypeID = 571;
	
	public static final int POS_INV_SOURCE_ID = 147;   //invStkCard.SourceID = 477;
	public static final int POS_INV_CURR_ID = 479;  //invStkCard.CurrID = 479;
	public static final int POS_INV_CURR_RATE = 1;   //invStkRecordCurrRate
}
