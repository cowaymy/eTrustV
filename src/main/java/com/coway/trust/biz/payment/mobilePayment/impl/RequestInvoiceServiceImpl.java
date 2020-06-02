package com.coway.trust.biz.payment.mobilePayment.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.util.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.payment.mobilePayment.RequestInvoiceService;
import com.coway.trust.biz.scm.impl.ScmMasterManagementServiceImpl;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.BulkSmsVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.CommonUtils;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import java.io.IOException;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : InvoiceApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 27.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("RequestInvoiceService")
public class RequestInvoiceServiceImpl extends EgovAbstractServiceImpl implements RequestInvoiceService{
	private static final Logger LOGGER = LoggerFactory.getLogger(RequestInvoiceServiceImpl.class);

	@Resource(name = "RequestInvoiceMapper")
	private RequestInvoiceMapper requestInvoiceMapper;



    @Resource(name = "mobileAppTicketApiCommonService")
    private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;



	@Override
	public List<EgovMap> selectTicketStatusCode() throws Exception{
	    return requestInvoiceMapper.selectTicketStatusCode();
	}



	@Override
	public List<EgovMap> selectInvoiceType() throws Exception{
	    return requestInvoiceMapper.selectInvoiceType();
	}



    @Override
    public ReturnMessage selectRequestInvoiceList(Map<String, Object> param) throws Exception{
        ReturnMessage result = new ReturnMessage();
        int total = requestInvoiceMapper.selectRequestInvoiceCount(param);
        result.setTotal(total);
        result.setDataList(requestInvoiceMapper.selectRequestInvoiceList(param));
        return result;
    }



    @Override
	public int saveRequestInvoiceArrpove(Map<String, Object> param, int userId) throws Exception {
    	boolean apiresult = false;

		param.put("userId", userId);
		if (StringUtils.isEmpty(param.get("reqInvcNo"))) {
			throw new ApplicationException(AppConstants.FAIL, "Please check the Request Number value.");
		}
		if (StringUtils.isEmpty(param.get("reqStusId"))) {
			throw new ApplicationException(AppConstants.FAIL, "Please check the Request Status value.");
		}
		if (StringUtils.isEmpty(param.get("userId"))) {
			throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
		}
		if (StringUtils.isEmpty(param.get("mobTicketNo"))) {
			throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
		}

		LOGGER.debug("saveRequestInvoiceArrpove : {}", param.toString());

		int saveCnt = requestInvoiceMapper.saveRequestInvoiceArrpove(param);
		if (saveCnt == 0) {
			throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
		}

		List<Map<String, Object>> arrParams = new ArrayList<Map<String, Object>>();
		Map<String, Object> sParams = new HashMap<String, Object>();
		sParams.put("mobTicketNo", param.get("mobTicketNo"));
		sParams.put("ticketStusId", "5");
		sParams.put("userId", userId);
		arrParams.add(sParams);
		saveCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);
		if (saveCnt == 0) {
			throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
		}

		LOGGER.debug("param.get(taxInvcId)" + (param.get("taxInvcId") != null));

		if (param.get("taxInvcId") != null) {
			LOGGER.debug("param.get(taxInvcId) != null ");
			apiresult = sendMobileInvoiceRequest(param);
		}
		LOGGER.debug("apiresult "+apiresult);

		return saveCnt;
	}



    @Override
    public int saveRequestInvoiceReject(Map<String, Object> param, int userId) throws Exception{
        param.put("userId", userId);
        if( StringUtils.isEmpty( param.get("reqInvcNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Number value.");
        }
        if( StringUtils.isEmpty( param.get("reqStusId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Status value.");
        }
        if( StringUtils.isEmpty( param.get("userId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
        }
        if( StringUtils.isEmpty( param.get("rem") )){
            throw new ApplicationException(AppConstants.FAIL, "Reject reason value does not exist.");
        }
        if( StringUtil.getEncodedSize(String.valueOf(param.get("rem"))) > 4000 ){
            throw new ApplicationException(AppConstants.FAIL, "Reject reason is too long.");
        }

        int saveCnt = requestInvoiceMapper.saveRequestInvoiceReject(param);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
        }

        List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
        Map<String, Object> sParams = new HashMap<String, Object>();
        sParams.put("mobTicketNo", param.get("mobTicketNo"));
        sParams.put("ticketStusId", "6");
        sParams.put("userId", userId);
        arrParams.add(sParams);
        saveCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }
        return saveCnt;
    }

    private boolean sendMobileInvoiceRequest(Map<String, Object> param) throws JsonParseException, JsonMappingException, IOException {
		boolean result = false;

		LOGGER.debug("sendMobileInvoiceRequest : {}", param.toString());

		List<EgovMap> selectInvoiceDetails	= requestInvoiceMapper.selectInvoiceDetails(param);

		LOGGER.debug("selectInvoiceDetails : {}",selectInvoiceDetails);

//        if (CommonUtils.isEmpty(bulkSmsVO.getMobile())) {
//            throw new ApplicationException(AppConstants.FAIL, "required mobiles.....");
//        }

        //SmsResult result = new SmsResult();
        Map<String, String> reason = new HashMap<>();
        //result.setReqCount(1);

        //String trId = UUIDGenerator.get();
        //result.setMsgId(trId);
        String smsUrl = "http://128.199.165.110:8080/invoice/email?x-token=fGxqeS9pzR7duRBV7xpXSkFBPtQFKn";
		/*"http://" + giHost + giPath + "?user=" + giUserName + "&secret=" + giPassword
                + "&phone_number=" + giCountryCode + bulkSmsVO.getMobile().trim()
                + "&text=" + URLEncoder.encode(bulkSmsVO.getMessage(), "UTF-8");*/
        //http://47.254.203.181/api/send?user=gi_xHdw6&secret=VpHVSMLS1E4xa2vq7qtVYtb7XJIBDB&phone_number=6014225372&text=testing123

        int statusId;
        String body = null;
        String retCode = null;

        Client client = Client.create();
        WebResource webResource = client.resource(smsUrl);
        ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
        String output = response.getEntity(String.class);

        ObjectMapper mapper = new ObjectMapper();

        Map<String, Object> resultMap = mapper.readValue(output, new TypeReference<Map<String, Object>>() {});
        String success = resultMap.get("success").toString();
        String errorCode = resultMap.get("error_code") != null ? resultMap.get("error_code").toString() : null ;
        String errorMessage = resultMap.get("error_message") != null ? resultMap.get("error_message").toString() : null;

        System.out.println("================");
        System.out.println(success);
        System.out.println(errorCode);
        System.out.println(errorMessage);
        System.out.println("================");

        if(success.equals("true")){
			result = true;
          //retCode = String.valueOf(response.getStatus());
          //body = "success";
          //statusId = 4;
          //result.setSuccessCount(result.getSuccessCount() + 1);
        }else{
			result = false;
          //retCode = errorCode;
          //body = errorMessage;
          //statusId = 21;
          //result.setFailCount(result.getFailCount() + 1);
          //reason.clear();
          //reason.put(bulkSmsVO.getMobile(), errorMessage);
          //result.addFailReason(reason);
        }

        //updateResult(bulkSmsVO.getSmsId(), statusId, retCode, body, trId);
        return result;
    }
}
