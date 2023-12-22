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
import com.coway.trust.biz.api.vo.chatbotInbound.verifyCustomerIdentity.CustomerVO;
import com.coway.trust.biz.api.vo.chatbotInbound.verifyCustomerIdentity.VerifyCustIdentityReqForm;
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
	    String respTm = null, apiUserId = "0", respParam = null;

	    EgovMap resultValue = new EgovMap();

	    // Check phone number whether exist or not
    	String data = commonApiService.decodeJson(request);
    	Gson g = new Gson();
    	VerifyCustIdentityReqForm reqParam = g.fromJson(data, VerifyCustIdentityReqForm.class);

    	Exception e1 = null;
    	if(reqParam.getCustPhoneNo().toString().isEmpty()){
    		resultValue.put("success", false);
    		resultValue.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
    		resultValue.put("message", "Customer phone number is required");
    		return resultValue;
    	}

	    StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

	    List<CustomerVO> cust = new ArrayList<>();
	    String custPhoneNo = reqParam.getCustPhoneNo().toString();
	    params.put("custPhoneNo", custPhoneNo);

	    EgovMap authorize = verifyBasicAuth(request);

	    if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){
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

				Gson gson = new GsonBuilder().create();
			    respParam = gson.toJson(cust);

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

	    stopWatch.stop();
	    respTm = stopWatch.toString();

	    // Insert log into API0004M
	    params.put("reqParam", reqParam);
	    params.put("ipAddr", CommonUtils.getClientIp(request));
	    params.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
	    params.put("respTm", respTm);
	    params.put("apiUserId", apiUserId);
	    rtnRespMsg(params);

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

	    return resultValue;
	}



	@Override
	public EgovMap verifyBasicAuth(HttpServletRequest request){
		String respTm = null, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0", sysUserId = "0";
		int code = Integer.parseInt(AppConstants.FAIL);

	    String userName = request.getHeader("userName");
	    String key = request.getHeader("key");

    	Exception e1 = null;

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
		EgovMap data = new EgovMap();
		Map<String, Object> params = new HashMap<>();

		params.put("respCde", param.get("statusCode"));
		params.put("errMsg", param.get("message"));
		params.put("reqParam", param.get("reqPrm"));
		params.put("ipAddr", param.get("ipAddr"));
		params.put("prgPath", param.get("prgPath"));
		params.put("respTm", param.get("respTm"));
		params.put("respParam", param.containsKey("respParam") ? param.get("respParam").toString().length() >= 4000 ? param.get("respParam").toString().substring(0,4000) : param.get("respParam").toString() : "");
      	params.put("apiUserId", param.get("apiUserId") );

      	commonApiMapper.insertApiAccessLog(params);
	}
}
