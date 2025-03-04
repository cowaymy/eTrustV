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
    		case SalesConstants.APP_TYPE_CODE_ID_TRIAL_RENTAL:
    			appTypeName = SalesConstants.APP_TYPE_CODE_TRIAL_RENTAL_FULL;
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
	/** DSC Branch */
	public static final String DSC_BRANCH_TYPE = "43";

	/** Base Term Date */
	public static final String TERM_DT_CD = "5763";

	/** Homecare Category ID */
	public static class HC_CTGRY_ID {
		/** Mattress */
		public static final int MAT = 5706;
		/** Frame */
		public static final int FRM = 5707;
		/** Aircon (Indoor) */
		public static final int ACI = 7237;
		/** Aircon (Outdoor) */
		public static final int ACO = 7241;
		/** Massage Chair */
		public static final int MC = 7177;
	}

	/** Homecare Category CD */
	public static class HC_CTGRY_CD {
		/** Mattress */
		public static final String MAT = "MAT";
		/** Frame */
		public static final String FRM = "FRM";
		/** Aircon (Indoor) */
		public static final String ACI = "ACI";
		/** Aircon (Outdoor) */
		public static final String ACO = "ACO";
		/** Massage Chair */
		public static final String MC = "MC";
	}

	/** Member Type */
	public static class MEM_TYPE {
		/** CT Memeber Type */
		public static final String CT = "3";
		/** DT Memeber Type */
		public static final String DT = "5758";

		public static final String LT = "6672";
	}

}

