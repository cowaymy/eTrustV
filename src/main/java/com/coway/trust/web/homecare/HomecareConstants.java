package com.coway.trust.web.homecare;

import com.coway.trust.web.sales.SalesConstants;

/**
 * @ClassName : HomecareConstants.java
 * @Description : Homecare Constants
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 30.   KR-SH        First creation
 * </pre>
 */
public class HomecareConstants {

	/**
	 * AppTypeID Conversion AppTypeName
	 * @Author KR-SH
	 * @Date 2019. 10. 30.
	 * @param appTypeId
	 * @return appTypeName
	 */
	public static String cnvAppTypeName(int appTypeId){
		String appTypeName = "";

		switch (appTypeId) {
    		case SalesConstants.APP_TYPE_CODE_ID_RENTAL:
    			appTypeName = SalesConstants.APP_TYPE_CODE_RENTAL_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT:
    			appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHT_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT:
    			appTypeName = SalesConstants.APP_TYPE_CODE_INSTALLMENT_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_SPONSOR:
    			appTypeName = SalesConstants.APP_TYPE_CODE_SPONSOR_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_SERVICE:
    			appTypeName = SalesConstants.APP_TYPE_CODE_SERVICE_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_EDUCATION:
    			appTypeName = SalesConstants.APP_TYPE_CODE_EDUCATION_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_FREE_TRIAL:
    			appTypeName = SalesConstants.APP_TYPE_CODE_FREE_TRIAL_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS:
    			appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHTPLUS_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_AUX:
    			appTypeName = SalesConstants.APP_TYPE_CODE_AUX_FULL;
    			break;
    		default:
    			break;
    	}
		return appTypeName;
	}

	/**
	 * @ClassName : HomecareConstants.java
	 * @Description : Homecare Pre Order Status
	 *
	 * @History
	 * <pre>
	 * Date            Author       Description
	 * -------------  -----------  -------------
	 * 2019. 11. 11.   KR-SH        First creation
	 * </pre>
	 */
	public static class HC_PRE_ORDER {
		/** Homecare Pre Order Status - Active */
		public static final int STATUS_ACT = 1;
		/** Homecare Pre Order Status - Cancelled */
		public static final int STATUS_CAN = 10;
		/** Homecare Pre Order Status - Failed */
		public static final int STATUS_FAL = 21;
	}

	public static class TB_ORG0029H_DISAB {
		/** add */
		public static final int ADD = 1;
		/** delete */
		public static final int DELETE = 0;
	}

	/** HDC Branch */
	public static final String HDC_BRANCH_TYPE = "5754";
	/** HDC Member */
	public static final String HDC_MEMBET_TYPE = "5758";
	/** Base Term Date */
	public static final String TERM_DT_CD = "5763";

	/** Homecare Category ID */
	public static class HC_CTGRY_ID {
		/** Mattress */
		public static final int MAT = 5706;
		/** Frame */
		public static final int FRM = 5707;
	}

}

