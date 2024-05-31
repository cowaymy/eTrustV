package com.coway.trust.web.sales;

public class SalesConstants {

  public static final String SALES_GSTEURCERET_SUBPATH = "/GSTEURCertificate";
  public static final String SALES_INVESTIGATION_SUBPATH = "/Investigation";

  public static final int IS_FALSE = 0;
  public static final int IS_TRUE = 1;

  public static final int STATUS_ACTIVE = 1;
  public static final int STATUS_COMPLETED = 4;
  public static final int STATUS_INACTIVE = 8;
  public static final int STATUS_CANCELLED = 10;
  public static final int STATUS_READY_TO_ORDER = 97;
  public static final int STATUS_FAILED = 21;
  public static final int STATUS_AUTO_CANCELLED = 98;

  public static final String DEFAULT_DATE = "01/01/1900";
  public static final String DEFAULT_DATE2 = "1900-01-01";
  public static final String DEFAULT_DATE3 = "19000101";
  public static final String DEFAULT_END_DATE = "31/12/2099";
  public static final String DEFAULT_TM = "00:00:00";
  public static final String DEFAULT_DATE_FORMAT1 = "dd/MM/yyyy";
  public static final String DEFAULT_DATE_FORMAT2 = "yyyy-MM-dd";
  public static final String DEFAULT_DATE_FORMAT3 = "yyyyMMdd";

  public static final String DEFAULT_DATE_FORMAT4 = "MM/yyyy";

  // COMMON CODE : Rental Verify(CODEMASTERID = 9)
  public static final int SALES_AEON_CODEID = 121;
  public static final String SALES_AEON_CODE = "AEON";
  public static final int SALES_CCP_CODEID = 122;
  public static final String SALES_CCp_CODE = "CCP";
  // Added for On-Loan Order module by Hui Ding, 19/02/2020
  public static final String APP_TYPE_CODE_IHR_LOAN           = "IHR"; // In-House Repair Loan Product -- Hidden. only applicable for On-Loan Order Module.

  // COMMON CODE : PST_TRANSIT_TYPE(CODEMASTERID = 93)
  public static final int SALES_PSTREQ_CODEID = 1144;
  public static final int SALES_PSTDO_CODEID = 1145;
  public static final int SALES_PSTCAN_CODEID = 1146;
  // Added for On-Loan Order module by Hui Ding, 19/02/2020
  public static final String APP_TYPE_CODE_IHR_LOAN_FULL          = "In-House Repair Loan";  // IHR -- Hidden. only applicable for On-Loan Order Module.

  // STATUS CODE
  public static final String APP_TYPE_CODE_RENTAL = "REN"; // Rental
  public static final String APP_TYPE_CODE_OUTRIGHT = "OUT"; // Outright
  public static final String APP_TYPE_CODE_INSTALLMENT = "INS"; // Installment
  public static final String APP_TYPE_CODE_DONATION = "DON"; // Donation
  public static final String APP_TYPE_CODE_GIFT = "GRT"; // Gift
  public static final String APP_TYPE_CODE_SPONSOR = "SPN"; // Sponsor
  public static final String APP_TYPE_CODE_SERVICE = "SRV"; // Service
  public static final String APP_TYPE_CODE_EDUCATION = "EDU"; // Education
  public static final String APP_TYPE_CODE_FREE_TRIAL = "TRL"; // Free Trial
  public static final String APP_TYPE_CODE_PROJECT_SALES = "PST"; // Project
                                                                  // Sales
  public static final String APP_TYPE_CODE_POINT_O_FSALES = "POS"; // Point of
                                                                   // Sales
  public static final String APP_TYPE_CODE_ITEM_BANK = "ITB"; // Item Bank
  public static final String APP_TYPE_CODE_OUTRIGHTPLUS = "OUTPLS"; // Outright
                                                                    // Plus
  public static final String APP_TYPE_CODE_AUX = "AUX"; // AUX
  // Added for On-Loan Order module by Hui Ding, 19/02/2020
  public static final int APP_TYPE_CODE_ID_IHR_LOAN       = 5788;  // IHR -- Hidden. only applicable for On-Loan Order Module.

  public static final String APP_TYPE_CODE_RENTAL_FULL = "Rental"; // Rental
  public static final String APP_TYPE_CODE_OUTRIGHT_FULL = "Outright"; // Outright
  public static final String APP_TYPE_CODE_INSTALLMENT_FULL = "Installment"; // Installment
  public static final String APP_TYPE_CODE_DONATION_FULL = "Donation"; // Donation
  public static final String APP_TYPE_CODE_GIFT_FULL = "Gift"; // Gift
  public static final String APP_TYPE_CODE_SPONSOR_FULL = "Sponsor "; // Sponsor
  public static final String APP_TYPE_CODE_SERVICE_FULL = "Service "; // Service
  public static final String APP_TYPE_CODE_EDUCATION_FULL = "Education  "; // Education
  public static final String APP_TYPE_CODE_FREE_TRIAL_FULL = "Free Trial  "; // Free
                                                                             // Trial
  public static final String APP_TYPE_CODE_PROJECT_SALES_FULL = "Project Sales"; // Project
                                                                                 // Sales
  public static final String APP_TYPE_CODE_POINT_O_FSALES_FULL = "Point of Sales"; // Point
                                                                                   // of
                                                                                   // Sales
  public static final String APP_TYPE_CODE_ITEM_BANK_FULL = "Item Bank"; // Item
                                                                         // Bank
  public static final String APP_TYPE_CODE_OUTRIGHTPLUS_FULL = "Outright Plus"; // Outright
                                                                                // Plus
  public static final String APP_TYPE_CODE_AUX_FULL = "Auxiliary"; // Auxiliary

  public static final int APP_TYPE_CODE_ID_RENTAL = 66; // Rental
  public static final int APP_TYPE_CODE_ID_OUTRIGHT = 67; // Outright
  public static final int APP_TYPE_CODE_ID_INSTALLMENT = 68; // Installment
  public static final int APP_TYPE_CODE_ID_DONATION = 140; // Donation
  public static final int APP_TYPE_CODE_ID_GIFT = 141; // Gift
  public static final int APP_TYPE_CODE_ID_SPONSOR = 142; // Sponsor
  public static final int APP_TYPE_CODE_ID_SERVICE = 143; // Service
  public static final int APP_TYPE_CODE_ID_EDUCATION = 144; // Education
  public static final int APP_TYPE_CODE_ID_FREE_TRIAL = 145; // Free Trial
  public static final int APP_TYPE_CODE_ID_PROJECT_SALES = 863; // Project Sales
  public static final int APP_TYPE_CODE_ID_POINT_O_FSALES = 1254; // Point of
                                                                  // Sales
  public static final int APP_TYPE_CODE_ID_ITEM_BANK = 1255; // Item Bank
  public static final int APP_TYPE_CODE_ID_OUTRIGHTPLUS = 1412; // Outright Plus
  public static final int APP_TYPE_CODE_ID_AUX = 5764; // AUX

  public static final int APP_SUB_TYPE_CODE_ID_RENTAL = 367; // Rental
  public static final int APP_SUB_TYPE_CODE_ID_OUTRIGHT = 368; // Outright
  public static final int APP_SUB_TYPE_CODE_ID_INSTALLMENT = 369; // Installment
  public static final int APP_SUB_TYPE_CODE_ID_SPONSOR = 371; // Sponsor
  public static final int APP_SUB_TYPE_CODE_ID_SERVICE = 372; // Service
  public static final int APP_SUB_TYPE_CODE_ID_EDUCATION = 373; // Education
  public static final int APP_SUB_TYPE_CODE_ID_FREE_TRIAL = 374; // Free Trial
  public static final int APP_SUB_TYPE_CODE_ID_OUTRIGHTPLUS = 370; // Outright
                                                                   // Plus

  // Promotion Application
  public static final int PROMO_APP_TYPE_CODE_ID_REN = 2284; // Rental
  public static final int PROMO_APP_TYPE_CODE_ID_OUT = 2285; // Outright
  public static final int PROMO_APP_TYPE_CODE_ID_INS = 2286; // Installment
  public static final int PROMO_APP_TYPE_CODE_ID_OUTPLS = 2287; // Outright Plus
  public static final int PROMO_APP_TYPE_CODE_ID_OSVM = 2288; // Outright SVM
  public static final int PROMO_APP_TYPE_CODE_ID_RSVM = 2289; // Rental SVM
  public static final int PROMO_APP_TYPE_CODE_ID_FIL_OSVM = 2290; // Expired
                                                                  // Filter
                                                                  // (Outright
                                                                  // SVM)
  public static final int PROMO_APP_TYPE_CODE_ID_FIL_RSVM = 2744; // Expired
                                                                  // Filter
                                                                  // (Rental
                                                                  // SVM)
  public static final int PROMO_APP_TYPE_CODE_ID_EDU = 7553; // Education

  // Promotion Period Type
  public static final int PROMO_DISC_TYPE_EQUAL = 2293; // EQUAL
  public static final int PROMO_DISC_TYPE_EARLY = 2294; // EARLY
  public static final int PROMO_DISC_TYPE_LATE = 2295; // LATE

  // STATUS CODE
  public static final int STATUS_CODE_ID_ACT = 1; // ACT
  public static final String STATUS_CODE_NAME_ACT = "ACT"; // ACT

  // Customer Type(Master Code : 8)
  public static final int CUST_TYPE_CODE_ID_IND = 964; // Individual
  public static final String CUST_TYPE_CODE_NM_IND = "IND"; // Individual

  // CCP Scheme(Master Code : 53)
  public static final int CCP_SCHEME_TYPE_CODE_ID_ICS = 969; // Individual CCP
                                                             // Scheme
  public static final String CCP_SCHEME_TYPE_CODE_NM_ICS = "ICS"; // Individual
                                                                  // CCP Scheme
  public static final int CCP_SCHEME_TYPE_CODE_ID_CCS = 970; // Company CCP
                                                             // scheme
  public static final String CCP_SCHEME_TYPE_CODE_NM_CCS = "CCS"; // Company CCP
                                                                  // scheme

  // Document Submission Type(Master Code : 16)
  public static final int CCP_DOC_SUB_CODE_ID_ICS = 248; // CCP Document
                                                         // Submission
  public static final String CCP_DOC_SUB_CODE_NM_ICS = "CCPDOC"; // CCP Document
                                                                 // Submission

  // CCP
  public static final String CCP_AGREEMENT_SUB_PATH = "sales/ccp/agreement";

  public static final String AGREEMENT_CODEID = "51"; // Agreement
  public static final String RENTAL_AGREEMENT_CODEID = "183"; // Agreement
  public static final String RENT_MEM_CODEID = "146"; // Rent Membership
  public static final String AGREEMENT_TRUE = "true";
  public static final String AGREEMENT_FALSE = "false";
  public static final String CONSIGNMENT_HAND = "H";
  public static final String CONSIGNMENT_COURIER = "C";
  public static final String CONTRACT_RENTAL_STATUS_APPROVE = "REG";
  public static final String CONTRACT_RENTAL_STATUS_CANCEL = "CAN";
  public static final String SRV_PRD_REM = "Cooperate Customer - System Activated.";
  public static final int SRV_CNTRCT_STUSID = 4;
  public static final int SRV_PRD_STUS_IDENTIFY = 8;
  public static final int TRMNAT_STUS_ID = 4;
  public static final String TRMNAT_REASON_ID = "2127"; // TerminationReasonID
  public static final String TRMNAT_REM = "CCP REJECTED - RENTAL MEMBERSHIP";// TerminationRemark
  public static final int TRMNAT_OBLIGATION_PERIOD = 12; // TerminationObligationPeriod
                                                         // = 12;
  public static final int TRMNAT_PENALTY = 0; // terminate.TerminationPenalty =
                                              // 0;
  public static final int TRMNAT_CONTRACT_SUB_PERIOD = 3; // terminate.TerminationContractSubPeriod
                                                          // = 3;
  public static final String CATEGORY_TYPE_ID_ORD = "212";
  public static final String CATEGORY_TYPE_ID_ROS = "213";
  public static final String CATEGORY_TYPE_ID_SUS = "216";
  public static final String CATEGORY_TYPE_ID_CUST = "210";
  public static final String CATEGORY_MASTER_ID_COMPANY = "2";
  public static final String CATEGORY_MASTER_ID_INDIVIDUAL = "1";
  public static final String RENTAL_STATUS_SUS = "SUS";
  public static final String RENTAL_STATUS_TER = "TER";
  public static final String RENTAL_STATUS_RET = "RET";
  public static final String RENTAL_STATUS_WOF = "WOF";
  public static final String APPLICANT_TYPE_ID_INDIVIDUAL = "964";
  public static final String APPLICANT_TYPE_ID_COMPANY = "965";
  public static final String CCP_ITM_STUS_UPD = "8"; //
  public static final String CCP_ITM_STUS_INS = "1";
  public static final String ORD_STATUS_UPD = "10";
  public static final String ORD_REM = "CCP Reject Cancel";
  public static final String ORD_SYNC_CHK = "0";
  public static final String SO_REQ_STATUS_ID = "32"; // SOReqStatusID
  public static final String SO_REQ_CUR_STATUS_ID = "24";
  public static final String SO_REQ_CUR_STATUS_ID_SEC = "25";
  public static final String SO_REQ_REASON_ID = "1996"; // SOReqReasonID
  public static final String SO_REQ_PREV_CALL_ENTRY_ID = "0";
  public static final String SO_REQ_CUR_CALL_ENTRY_ID = "0";
  public static final String SO_REQ_CANCEL_PENALTY_AMT = "0"; // soReqCancelPenaltyAmt
  public static final String SO_REQ_CANCEL_OB_PERIOD = "0"; // soReqCancelObPeriod
  public static final String SO_REQ_CANCEL_IS_UNDER_COOL_PERIOD = "0"; // soReqCancelIsUnderCoolPeriod
  public static final String SO_REQ_CANCEL_TOTAL_USE_PERIOD = "0"; // soReqCancelTotalUsePeriod
  public static final String SO_REQ_NO = ""; // soReqNo
  public static final String SO_REQ_CANCEL_ADJUSTMENT_AMT = "0"; // soReqCancelAdjustmentAmt
  public static final String SO_REQ_REQUESTOR = "0"; // soRequestor
  public static final String CALL_ENTRY_TYPE_ID = "259"; // callEntryTypeId
  public static final String CALL_ENTRY_TYPE_ID_APPROVED = "257"; // callEntryTypeId
  public static final String CALL_ENTRY_MASTER_STUS_CODE_ID = "32"; // CallEntryMaster.StatusCodeID
                                                                    // = 32;
  public static final String CALL_ENTRY_MASTER_STUS_CODE_ID_APPROVED = "1";
  public static final String CALL_ENTRY_MASTER_RESULT_ID = "0"; // CallEntryMaster.ResultID
                                                                // = 0; //NEED
                                                                // UPDATE
  public static final String CALL_ENTRY_MASTER_IS_WAIT_FOR_CANCEL = "0";// CallEntryMaster.IsWaitForCancel
                                                                        // =
                                                                        // false;
  public static final String CALL_ENTRY_MASTER_HAPPY_CALL_ID = "0"; // CallEntryMaster.HappyCallerID
                                                                    // = 0;
  public static final String CALL_RESULT_DETAILS_CALL_STATUS_ID = "32"; // allResultDetails.CallStatusID
                                                                        // = 32;
  public static final String CALL_RESULT_DETAILS_CALL_FEEDBACK_ID = "1996"; // CallResultDetails.CallFeedBackID
                                                                            // =
                                                                            // 1996;
  public static final String CALL_RESULT_DETAILS_CALL_CT_ID = "0"; // CallResultDetails.CallCTID
                                                                   // = 0;
  public static final String CALL_RESULT_DETAILS_CALL_REM = "CCP Reject Cancel"; // CallResultDetails.CallRemark
                                                                                 // =
                                                                                 // "CCP
                                                                                 // Reject
                                                                                 // Cancel";
  public static final String CALL_RESULT_DETAILS_CREATE_BY_DEPT = "0";// CallResultDetails.CallCreateByDept
                                                                      // = 0;
  public static final String CALL_RESULT_DETAILS_CALL_HC_ID = "0"; // CallResultDetails.CallHCID
                                                                   // = 0;
  public static final String CALL_RESULT_DETAILS_CALL_ROS_AMT = "0"; // CallResultDetails.CallROSAmt
                                                                     // = 0;
  public static final String CALL_RESULT_DETAILS_CALL_SMS = "0"; // CallResultDetails.CallSMS
                                                                 // = false;
  public static final String CALL_RESULT_DETAILS_CALL_SMS_REM = ""; // CallResultDetails.CallSMSRemark
                                                                    // = "";
  public static final String SALES_ORDER_LOG_PRGID_CANCEL = "13";
  public static final String SALES_ORDER_LOG_PRGID_APPROVED = "2";
  public static final String SALES_ORDER_LOG_PRGID_ACTIVE = "1";
  public static final String SALES_ORDER_IS_LOCK_CANCEL = "0";
  public static final String SALES_ORDER_IS_LOCK_APPROVED = "1";
  public static final String SALES_ORDER_REF_ID = "0";

  public static final String CCP_INCOME_RANGE_MODE_ID = "131"; // ModeId

  public static final String CCP_INCOME_RANGE_MODE_ID_INDIVIDUAL = "29";
  public static final String CCP_INCOME_RANGE_MODE_ID_COMPANY = "22";

  public static final String CCP_COMPANY_IS_BOOL = "969"; // company boolean

  // Order Investigation
  public static final String INVEST_CODEID = "73"; // Investigation (Get DocNo)

  // Order Edit Type
  public static final String ORDER_EDIT_TYPE_CD_BSC = "BSC"; // Basic Info
  public static final String ORDER_EDIT_TYPE_CD_MAL = "MAL"; // Mailing Address
  public static final String ORDER_EDIT_TYPE_CD_CNT = "CNT"; // Contact Person
  public static final String ORDER_EDIT_TYPE_CD_NRC = "NRC"; // Customer NRIC
  public static final String ORDER_EDIT_TYPE_CD_INS = "INS"; // Install Info
  public static final String ORDER_EDIT_TYPE_CD_PAY = "PAY"; // Payment Channel
  public static final String ORDER_EDIT_TYPE_CD_PRM = "PRM"; // Promotion
  public static final String ORDER_EDIT_TYPE_CD_DOC = "DOC"; // Documents
                                                             // Submission
  public static final String ORDER_EDIT_TYPE_CD_GST = "GST"; // GST
                                                             // Certification
  public static final String ORDER_EDIT_TYPE_CD_RFR = "RFR"; // Referrals Info

  // Order Edit Type
  public static final String ORDER_REQ_TYPE_CD_CANC = "CANC"; // Cancellation
  public static final String ORDER_REQ_TYPE_CD_PEXC = "PEXC"; // Product
                                                              // Exchange
  public static final String ORDER_REQ_TYPE_CD_AEXC = "AEXC"; // Application
                                                              // Exchange
  public static final String ORDER_REQ_TYPE_CD_SCHM = "SCHM"; // Scheme
                                                              // Conversion
  public static final String ORDER_REQ_TYPE_CD_OTRN = "OTRN"; // Ownership
                                                              // Transfer

  // Pre-Order Channel
  public static final int PRE_ORDER_CHANNEL_MOB = 0;
  public static final int PRE_ORDER_CHANNEL_WEB = 1;

  // POS
  public static final int POS_DETAIL_NON_RECEIVE = 96; // 96 == nonReceive
  public static final int POS_DETAIL_RECEIVE = 85; // 85 == Receive
  public static final int POS_SALES_STATUS_ACTIVE = 1; // 1 == Active
  public static final int POS_SALES_STATUS_NON_RECEIVE = 96; // 96 == Non
                                                             // Receive
  public static final int POS_SALES_STATUS_COMPLETE = 4; // 4 == Complete

  public static final String POS_SALES_TYPE_FILTER = "1352"; // Filter Type
  public static final String POS_SALES_TYPE_ITMBANK = "1353"; // Filter Type
  public static final String POS_SALES_TYPE_OTHER_INCOME = "1357"; // Filter
                                                                   // Type
  public static final String POS_SALES_TYPE_ITMBANK_HQ = "1358"; // Filter Type
  public static final String POS_SALES_TYPE_REVERSAL = "1361"; // POS REVERSAL
  public static final String POS_SALES_TYPE_FLEXI_REVERSAL = "5794"; // POS FLEXI POINT REVERSAL
  public static final String POS_SALES_MODULE_TYPE_POS_SALES = "2390"; // POS
                                                                       // Sales
  public static final String POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION = "2391"; // Deduction
                                                                                  // Commission
  public static final String POS_SALES_MODULE_TYPE_OTH = "2392"; // Other Income

  public static final String POS_SALES_NOT_BANK = "2687"; // ItemBank from Code
                                                          // M

  public static final int POS_DRACC_ID_FILTER = 540; // Filter - DR
  public static final int POS_CRACC_ID_FILTER = 541; // Filter - CR
  public static final int POS_DRACC_ID_ITEMBANK = 540; // Filter - CR
  public static final int POS_CRACC_ID_ITEMBANK = 549; // Filter - CR
  public static final int POS_DRACC_ID_OTH_HQ_BANK = 548;
  public static final int POS_CRACC_ID_OTH_HQ_BANK = 549;
  public static final int POS_DRACC_ID_OTH = 548;
  public static final int POS_CRACC_ID_OTH = 539;

  public static final int POS_ITM_TAX_CODE_ID = 32;
  public static final int POS_DOC_NO_PSN_NO = 144; // PSN No.
  public static final int POS_DOC_NO_INVOICE_NO = 143; // Invoice No. BR68
  public static final int POS_DOC_NO_VOID_NO = 112; // Void No.
  public static final int POS_DOC_NO_RD_NO = 18; // RD no.
  public static final int POS_DOC_NO_CN_NEW_NO = 134; // CN-NEW no.
  public static final int POS_DOC_NO_TRX_NO = 23; // TRX no.
  public static final int POS_DOC_NO_WOR_NO = 3; // WOR no.
  public static final int POS_DOC_ROR_NO = 82; // ROR no.

  public static final String POS_CUST_ID = "107205"; // ASIS
                                                     // //posM.POSCustomerID

  public static final int POS_BILL_ID = 0; // pos Bill Id
  public static final int POS_BILL_TYPE_ID = 569;
  public static final String POS_ORD_BILL_TYPE_ID = "1159"; // posOrdBillTypeId
  public static final String POS_ORD_BILL_MODE_ID = "1351"; // posOrdBillModeId
  public static final int POS_ORD_BILL_TAX_CODE_ID = 32; // posOrdBillTaxCodeId
  public static final int POS_ORD_BILL_TAX_RATE = 6; // 6 posOrdBillTaxRate

  public static final String POS_TAX_INVOICE_TYPE = "142"; // 142 posTaxInvType
  public static final int POS_INV_ITM_GST_RATE = 6; // InvoiceItemGSTRate // 6

  public static final String POS_STOCK_TYPE_FILTER = "62";
  public static final String POS_STOCK_TYPE_PARTS = "63";
  public static final int POS_INV_STK_TYPE_ID = 571; // invStkCard.TypeID = 571;

  public static final int POS_INV_SOURCE_ID = 147; // invStkCard.SourceID = 477;
  public static final int POS_INV_CURR_ID = 479; // invStkCard.CurrID = 479;
  public static final int POS_INV_CURR_RATE = 1; // invStkRecordCurrRate

  public static final int POS_ACC_BILL_STATUS = 74; // accorderbill.AccBillStatus
                                                    // = 74;
  public static final int POS_ACC_BILL_TASK_ID = 0; // ACC_BILL_TASK_ID = 0

  public static final int POS_INV_ADJM_MEMO_TYPE_ID = 1293;// InvAdjM.MemoAdjustTypeID
                                                           // = 1293; //Type -
                                                           // CN
  public static final int POS_INV_ADJM_MEMO_INVOICE_TYPE_ID = 128;// InvAdjM.MemoAdjustInvoiceTypeID
                                                                  // = 128; //
                                                                  // Invoice-Miscellaneous
  public static final int POS_INV_ADJM_MEMO_STATUS_ID = 4; // InvAdjM.MemoAdjustStatusID
                                                           // = 4;
  public static final int POS_INV_ADJM_MEMO_RESN_ID = 2038; // InvAdjM.MemoAdjustReasonID
                                                            // = 2038; //
                                                            // Invoice Reversal

  public static final int POS_NOTE_TYPE_ID = 1293; //// dcnM.NoteTypeID = 1293;
                                                   //// //CN
  public static final int POS_NOTE_INVOICE_TYPE_ID = 128; // dcnM.NoteInvoiceTypeID
                                                          // = 128; //MISC

  public static final String POS_REM_SOI_COMMENT = "SOI Reversal -";
  public static final String POS_REM_SOI_COMMENT_INV_VOID = "SOI Reversal_"; // InvVoidM.AccInvVoidRemark
                                                                             // =
                                                                             // "SOI
                                                                             // Reversal_"
                                                                             // +
                                                                             // this.txtReferenceNo.Text.Trim();
  public static final int POS_NOTE_STATUS_ID = 4;

  public static final int POS_MEMO_ITM_STATUS_ID = 1; // ias.MemoItemStatusID =
                                                      // 1;

  public static final int POS_ACC_INV_VOID_STATUS = 1; // InvVoidM.AccInvVoidStatusID
                                                       // = 1;
  public static final int POS_ACC_INV_VOID_ORD_ID = 0; // InvVoidS.AccInvVoidSubOrderID
                                                       // = 0;

  public static final int POS_OTH_CHECK_PARAM = 1;// Other Income Check
                                                  // Parameter

  public static final int POS_TRX_TYPE_ID = 577; // POS pay Trx Type Id
  public static final int POS_PAY_MASTER_TYPE_ID = 577; // POS Pay Master Type
                                                        // Id
  public static final int POS_RECEIPT_TYPE_ID = 577;

  public static final int POS_TEMP_SALES_ORDER_ID = 0;

  public static final int POS_BANK_CHARGE_AMOUNT = 0;
  public static final int POS_BANK_CHARGE_ACCOUNT_ID = 0;
  public static final int POS_COLL_MEMBER_ID = 0;

  public static final int POS_PAY_ALLOW_COMM = 0;
  public static final int POS_PAY_STATUS_ID = 1;
  public static final int POS_PAY_SYNC_CHECK = 0;

  public static final int POS_THIRD_PARTY_CUST_ID = 0;
  public static final int POS_MATCH_ID = 0;

  public static final int POS_IS_ALLOW_REV_MULTY = 0;
  public static final int POS_IS_GL_POST_CLAIM = 0;

  public static final int POS_ADV_MONTH = 0;
  public static final int POS_TAX_INVOICE_GENERATED = 1;
  public static final int POS_SERVICE_CONTRACT_ID = 0;
  public static final int POS_BATCH_PAYMEMNT_ID = 0;

  public static final String POS_PAY_DEBTOR_ACC_CODE = "2136/000";

  public static final int POS_PAY_ITEM_IS_LOCK = 0;
  public static final int POS_PAY_ITEM_IS_THIRD_PARTY = 0;
  public static final int POS_IS_FUND_TRANS_FR = 0;
  public static final int POS_SKIP_RECON = 0;

  public static final int POS_PAY_METHOD_CASH = 105;
  public static final int POS_PAY_METHOD_CARD = 107;
  public static final int POS_PAY_METHOD_COMMISSION = 108;

  public static final int POS_PAY_SUSPEND_CASH = 531;
  public static final int POS_PAY_SUSPEND_COMMISSION = 533;

  public static final int POS_ITE_BANK_ACC_99 = 99;
  public static final int POS_ITE_BANK_ACC_100 = 100;
  public static final int POS_ITE_BANK_ACC_101 = 101;
  public static final int POS_ITE_BANK_ACC_103 = 103;
  public static final int POS_ITE_BANK_ACC_104 = 104;
  public static final int POS_ITE_BANK_ACC_105 = 105;
  public static final int POS_ITE_BANK_ACC_106 = 106;
  public static final int POS_ITE_BANK_ACC_107 = 107;
  public static final int POS_ITE_BANK_ACC_110 = 110;
  public static final int POS_ITE_BANK_ACC_497 = 497;

  public static final int POS_SET_SETTLE_ACC_83 = 83;
  public static final int POS_SET_SETTLE_ACC_90 = 90;
  public static final int POS_SET_SETTLE_ACC_84 = 84;
  public static final int POS_SET_SETTLE_ACC_86 = 86;
  public static final int POS_SET_SETTLE_ACC_85 = 85;
  public static final int POS_SET_SETTLE_ACC_88 = 88;
  public static final int POS_SET_SETTLE_ACC_89 = 89;
  public static final int POS_SET_SETTLE_ACC_497 = 497;

  public static final int POS_GL_REVERSE_RECEIPT_ITEM_ID = 0;
  public static final int POS_GL_RECEIPT_ITEM_CHARGES = 0;
  public static final String POS_GL_RECEIPT_ITEM_RCL_STATUS = "N";
  public static final String POS_GL_CONVERSION_STATUS = "Y";
  public static final int POS_PAY_REVERSE_TYPE = 101;
  public static final String POS_PAY_ITEM_REMARK_REVERSAL = "SOI Reversal - ";

  public static final int POS_TRX_REVERSE_TYPE = 101;
  public static final int POS_GL_RECEIPT_REVERSE_TYPE = 101;

  public static final int POS_PAY_ORDER_SEQ = 0;
  public static final String POS_PAY_APP_TYPE = "POS";
  public static final String POS_PAY_ROUTE = "WEB";
  public static final String POS_PAY_KEY_IN_SCRN = "POS";
  public static final int POS_PAY_LEDGER_TYPE = 6;

  // ROS CALL
  public static final int ROS_CALLER_USER_ID = 0; // ROSCallerUserID
  public static final int ROS_CALL_STATUS_ID = 4; // ROSCallStatusID = 4;
  public static final int ROS_CALL_CT_ID = 0; // callResultDetails.CallCTID = 0;
  public static final int ROS_CALL_CREATE_BY_DEPT = 0; // callResultDetails.CallCreateByDept
                                                       // = 0;
  public static final int ROS_CALL_HCID = 0; // callResultDetails.CallHCID = 0;

  public static final int ROS_CHECK_SMS_TRUE = 1;
  public static final int ROS_CHECK_SMS_FALSE = 0;

  public static final int ROS_NEW_CALL_ENTRY_TYPE_ID = 507; // newCallEntry.TypeID
                                                            // = 507;
  public static final int ROS_NEW_CALL_ENTRY_STATUS_ID = 1; // newCallEntry.StatusCodeID
                                                            // = 1;
  public static final int ROS_NEW_CALL_ENTRY_RESULT_ID = 0; // newCallEntry.ResultID
                                                            // = 0;
  public static final int ROS_NEW_CALL_ENTRY_DOC_ID = 0;// newCallEntry.DocID =
                                                        // 0;
  public static final int ROS_NEW_CALL_ENTRY_WAIT_CANCEL = 0; // newCallEntry.IsWaitForCancel
                                                              // = false;
  public static final int ROS_NEW_CALL_ENTRY_HAPPY_CALLER_ID = 0; // newCallEntry.HappyCallerID
                                                                  // = 0;

  public static final int ROS_ORD_REM_UPLOAD_STATUS = 1; // det.StatusID = 1;
  public static final int ROS_ORD_VALID_STATUS_ID = 1; // det.ValidStatusID = 1;
  public static final int ROS_ORD_VALID_STATUS_PASS_ID = 4;
  public static final int ROS_ORD_DISABLE_ID = 8;

  public static final int ROS_ORD_VALID_REM = 4;
  public static final int ROS_ORD_INVALID_REM = 21;

  public static final int ROS_CALLER_UPD_STATUS_ID = 1; // callerUpdateM.StatusCodeID
                                                        // = 1;
  public static final int ROS_CALLER_UPD_TOT = 0;
  public static final int ROS_CALLER_UPD_COMPL = 0;
  public static final int ROS_CALLER_UPD_FAIL = 0;

  public static final int ROS_CALLER_UPD_DETAIL_STATUS_CODE_ID = 1; // det.ItemStatusCodeID
                                                                    // = 1;
  public static final int ROS_CALLER_SYS_ORD_ID = 0; // det.SysOrderID = 0;
  public static final int RSO_CALLER_SYS_USER_ID = 0; // det.SysUserID = 0;

  /* Fico Score */
  public static final String FICO_CTOS_REPORT_SUBPATH = "sales";
  public static final String FICO_CTOS_REPORT_FILENAME = "response.html";
  /*
   * callerUpdateM.StatusCodeID = 1; callerUpdateM.TotalComplete = 0;
   * callerUpdateM.TotalFail = 0;
   */
  public static final String FICO_VIEW_TYPE = "FICO_VIEW";
  public static final String CTOS_VIEW_TYPE = "CTOS_VIEW";

  /* EXPERIAN Score */
  public static final String EXPERIAN_REPORT_SUBPATH = "sales";
  public static final String EXPERIAN_REPORT_FILENAME = "expresponse.html";
  public static final String IRISS_VIEW_TYPE = "IRISS_VIEW";
  public static final String IRIS_VIEW_TYPE = "IRIS_VIEW";
  /* EXPERIAN Score */

  /**
   * 메세지 KEY
   */
  public static final String MEM_NO = "sales.MembershipNo";
  public static final String MSG_NO_MEMNO = "sales.msg.noMemNo";
  public static final String ORD_NO = "sales.OrderNo";
  public static final String MSG_NO_ORDNO = "sales.msg.noOrdNo";
  public static final String MSG_STUS_MISMATCH = "sales.msg.stusMismatch";
  public static final String MSG_RENTAL_REM = "sales.msg.rem";

  public static final String MSG_DCF_OUTO_REM = "sales.msg.dcfRem"; // System
                                                                    // Auto
                                                                    // Approve
                                                                    // for TR
                                                                    // Lost
  public static final String MSG_DCF_SETTLED = "sales.msg.settled"; // Approval
                                                                    // result
                                                                    // has
                                                                    // settled.
  public static final String MSG_DCF_SUCC = "sales.msg.dcfSucc"; // TR book lost
                                                                 // result
                                                                 // successfully
                                                                 // saved.
  public static final String MSG_DCF_UNABLE = "sales.msg.dcfUnable"; // Unable
                                                                     // to find
                                                                     // DCF
                                                                     // request
                                                                     // record.

  public static final String MSG_INV_ORDNO = "sales.msg.invOrd"; // Unable to
                                                                 // find DCF
                                                                 // request
                                                                 // record.
  public static final String MSG_INV_AGENTID = "sales.msg.invAgent"; // Unable
                                                                     // to find
                                                                     // DCF
                                                                     // request
                                                                     // record.
  //Supplement Submission Approval
  public static final String SUB_APPOVAL_STATUS_APPROVED = "APV";

  public static final String SUB_APPOVAL_STATUS_FAILED = "FAL";

  public static final String SUB_APPOVAL_STATUS_CANCELLED = "CAN";

  public static final String SUB_APPOVAL_STATUS_REJECTED = "RJT";

  public static final String SUB_APPOVAL_DEL_FLG_N= "N";

  public static final String SUB_APPOVAL_DEL_FLG_Y= "Y";

  public static final String SUPPLEMENT_WH_LOC_CODE = "H000"; // HEAD QUATERS WAREHOUSE LOCATION CODE

  public static final String SUPPLEMENT_WH_LOC_ID = "70574"; // HEAD QUATERS WAREHOUSE LOCATION ID

}
