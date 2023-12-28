package com.coway.trust.biz.api.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.ChatbotInboundApiService;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.vo.chatbotInbound.CustomerVO;
import com.coway.trust.biz.api.vo.chatbotInbound.OrderListReqForm;
import com.coway.trust.biz.api.vo.chatbotInbound.OrderVO;
import com.coway.trust.biz.api.vo.chatbotInbound.StatementReqForm;
import com.coway.trust.biz.api.vo.chatbotInbound.VerifyCustIdentityReqForm;
import com.coway.trust.util.CommonUtils;
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

	@Override
	public EgovMap verifyCustIdentity(HttpServletRequest request, Map<String, Object> params) throws Exception {
	    String respTm = null, apiUserId = "0", reqParam = null, respParam = null;

	    EgovMap resultValue = new EgovMap();
	 	List<CustomerVO> cust = new ArrayList<>();
	    StopWatch stopWatch = new StopWatch();

	 	try{

    	    stopWatch.reset();
    	    stopWatch.start();

    	    EgovMap authorize = verifyBasicAuth(request);

    	    if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){
    	    	// Check phone number whether exist or not
    	    	String data = commonApiService.decodeJson(request);
    	    	Gson g = new Gson();
    	    	VerifyCustIdentityReqForm reqParameter = g.fromJson(data, VerifyCustIdentityReqForm.class);

    	    	if(reqParameter.getCustPhoneNo().toString().isEmpty()){
    	    		resultValue.put("success", false);
    	    		resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    	    		resultValue.put("message", "Customer phone number is required");
    	    		return resultValue;
    	    	}

    	   	    String custPhoneNo = reqParameter.getCustPhoneNo().toString();
    	   	    params.put("custPhoneNo", custPhoneNo);

    	   	    Gson gson = new GsonBuilder().create();
    	   	    reqParam = gson.toJson(reqParameter);

    			LOGGER.debug(">>> Phone Number :" + custPhoneNo);

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
			throw e;

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
		    params.put("reqParam", reqParam);
		    params.put("ipAddr", CommonUtils.getClientIp(request));
		    params.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
		    params.put("respTm", respTm);
		    params.put("apiUserId", apiUserId);
		    rtnRespMsg(params);
	 	}

	 	return resultValue;
	}


	@Override
	public EgovMap getOrderList(HttpServletRequest request, Map<String, Object> params) throws Exception {
		String respTm = null, apiUserId = "0", reqParam = null, respParam = null;

		StopWatch stopWatch = new StopWatch();
		EgovMap resultValue = new EgovMap();
		List<OrderVO> orderVO = new ArrayList<>();

		try{
    		stopWatch.reset();
    		stopWatch.start();

    		EgovMap authorize = verifyBasicAuth(request);

    		if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){

    			// Check phone number whether exist or not
    			String data = commonApiService.decodeJson(request);
    			Gson g = new Gson();
    			OrderListReqForm reqParameter = g.fromJson(data, OrderListReqForm.class);

    			if(reqParameter.getCustId() < 0){
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

    			if(isCustExist > 0){


    				List<EgovMap> orderListRaw = chatbotInboundApiMapper.getOrderList(params);
    				for(EgovMap orderRaw : orderListRaw){
    					OrderVO order = OrderVO.create(orderRaw);
    					orderVO.add(order);
    				}

    				respParam = gson.toJson(orderVO);

    				params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
    				params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
    				params.put("respParam", respParam.toString());

    			}else{
    				params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    				params.put("message", "Order not found");
    			}

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

    		if(params.containsKey("respParam")){
    			resultValue.put("orders", orderVO);
    		}

		}catch(Exception ex){
			resultValue.put("success",false);
		}finally{
    		stopWatch.stop();
    		respTm = stopWatch.toString();

    		// Insert log into API0004M
    		params.put("reqParam", reqParam);
    		params.put("ipAddr", CommonUtils.getClientIp(request));
    		params.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
    		params.put("respTm", respTm);
    		params.put("apiUserId", apiUserId);
    		params.put("respParam", resultValue);
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

    			if(reqParameter.getStatementType() == 1 && reqParameter.getMonth() < 0){
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

    			params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
    			params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);

//    			params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
//				params.put("message", "Not Found");
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
			resultValue.put("success",false);
		}finally{
    		stopWatch.stop();
    		respTm = stopWatch.toString();

    		// Insert log into API0004M
    		params.put("reqParam", reqParam);
    		params.put("ipAddr", CommonUtils.getClientIp(request));
    		params.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
    		params.put("respTm", respTm);
    		params.put("apiUserId", apiUserId);
    		params.put("respParam", resultValue);
    		rtnRespMsg(params);

    		return resultValue;
		}
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
