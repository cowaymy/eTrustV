package com.coway.trust.biz.services.pr.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.coway.trust.api.mobile.services.productRetrun.PRFailJobRequestDto;
import com.coway.trust.api.mobile.services.productRetrun.PRFailJobRequestForm;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultDto;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultForm;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.biz.services.pr.ServiceApiPRDetailService;
import com.coway.trust.biz.services.pr.ServiceApiPRService;
import com.coway.trust.cmmn.exception.BizException;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @ClassName : ServiceApiPRServiceImpl.java
 * @Description : Mobile Product Return Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 24.   Jun             First creation
 */
@Service("serviceApiPRService")
public class ServiceApiPRServiceImpl extends EgovAbstractServiceImpl implements ServiceApiPRService {
	private static final Logger logger = LoggerFactory.getLogger(ServiceApiPRServiceImpl.class);

	@Resource(name = "MSvcLogApiService")
	private MSvcLogApiService MSvcLogApiService;

	@Resource(name = "serviceApiPRDetailService")
	private ServiceApiPRDetailService serviceApiPRDetailService;

	@Override
	public ResponseEntity<ProductReturnResultDto> productReturnResult(List<ProductReturnResultForm> productReturnResultForm) throws Exception {
		String transactionId = "";
	    List<Map<String, Object>> prTransLogs = null;
	    int totalCnt = 0;
		int successCnt = 0;
		int failCnt = 0;

	    logger.debug("==================================[MB]PRODUCT RETURN RESULT REGISTRATION - START - ====================================");
	    logger.debug("### PRODUCT RETURN FORM : ", productReturnResultForm);

	    prTransLogs = new ArrayList<>();
	    for (ProductReturnResultForm prService : productReturnResultForm) {
	    	prTransLogs.addAll(prService.createMaps(prService));
	    }

	    totalCnt = prTransLogs.size();

	    logger.debug("### PRODUCT RETURN SIZE : " + prTransLogs.size());
	    for (int i = 0; i < prTransLogs.size(); i++) {
	    	logger.debug("### PRODUCT RETURN DETAIL : " + prTransLogs.get(i));
	    	Map<String, Object> paramsTran = prTransLogs.get(i);
	    	Map<String, Object> cvMp = new HashMap<String, Object>();

	    	cvMp.put("stkRetnStusId", "4");
		    cvMp.put("stkRetnStkIsRet", "1");
		    cvMp.put("stkRetnRem", String.valueOf(paramsTran.get("resultRemark")));
		    cvMp.put("stkRetnResnId", paramsTran.get("resultCode"));
		    cvMp.put("stkRetnCcId", paramsTran.get("ccCode"));
		    cvMp.put("stkRetnCrtUserId", paramsTran.get("userId"));
		    cvMp.put("stkRetnUpdUserId", paramsTran.get("userId"));
		    cvMp.put("stkRetnResultIsSynch", "0");
		    cvMp.put("stkRetnAllowComm", "1");
		    cvMp.put("stkRetnCtMemId", paramsTran.get("userId"));
		    cvMp.put("checkinDt", String.valueOf(paramsTran.get("checkInDate")));
		    cvMp.put("checkinTm", String.valueOf(paramsTran.get("checkInTime")));
		    cvMp.put("checkinGps", String.valueOf(paramsTran.get("checkInGps")));
		    cvMp.put("signData", paramsTran.get("signData"));
		    cvMp.put("signRegDt", String.valueOf(paramsTran.get("signRegDate")));
		    cvMp.put("signRegTm", String.valueOf(paramsTran.get("signRegTime")));
		    cvMp.put("ownerCode", String.valueOf(paramsTran.get("ownerCode")));
		    cvMp.put("resultCustName", String.valueOf(paramsTran.get("resultCustName")));
		    cvMp.put("resultIcmobileNo", String.valueOf(paramsTran.get("resultIcMobileNo")));
		    cvMp.put("resultRptEmailNo", String.valueOf(paramsTran.get("resultReportEmailNo")));
		    cvMp.put("resultAceptName", String.valueOf(paramsTran.get("resultAcceptanceName")));
		    cvMp.put("salesOrderNo", String.valueOf(paramsTran.get("salesOrderNo")));
		    cvMp.put("userId", String.valueOf(paramsTran.get("userId")));
		    cvMp.put("serviceNo", String.valueOf(paramsTran.get("serviceNo")));
		    cvMp.put("transactionId", String.valueOf(paramsTran.get("transactionId")));

		    logger.debug("### PRODUCT RETURN INFORMATION : " + cvMp.toString());

	    	transactionId = String.valueOf(paramsTran.get("transactionId"));

	    	try {
	    		// INSERT LOG HISTORY (SVC0026T)(REQUIRES_NEW)
		        MSvcLogApiService.insert_SVC0026T(cvMp);
	    	}
	    	catch (Exception e) {
	    		// UPDATE LOG HISTORY (SVC0026T)(REQUIRES_NEW)
	    		MSvcLogApiService.updatePRErrStatus(transactionId);

		        Map<String, Object> m = new HashMap();
		        m.put("APP_TYPE", "PR");
		        m.put("SVC_NO", cvMp.get("serviceNo"));
		        m.put("ERR_CODE", "01");
		        m.put("ERR_MSG", "[API] " + e.toString());
		        m.put("TRNSC_ID", transactionId);

		        // INSERT FAIL LOG HISTORY (SVC0066T)(REQUIRES_NEW)
		        MSvcLogApiService.insert_SVC0066T(m);

		        continue;
	    	}

	    	// DETAIL PROC
			try {
				serviceApiPRDetailService.productReturnResultProc(cvMp);
				successCnt = successCnt + 1;
			}
			catch (BizException bizException) {
				// UPDATE LOG HISTORY (SVC0026T)(REQUIRES_NEW)
				MSvcLogApiService.updatePRErrStatus(transactionId);

				Map<String, Object> m = new HashMap();
				m.put("APP_TYPE", "PR");
				m.put("SVC_NO", cvMp.get("serviceNo"));
				m.put("ERR_CODE", bizException.getErrorCode());
				m.put("ERR_MSG", bizException.getBizMsgVO().getErrorMsg());
				m.put("TRNSC_ID", transactionId);

				// INSERT FAIL LOG HISTORY (SVC0066T)(REQUIRES_NEW)
				MSvcLogApiService.insert_SVC0066T(m);

				failCnt = failCnt + 1;

				throw bizException;
			}
			catch (Exception exception) {
				// UPDATE LOG HISTORY (SVC0026T)(REQUIRES_NEW)
				MSvcLogApiService.updatePRErrStatus(transactionId);

				Map<String, Object> m = new HashMap();
				m.put("APP_TYPE", "PR");
				m.put("SVC_NO", cvMp.get("serviceNo"));
				m.put("ERR_CODE", "01");
				m.put("ERR_MSG", exception.toString());
				m.put("TRNSC_ID", transactionId);

				// INSERT FAIL LOG HISTORY (SVC0066T)(REQUIRES_NEW)
				MSvcLogApiService.insert_SVC0066T(m);

				failCnt = failCnt + 1;

				throw exception;
			}

			MSvcLogApiService.updatePRStatus(transactionId);
	    }

	    logger.debug("==================================[MB]PRODUCT RETURN RESULT REGISTRATION - END - ====================================");

	    return ResponseEntity.ok(ProductReturnResultDto.create(transactionId));
	}

	@Override
	public ResponseEntity<PRFailJobRequestDto> prReAppointmentRequest(PRFailJobRequestForm pRFailJobRequestForm) throws Exception {
		String serviceNo = "";

	    Map<String, Object> params = PRFailJobRequestForm.createMaps(pRFailJobRequestForm);

	    serviceNo = String.valueOf(params.get("serviceNo"));

	    logger.debug("==================================[MB]PRODUCT RETURN FAIL JOB REQUEST ====================================");
	    logger.debug("### PRODUCT RETURN FAIL JOB REQUEST FORM : " + params.toString());
	    logger.debug("==================================[MB]PRODUCT RETURN FAIL JOB REQUEST ====================================");

	    serviceApiPRDetailService.prReAppointmentRequestProc(params);

	    return ResponseEntity.ok(PRFailJobRequestDto.create(serviceNo));
	}
}
