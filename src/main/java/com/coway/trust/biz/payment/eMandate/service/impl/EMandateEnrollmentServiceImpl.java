package com.coway.trust.biz.payment.eMandate.service.impl;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.impl.CommonApiMapper;
import com.coway.trust.biz.payment.eMandate.service.EMandateEnrollmentService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.payment.eMandate.controller.EMandateConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 *
 * @author HQIT-HUIDING
 * Jul 13, 2023
 */
@Service("eMandateEnrollmentService")
public class EMandateEnrollmentServiceImpl extends EgovAbstractServiceImpl implements EMandateEnrollmentService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EMandateEnrollmentServiceImpl.class);

	@Value("${eghl.dd.enroll.url}")
	private String enrollUrl;

	@Value("${eghl.dd.serviceId}")
	private String serviceId;

	@Value("${eghl.dd.password}")
	private String password;

	@Resource(name = "eMandateMapper")
	private EMandateMapper eMandateMapper;

	@Resource(name = "CommonApiMapper")
	private CommonApiMapper commonApiMapper;

	private final int eGhlApiUserId = 6;

	/**
	 *
	 * @author HQIT-HUIDING
	 * Jul 13, 2023
	 */
	  @Override
	  public EgovMap checkValidCustomer (Map<String, Object> params){
		  // check customer nric, name and order no
		  // return cust_id, sales_ord_id
		  return eMandateMapper.getOrderByCustomer(params);
	  }

	  @SuppressWarnings("finally")
	  @Override
	  public Map<String, Object> enrollCustomer (Map<String, Object> params) throws Exception{

		  Map<String,Object> returnParams = new HashMap<String, Object>();
		  String outputCode = "";
		  String reqBody = "";
		  String returnEGHLurl = "";

		  String paymentID;
		  // generate new payment ID
		  EgovMap paymentIdObj = eMandateMapper.getNextPaymentId(params);

		  if (paymentIdObj == null){
			  throw new Exception ("[E001] Failed. Please contact administrator.");
		  } else {
			  paymentID = paymentIdObj.get("payId").toString();
		  }

		  //configure client public IP address
		  //String clientIp = CommonUtils.getClientIp(request);
		  String clientIp = params.get("clientIp") != null ? params.get("clientIp").toString() : null;

		  if (clientIp == null){
			  throw new Exception("[E002] Fail to obtain IP Address. Please contact Administrator");
		  } else {
			  if (clientIp.length() > 20){
				  clientIp = clientIp.substring(0, 20); //maximum can set 20 only
			  }
		  }

		  //LOGGER.debug("========IP ==========: "+ clientIp);

		  // rental amount
		  String rentalAmount = params.get("mthRentAmt")+ ".00"; // must be in 2 decimal places

		  // Configure param6 - ID type | ID
		  // ID Type - 1(New IC) - 2(Old IC) - 3(Passport Number) - 4(Business Registration) - 5(Others)
		  String param6 = EMandateConstants.ID_TYPE_NEW_IC + "|" + params.get("nric").toString();

		  // Configure param7 - max recurring times | frequency | effective date
		  String effectiveDate = CommonUtils.getCalDate(1, "ddMMyy");
		  String param7 = EMandateConstants.Maximum_DD_RECURR + "|" + EMandateConstants.FREQ_MODE_WEEKLY + "|"  + effectiveDate;

		  // Configure respond URL to be used in hashvalue
		  String approvedURL = EMandateConstants.RESPOND_URL + "?payId=" +  paymentID + ";status=" + EMandateConstants.STATUS_MERCHANT_APPROVED;
		  String unApprovedURL = EMandateConstants.RESPOND_URL + "?payId=" +  paymentID + ";status=" + EMandateConstants.STATUS_MERCHANT_UNAPPROVE;

		  // Configure HashValue
		  /**Hash Key = Password + ServiceID + PaymentID + MerchantReturnURL + MerchantApprovalURL + MerchantUnApprovalURL +
		   * MerchantCallBackURL + Amount +
		   * +CurrencyCode + CustIP + PageTimeout + CardNo + Token + RecurringCriteria*/
		  String hashKey = password + serviceId + paymentID + unApprovedURL + approvedURL + unApprovedURL + unApprovedURL + rentalAmount +
				  					EMandateConstants.CURRENCY_CODE + clientIp + EMandateConstants.PAGE_TIME_OUT;

		  LOGGER.debug("========Hash Key==========: "+ hashKey);
		  String hashValue = DigestUtils.sha256Hex(hashKey);
		  LOGGER.debug("========Hash Value==========: "+ hashValue);

		  // insert request into request Table
		  params.put("userId", 349);
		  params.put("paymentId", paymentID);
		  params.put("paymentMode", EMandateConstants.PYMT_METHOD_DD);
		  params.put("stus", EMandateConstants.STATUS_IN_PROGRESS); // default IN Progress status
		  params.put("amt", rentalAmount);
		  params.put("hashKey", hashKey);
		  params.put("effectDate", effectiveDate);

		  eMandateMapper.insertDDRequest(params);


		  String respTm = null;
		  StopWatch stopWatch = new StopWatch();
		  stopWatch.reset();
		  stopWatch.start();

		  try {
			  URL url = new URL(enrollUrl);
			  LOGGER.error("Start Calling eGHL Enrollment API ...." + enrollUrl + "......\n");

			  reqBody = new StringBuffer("TransactionType=").append(EMandateConstants.TRANSACTION_TYPE)
					  .append("&PymtMethod=").append(EMandateConstants.PYMT_METHOD_DD)
					  .append("&ServiceID=").append(serviceId)
					  .append("&PaymentId=").append(paymentID)
					  .append("&OrderNumber=").append(params.get("orderNo").toString())
					  .append("&PaymentDesc=").append(EMandateConstants.PAYMENT_DESC)
					  .append("&Amount=").append(rentalAmount)
					  .append("&CurrencyCode=").append(EMandateConstants.CURRENCY_CODE)
					  .append("&HashValue=").append(hashValue)
					  .append("&CustIP=").append(clientIp)
					  .append("&CustName=").append(params.get("name").toString())
					  .append("&CustEmail=").append(EMandateConstants.DEFAULT_EMAIL_ADDR)
					  .append("&CustPhone=").append(EMandateConstants.DEFAULT_HP_NO)
					  .append("&MerchantApprovalURL=").append(approvedURL)
					  .append("&MerchantUnApprovalURL=").append(unApprovedURL)
					  .append("&MerchantReturnURL=").append(unApprovedURL)
					  .append("&MerchantCallBackURL=").append(unApprovedURL)
					  .append("&LanguageCode=").append(EMandateConstants.LANGUAGE_CODE)
					  .append("&PageTimeout=").append(EMandateConstants.PAGE_TIME_OUT)
					  .append("&Param6=").append(param6)
					  .append("&Param7=").append(param7)
					  .toString();

			  LOGGER.info("eGHL Enrollment API Request: " + reqBody + "\n");

			  HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			  conn.disconnect();
			  conn.setDoInput(true);
			  conn.setDoOutput(true);
			  conn.setRequestMethod("POST");
			  conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			  conn.connect();

			  DataOutputStream out = new DataOutputStream(conn.getOutputStream());
			  out.writeBytes(reqBody);
//			  out.flush();
//		      out.close();

		      LOGGER.error("End Calling eGHL API return... " + conn.getResponseCode() + "......\n");
		      LOGGER.info("return url: " + conn.getURL()+ "\n");

		      InputStream inputStream;
		        if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {

		        	BufferedReader br = new BufferedReader(new InputStreamReader(
			                (conn.getInputStream())));
		        	returnEGHLurl = conn.getURL().toString();

//		            inputStream = conn.getInputStream();
		            returnParams.put("status", AppConstants.SUCCESS);
//		            returnParams.put("msg", "");

			        LOGGER.debug("Output from Server .... \n");
			        returnParams.put("url", returnEGHLurl);

			        conn.disconnect();
					br.close();

		        } else {
		            inputStream = conn.getErrorStream();
		            returnParams.put("status", AppConstants.FAIL);
		        }
		        out.flush();
			      out.close();

		  } catch (Exception e) {
			  throw e;
		  } finally{

				stopWatch.stop();
			    respTm = stopWatch.toString();

			    params.put("responseCode", returnParams.get("status") == null ? "" : returnParams.get("status").toString());
	            params.put("responseMessage", returnParams.get("msg") == null ? "" : returnParams.get("msg").toString());
	            params.put("reqPrm", reqBody);
	            params.put("ipAddr", clientIp);
	            params.put("url", enrollUrl);
	            params.put("respTm", respTm);
	            params.put("resPrm", returnEGHLurl);
	            params.put("apiUserId", eGhlApiUserId);
	            params.put("refNo", paymentID == null ? params.get("nric").toString() : paymentID);

				rtnRespMsg(params);

				return returnParams;
		  }

	  }

	@Transactional(propagation = Propagation.REQUIRES_NEW)
	@Override
	public void rtnRespMsg(Map<String, Object> param) {

	    EgovMap data = new EgovMap();
	    Map<String, Object> params = new HashMap<>();

	      params.put("respCde", param.get("responseCode"));
	      params.put("errMsg", param.get("responseMessage"));
	      params.put("reqParam", param.get("reqPrm"));
	      params.put("ipAddr", param.get("ipAddr"));
	      params.put("prgPath", param.get("url"));
	      params.put("respTm", param.get("respTm"));
	      params.put("respParam", param.get("resPrm"));
	      params.put("apiUserId", param.get("apiUserId"));
	      params.put("refNo", param.get("refNo"));

	      commonApiMapper.insertApiAccessLog(params);
	  }

	/**
	 * Process enrollment respond from eGHL
	 * params: payId, enrolRespond
	 * @author HQIT-HUIDING
	 * Jul 24, 2023
	 */
	 public Map<String, Object> enrollRespond (Map<String, Object> params) throws Exception{
		 Map<String,Object> returnParams = new HashMap<String, Object>();

		 LOGGER.info("=======respondParams======: " + params.toString()); //eg: {payId=CDD2307250000085;status=99}

		 if (params == null || params.isEmpty()){
			 throw new Exception("E003. Fail. Empty respond params");
		 }

		 String paramList = (String) params.get("payId"); //
		 LOGGER.info("=======paramList======: " + paramList); //eg: CDD2307250000085;status=99

		 String[] param = paramList.split("[;=]");
		 returnParams.put("payId", param[0]); // eg: CDD2307250000085
		 returnParams.put("status", param[2]);// eg: 99

		 LOGGER.info("=======finalParams======: " + returnParams);// eg: {payId=CDD2307250000085, status=99}

		 // update DD request status
		 Map<String, Object> respInfo = new HashMap<String, Object>();
		 respInfo.put("userId", 349);

		 if (CommonUtils.nvl(returnParams.get("status")) != null && returnParams.get("status").equals("00")){
			 respInfo.put("status", EMandateConstants.STATUS_SUCCESS);
		 } else {
			 respInfo.put("status", EMandateConstants.STATUS_FAILED);
		 }

		 respInfo.put("paymentId", returnParams.get("payId"));

		 eMandateMapper.updateStatusDDRequest(respInfo);


		 return returnParams;

	 }

	 @Override
	 public Map<String, Object> getEnrollInfoByPaymentId (String paymentId){

		 Map<String, Object> param = new HashMap<String, Object>();
		 param.put("paymentId", paymentId);

		 return eMandateMapper.getEnrollInfoByPaymentId(param);
	 }

}
