package com.coway.trust.biz.services.as.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.coway.trust.api.mobile.services.RegistrationConstants;
import com.coway.trust.api.mobile.services.as.ASFailJobRequestDto;
import com.coway.trust.api.mobile.services.as.ASFailJobRequestForm;
import com.coway.trust.api.mobile.services.as.AfterServiceResultDto;
import com.coway.trust.api.mobile.services.as.AfterServiceResultForm;
import com.coway.trust.biz.services.as.ServiceApiASDetailService;
import com.coway.trust.biz.services.as.ServiceApiASService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.BizException;
import org.apache.http.client.HttpResponseException;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.AppConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @ClassName : ServiceApiASServiceImpl.java
 * @Description : Mobile After Service Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 20.   Jun             First creation
 */
@Service("serviceApiASService")
public class ServiceApiASServiceImpl extends EgovAbstractServiceImpl implements ServiceApiASService {
	private static final Logger logger = LoggerFactory.getLogger(ServiceApiASServiceImpl.class);

	@Resource(name = "MSvcLogApiService")
	private MSvcLogApiService MSvcLogApiService;

	@Resource(name = "serviceApiASDetailService")
	private ServiceApiASDetailService serviceApiASDetailService;

	@Override
	public ResponseEntity<AfterServiceResultDto> asResult(List<AfterServiceResultForm> afterServiceForms) throws Exception {
		String transactionId = "";
		String serviceNo = "";
		List<Map<String, Object>> asTransLogs = null;
	    List<Map<String, Object>> asTransLogs1 = null;
	    int totalCnt = 0;
		int successCnt = 0;
		int failCnt = 0;

		// INSERT DATA FROM MOBILE INTO LOG TABLE
	    logger.debug("==================================[MB]AFTER SERVICE RESULT - START - ====================================");
	    logger.debug("### INSERT HEART LOG? : {}" + RegistrationConstants.IS_INSERT_AS_LOG);
	    logger.debug("### TRANSACTION ID? : {}" + RegistrationConstants.IS_INSERT_AS_LOG);
	    logger.debug("### AS FORM : {}" + afterServiceForms);

	    if (RegistrationConstants.IS_INSERT_AS_LOG) {
	    	logger.debug("==================================[MB]AFTER SERVICE RESULT > SAVE HS LOG - START - ====================================");
		    asTransLogs = new ArrayList<>();
		    for (AfterServiceResultForm afterService : afterServiceForms) {
		    	asTransLogs.addAll(afterService.createMaps(afterService));
		    }

		    MSvcLogApiService.saveAfterServiceLogs(asTransLogs);

		    transactionId = afterServiceForms.get(0).getTransactionId();
		    logger.debug("### TRANSACTION ID : " + transactionId);
		    logger.debug("==================================[MB]AFTER SERVICE RESULT > SAVE HS LOG - END - ====================================");
	    }

	    asTransLogs1 = new ArrayList<>();
	    for (AfterServiceResultForm afterService1 : afterServiceForms) {
	    	asTransLogs1.addAll(afterService1.createMaps1(afterService1));
	    }

	    totalCnt = asTransLogs1.size();

	    logger.debug("### AS TRANSACTION TOTAL : " + asTransLogs1.size());
	    for (int i = 0; i < asTransLogs1.size(); i++) {
	    	logger.debug("### AS TRANSACTION DETAILS : " + asTransLogs1.get(i));

	    	Map<String, Object> insApiresult = asTransLogs1.get(i);
	    	transactionId = String.valueOf(insApiresult.get("transactionId"));
	    	serviceNo = String.valueOf(insApiresult.get("serviceNo"));

	    	// DETAIL PROC
			try {
				serviceApiASDetailService.asResultProc(insApiresult);
				successCnt = successCnt + 1;
			}
			catch (BizException bizException) {
				// UPDATE LOG HISTORY (SVC0024T)(REQUIRES_NEW)
				MSvcLogApiService.updateErrStatus(transactionId);

				Map<String, Object> m = new HashMap();
				m.put("APP_TYPE", "AS");
	            m.put("SVC_NO", serviceNo);
	            m.put("ERR_CODE", bizException.getErrorCode());
	            m.put("ERR_MSG", bizException.getErrorMsg());
	            m.put("TRNSC_ID", transactionId);

				// INSERT FAIL LOG HISTORY (SVC0066T)(REQUIRES_NEW)
				MSvcLogApiService.insert_SVC0066T(m);

				failCnt = failCnt + 1;

				throw new ApplicationException(AppConstants.FAIL, bizException.getProcMsg());
			}
			catch (Exception exception) {
				// UPDATE LOG HISTORY (SVC0024T)(REQUIRES_NEW)
				MSvcLogApiService.updateErrStatus(transactionId);

				Map<String, Object> m = new HashMap();
				m.put("APP_TYPE", "AS");
				m.put("SVC_NO", serviceNo);
				m.put("ERR_CODE", "01");
				m.put("ERR_MSG", exception.toString());
				m.put("TRNSC_ID", transactionId);

				// INSERT FAIL LOG HISTORY (SVC0066T)(REQUIRES_NEW)
				MSvcLogApiService.insert_SVC0066T(m);

				failCnt = failCnt + 1;

				throw new ApplicationException(AppConstants.FAIL, "Fail");
			}
	    }

	    logger.debug("==================================[MB]AFTER SERVICE RESULT - END - ====================================");

	    return ResponseEntity.ok(AfterServiceResultDto.create(transactionId));
	}

	@Override
	public ResponseEntity<ASFailJobRequestDto> asFailJobRequest(ASFailJobRequestForm asFailJobRequestForm) throws Exception {
		Map<String, Object> params = ASFailJobRequestForm.createMaps(asFailJobRequestForm);

		String serviceNo = String.valueOf(params.get("serviceNo"));

	    logger.debug("==================================[MB]AS FAIL JOB REQUEST ====================================");
	    logger.debug("### AS FAIL JOB REQUEST FORM : " + params.toString());
	    logger.debug("==================================[MB]AS FAIL JOB REQUEST ====================================");

	    // INSERT LOG HISTORY (SVC0041T)(REQUIRES_NEW)
	    if (RegistrationConstants.IS_INSERT_HSFAIL_LOG) {
	    	try {
	    		MSvcLogApiService.saveAsFailServiceLogs(params);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
	    }

	    serviceApiASDetailService.asFailJobRequestProc(params);

	    return ResponseEntity.ok(ASFailJobRequestDto.create(serviceNo));
	}
}
