package com.coway.trust;

public class AppConstants {

	private AppConstants() {
	}

	public static final String SLASH = "/";

	// API 버전
	public static final String TAG = SLASH + "v1";

	public static final String MOBILE = "mobile";

	public static final String CALLCENTER = "callcenter";

	public static final String WEB = "web";

	public static final String PATH_API = SLASH + "api";

	public static final int RECORD_COUNT_PER_PAGE = 10;

	public static final int RECORD_MAX_SIZE = 100000;
	public static final int EXCEL_UPLOAD_MAX_ROW = 500000;


	public static final String CALLCENTER_TOKEN_KEY = "_TOKEN";
	public static final String CALLCENTER_USER_KEY = "_USER_ID";


	// API BASE UR
	public static final String API_BASE_URI = AppConstants.PATH_API + AppConstants.TAG;
	public static final String CALL_CENTER_API_BASE_URI = AppConstants.SLASH + AppConstants.CALLCENTER
			+ AppConstants.API_BASE_URI;
	public static final String MOBILE_API_BASE_URI = AppConstants.SLASH + AppConstants.MOBILE
			+ AppConstants.API_BASE_URI;
	public static final String WEB_API_BASE_URI = AppConstants.SLASH + AppConstants.WEB
      + AppConstants.API_BASE_URI ;

	public static final String DEFAULT_CHARSET = "UTF-8";

	/**
	 * 로그인 히스토리
	 */
	public static final String LOGIN_WEB = "01";
	public static final String LOGIN_MOBILE = "02";
	public static final String LOGIN_CALL_CENTER = "03";

	/**
	 * URL
	 */
	public static final String REDIRECT_LOGIN = "redirect:/login/login.do";
	public static final String REDIRECT_MOBILE_LOGIN = "redirect:/mobileWeb/login.do";
	public static final String REDIRECT_UNAUTHORIZED = "redirect:/common/unauthorized.do";
	public static final String REDIRECT_CUSTOMER_LOGIN = "redirect:/enquiry/trueaddress.do";
	public static final String REDIRECT_CUSTOMER_CONSENT = "redirect:/sales/ccp/consent";
	public static final String CUSTOMER_WEB = "/enquiry";
	public static final String CUSTOMER_CONSENT = "/sales/ccp/consent";
	/**
	 * ajax return code
	 */
	public static final String SUCCESS = "00";

	public static final String FAIL = "99";

	public static final String SERVER_ERROR= "SERVER_ERROR";

	public static final String RETRY = "RETRY";

	/**
	 * file 관련
	 */
	public static final long UPLOAD_MAX_FILE_SIZE = 1024 * 1024 * 100; // 업로드 최대 사이즈 설정 (100M)
	public static final long UPLOAD_MIN_FILE_SIZE = 1024 * 1024 * 2; // 업로드 최대 사이즈 설정 (2M)
    public static final long UPLOAD_EXCEL_MAX_SIZE = 1024 * 1024 * 20; // 업로드 최대 사이즈 설정 (20M)
	public static final String MSG_IS_NOT_ALLOW = " is not allow.";

	/**
	 * excel config
	 */
	public static final String FILE_NAME = "fileName";
	public static final String HEAD = "head";
	public static final String BODY = "body";

	public static final String XLS = "xls";
	public static final String XLSX = "xlsx";

	/**
	 * ehcache
	 */
	public static final String LEFT_MENU_CACHE = "menu_cache";
	public static final String LEFT_MY_MENU_CACHE = "my_menu_cache";
	public static final String PERIODICAL_CACHE = "periodical_cache";

	/**
	 * session info
	 */
	public static final String SESSION_INFO = "SESSION_INFO";

	/**
	 * MENU
	 */
	public static final String CURRENT_MENU_CODE= "CURRENT_MENU_CODE";
	public static final String MENU_KEY = "MENU_KEY";
	public static final String MENU_FAVORITES = "MENU_FAVORITES";
	public static final String PAGE_AUTH = "PAGE_AUTH";

	/**
	 * AUIGrid
	 */
	public static final String AUIGRID_ADD = "add";
	public static final String AUIGRID_UPDATE = "update";
	public static final String AUIGRID_REMOVE = "remove";
	public static final String AUIGRID_CHECK = "checked";
	public static final String AUIGRID_ALL = "all";
	public static final String AUIGRID_FORM = "form";

	/**
	 * CrystalReport
	 */
	public static final String REPORT_DOWN_FILE_NAME = "reportDownFileName";
	public static final String REPORT_FILE_NAME = "reportFileName";
	public static final String REPORT_VIEW_TYPE = "viewType";
	public static final String REPORT_CLIENT_DOCUMENT = "com.crystaldecisions.sdk.occa.report.application.ReportClientDocument";

	/**
	 * Email
	 */
	public static final String EMAIL_SUBJECT = "emailSubject";
	public static final String EMAIL_TEXT = "emailText";
	public static final String EMAIL_TO = "emailTo";
	public static final String EMAIL_URL = "url";

	/**
	 * 5 hours
	 */
	public static final int SESSION_MAX_INACTIVE_INTERVAL = 5 * 60 * 60;

	/**
	 * Example: 2014-11-21 16:25:32
	 */
	public static final String DEFAULT_TIMESTAMP_FORMAT = "yyyy-MM-dd HH:mm:ss";

	/**
	 * Example: 2014-11-21T16:25:32-05:00
	 */
	public static final String DEFAULT_TIMESTAMP_GMT_FORMAT = "yyyy-MM-dd'T'HH:mm:ssZ";

	/**
	 * Example: 2016-04-06T16:04:10.626+0900
	 */
	public static final String DEFAULT_TIMESTAMP_GMT_NANOFORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";

	/**
	 * Arrays 값을 하나의 문자열로 전달 하는 경우 "대|!|한|!|민|!|국" 과 같이 전달 한다.
	 */
	public static final String DEFAULT_DELIMITER = "|!|";

	/**
	 * 공통 메세지 KEY
	 */
	public static final String MSG_SUCCESS = "sys.msg.success";
	public static final String MSG_FAIL = "sys.msg.fail";
	public static final String MSG_NOT_EXIST = "sys.msg.notexist";
	public static final String MSG_INVALID = "sys.msg.invalid";
	public static final String MSG_NECESSARY = "sys.msg.necessary";
	public static final String MSG_FILE_MAX_LIMT = "sys.msg.file.limit";
	public static final String MSG_INVALID_TOKEN = "sys.msg.invalid.token";
	public static final String MSG_ERROR = "enquiry.errorMsg";
	/**
	 * 공통 코드 KEY
	 */
	public static final int CODE_EMPLOYEE_TYPE = 1;
	public static final int CODE_RACE_TYPE = 2;
	public static final int CODE_LANGUAGE_TYPE = 3;
	public static final int CODE_MARITAL_STATUS = 4;
	public static final int CODE_EDUCATION_LEVEL = 5;
	public static final int CODE_MEMBER_RANK = 6;
	public static final int CODE_TRANSPORT_TYPE = 7;
	public static final int CODE_APPLICATION_TYPE = 10;
	public static final int CODE_WAREHOUSE_TYPE = 14;
	public static final int CODE_PAY_MODE = 36;
	public static final int CODE_PAY_TYPE = 48;
	public static final int CODE_DISCOUNT_TYPE = 74;

	public static final int SIRIM_TRANSFER = 72;

	public static final int RESPONSE_CODE_SUCCESS = 200;
	public static final int RESPONSE_CODE_CREATED = 201;
	public static final int RESPONSE_CODE_INVALID = 400;
	public static final int RESPONSE_CODE_UNAUTHORIZED = 401;
	public static final int RESPONSE_CODE_FORBIDDEN = 403;
	public static final int RESPONSE_CODE_NOT_FOUND = 404;
	public static final int RESPONSE_CODE_TIMEOUT = 405;

	public static final int RESPONSE_CODE_INTERNAL_UNEXPECTED = 1;
	public static final int RESPONSE_CODE_INTERNAL_NOT_FOUND = 2;
	public static final int RESPONSE_CODE_INTERNAL_NO_STOCK = 3;
	public static final int RESPONSE_CODE_INTERNAL_SUCCESS = 4;
	public static final int RESPONSE_CODE_INTERNAL_FAILED = 5;

	public static final String RESPONSE_DESC_SUCCESS = "Successful Operation";
	public static final String RESPONSE_DESC_CREATED = "Successful Created";
	public static final String RESPONSE_DESC_INVALID = "Invalid Parameter(s) supplied";
	public static final String RESPONSE_DESC_UNAUTHORIZED = "Invalid API Key";
	public static final String RESPONSE_DESC_FORBIDDEN = "Forbidden";
	public static final String RESPONSE_DESC_NOT_FOUND = "User not found";
	public static final String RESPONSE_DESC_DUP = "Duplicated record(s)";
	public static final String RESPONSE_DESC_NOT_COVERED = "Address area not in coverage";

	public static final String DESC_SUCCESS = "Success";
	public static final String DESC_FAILED = "Failed";
	public static final String DESC_INPROGRESS = "In-Progress";

	//batch email
	public static final int EMAIL_TYPE_TEMPLATE = 1;
	public static final int EMAIL_TYPE_NORMAL = 2;

	//etrust batch template path
	public static final String E_VOUCHER_RECEIPT_BATCH_TEMPLATE = "template/html/eVoucherReceipt.html";

	public static final String BILLER_CODE = "9928 (COWAY (MALAYSIA) SDN BHD)";

	//whatsApp
	public static final String WA_TYPE_TEMPLATE = "wa_template";
	public static final String WA_PLATFORM = "whatsapp";
	public static final String LANGUAGE_EN = "en";
	public static final String LANGUAGE_CN = "cn";
	public static final String LANGUAGE_MS = "ms";
	public static final String COUNTRY_CODE_MY = "60";
	public static final String CODE_MY = "6";

	public static final String WA_CALL_LOG_HA_TNC_FILE_NAME = "SOF_CowayRentalTnc.pdf";
	public static final String WA_CALL_LOG_HC_TNC_FILE_NAME = "MSOF_CowayRentalTnc.pdf";
}
