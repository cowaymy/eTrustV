package com.coway.trust.biz.api.impl;

import static com.coway.trust.AppConstants.MSG_NECESSARY;
import static com.coway.trust.AppConstants.REPORT_CLIENT_DOCUMENT;
import static com.coway.trust.AppConstants.REPORT_DOWN_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_VIEW_TYPE;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.Month;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.ChatbotInboundApiService;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.vo.chatbotInbound.CustomerVO;
import com.coway.trust.biz.api.vo.chatbotInbound.GetOtdReqForm;
import com.coway.trust.biz.api.vo.chatbotInbound.GetPayModeReqForm;
import com.coway.trust.biz.api.vo.chatbotInbound.JompayVO;
import com.coway.trust.biz.api.vo.chatbotInbound.OrderListReqForm;
import com.coway.trust.biz.api.vo.chatbotInbound.OrderVO;
import com.coway.trust.biz.api.vo.chatbotInbound.OutStdVO;
import com.coway.trust.biz.api.vo.chatbotInbound.StatementReqForm;
import com.coway.trust.biz.api.vo.chatbotInbound.PaymentVO;
import com.coway.trust.biz.api.vo.chatbotInbound.VerifyCustIdentityReqForm;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.biz.common.ReportBatchService;
import com.coway.trust.biz.sales.order.impl.OrderLedgerMapper;
import com.coway.trust.cmmn.CRJavaHelper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.Precondition;
import com.coway.trust.util.ReportUtils;
import com.coway.trust.web.common.CommonController;
import com.coway.trust.web.common.ReportController;
import com.coway.trust.web.common.ReportController.ViewType;
import com.coway.trust.web.common.claim.ClaimFileFPXHandler;
import com.coway.trust.web.common.visualcut.ReportBatchController;
import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ParameterFieldController;
import com.crystaldecisions.sdk.occa.report.application.ReportAppSession;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("chatbotInboundApiService")
public class ChatbotInboundApiServiceImpl extends EgovAbstractServiceImpl implements ChatbotInboundApiService{
	private static final Logger LOGGER = LoggerFactory.getLogger(ChatbotInboundApiServiceImpl.class);

	@Resource(name = "ChatbotInboundApiMapper")
	private ChatbotInboundApiMapper chatbotInboundApiMapper;

	@Resource(name = "CommonApiMapper")
	private CommonApiMapper commonApiMapper;

	@Resource(name = "commonApiService")
	private CommonApiService commonApiService;

	@Resource(name = "orderLedgerMapper")
	private OrderLedgerMapper orderLedgerMapper;

	@Value("${com.file.upload.path}")
	private String fileUploadPath;

	@Value("${web.resource.upload.file}")
	private String webResourseUploadPath;

	@Autowired
	  private AdaptorService adaptorService;
	@Autowired
	  private LargeExcelService largeExcelService;
	  @Autowired
	  private MessageSourceAccessor messageAccessor;
	  @Value("${report.datasource.driver-class-name}")
	  private String reportDriverClass;
	  @Value("${report.datasource.url}")
	  private String reportUrl;

	  @Value("${report.datasource.username}")
	  private String reportUserName;

	  @Value("${report.datasource.password}")
	  private String reportPassword;

	  @Value("${report.file.path}")
	  private String reportFilePath;

	  @Value("${web.resource.upload.file}")
	  private String uploadDirWeb;
	  @Autowired
	  private ReportBatchService reportBatchService;
//	@Autowired
//	private ReportBatchController reportBatchController;

	@Override
	public EgovMap verifyCustIdentity(HttpServletRequest request, VerifyCustIdentityReqForm param) throws Exception {

	    String respTm = null, apiUserId = "0", reqParam = null, respParam = null;

	    EgovMap params = new EgovMap();
	    EgovMap resultValue = new EgovMap();
	 	List<CustomerVO> cust = new ArrayList<>();
	    StopWatch stopWatch = new StopWatch();

	 	try{
    	    stopWatch.reset();
    	    stopWatch.start();

    	    EgovMap authorize = verifyBasicAuth(request);

    	    if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){
    	    	// Check phone number whether exist or not
    	    	if(CommonUtils.isEmpty(param.getCustPhoneNo())){
    	    		resultValue.put("success", false);
    	    		resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    	    		resultValue.put("message", "Customer phone number is required");
    	    		return resultValue;
    	    	}

    	   	    String custPhoneNo = param.getCustPhoneNo().toString();
    	   	    params.put("custPhoneNo", custPhoneNo);

    	   	    Gson gson = new GsonBuilder().create();
    	   	    reqParam = gson.toJson(params);

    	   	    LOGGER.debug(">>> reqParam :" + reqParam);

    			apiUserId = authorize.get("apiUserId").toString();

    		    // Trim country calling code in phone number
    			String custPhoneNoWoutCode = custPhoneNo.substring(1);
    			params.put("custPhoneNoWoutCode", custPhoneNoWoutCode);

    		    // Get customer info
    			List<EgovMap> customerVO = chatbotInboundApiMapper.verifyCustIdentity(params);

    			if(customerVO.size() > 0){

    				for(EgovMap custList : customerVO){
    					CustomerVO customerList = CustomerVO.create(custList);
    					cust.add(customerList);
    				}

    			    respParam = gson.toJson(customerVO);

    	    		params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
    	    		params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
    	    		params.put("respParam", respParam.toString());

    			}else{
    	    		params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    	    		params.put("message", "Customer not found");
    			}

    	    }else{
        		params.put("statusCode", authorize.get("code"));
        		params.put("message", authorize.get("message").toString());
    	    }

	 	} catch(Exception e){
	 		params.put("statusCode", AppConstants.FAIL);
	 		params.put("message", !CommonUtils.isEmpty(e.getMessage()) ? e.getMessage() : "Failed to get info.");
			e.printStackTrace();
	 		LOGGER.debug(">>> Error Message :" + e);

	 	} finally{
	 		// Return result
	        if(params.get("statusCode").toString().equals("200") || params.get("statusCode").toString().equals("201")){
	        	resultValue.put("success", true);
	        }else{
	        	resultValue.put("success",false);
	        }

	        resultValue.put("statusCode", params.get("statusCode"));
	        resultValue.put("message", params.get("message"));

		    if(params.containsKey("respParam")){
	        	resultValue.put("customers", cust);
	        }

		    stopWatch.stop();
		    respTm = stopWatch.toString();

		    // Insert log into API0004M
		    params.put("reqParam", CommonUtils.nvl(reqParam));
		    params.put("ipAddr", CommonUtils.getClientIp(request));
		    params.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
		    params.put("respTm", CommonUtils.nvl(respTm));
		    params.put("apiUserId", CommonUtils.nvl(apiUserId));
		    rtnRespMsg(params);
	 	}

	 	return resultValue;
	}


	@Override
	public EgovMap getOrderList(HttpServletRequest request, OrderListReqForm reqParameter) throws Exception {
		String respTm = null, apiUserId = "0", reqParam = null, respParam = null;

		StopWatch stopWatch = new StopWatch();
		EgovMap resultValue = new EgovMap();
		List<OrderVO> orderVO = new ArrayList<>();
		Map<String, Object> params = new HashMap<String, Object>();

		try{
    		stopWatch.reset();
    		stopWatch.start();

    		EgovMap authorize = verifyBasicAuth(request);

    		if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){

    			if(CommonUtils.intNvl(reqParameter.getCustId()) < 0){
    				resultValue.put("success", false);
    				resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    				resultValue.put("message", "Customer ID is required");
    				return resultValue;
    			}

    			if(reqParameter.getCustNric().isEmpty()){
    				resultValue.put("success", false);
    				resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    				resultValue.put("message", "Customer NRIC is required");
    				return resultValue;
    			}

    			params.put("custId", reqParameter.getCustId());
    			params.put("custNric", reqParameter.getCustNric());

    			Gson gson = new GsonBuilder().create();
    			reqParam = gson.toJson(reqParameter);

    			apiUserId = authorize.get("apiUserId").toString();

    			// Get customer info
    			int isCustExist = chatbotInboundApiMapper.isCustExist(params);

    			LOGGER.debug("isCustExist :" + isCustExist);
    			if(isCustExist > 0){


    				List<Map<String, Object>> orderListRaw = chatbotInboundApiMapper.getOrderList(params);
    				for(Map<String, Object> orderRaw : orderListRaw){
    					OrderVO order = OrderVO.create(orderRaw);
    					orderVO.add(order);
    				}

    				respParam = gson.toJson(orderVO);

    				params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
    				params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
    				params.put("respParam", respParam.toString());

    			}else{
    				params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    				params.put("message", "Customer not found");
    			}

    		}else{
    			params.put("statusCode", authorize.get("code"));
    			params.put("message", authorize.get("message").toString());
    		}

    		// Return result
    		if(params.get("statusCode").toString().equals("200")){
    			resultValue.put("success", true);
    		}else{
    			resultValue.put("success",false);
    		}

    		resultValue.put("statusCode", params.get("statusCode"));
    		resultValue.put("message", params.get("message"));

    		if(params.containsKey("respParam")){
    			resultValue.put("orders", orderVO);
    		}

		}catch(Exception ex){
			resultValue.put("success",false);
			resultValue.put("statusCode", AppConstants.FAIL);
			resultValue.put("message", !CommonUtils.isEmpty(ex.getMessage()) ? ex.getMessage() : "Failed to get info.");
			ex.printStackTrace();
			LOGGER.error(">>> Exception :" + ex);
		}finally{
    		stopWatch.stop();
    		respTm = stopWatch.toString();

    		// Insert log into API0004M
    		params.put("reqParam", CommonUtils.nvl(reqParam));
    		params.put("ipAddr", CommonUtils.getClientIp(request));
    		params.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
    		params.put("respTm", CommonUtils.nvl(respTm));
    		params.put("apiUserId", CommonUtils.nvl(apiUserId));
    		params.put("respParam", CommonUtils.nvl(resultValue));
    		rtnRespMsg(params);

    		return resultValue;
		}
	}

	@Override
	public EgovMap sendStatement(HttpServletRequest request, Map<String, Object> params) throws Exception {
		String respTm = null, apiUserId = "0", reqParam = null, respParam = null;

		StopWatch stopWatch = new StopWatch();
		EgovMap resultValue = new EgovMap();
		List<OrderVO> orderVO = new ArrayList<>();
		ObjectMapper mapper = new ObjectMapper();

		try{
    		stopWatch.reset();
    		stopWatch.start();

    		EgovMap authorize = verifyBasicAuth(request);

    		if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){

    			// Check phone number whether exist or not
    			String data = commonApiService.decodeJson(request);
    			Gson g = new Gson();
    			StatementReqForm reqParameter = g.fromJson(data, StatementReqForm.class);

    			if(reqParameter.getOrderNo().isEmpty()){
    				resultValue.put("success", false);
    				resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    				resultValue.put("message", "Order  Number is required");
    				return resultValue;
    			}

    			if(reqParameter.getOrderId() < 0){
    				resultValue.put("success", false);
    				resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    				resultValue.put("message", "Order ID is required");
    				return resultValue;
    			}

    			if(reqParameter.getCustEmailAdd().isEmpty()){
    				resultValue.put("success", false);
    				resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    				resultValue.put("message", "Customer Email Address is required");
    				return resultValue;
    			}

    			if(reqParameter.getStatementType() < 0){
    				resultValue.put("success", false);
    				resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    				resultValue.put("message", "Statement Type is required");
    				return resultValue;
    			}

    			if((reqParameter.getStatementType() == 1 || reqParameter.getStatementType() == 2) && reqParameter.getMonth() < 1){
    				resultValue.put("success", false);
    				resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    				resultValue.put("message", "Month is required");
    				return resultValue;
    			}

    			params.put("orderNo", reqParameter.getOrderNo());
    			params.put("orderId", reqParameter.getOrderId());
    			params.put("custEmailAdd", reqParameter.getCustEmailAdd());
    			params.put("statementType", reqParameter.getStatementType());
    			params.put("month", reqParameter.getMonth());

    			Gson gson = new GsonBuilder().create();
    			reqParam = gson.toJson(reqParameter);

    			apiUserId = authorize.get("apiUserId").toString();

    			Map<String, Object> emailReqParam = new HashMap<String, Object>();

     			Calendar calNow = Calendar.getInstance();
    			int nowYear = calNow.get(Calendar.YEAR);
    			int requestYear = 0;
    			int nowMonth = calNow.get(Calendar.MONTH) +1;
    			String requestMonth = "";
    			String monthName = "";

    			if((reqParameter.getStatementType() == 1 || reqParameter.getStatementType() == 2) && reqParameter.getMonth() > 0){
    				requestMonth = String.format("%02d", Integer.valueOf(params.get("month").toString()));
        			if(nowMonth < Integer.valueOf(params.get("month").toString())){
        				requestYear = nowYear -1;
        			}else{
        				requestYear = nowYear;
        			}
        			params.put("year", requestYear);
        			Month month = Month.of(Integer.valueOf(params.get("month").toString()));
        			monthName = month.toString();
    			}

    			Date currentDate = calNow.getTime();
    			SimpleDateFormat dateFormat = new SimpleDateFormat("ddMMyyyy");
    			String formattedDate = dateFormat.format(currentDate);

    			Map<String, Object> rptParam = new HashMap();
    			//Search Statement ID
    			if(reqParameter.getStatementType() == 1){//SOA
    				Map<String, Object> invoiceDet = chatbotInboundApiMapper.getSoaDet(params);
    				if(invoiceDet == null){
    					throw new Exception("order not found");
    				}
    				rptParam.put("v_statementID", invoiceDet.get("stateId"));
    				rptParam.put("V_TEMP", "TEMP");
    				rptParam.put("date", monthName + " "+ String.valueOf(requestYear));
    				rptParam.put("requestNameType", "STATEMENT OF ACCOUNT");
    				rptParam.put("custEmail", params.get("custEmailAdd").toString());
    				emailReqParam.put("rptName", "/statement/Official_StatementofAccount_Company_PDF_New.rpt");
    				emailReqParam.put("fileName", "SOA_"+ params.get("orderNo").toString() + "_StatementPeriod(" + requestMonth + requestYear + ").pdf");
    			}else if(reqParameter.getStatementType() == 2){//Tax Invoice
    				Map<String, Object> invoiceDet = chatbotInboundApiMapper.getInvoiceDet(params);
    				if(invoiceDet == null){
    					throw new Exception("order not found");
    				}
    				String invcDt = invoiceDet.get("invcDt").toString();
    				String[] invcDtSplit = invcDt.split("/");
    				String day = invcDtSplit[0];
    				String invcDay = String.format("%02d", Integer.valueOf(day));

    				// Check E-Invoice
    				boolean getEInv = false;

    			    EgovMap eInvResult = chatbotInboundApiMapper.checkRenEInv(invoiceDet);

    			    if(eInvResult != null){
    			    	String result = eInvResult.get("genEInv").toString();
    			    	 int year = Integer.parseInt(eInvResult.get("year").toString()) * 100;
    			    	 int month = Integer.parseInt(eInvResult.get("month").toString());

    			    	 int eInvStrDt = Integer.parseInt(chatbotInboundApiMapper.getEInvStrDt().get("paramVal").toString());

    			    	 if(result.equals("Y") && (year + month >= eInvStrDt)){ // will not send eInvoice through E-statement due to 08/24 undergo Pilot test
    			    		 getEInv = true;
    			    	 }
    			    }

    			    if(getEInv == true){
    			    	emailReqParam.put("rptName", "/statement/TaxInvoice_Rental_PDF_JOMPAY_EIV.rpt");
        				emailReqParam.put("fileName", "eInvoice_"+ params.get("orderNo").toString() + "_InvoiceDate(" + invcDay + requestMonth + requestYear + ").pdf");
    			    }else{
    			    	emailReqParam.put("rptName", "/statement/TaxInvoice_Rental_PDF_JOMPAY.rpt");
        				emailReqParam.put("fileName", "TaxInvoice_"+ params.get("orderNo").toString() + "_InvoiceDate(" + invcDay + requestMonth + requestYear + ").pdf");
    			    }

    				rptParam.put("v_referenceID", invoiceDet.get("stateId"));
    				rptParam.put("v_taskId", "1");
    				rptParam.put("v_refMonth", "1");
    				rptParam.put("v_refYear", "1");
    				rptParam.put("V_TYPE", 133);
    				rptParam.put("date", monthName + " " + String.valueOf(requestYear));
    				rptParam.put("requestNameType", "INVOICE");
    				rptParam.put("custEmail", params.get("custEmailAdd").toString());

    			}else if(reqParameter.getStatementType() == 3){//Ledger
    				Map<String, Object> ledgerParam = new HashMap<String, Object>();
    				ledgerParam.put("ordId", params.get("orderId"));
    				Map<String, Object> ledgerDet = orderLedgerMapper.selectOrderLedgerView(ledgerParam);
    				if(ledgerDet == null){
    					throw new Exception("Ledger not found");
    				}
    				rptParam.put("V_ORDERID", params.get("orderId"));
    				rptParam.put("V_ORDERNO", params.get("orderNo"));
    				rptParam.put("V_PAYREFNO", ledgerDet.get("jomPayRef"));
    				rptParam.put("V_CUSTTYPE", ledgerDet.get("custTypeId"));
    				rptParam.put("V_CUTOFFDATE", "01/01/1900");
    				rptParam.put("date", formattedDate);
    				rptParam.put("requestNameType", "LEDGER");
    				rptParam.put("custEmail", params.get("custEmailAdd").toString());
    				emailReqParam.put("rptName", "/sales/OrderLedger2.rpt");
    				emailReqParam.put("fileName", "Ledger_"+ params.get("orderNo").toString() + "_InvoiceDate(" + formattedDate + ").pdf");
    			}

    			try {
    				emailReqParam.put("rptParams", mapper.writeValueAsString(rptParam));
    			} catch (JsonProcessingException e) {
    				throw new ApplicationException(AppConstants.FAIL,
    						"Unable to trigger email sender. Please inform IT.");
    			}

    			//Insert to CBT0006M to be pending generate statement/Invoice, then call batch schedular to send to respective requester
    			emailReqParam.put("stateType", reqParameter.getStatementType());
    			emailReqParam.put("orderNo", reqParameter.getOrderNo());
    			chatbotInboundApiMapper.CBT0006M_insert(emailReqParam);

    			params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
    			params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);

//    			params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
//				params.put("message", "Not Found");

//    			Map<String, Object> genPdfParam = new HashMap<String, Object>();
//    			generatePDF(genPdfParam);
    		}else{
    			params.put("statusCode", authorize.get("code"));
    			params.put("message", authorize.get("message").toString());
    		}

    		// Return result
    		if(params.get("statusCode").toString().equals("200") || params.get("statusCode").toString().equals("201")){
    			resultValue.put("success", true);
    		}else{
    			resultValue.put("success",false);
    		}

    		resultValue.put("statusCode", params.get("statusCode"));
    		resultValue.put("message", params.get("message"));

		}catch(Exception ex){
			LOGGER.error(">>> Exception :" + ex);
			ex.printStackTrace();
			resultValue.put("success",false);
			resultValue.put("statusCode", AppConstants.FAIL);
			resultValue.put("message", !CommonUtils.isEmpty(ex.getMessage()) ? ex.getMessage() : "Failed to get info.");
		}finally{
    		stopWatch.stop();
    		respTm = stopWatch.toString();

    		// Insert log into API0004M
    		params.put("reqParam", CommonUtils.nvl(reqParam));
    		params.put("ipAddr", CommonUtils.getClientIp(request));
    		params.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
    		params.put("respTm", CommonUtils.nvl(respTm));
    		params.put("apiUserId", CommonUtils.nvl(apiUserId));
    		params.put("respParam", CommonUtils.nvl(resultValue));
    		rtnRespMsg(params);

    		return resultValue;
		}
	}

	@Override
	public List<Map<String, Object>> getGenPdfList(Map<String, Object> params) throws Exception {
		List<Map<String, Object>> emailListToSend = chatbotInboundApiMapper.getGenPdfList(params);
		return emailListToSend;
	}

	@Override
	public void update_chatbot(Map<String, Object> params) throws Exception {
		//update CBT0006M when success generated PDF
		params.put("stusUpdate", 4);
		chatbotInboundApiMapper.update_CBT0006M_Stus(params);

		//Insert email table for schedular batch run
		String Subject = "";
		if(params.get("requestNameType").toString().equals("LEDGER")){
			Subject = "COWAY MALAYSIA " + params.get("requestNameType").toString() +" - " + params.get("orderNo").toString() ;
		}else{
			Subject = "COWAY MALAYSIA " + params.get("requestNameType").toString() +" - (" + params.get("orderNo").toString() + " / " + params.get("date").toString() + ")" ;
		}

		String statementName = "";
		if(params.get("requestNameType").toString().equals("LEDGER")){
			statementName = params.get("requestNameType").toString().toLowerCase() ;
		}else{
			statementName = params.get("requestNameType").toString().toLowerCase() + " ( " + params.get("date").toString().substring(0, 1) + params.get("date").toString().substring(1).toLowerCase() + ")" ;
		}
		String Body = "Dear Valued Customer, <br /><br />Please find attached the "+ statementName + " for your kind perusal. <br /><br />"
				+ "Should you require further information or assistance, please contact our Customer Service Representative at 1800-888-111 or you may send your enquiry to "
				+ "<a href='www.coway.com.my/enquiry'>www.coway.com.my/enquiry</a>.<br /><br />"
				+ "Thank you and have a wonderful day.<br /><br /><b>COWAY (MALAYSIA) SDN. BHD.</b><br /><br />"
				+ "*** Note: This email is generated automatically; no response is necessary. ***";

		Map<String,Object> masterEmailDet = new HashMap<String, Object>();
		masterEmailDet.put("emailType",AppConstants.EMAIL_TYPE_NORMAL);
		masterEmailDet.put("templateName", "");
		masterEmailDet.put("categoryId", "3");
		masterEmailDet.put("email", params.get("custEmail"));
		masterEmailDet.put("emailSentStus", 1);
		masterEmailDet.put("name", "");
		masterEmailDet.put("userId", 349);
		masterEmailDet.put("emailSubject", Subject);
		masterEmailDet.put("emailParams",Body);
		masterEmailDet.put("attachment",webResourseUploadPath + "/RawData/Public/Chatbot Inbound" + "/" + params.get("fileName").toString());

		chatbotInboundApiMapper.insertBatchEmailSender(masterEmailDet);
	}

	@Override
	public Map<String, Object> generatePDF(Map<String, Object> params) throws Exception {
		Map<String, Object> resultValue = new HashMap<String, Object>();

		List<Map<String, Object>> emailListToSend = chatbotInboundApiMapper.getGenPdfList(params);

		if(emailListToSend.size() > 0){
			for(int i =0;i<emailListToSend.size();i++)
			{
				Map<String, Object> info = emailListToSend.get(i);
				Map<String, Object> updParams = createPdfFile(info);

				updParams.put("stusUpdate", 4);
				update_chatbot(updParams);
//				info.put("stusUpdate", 4);
//				int update = chatbotInboundApiMapper.update_CBT0006M_Stus(info);
			}
		}

		return resultValue;
	}

	public Map<String, Object> createPdfFile(Map<String, Object> params) throws Exception {
        String sFile;
        ObjectMapper mapper = new ObjectMapper();

        sFile = params.get("fileName").toString();

        LOGGER.info("[START] InboundGenPdf...");
        Map<String, Object> pdfMap = new HashMap<>();
        pdfMap.put(REPORT_FILE_NAME, params.get("rptName").toString());// visualcut
                                                                               // rpt
                                                                               // file name.
        pdfMap.put(REPORT_VIEW_TYPE, "PDF"); // viewType

        if(!CommonUtils.nvl(params.get("rptParams")).equals("")){
			try {
				Map<String, Object> additionalParam = mapper.readValue(params.get("rptParams").toString(),Map.class);
				pdfMap.putAll(additionalParam);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }

        pdfMap.put(AppConstants.REPORT_DOWN_FILE_NAME,
            "/Chatbot Inbound" + File.separator + params.get("fileName").toString());//pdf

        params.putAll(pdfMap);
//        this.viewProcedure(null, null, pdfMap);
        LOGGER.info("[END] InboundGenPdf...");

        // E-mail 전송하기
        File file = new File(fileUploadPath + "/RawData/Public/Chatbot Inbound" + "/" + sFile);
        EmailVO email = new EmailVO();

        email.setTo(pdfMap.get("custEmail").toString());
        email.setHtml(true);
        String Subject = "";

        Subject = "COWAY " + pdfMap.get("requestNameType").toString() +" - (" + params.get("orderNo").toString() + " / " + pdfMap.get("date").toString() + ")" ;
        email.setSubject(Subject);
        email.setText("Dear Valued Customer, <br /><br />Please find attached the " + pdfMap.get("requestNameType").toString().toLowerCase() +" for your kind perusal. <br /><br />Thank you. <br /><br />Regards,<br />Coway (Malaysia) Sdn Bhd");
        email.addFile(file);

        String attlong = "C:/works/workspace/etrust/src/main/webapp/resources/WebShare/RawData/Public/Chatbot Inbound/Ledger_2835506_InvoiceDate(09012024).pdf///C:/works/workspace/etrust/src/main/webapp/resources/WebShare/RawData/Public/Chatbot Inbound/TaxInvoice_2835506_InvoiceDate(05042023).pdf";
        String[] attachmentSplit = attlong.split("///");
        if(attachmentSplit.length == 1){
    		File file1 = new File(attlong.toString());
		    email.addFile(file1);
    	}else{
    		List<File> fileList = new ArrayList<>();
    		for (String attachFile : attachmentSplit){
    			File file1 = new File(attachFile);
    			fileList.add(file1);
    		}
		    email.addFiles(fileList);
    	}
//        File filea = new File("C:/works/workspace/etrust/src/main/webapp/resources/WebShare/RawData/Public/Chatbot Inbound/Ledger_2835506_InvoiceDate(09012024).pdf");
//        fileList.add(filea);
//        File fileb = new File("C:/works/workspace/etrust/src/main/webapp/resources/WebShare/RawData/Public/Chatbot Inbound/TaxInvoice_2835506_InvoiceDate(05042023).pdf");
//        fileList.add(fileb);
//	    email.addFiles(fileList);
        adaptorService.sendEmail(email, false);
        return params;
      }

	private void viewProcedure(HttpServletRequest request, HttpServletResponse response, Map<String, Object> params) {
		Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_FILE_NAME)), messageAccessor.getMessage(MSG_NECESSARY, new Object[] { REPORT_FILE_NAME }));
		Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_VIEW_TYPE)), messageAccessor.getMessage(MSG_NECESSARY, new Object[] { REPORT_VIEW_TYPE }));

	    SimpleDateFormat fmt = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS", Locale.getDefault(Locale.Category.FORMAT));
	    Calendar startTime = Calendar.getInstance();
	    Calendar endTime = null;

	    String reportFile = (String) params.get(REPORT_FILE_NAME);
	    String reportName = reportFilePath + reportFile;
	    ReportController.ViewType viewType = ReportController.ViewType.valueOf((String) params.get(REPORT_VIEW_TYPE));
	    String prodName;
	    int maxLength = 0;
	    String msg = "Completed";

	    try {
	      ReportAppSession ra = new ReportAppSession();
	      ra.createService(REPORT_CLIENT_DOCUMENT);

	      ra.setReportAppServer(ReportClientDocument.inprocConnectionString);
	      ra.initialize();
	      ReportClientDocument clientDoc = new ReportClientDocument();
	      clientDoc.setReportAppServer(ra.getReportAppServer());
	      clientDoc.open(reportName, OpenReportOptions._openAsReadOnly);


	      String connectString = reportUrl;
	      String driverName = reportDriverClass;
	      String jndiName = "sp";
	      String userName = reportUserName;
	      String password = reportPassword;

	      // Switch all tables on the main report and sub reports
	      //CRJavaHelper.changeDataSource(clientDoc, userName, password, connectString, driverName, jndiName);
	      CRJavaHelper.replaceConnection(clientDoc, userName, password, connectString, driverName, jndiName);
	      // logon to database
	      CRJavaHelper.logonDataSource(clientDoc, userName, password);


	      clientDoc.getDatabaseController().logon(reportUserName, reportPassword);

	      prodName = clientDoc.getDatabaseController().getDatabase().getTables().size() > 0 ? clientDoc.getDatabaseController().getDatabase().getTables().get(0).getName() : null;

	      params.put("repProdName", prodName);

	      ParameterFieldController paramController = clientDoc.getDataDefController().getParameterFieldController();
	      Fields fields = clientDoc.getDataDefinition().getParameterFields();
	      ReportUtils.setReportParameter(params, paramController, fields);
	      {
	        this.viewHandle(request, response, viewType, clientDoc,
	            ReportUtils.getCrystalReportViewer(clientDoc.getReportSource()), params);
	      }
	    } catch (Exception ex) {
	      LOGGER.error(CommonUtils.printStackTraceToString(ex));
	      maxLength = CommonUtils.printStackTraceToString(ex).length() <= 4000 ? CommonUtils.printStackTraceToString(ex).length() : 4000;

	      msg = CommonUtils.printStackTraceToString(ex).substring(0, maxLength);
	      throw new ApplicationException(ex);
	    } finally{
	      // Insert Log
	      endTime = Calendar.getInstance();
	      params.put("msg", msg);
	      params.put("startTime", fmt.format(startTime.getTime()));
	      params.put("endTime", fmt.format(endTime.getTime()));
	      params.put("userId", 349);

	      reportBatchService.insertLog(params);
	    }
	  }

	private void viewHandle(HttpServletRequest request, HttpServletResponse response, ViewType viewType,
		      ReportClientDocument clientDoc, CrystalReportViewer crystalReportViewer, Map<String, Object> params)
		      throws ReportSDKExceptionBase, IOException {

		String downFileName = (String) params.get(REPORT_DOWN_FILE_NAME);
		  		//Tested with switch case, apparently switch case unable to handle viewtype and return error 505 so use if/else
				if(viewType == ViewType.PDF){
					ReportUtils.viewPDF(response, clientDoc, downFileName);
				}
				else{
					throw new ApplicationException(AppConstants.FAIL, "wrong viewType....");
				}
		  }

	@Override
	public EgovMap getPaymentMode(HttpServletRequest request, GetPayModeReqForm param) throws Exception {
		String respTm = null, apiUserId = "0", reqParam = null, respParam = null;

		EgovMap params = new EgovMap();
		EgovMap resultValue = new EgovMap();
//		PaymentVO payVO = new PaymentVO();
		EgovMap payVO = new EgovMap();
		List<PaymentVO> paymentVO = new ArrayList<PaymentVO>();
		JompayVO jompayVO = new JompayVO();
		StopWatch stopWatch = new StopWatch();

		try{

			stopWatch.reset();
			stopWatch.start();

			EgovMap authorize = verifyBasicAuth(request);

			if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){
				// Check order no, order id and payment mode whether exist or not
				if(CommonUtils.isEmpty(param.getOrderNo())){
					resultValue.put("success", false);
					resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
					resultValue.put("message", "Sales order number is required");
					return resultValue;
				}

				if(param.getOrderId() == 0){
					resultValue.put("success", false);
					resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
					resultValue.put("message", "Sales order ID is required");
					return resultValue;
				}

				if(param.getPayMtdType() == 0){
					resultValue.put("success", false);
					resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
					resultValue.put("message", "Payment mode is required");
					return resultValue;
				}

				Gson gson = new GsonBuilder().create();
				reqParam = gson.toJson(param);

				LOGGER.debug(">>> reqParam :" + reqParam);

				apiUserId = authorize.get("apiUserId").toString();

				params.put("orderNo", param.getOrderNo().toString());
				params.put("orderId", param.getOrderId());
				params.put("paymentMode", param.getPayMtdType());

				if(param.getPayMtdType() == 1){ // Payment Mode Status Request

					// Get payment info
					EgovMap pay = chatbotInboundApiMapper.getPaymentMtd(params);

					if(!CommonUtils.isEmpty(pay)){
						if(pay.containsKey("appTypeId")){
							if(pay.get("appTypeId").toString().equals("66")){

								payVO.put("paymentMtd", pay.get("rentPayModeDesc").toString());

								if(pay.get("rentPayModeCode").toString().equals("REG")){
									PaymentVO paymentList = PaymentVO.create(payVO);
									paymentVO.add(paymentList);

								    respParam = gson.toJson(paymentVO);

								    params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
									params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
									params.put("respParam", respParam.toString());

								}else{

									 EgovMap deductionResult = chatbotInboundApiMapper.getDeductionResult(params);

									 if(!CommonUtils.isEmpty(deductionResult)){
											// SET LastPayDate
											if(deductionResult.containsKey("lastPayDt")){ // lastPayDt
												payVO.put("lastPayDate", deductionResult.get("lastPayDt").toString());


												// SET DeductionResult
												if(deductionResult.containsKey("isApproveStr")){ // isSuccess
													payVO.put("deductionResult", deductionResult.get("isApproveStr").toString());

													// SET PaymentStatus
													if(deductionResult.get("isApproveStr").equals("-")){
														payVO.put("paymentStatus",AppConstants.DESC_INPROGRESS);

													}else{

    													if(deductionResult.containsKey("bankAppv")){
    														if(Integer.parseInt(deductionResult.get("bankAppv").toString()) == 1){
    															payVO.put("paymentStatus", AppConstants.DESC_SUCCESS);

    														}else{
    															payVO.put("paymentStatus",AppConstants.DESC_FAILED);
    														}
    													}else{
    														payVO.put("paymentStatus","-");
    													}
													}


													// Convert resp to String format
													PaymentVO paymentList = PaymentVO.create(payVO);
													paymentVO.add(paymentList);

												    respParam = gson.toJson(paymentVO);

												    params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
													params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
													params.put("respParam", respParam.toString());

												}else{
													params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
													params.put("message", "Deduction result not found");
												}

//												// SET PaymentStatus
//												if(deductionResult.containsKey("bankAppv")){
//													if(Integer.parseInt(deductionResult.get("bankAppv").toString()) == 1){
//														payVO.put("paymentStatus", AppConstants.DESC_SUCCESS);
//
//													}else{
//														payVO.put("paymentStatus",AppConstants.DESC_FAILED);
//													}
//												}else{
//													payVO.put("paymentStatus","-");
//												}
//
//												// SET DeductionResult
//												if(deductionResult.containsKey("isApproveStr")){ // isSuccess
//													payVO.put("deductionResult", deductionResult.get("isApproveStr").toString());
//
//													// Convert resp to String format
//													PaymentVO paymentList = PaymentVO.create(payVO);
//													paymentVO.add(paymentList);
//
//												    respParam = gson.toJson(paymentVO);
//
//												    params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
//													params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
//													params.put("respParam", respParam.toString());
//
//												}else{
//													params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
//													params.put("message", "Record not found");
//												}

											}else{
												params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
												params.put("message", "Last pay date not found");
											}

										}else{
											params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
											params.put("message", "Deduction result list not found");
										}
								}

							}else{
								params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
//								params.put("message", "This order is not a rental order.");
								params.put("message", "Rental order not found");
							}

						}else{
							params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
							params.put("message", "Record not found");
						}

					}else{
						params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
						params.put("message", "Record not found");
					}

				}else if(param.getPayMtdType() == 2){ // Jompay Status Request

					// Get jomPay info
					EgovMap jompay = chatbotInboundApiMapper.getJomPayStatus(params);

					if(!CommonUtils.isEmpty(jompay)){
						// Convert data into Class object
						if(jompay.containsKey("ref1") && jompay.containsKey("ref2")){
							jompayVO.setBillerCode(AppConstants.BILLER_CODE);
							jompayVO.setRef1(jompay.get("ref1").toString());
							jompayVO.setRef2(jompay.get("ref2").toString());

							// Convert resp to String format
						    respParam = gson.toJson(jompayVO);

							params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
							params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
							params.put("respParam", respParam.toString());

						} else if(!jompay.containsKey("ref1")){
							params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
							params.put("message", "Ref1 not found");

						}else if(!jompay.containsKey("ref2")){
							params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
							params.put("message", "Ref2 not found");
						}

					}else{
						params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
						params.put("message", "Record not found");
					}
				}

			}else{
				params.put("statusCode", authorize.get("code"));
				params.put("message", authorize.get("message").toString());
			}

		} catch(Exception e){
			LOGGER.debug(">>> Error message : " + e);
			e.printStackTrace();
			params.put("statusCode", AppConstants.FAIL);
			params.put("message", !CommonUtils.isEmpty(e.getMessage()) ? e.getMessage() : "Failed to get info.");

		} finally{
			// Return result
			if(params.get("statusCode").toString().equals("200") || params.get("statusCode").toString().equals("201")){
				resultValue.put("success", true);
			}else{
				resultValue.put("success",false);
			}

			resultValue.put("statusCode", params.get("statusCode"));
			resultValue.put("message", params.get("message"));

			if(params.containsKey("respParam")){
				if(params.get("paymentMode").toString().equals("1")){
					resultValue.put("payments", paymentVO);
					resultValue.put("jompay", null);

				}else if (params.get("paymentMode").toString().equals("2")){
					resultValue.put("payments", null);
					resultValue.put("jompay", jompayVO);
				}
			}

			stopWatch.stop();
			respTm = stopWatch.toString();

			// Insert log into API0004M
			params.put("reqParam",  CommonUtils.nvl(reqParam));
			params.put("ipAddr", CommonUtils.getClientIp(request));
			params.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
			params.put("respTm", CommonUtils.nvl(respTm));
			params.put("apiUserId", CommonUtils.nvl(apiUserId));
			rtnRespMsg(params);
		}

		return resultValue;
	}


	@Override
	public EgovMap getOtd(HttpServletRequest request, GetOtdReqForm param) throws Exception {
	    String respTm = null, apiUserId = "0", reqParam = null, respParam = null;

	    EgovMap params = new EgovMap();
	    EgovMap resultValue = new EgovMap();
	    EgovMap outVO = new EgovMap();
	 	List<OutStdVO> outStdVO = new ArrayList<OutStdVO>();
	    StopWatch stopWatch = new StopWatch();

	 	try{

    	    stopWatch.reset();
    	    stopWatch.start();

    	    EgovMap authorize = verifyBasicAuth(request);

    	    if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){
    	    	// Check phone number whether exist or not
    	    	if(CommonUtils.isEmpty(param.getOrderNo())){
					resultValue.put("success", false);
					resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
					resultValue.put("message", "Sales order number is required");
					return resultValue;
				}

				if(param.getOrderId() == 0){
					resultValue.put("success", false);
					resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
					resultValue.put("message", "Sales order ID is required");
					return resultValue;
				}

				Gson gson = new GsonBuilder().create();
				reqParam = gson.toJson(param);

				LOGGER.debug(">>> reqParam :" + reqParam);

				apiUserId = authorize.get("apiUserId").toString();

				params.put("orderNo", param.getOrderNo().toString());
				params.put("orderId", param.getOrderId());

				//  Get app type
				String appTypeId = chatbotInboundApiMapper.getAppTypeId(params);

				if(!CommonUtils.isEmpty(appTypeId)){
					if(appTypeId.equals("66")){ // RENTAL
						// Get account status info
		    			EgovMap accStusVO = chatbotInboundApiMapper.getAccStus(params);

		    			if(!CommonUtils.isEmpty(accStusVO)){
		    				outVO.put("orderNo", param.getOrderNo().toString());
		    				outVO.put("accountStatus", accStusVO.get("prgrs").toString());

		    				// Get total due amount = total outstanding + total unbill amount
		    				List<EgovMap> ordOutInfoList = getOderOutsInfo(params);

		    				if(!CommonUtils.isEmpty(ordOutInfoList)){

		    					EgovMap ordOutInfo = ordOutInfoList.get(0);

		    					String ordTotOtstnd = ordOutInfo.get("ordTotOtstnd").toString().replace(",", "");
		    					String ordUnbillAmt = ordOutInfo.get("ordUnbillAmt").toString().replace(",", "");
		    					Double dueAmt = Double.parseDouble(ordTotOtstnd) + Double.parseDouble(ordUnbillAmt);
		    					outVO.put("totalAmtDue", dueAmt.toString());
		    				}

		    				// Get last payment info
		    				EgovMap lastPayInfo = new EgovMap();
        					lastPayInfo = chatbotInboundApiMapper.getRentalLastPayInfo(params);

        					if(!CommonUtils.isEmpty(lastPayInfo)){
        						if(lastPayInfo.containsKey("lastPaymentDt") && lastPayInfo.containsKey("lastPaymentAmt")){
        							outVO.put("lastPayDate", lastPayInfo.get("lastPaymentDt").toString());
        							outVO.put("lastPaymentAmt",Double.parseDouble(lastPayInfo.get("lastPaymentAmt").toString()));

        							OutStdVO outList = OutStdVO.create(outVO);
        							outStdVO.add(outList);
                    			    respParam = gson.toJson(outStdVO);

                    	    		params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
                    	    		params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
                    	    		params.put("respParam", respParam.toString());

        						}else if(!lastPayInfo.containsKey("lastPaymentDt")){
        							params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                    	    		params.put("message", "Last payment date not found");

        						}else if (!lastPayInfo.containsKey("lastPaymentAmt")){
        							params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                    	    		params.put("message", "Last payment amount not found");
        						}

            	    		}else {
                	    		params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                	    		params.put("message", "Last payment info not found");
            	    		}

		    			}else{
		    	    		params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
	        	    		params.put("message", "Account status not found");
		    			}

					}else{
	    	    		params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
        	    		params.put("message", "This order is not a rental order");
	    			}

				}else{
					params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    	    		params.put("message", "Order's app type not found");
				}

//        				else if(appTypeId.equals("1412")) { // OUTRIGHT PLUS
//        					lastPayInfo = chatbotInboundApiMapper.getOutPlusLastPayInfo(params);
//
//        				}else{
//        					lastPayInfo = chatbotInboundApiMapper.getOthersLastPayInfo(params);
//        				}

    	    }else{
        		params.put("statusCode", authorize.get("code"));
        		params.put("message", authorize.get("message").toString());
    	    }

	 	} catch(Exception e){
	 		LOGGER.debug(">>> error message : " + e);
	 		e.printStackTrace();
	 		params.put("statusCode", AppConstants.FAIL);
	 		params.put("message", !CommonUtils.isEmpty(e.getMessage()) ? e.getMessage() : "Failed to get info.");

	 	} finally{
	 		// Return result
	        if(params.get("statusCode").toString().equals("200") || params.get("statusCode").toString().equals("201")){
	        	resultValue.put("success", true);
	        }else{
	        	resultValue.put("success",false);
	        }

	        resultValue.put("statusCode", params.get("statusCode"));
	        resultValue.put("message", params.get("message"));

		    if(params.containsKey("respParam")){
	        	resultValue.put("data", outStdVO);
	        }

		    stopWatch.stop();
		    respTm = stopWatch.toString();

		    // Insert log into API0004M
		    params.put("reqParam", CommonUtils.nvl(reqParam));
		    params.put("ipAddr", CommonUtils.getClientIp(request));
		    params.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
		    params.put("respTm", CommonUtils.nvl(respTm));
		    params.put("apiUserId", CommonUtils.nvl(apiUserId));
		    rtnRespMsg(params);
	 	}

	 	return resultValue;
	}

	public List<EgovMap> getOderOutsInfo(Map<String, Object> params) {
		chatbotInboundApiMapper.getOderOutsInfo(params);

		 return (List<EgovMap>) params.get("p1");
	}


	@Override
	public EgovMap verifyBasicAuth(HttpServletRequest request){
		String message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0", sysUserId = "0";
		int code = Integer.parseInt(AppConstants.FAIL);

	    String userName = request.getHeader("userName");
	    String key = request.getHeader("key");

    	EgovMap reqPrm = new EgovMap();
    	reqPrm.put("userName", userName);
    	reqPrm.put("key", key);

    	EgovMap access = new EgovMap();
    	access = chatbotInboundApiMapper.checkAccess(reqPrm);

    	if(access == null){
    		code = AppConstants.RESPONSE_CODE_UNAUTHORIZED;
    		message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
    	}else{
    		code = AppConstants.RESPONSE_CODE_SUCCESS;
    		message = AppConstants.RESPONSE_DESC_SUCCESS;

    		apiUserId = access.get("apiUserId").toString();
    		sysUserId = access.get("sysUserId").toString();
    		reqPrm.put("apiUserId", apiUserId);
    		reqPrm.put("sysUserId", sysUserId);
    	}

    	reqPrm.put("code", code);
		reqPrm.put("message", message);

    	return reqPrm;
	}


	@Override
	public void rtnRespMsg(Map<String, Object> param) {
		Map<String, Object> params = new HashMap<>();

		params.put("respCde", param.get("statusCode"));
		params.put("errMsg", param.get("message"));
		params.put("reqParam", param.get("reqParam").toString());
		params.put("ipAddr", param.get("ipAddr"));
		params.put("prgPath", param.get("prgPath"));
		params.put("respTm", param.get("respTm"));
		params.put("respParam", param.containsKey("respParam") ? param.get("respParam").toString().length() >= 4000 ? param.get("respParam").toString().substring(0,4000) : param.get("respParam").toString() : "");
      	params.put("apiUserId", param.get("apiUserId") );

      	commonApiMapper.insertApiAccessLog(params);
	}
}
