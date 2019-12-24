package com.coway.trust.biz.services.installation.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.http.client.HttpResponseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.services.RegistrationConstants;
import com.coway.trust.api.mobile.services.installation.InstallFailJobRequestDto;
import com.coway.trust.api.mobile.services.installation.InstallFailJobRequestForm;
import com.coway.trust.api.mobile.services.installation.InstallationResultDto;
import com.coway.trust.api.mobile.services.installation.InstallationResultForm;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.biz.services.installation.ServiceApiInstallationDetailService;
import com.coway.trust.biz.services.installation.ServiceApiInstallationService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.BizException;
import com.coway.trust.web.services.installation.InstallationResultListController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @ClassName : ServiceApiInstallationServiceImpl.java
 * @Description : Mobile Installation Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 17.   Jun             First creation
 */
@Service("serviceApiInstallationService")
public class ServiceApiInstallationServiceImpl extends EgovAbstractServiceImpl implements ServiceApiInstallationService {
	private static final Logger logger = LoggerFactory.getLogger(InstallationResultListController.class);

	@Resource(name = "MSvcLogApiService")
	private MSvcLogApiService MSvcLogApiService;

	@Resource(name = "serviceApiInstallationDetailService")
	private ServiceApiInstallationDetailService serviceApiInstallationDetailService;

	@Resource(name = "installationResultListService")
	private InstallationResultListService installationResultListService;

	@Override
	public ResponseEntity<InstallationResultDto> installationResult(List<InstallationResultForm> installationResultForms) throws Exception {
		String transactionId = "";
		List<Map<String, Object>> insTransLogs = null;
		Map<String, Object> insApiresult = null;
		int totalCnt = 0;
		int successCnt = 0;
		int failCnt = 0;

		logger.debug("==================================[MB]INSTALLATION RESULT REGISTRATION - START - ====================================");
		logger.debug("### INSTALLATION FORM : ", installationResultForms);

		insTransLogs = new ArrayList<>();
		for (InstallationResultForm insService : installationResultForms) {
			insTransLogs.addAll(insService.createMaps(insService));
		}

		// Insert Log Adapter. So Delete Log
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			for (int i = 0; i < insTransLogs.size(); i++) {
//				// INSERT LOG HISTORY (SVC0025T)(REQUIRES_NEW)
//				try {
//					MSvcLogApiService.saveInstallServiceLogs(insTransLogs.get(i));
//				}
//				catch (Exception e) {
//					e.printStackTrace();
//				}
//			}
//		}

		totalCnt = insTransLogs.size();

		logger.debug("### INSTALLATION SIZE : " + insTransLogs.size());
		for (int i = 0; i < insTransLogs.size(); i++) {
			logger.debug("### INSTALLATION DETAILS : " + insTransLogs.get(i));

			insApiresult = insTransLogs.get(i);

			transactionId = String.valueOf(insApiresult.get("transactionId"));

			// DETAIL PROC
			try {
				serviceApiInstallationDetailService.installationResultProc(insApiresult);
				successCnt = successCnt + 1;
			}
			catch (BizException bizException) {
				logger.debug("### INSTALLATION bizException errorcode : " + bizException.getErrorCode());
				logger.debug("### INSTALLATION bizException errormsg : " + bizException.getErrorMsg());
				// UPDATE LOG HISTORY (SVC0025T)(REQUIRES_NEW)
				// Insert Log Adapter. So Delete Log
//				MSvcLogApiService.updateSuccessErrInstallStatus(transactionId);

				Map<String, Object> m = new HashMap();
				m.put("APP_TYPE", "INS");
				m.put("SVC_NO", insApiresult.get("serviceNo"));
				m.put("ERR_CODE", bizException.getErrorCode());
				m.put("ERR_MSG", bizException.getErrorMsg());
				m.put("TRNSC_ID", transactionId);

				// INSERT FAIL LOG HISTORY (SVC0066T)(REQUIRES_NEW)
				MSvcLogApiService.insert_SVC0066T(m);

				failCnt = failCnt + 1;

				throw new ApplicationException(AppConstants.FAIL, bizException.getProcMsg());
			}
			catch (Exception exception) {
				// UPDATE LOG HISTORY (SVC0025T)(REQUIRES_NEW)
				// Insert Log Adapter. So Delete Log
//				MSvcLogApiService.updateSuccessErrInstallStatus(transactionId);

				Map<String, Object> m = new HashMap();
				m.put("APP_TYPE", "INS");
				m.put("SVC_NO", insApiresult.get("serviceNo"));
				m.put("ERR_CODE", "01");
				m.put("ERR_MSG", exception.toString());
				m.put("TRNSC_ID", transactionId);

				// INSERT FAIL LOG HISTORY (SVC0066T)(REQUIRES_NEW)
				MSvcLogApiService.insert_SVC0066T(m);

				failCnt = failCnt + 1;

				throw new ApplicationException(AppConstants.FAIL, "Fail");
			}
		}

		logger.debug("==================================[MB]INSTALLATION RESULT REGISTRATION - END - ====================================");

	    return ResponseEntity.ok(InstallationResultDto.create(transactionId));
	}

	@Override
	public ResponseEntity<InstallFailJobRequestDto> installFailJobRequest(InstallFailJobRequestForm installFailJobRequestForm) throws Exception {
		String serviceNo = "";

	    Map<String, Object> params = InstallFailJobRequestForm.createMaps(installFailJobRequestForm);

	    serviceNo = String.valueOf(params.get("serviceNo"));

	    logger.debug("==================================[MB]INSTALLATION FAIL JOB REQUEST ====================================");
	    logger.debug("### INSTALLATION FAIL JOB REQUEST FORM : " + params.toString());
	    logger.debug("==================================[MB]INSTALLATION FAIL JOB REQUEST ====================================");

	    // INSERT LOG HISTORY (SVC0043T)(REQUIRES_NEW) (resultSeq KEY CREATE)
	    if (RegistrationConstants.IS_INSERT_INSFAIL_LOG) {
	    	try {
	    		MSvcLogApiService.saveInsFailServiceLogs(params);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
	    }

	    try {
	    	serviceApiInstallationDetailService.installFailJobRequestProc(params);
	    }
	    catch (Exception e) {
	    	throw new ApplicationException(AppConstants.FAIL, "Fail");
		}

	    return ResponseEntity.ok(InstallFailJobRequestDto.create(serviceNo));
	}

	@Override
	public ResponseEntity<InstallationResultDto> installationDtResult(List<InstallationResultForm> installationResultForms) throws Exception {
		String transactionId = "";
		List<Map<String, Object>> insTransLogs = null;
		Map<String, Object> insApiresult = null;
		int totalCnt = 0;
		int successCnt = 0;
		int failCnt = 0;

		logger.debug("==================================[MB]INSTALLATION RESULT REGISTRATION - START - ====================================");
		logger.debug("### INSTALLATION FORM : ", installationResultForms);

		insTransLogs = new ArrayList<>();
		for (InstallationResultForm insService : installationResultForms) {
			insTransLogs.addAll(insService.createMaps(insService));
		}

		totalCnt = insTransLogs.size();

		logger.debug("### INSTALLATION SIZE : " + insTransLogs.size());
		for (int i = 0; i < insTransLogs.size(); i++) {
			logger.debug("### INSTALLATION DETAILS : " + insTransLogs.get(i));

			insApiresult = insTransLogs.get(i);

			transactionId = String.valueOf(insApiresult.get("transactionId"));

			// DETAIL PROC
			try {
				serviceApiInstallationDetailService.installationDtResultProc(insApiresult);
				successCnt = successCnt + 1;
			}
			catch (BizException bizException) {
				logger.debug("### INSTALLATION bizException errorcode : " + bizException.getErrorCode());
				logger.debug("### INSTALLATION bizException errormsg : " + bizException.getErrorMsg());

				Map<String, Object> m = new HashMap();
				m.put("APP_TYPE", "INS");
				m.put("SVC_NO", insApiresult.get("serviceNo"));
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
				m.put("APP_TYPE", "INS");
				m.put("SVC_NO", insApiresult.get("serviceNo"));
				m.put("ERR_CODE", "01");
				m.put("ERR_MSG", exception.toString());
				m.put("TRNSC_ID", transactionId);

				// INSERT FAIL LOG HISTORY (SVC0066T)(REQUIRES_NEW)
				MSvcLogApiService.insert_SVC0066T(m);

				failCnt = failCnt + 1;

				throw new ApplicationException(AppConstants.FAIL, "Fail");
			}
		}

		logger.debug("==================================[MB]INSTALLATION RESULT REGISTRATION - END - ====================================");

	    return ResponseEntity.ok(InstallationResultDto.create(transactionId));
	}
}
