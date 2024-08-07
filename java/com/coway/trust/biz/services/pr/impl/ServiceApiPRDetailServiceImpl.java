package com.coway.trust.biz.services.pr.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.api.mobile.services.productRetrun.PRFailJobRequestDto;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultDto;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.biz.services.pr.ServiceApiPRDetailService;
import com.coway.trust.cmmn.exception.BizExceptionFactoryBean;
import com.coway.trust.cmmn.exception.BizException;
import com.coway.trust.cmmn.model.BizMsgVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;

/**
 * @ClassName : ServiceApiPRDetailServiceImpl.java
 * @Description : Mobile Product Return Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 24.   Jun             First creation
 */
@Service("serviceApiPRDetailService")
public class ServiceApiPRDetailServiceImpl extends EgovAbstractServiceImpl implements ServiceApiPRDetailService {
	private static final Logger logger = LoggerFactory.getLogger(ServiceApiPRDetailServiceImpl.class);

	@Resource(name = "MSvcLogApiService")
	private MSvcLogApiService MSvcLogApiService;

	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;

	@Override
	public ResponseEntity<ProductReturnResultDto> productReturnResultProc(Map<String, Object> cvMp) throws Exception {
		String transactionId = "";
		String serviceNo = "";

		transactionId = String.valueOf(cvMp.get("transactionId"));
		serviceNo = String.valueOf(cvMp.get("serviceNo"));

		Map<String, Object> params = cvMp;

		// CHECK CT VALID TO PERFORM THIS ACTION
		int memCnt = MSvcLogApiService.prdResultSync(cvMp);

		if (memCnt > 0) {
			int isPrdRtnCnt = MSvcLogApiService.isPrdRtnAlreadyResult(cvMp);

	        if (isPrdRtnCnt == 0) {
	        	try {
	        		EgovMap ordIdMap = MSvcLogApiService.getOrdID(cvMp);
	        		String userId = MSvcLogApiService.getUseridToMemid(params); // SELECT MEM_ID FROM ORG0001D WHERE mem_code = #{userId}

	        		cvMp.put("hidSerialRequireChkYn", String.valueOf( cvMp.get("serialRequireChkYn")));

	        		EgovMap rtnValue = MSvcLogApiService.productReturnResult(cvMp);

	        		if (null != rtnValue) {
	        			HashMap spMap = (HashMap) rtnValue.get("spMap");
	        			if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
	        				rtnValue.put("logerr", "Y");
	        			}

						logger.debug("++++ String.valueOf( cvMp.get('serialRequireChkYn')) ::" + String.valueOf( cvMp.get("serialRequireChkYn")) );

    					if("Y".equals(  String.valueOf( cvMp.get("serialRequireChkYn")) )){

    	        			// DELVRY_NO
    	        			params.put("refDocNo", String.valueOf(cvMp.get("serviceNo")));
    	        			EgovMap delvryNoMap = MSvcLogApiService.getDelvryNo(params);

    	        			params.put("scanSerial", String.valueOf(cvMp.get("scanSerial")));
        					params.put("salesOrdId", String.valueOf(ordIdMap.get("salesOrdId")));
        					params.put("reqstNo", String.valueOf(cvMp.get("serviceNo")));
        					params.put("delvryNo", String.valueOf(delvryNoMap.get("delvryNo")));
        					params.put("callGbn", "RETURN");
        					params.put("mobileYn", "Y");
        					params.put("userId", userId);
        					params.put("pErrcode", "");
        					params.put("pErrmsg", "");
        					MSvcLogApiService.SP_SVC_BARCODE_SAVE(params);

        					logger.debug("++++ SP_SVC_BARCODE_SAVE params ::" + params.toString()  );

        					if (!"000".equals(params.get("pErrcode"))) {
        						String procTransactionId = transactionId;
        						String procName = "ProductReturn";
        						String procKey = serviceNo;
        						String procMsg = "Failed to Barcode Save";
        						String errorMsg = "[API] " + params.get("pErrmsg");
        						throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
    						}

    	        			// SP_SVC_LOGISTIC_REQUEST COMMIT STRING DELETE
        					spMap.put("pErrcode", "");
        					spMap.put("pErrmsg", "");
    	        			servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

    	        			String errCode = (String)spMap.get("pErrcode");
  	                	  	String errMsg = (String)spMap.get("pErrmsg");

  	                	  	logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR CODE : " + errCode);
  	                	  	logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR MSG: " + errMsg);

  	                	  	// pErrcode : 000  = Success, others = Fail
  	                	  	if (!"000".equals(errCode)) {
  	                	  		throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
  	                	  	}
    					}else{
    						// SP_SVC_LOGISTIC_REQUEST COMMIT STRING DELETE
    						servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
    					}
	        		}
	        	}
	        	catch (Exception e) {
	        		String procTransactionId = transactionId;
	    			String procName = "ProductReturn";
	    			String procKey = serviceNo;
	    			String procMsg = "Failed to Save";
	    			String errorMsg = "[API] " + e.toString();
	    			throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
	        	}
	        }
	        else {
	        	String procTransactionId = transactionId;
    			String procName = "ProductReturn";
    			String procKey = serviceNo;
    			String procMsg = "NoTarget Data";
    			String errorMsg = "[API] [" + cvMp.get("userId") + "] THIS PR ALREADY NOT IN ACTIVE STATUS. ";
    			throw new BizException("04", procTransactionId, procName, procKey, procMsg, errorMsg, null);
	        }
		}
		else {
			String procTransactionId = transactionId;
			String procName = "ProductReturn";
			String procKey = serviceNo;
			String procMsg = "NoTarget Data";
			String errorMsg = "[API] [" + cvMp.get("userId") + "] THIS PR ALREADY NOT IN ACTIVE STATUS. ";
			throw new BizException("04", procTransactionId, procName, procKey, procMsg, errorMsg, null);
		}

		logger.debug("### PRODUCT RETURN FINAL PARAM : " + cvMp.toString());

	    return ResponseEntity.ok(ProductReturnResultDto.create(transactionId));
	}

	@Override
	public ResponseEntity<PRFailJobRequestDto> prReAppointmentRequestProc(Map<String, Object> params) throws Exception {
		String serviceNo = String.valueOf(params.get("serviceNo"));

		logger.debug("### P1 PARAM : " + params.toString());

		MSvcLogApiService.savePrFailServiceLogs(params);

		logger.debug("### P2 PARAM : " + params.toString());

	    MSvcLogApiService.setPRFailJobRequest(params);

	    logger.debug("### P3 PARAM : " + params.toString());

	    return ResponseEntity.ok(PRFailJobRequestDto.create(serviceNo));
	}

	@Override
	public ResponseEntity<ProductReturnResultDto> productReturnDtResultProc(Map<String, Object> cvMp) throws Exception {
		String transactionId = "";
		String serviceNo = "";

		transactionId = String.valueOf(cvMp.get("transactionId"));
		serviceNo = String.valueOf(cvMp.get("serviceNo"));

		Map<String, Object> params = cvMp;

		// CHECK CT VALID TO PERFORM THIS ACTION
		int memCnt = MSvcLogApiService.prdResultSync(cvMp);

		if (memCnt > 0) {
			int isPrdRtnCnt = MSvcLogApiService.isPrdRtnAlreadyResult(cvMp);

	        if (isPrdRtnCnt == 0) {
	        	try {
	        		EgovMap ordIdMap = MSvcLogApiService.getOrdID(cvMp);
	        		String userId = MSvcLogApiService.getUseridToMemid(params); // SELECT MEM_ID FROM ORG0001D WHERE mem_code = #{userId}

	        		cvMp.put("hidSerialRequireChkYn", "Y");

	        		EgovMap rtnValue = MSvcLogApiService.productReturnResult(cvMp);

	        		if (null != rtnValue) {
	        			HashMap spMap = (HashMap) rtnValue.get("spMap");
	        			if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
	        				rtnValue.put("logerr", "Y");
	        				throw new ApplicationException(AppConstants.FAIL, "Fail");
	        			}

	        			EgovMap delvryMap = MSvcLogApiService.getPrdRtnDelvryNo(cvMp);

	        			params.put("scanSerial", String.valueOf(cvMp.get("scanSerial")));
    					params.put("salesOrdId", String.valueOf(ordIdMap.get("salesOrdId")));
    					params.put("reqstNo", String.valueOf(cvMp.get("serviceNo")));
    					params.put("delvryNo", String.valueOf(delvryMap.get("delvryNo")));
    					params.put("callGbn", "RETURN");
    					params.put("mobileYn", "Y");
    					params.put("userId", userId);
    					params.put("pErrcode", "");
    					params.put("pErrmsg", "");
    					MSvcLogApiService.SP_SVC_BARCODE_SAVE(params);

    					logger.debug("### SP_SVC_BARCODE_SAVE PARAM : " + params.toString());

    					if (!"000".equals(params.get("pErrcode"))) {
    						String procTransactionId = transactionId;
    						String procName = "ProductReturn";
    						String procKey = serviceNo;
    						String procMsg = "Failed to Barcode Save";
    						String errorMsg = "[API] " + params.get("pErrmsg");
    						throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
						}

    					spMap.put("pErrcode", "");
    					spMap.put("pErrmsg", "");
	        			servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);
	        			if (!"000".equals(spMap.get("pErrcode"))) {
    						String procTransactionId = transactionId;
    						String procName = "ProductReturn";
    						String procKey = serviceNo;
    						String procMsg = "Failed to Barcode Save";
    						String errorMsg = "[API] " + params.get("pErrmsg");
    						throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
						}
	        		}
	        	}
	        	catch (Exception e) {
	        		String procTransactionId = transactionId;
	    			String procName = "ProductReturn";
	    			String procKey = serviceNo;
	    			String procMsg = "Failed to Save";
	    			String errorMsg = "[API] " + e.toString();
	    			throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
	        	}
	        }
		}
		else {
			String procTransactionId = transactionId;
			String procName = "ProductReturn";
			String procKey = serviceNo;
			String procMsg = "NoTarget Data";
			String errorMsg = "[API] [" + cvMp.get("userId") + "] THIS PR ALREADY NOT IN ACTIVE STATUS. ";
			throw new BizException("04", procTransactionId, procName, procKey, procMsg, errorMsg, null);
		}

		logger.debug("### PRODUCT RETURN FINAL PARAM : " + cvMp.toString());

	    return ResponseEntity.ok(ProductReturnResultDto.create(transactionId));
	}
}
