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
import egovframework.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.BeanUtils;

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

		List<InstallationResultForm> installationList = new ArrayList<>();

		logger.debug("==================================[MB]INSTALLATION RESULT REGISTRATION - START - ====================================");
		logger.debug("### INSTALLATION FORM : ", installationResultForms);

		// Frame이 존재한다면 insTransLogs New Row
		for (InstallationResultForm insService : installationResultForms) {
			InstallationResultForm orgForm = new InstallationResultForm();
			BeanUtils.copyProperties(insService, orgForm);
			installationList.add(orgForm);

			InstallationResultForm resultForm = new InstallationResultForm();
			BeanUtils.copyProperties(insService, resultForm);

			// 해당 서비스 프레임 존재 확인
			Map<String, Object> fraParam = new HashMap();
			fraParam.put("matOrdNo", resultForm.getSalesOrderNo());
			fraParam.put("userId", resultForm.getUserId());
			EgovMap fraInfo = MSvcLogApiService.getFraOrdInfo(fraParam);

			if (fraInfo != null) {
				String newTransactionId = resultForm.getTransactionId().replaceAll(String.valueOf(resultForm.getSalesOrderNo()), fraInfo.get("salesOrderNo").toString());
				newTransactionId = newTransactionId.replaceAll(resultForm.getServiceNo(), String.valueOf(fraInfo.get("serviceNo")));

				resultForm.setSalesOrderNo(Integer.parseInt(fraInfo.get("salesOrderNo").toString()));
				resultForm.setServiceNo(String.valueOf(fraInfo.get("serviceNo")));
				resultForm.setTransactionId(newTransactionId);

				/*
				 requestList.push({
					"userId":row.userId,
					"salesOrderNo": row.salesOrderNo,---------------
					"serviceNo":row.serviceNo,----------------------
					"checkInDate" : row.checkInDate,
					"checkInTime" : row.checkInTime,
					"checkInGps" : row.checkInGps,
					"sirimNo":(row.sirimNo).toUpperCase(),
					"serialNo":(row.serialNo).toUpperCase(),
					"asExchangeYN":row.asExchangeYN,-----------
					"beforeProductSerialNo":row.beforeProductSerialNo,------
					"resultRemark":row.resultRemark,
					"ownerCode": Number(row.ownerCode),
					"resultCustName":row.resultCustName,
					"resultIcMobileNo":row.resultIcMobileNo,
					"resultReportEmailNo":row.resultReportEmailNo,
					"resultAcceptanceName":row.resultAcceptanceName,
					"signData":row.signData,
					"signRegDate":row.signRegDate,
					"signRegTime":row.signRegTime,
					"transactionId":row.transactionId,---------userId || '_' || salesOrderNo || '_' || serviceNo || '_' || strftime('%Y%m%d%H%M%S','now','localtime') as transactionId ";
					"scanSerial":row.scanSerial
				});
				*/

				installationList.add(resultForm);
			}
		}

		insTransLogs = new ArrayList<>();
		for (InstallationResultForm insService : installationList) {
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

	@Override
	public ResponseEntity<InstallFailJobRequestDto> installDtFailJobRequest(InstallFailJobRequestForm installFailJobRequestForm) throws Exception {
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
			Map<String, Object> fraParams =  new HashMap();
			fraParams.put("failReasonCode", params.get("failReasonCode"));
			fraParams.put("resultSeq", params.get("resultSeq"));
			fraParams.put("scanSerial", params.get("scanSerial"));
			fraParams.put("serviceNo", params.get("serviceNo"));
			fraParams.put("userId", params.get("userId"));
			fraParams.put("salesOrderNo", params.get("salesOrderNo"));
			fraParams.put("serialNo", params.get("serialNo"));

	    	serviceApiInstallationDetailService.installFailJobRequestProc(params);

	    	// Frame이 존재한다면 installFailJobRequestProc New Data Try
	    	Map<String, Object> fraParam = new HashMap();
			fraParam.put("matOrdNo", params.get("salesOrderNo"));
			fraParam.put("userId", String.valueOf(params.get("userId")));
			EgovMap fraInfo = MSvcLogApiService.getFraOrdInfo(fraParam);
			if (fraInfo != null) {
				fraParams.put("salesOrderNo", Integer.parseInt(fraInfo.get("salesOrderNo").toString()));
	    		fraParams.put("serviceNo", String.valueOf(fraInfo.get("serviceNo")));

				serviceApiInstallationDetailService.installFailJobRequestProc(fraParams);
			}
	    }
	    catch (Exception e) {
	    	throw new ApplicationException(AppConstants.FAIL, "Fail");
		}

	    return ResponseEntity.ok(InstallFailJobRequestDto.create(serviceNo));
	}
}
