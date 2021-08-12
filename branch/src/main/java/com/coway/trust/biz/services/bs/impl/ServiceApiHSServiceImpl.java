package com.coway.trust.biz.services.bs.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.apache.http.client.HttpResponseException;

import com.coway.trust.api.mobile.services.RegistrationConstants;
import com.coway.trust.api.mobile.services.heartService.HSFailJobRequestDto;
import com.coway.trust.api.mobile.services.heartService.HSFailJobRequestForm;
import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDetailForm;
import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDto;
import com.coway.trust.api.mobile.services.heartService.HeartServiceResultForm;
import com.coway.trust.biz.services.bs.ServiceApiHSDetailService;
import com.coway.trust.biz.services.bs.ServiceApiHSService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.BizException;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.AppConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @ClassName : ServiceApiHSServiceImpl.java
 * @Description : Mobile Heart Service Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 20.   Jun             First creation
 */
@Service("serviceApiHSService")
public class ServiceApiHSServiceImpl extends EgovAbstractServiceImpl implements ServiceApiHSService {
	private static final Logger logger = LoggerFactory.getLogger(ServiceApiHSServiceImpl.class);

	@Resource(name = "MSvcLogApiService")
	private MSvcLogApiService MSvcLogApiService;

	@Resource(name = "serviceApiHSDetailService")
	private ServiceApiHSDetailService serviceApiHSDetailService;

	@Override
	public ResponseEntity<HeartServiceResultDto> hsResult(List<HeartServiceResultForm> heartForms) throws Exception {
		String transactionId = "";
		String serviceNo = "";
	    List<Map<String, Object>> heartLogs = null;
	    List<Map<String, Object>> hsTransLogs1 = null;
	    int totalCnt = 0;
		int successCnt = 0;
		int failCnt = 0;

	    // INSERT DATA FROM MOBILE INTO LOG TABLE
	    logger.debug("==================================[MB]HEART SERVICE RESULT - START - ====================================");
	    logger.debug("### INSERT HEART LOG? : {}" + RegistrationConstants.IS_INSERT_HEART_LOG);
	    logger.debug("### TRANSACTION ID? : {}" + RegistrationConstants.IS_INSERT_HEART_LOG);
	    logger.debug("### HS FORM : {}" + heartForms);

	    if (RegistrationConstants.IS_INSERT_HEART_LOG) {
	    	logger.debug("==================================[MB]HEART SERVICE RESULT > SAVE HS LOG - START - ====================================");
	    	heartLogs = new ArrayList<>();

	    	for (HeartServiceResultForm heart : heartForms) {
	    		heartLogs.addAll(heart.createMaps(heart));
	    	}

	    	try {
	    		MSvcLogApiService.saveHearLogs(heartLogs);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
	    	logger.debug("==================================[MB]HEART SERVICE RESULT > SAVE HS LOG - END - ====================================");
	    }

	    hsTransLogs1 = new ArrayList<>();
	    for (HeartServiceResultForm hsService1 : heartForms) {
	    	hsTransLogs1.addAll(hsService1.createMaps1(hsService1));
	    }

	    totalCnt = hsTransLogs1.size();

	    logger.debug("### HS TRANSACTION TOTAL : " + hsTransLogs1.size());
	    for (int i = 0; i < hsTransLogs1.size(); i++) {
	    	logger.debug("### HS TRANSACTION DETAILS : " + hsTransLogs1.get(i));

	    	List<Map<String, Object>> paramsDetail = HeartServiceResultDetailForm.createMaps((List<HeartServiceResultDetailForm>) hsTransLogs1.get(i).get("heartDtails"));
	    	List<Object> paramsDetailList = HeartServiceResultDetailForm.createMaps1((List<HeartServiceResultDetailForm>) hsTransLogs1.get(i).get("heartDtails"));

	    	Map<String, Object> params = hsTransLogs1.get(i);
	    	params.put("updList", paramsDetail);

	    	Map<String, Object> insApiresult = hsTransLogs1.get(i);
	    	transactionId = String.valueOf(insApiresult.get("transactionId"));
	    	serviceNo = String.valueOf(insApiresult.get("serviceNo"));

	    	logger.debug("### HS TRANSACTION PARAM : " + params.toString());

	    	// DETAIL PROC
			try {
				serviceApiHSDetailService.hsResultProc(insApiresult, params, paramsDetailList);
				successCnt = successCnt + 1;
			}
			catch (BizException bizException) {
				// UPDATE LOG HISTORY (SVC0023T)(REQUIRES_NEW)
				MSvcLogApiService.updateErrStatus(transactionId);

				Map<String, Object> m = new HashMap();
				m.put("APP_TYPE", "HS");
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
				// UPDATE LOG HISTORY (SVC0023T)(REQUIRES_NEW)
				MSvcLogApiService.updateErrStatus(transactionId);

				Map<String, Object> m = new HashMap();
				m.put("APP_TYPE", "HS");
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

	    logger.debug("==================================[MB]HEART SERVICE RESULT - END - ====================================");

	    return ResponseEntity.ok(HeartServiceResultDto.create(transactionId));
	}

	@Override
	public ResponseEntity<HSFailJobRequestDto> hsFailJobRequest(HSFailJobRequestForm hSFailJobRequestForm) throws Exception {
		String serviceNo = "";

	    Map<String, Object> params = HSFailJobRequestForm.createMaps(hSFailJobRequestForm);

	    serviceNo = String.valueOf(params.get("serviceNo"));

	    logger.debug("==================================[MB]HS FAIL JOB REQUEST ====================================");
	    logger.debug("### HS FAIL JOB REQUEST FORM : " + params.toString());
	    logger.debug("==================================[MB]HS FAIL JOB REQUEST ====================================");

	    // INSERT LOG HISTORY (SVC0041T)(REQUIRES_NEW)
	    if (RegistrationConstants.IS_INSERT_HSFAIL_LOG) {
	    	try {
	    		MSvcLogApiService.saveHsFailServiceLogs(params);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
	    }

	    try {
	    	serviceApiHSDetailService.hsFailJobRequestProc(params);
	    }
	    catch (Exception e) {
	    	throw new ApplicationException(AppConstants.FAIL, "Fail");
		}

	    return ResponseEntity.ok(HSFailJobRequestDto.create(serviceNo));
	}

	@Override
	public ResponseEntity<HeartServiceResultDto> htResult(List<HeartServiceResultForm> heartForms) throws Exception {
		String transactionId = "";
		String serviceNo = "";
	    List<Map<String, Object>> heartLogs = null;
	    List<Map<String, Object>> hsTransLogs1 = null;
	    int totalCnt = 0;
		int successCnt = 0;
		int failCnt = 0;

	    // INSERT DATA FROM MOBILE INTO LOG TABLE
	    logger.debug("==================================[MB]CARE SERVICE RESULT - START - ====================================");
	    logger.debug("### CS FORM : {}" + heartForms);

	    hsTransLogs1 = new ArrayList<>();
	    for (HeartServiceResultForm hsService1 : heartForms) {
	    	hsTransLogs1.addAll(hsService1.createMaps1(hsService1));
	    }

	    totalCnt = hsTransLogs1.size();

	    logger.debug("### CS TRANSACTION TOTAL : " + hsTransLogs1.size());
	    for (int i = 0; i < hsTransLogs1.size(); i++) {
	    	logger.debug("### CS TRANSACTION DETAILS : " + hsTransLogs1.get(i));

	    	List<Map<String, Object>> paramsDetail = HeartServiceResultDetailForm.createMaps((List<HeartServiceResultDetailForm>) hsTransLogs1.get(i).get("heartDtails"));
	    	List<Object> paramsDetailList = HeartServiceResultDetailForm.createMaps1((List<HeartServiceResultDetailForm>) hsTransLogs1.get(i).get("heartDtails"));

	    	Map<String, Object> params = hsTransLogs1.get(i);
	    	params.put("updList", paramsDetail);

	    	Map<String, Object> insApiresult = hsTransLogs1.get(i);
	    	transactionId = String.valueOf(insApiresult.get("transactionId"));
	    	serviceNo = String.valueOf(insApiresult.get("serviceNo"));

	    	logger.debug("### CS TRANSACTION PARAM : " + params.toString());
	    	logger.debug("### CS TRANSACTION PARAM : " + paramsDetailList);

	    	// DETAIL PROC
			try {
				serviceApiHSDetailService.htResultProc(insApiresult, params, paramsDetailList);
				successCnt = successCnt + 1;
			}
			catch (BizException bizException) {
				Map<String, Object> m = new HashMap();
				m.put("APP_TYPE", "HS");
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
				Map<String, Object> m = new HashMap();
				m.put("APP_TYPE", "HS");
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

	    logger.debug("==================================[MB]CARE SERVICE RESULT - END - ====================================");

	    return ResponseEntity.ok(HeartServiceResultDto.create(transactionId));
	}

	@Override
	public ResponseEntity<HSFailJobRequestDto> htFailJobRequest(HSFailJobRequestForm hSFailJobRequestForm) throws Exception {
		String serviceNo = "";

	    Map<String, Object> params = HSFailJobRequestForm.createMaps(hSFailJobRequestForm);

	    serviceNo = String.valueOf(params.get("serviceNo"));

	    logger.debug("==================================[MB]CS FAIL JOB REQUEST ====================================");
	    logger.debug("### CS FAIL JOB REQUEST FORM : " + params.toString());
	    logger.debug("==================================[MB]CS FAIL JOB REQUEST ====================================");

	    // INSERT LOG HISTORY (SVC0041T)(REQUIRES_NEW)
	    if (RegistrationConstants.IS_INSERT_HSFAIL_LOG) {
	    	try {
	    		MSvcLogApiService.saveHsFailServiceLogs(params);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
	    }

	    try {
	    	serviceApiHSDetailService.htFailJobRequestProc(params);
	    }
	    catch (Exception e) {
	    	logger.debug("==================================[MB]CS FAIL Exception ====================================");
	    	logger.debug(e.toString());
	    	throw new ApplicationException(AppConstants.FAIL, "Fail");
		}

	    return ResponseEntity.ok(HSFailJobRequestDto.create(serviceNo));
	}
}
