package com.coway.trust.web.payment.eMandate.controller;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

public class EMandateConstants {

	public static final String TRANSACTION_TYPE = "EMANDATE01";
	public static final String PYMT_METHOD_DD = "DD";
	public static final String CURRENCY_CODE = "MYR";
	public static final String RESPOND_URL = "https://etrust.my.coway.com/payment/enroll/ddRespond.do";
	//public static final String RESPOND_URL = "http://localhost:8080/payment/enroll/ddRespond.do";

	public static final String LANGUAGE_CODE = "EN";
	public static final int PAGE_TIME_OUT = 900; // enrollment page time out in second

	public static final String FREQ_MODE_DAILY = "DL";
	public static final String FREQ_MODE_WEEKLY = "WK";
	public static final String FREQ_MODE_MONTHLY = "MT";
	public static final String FREQ_MODE_YEARLY = "YR";

	public static final String ID_TYPE_NEW_IC = "1";
	public static final String ID_TYPE_OLD_IC = "2";
	public static final String ID_TYPE_PASSPORT_NUMBER = "3";
	public static final String ID_TYPE_BRN = "4"; // business registration number
	public static final String ID_TYPE_OTHERS = "5";

	public static final String DEFAULT_HP_NO = "0100000000";
	public static final String DEFAULT_EMAIL_ADDR = "sample@email.com";
	public static final String PAYMENT_DESC = "Rental Payment";

	public static final String MAXIMUM_DD_AMOUNT = "999.00"; // must be in 2 decimal places
	public static final String Maximum_DD_RECURR = "2";

	public static final String STATUS_MERCHANT_APPROVED = "00";
	public static final String STATUS_MERCHANT_UNAPPROVE = "99";
	public static final int STATUS_IN_PROGRESS = 60;
	public static final int STATUS_FAILED = 21;
	public static final int STATUS_SUCCESS = 71;


}

