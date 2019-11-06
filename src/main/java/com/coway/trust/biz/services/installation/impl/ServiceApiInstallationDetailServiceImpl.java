package com.coway.trust.biz.services.installation.impl;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.api.mobile.services.RegistrationConstants;
import com.coway.trust.api.mobile.services.installation.InstallFailJobRequestDto;
import com.coway.trust.api.mobile.services.installation.InstallationResultDto;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.biz.services.installation.ServiceApiInstallationDetailService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.BizExceptionFactoryBean;
import com.coway.trust.cmmn.model.BizMsgVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ServiceApiInstallationDetailServiceImpl.java
 * @Description : Mobile Installation Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 17.   Jun             First creation
 */
@Service("serviceApiInstallationDetailService")
public class ServiceApiInstallationDetailServiceImpl extends EgovAbstractServiceImpl implements ServiceApiInstallationDetailService {
	private static final Logger logger = LoggerFactory.getLogger(ServiceApiInstallationDetailServiceImpl.class);

	@Resource(name = "MSvcLogApiService")
	private MSvcLogApiService MSvcLogApiService;

	@Resource(name = "installationResultListService")
	private InstallationResultListService installationResultListService;

	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;

	@Override
	public ResponseEntity<InstallationResultDto> installationResultProc(Map<String, Object> insApiresult) throws Exception {
		String transactionId = "";
		String serviceNo = "";

		SessionVO sessionVO1 = new SessionVO();

		Map<String, Object> params = insApiresult;

		transactionId = String.valueOf(params.get("transactionId"));
		serviceNo = String.valueOf(params.get("serviceNo"));

		// SAL0046D CHECK
		int isInsMemIdCnt = installationResultListService.insResultSync(params);

		if (isInsMemIdCnt > 0) {
			// SAL0046D CHECK (STUS_CODE_ID <> '1')
			int isInsCnt = installationResultListService.isInstallAlreadyResult(params);

			// MAKE SURE IT'S ALREADY PROCEEDED
			if (isInsCnt == 0) {
				String statusId = "4"; // INSTALLATION STATUS

				// DETAIL INFO SELECT (SALES_ORD_NO, INSTALL_ENTRY_NO)
				EgovMap installResult = MSvcLogApiService.getInstallResultByInstallEntryID(params);
				params.put("installEntryId", installResult.get("installEntryId"));

				// DETAIL INFO RESULT IS NO COLUMN
				// java.lang.NullPointerException -> addrDtl, areaId
//				try {
//					params.put("hidInstallation_AddDtl", installResult.get("addrDtl"));
//					params.put("hidInstallation_AreaID", installResult.get("areaId"));
//				}
//				catch (Exception e) {
//					e.printStackTrace();
//				}

				// DETAIL INFO SELECT (installEntryId)
				EgovMap orderInfo = installationResultListService.getOrderInfo(params);

				logger.debug("### INSTALLATION STOCK : " + orderInfo.get("stkId"));
				if (orderInfo.get("stkId") != null || !("".equals(orderInfo.get("stkId")))) {
					// CHECK STOCK QUANTITY
					Map<String, Object> locInfoEntry = new HashMap<String, Object>();
					locInfoEntry.put("CT_CODE", CommonUtils.nvl(insApiresult.get("userId").toString()));
					locInfoEntry.put("STK_CODE", CommonUtils.nvl(orderInfo.get("stkId").toString()));

					logger.debug("LOC. INFO. ENTRY : {}" + locInfoEntry);

					// select FN_GET_SVC_AVAILABLE_INVENTORY(#{CT_CODE}, #{STK_CODE})  AVAIL_QTY from dual
					// 재고 수량 조회
					EgovMap locInfo = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY(locInfoEntry);

					logger.debug("LOC. INFO. : {}" + locInfo);

					if (locInfo != null) {
						if(Integer.parseInt(locInfo.get("availQty").toString()) < 1){
							MSvcLogApiService.updateSuccessErrInstallStatus(transactionId);

							Map<String, Object> m = new HashMap();
							m.put("APP_TYPE", "INS");
							m.put("SVC_NO", insApiresult.get("serviceNo"));
							m.put("ERR_CODE", "03");
							m.put("ERR_MSG", "[API] [" + insApiresult.get("userId") + "] PRODUCT FOR [" + orderInfo.get("stkId").toString() + "] IS UNAVAILABLE. " + locInfo.get("availQty").toString());
							m.put("TRNSC_ID", transactionId);

							MSvcLogApiService.insert_SVC0066T(m);

							BizMsgVO bizMsgVO = new BizMsgVO();
							bizMsgVO.setProcTransactionId(transactionId);
							bizMsgVO.setProcKey(serviceNo);
							bizMsgVO.setProcName("Installation");
							bizMsgVO.setProcMsg("PRODUCT UNAVAILABLE");
							//bizMsgVO.setErrorMsg("[API] [" + insApiresult.get("userId") + "] PRODUCT FOR [" + orderInfo.get("stkId").toString() + "] IS UNAVAILABLE. " + locInfo.get("availQty").toString());
							bizMsgVO.setErrorMsg("[API] [" + insApiresult.get("userId") + "] PRODUCT FOR [" + (String)orderInfo.get("stkId") + "] IS UNAVAILABLE. " + (String)locInfo.get("availQty"));
							throw BizExceptionFactoryBean.getInstance().createBizException("01", bizMsgVO);

							//return ResponseEntity.ok(InstallationResultDto.create(transactionId));
						}
					}
					else {
						MSvcLogApiService.updateSuccessErrInstallStatus(transactionId);

						Map<String, Object> m = new HashMap();
						m.put("APP_TYPE", "INS");
						m.put("SVC_NO", insApiresult.get("serviceNo"));
						m.put("ERR_CODE", "03");
						m.put("ERR_MSG", "[API] [" + insApiresult.get("userId") + "] PRODUCT FOR [" + orderInfo.get("stkId").toString() + "] IS UNAVAILABLE. ");
						m.put("TRNSC_ID", transactionId);

						MSvcLogApiService.insert_SVC0066T(m);

						BizMsgVO bizMsgVO = new BizMsgVO();
						bizMsgVO.setProcTransactionId(transactionId);
						bizMsgVO.setProcKey(serviceNo);
						bizMsgVO.setProcName("Installation");
						bizMsgVO.setProcMsg("PRODUCT LOC NO DATA");
						bizMsgVO.setErrorMsg("PRODUCT LOC NO DATA");
						throw BizExceptionFactoryBean.getInstance().createBizException("01", bizMsgVO);

						//return ResponseEntity.ok(InstallationResultDto.create(transactionId));
					}
				}

				String userId = MSvcLogApiService.getUseridToMemid(params); // SELECT MEM_ID FROM ORG0001D WHERE mem_code = #{userId}
				String installDate = MSvcLogApiService.getInstallDate(insApiresult); // SELECT TO_CHAR( TO_DATE(#{checkInDate} ,'YYYY/MM/DD') , 'DD/MM/YYYY' ) FROM DUAL

				params.put("installStatus", String.valueOf(statusId));
				params.put("statusCodeId", Integer.parseInt(params.get("installStatus").toString()));
				params.put("hidEntryId", String.valueOf(installResult.get("installEntryId")));
				params.put("hidCustomerId", String.valueOf(installResult.get("custId")));
				params.put("hidSalesOrderId", String.valueOf(installResult.get("salesOrdId")));
				params.put("hidTaxInvDSalesOrderNo", String.valueOf(installResult.get("salesOrdNo")));
				params.put("hidStockIsSirim", String.valueOf(installResult.get("isSirim")));
				params.put("hidStockGrade", installResult.get("stkGrad"));
				params.put("hidSirimTypeId", String.valueOf(installResult.get("stkCtgryId")));
				params.put("hiddeninstallEntryNo", String.valueOf(installResult.get("installEntryNo")));
				params.put("hidTradeLedger_InstallNo", String.valueOf(installResult.get("installEntryNo")));
				params.put("installDate", installDate);
				params.put("CTID", String.valueOf(userId));
				params.put("updator", String.valueOf(userId));
				params.put("nextCallDate", "01-01-1999");
				params.put("refNo1", "0");
				params.put("refNo2", "0");
				params.put("codeId", String.valueOf(installResult.get("257")));
				params.put("checkCommission", 1);

				if (orderInfo != null) {
					params.put("hidOutright_Price", CommonUtils.nvl(String.valueOf(orderInfo.get("c5"))));
				}
				else {
					params.put("hidOutright_Price", "0");
				}

				params.put("hidAppTypeId", installResult.get("codeId"));
				params.put("hidStockIsSirim", String.valueOf(insApiresult.get("sirimNo")));
				params.put("hidSerialNo", String.valueOf(insApiresult.get("serialNo")));
				params.put("remark", insApiresult.get("resultRemark"));

				logger.debug("### INSTALLATION PARAM : " + params.toString());

				sessionVO1.setUserId(Integer.parseInt(userId));

				try {
					Map rtnValue = installationResultListService.insertInstallationResult(params, sessionVO1);

					if (null != rtnValue) {
						HashMap spMap = (HashMap) rtnValue.get("spMap");
						if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
							rtnValue.put("logerr", "Y");
						}
						else {
							if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
								MSvcLogApiService.updateSuccessInstallStatus(transactionId);
							}
						}

						// SP_SVC_LOGISTIC_REQUEST COMMIT STRING DELETE
						servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
					}
				} catch (Exception e) {
					BizMsgVO bizMsgVO = new BizMsgVO();
					bizMsgVO.setProcTransactionId(transactionId);
					bizMsgVO.setProcKey(serviceNo);
					bizMsgVO.setProcName("Installation");
					bizMsgVO.setProcMsg("Failed to Save");
					bizMsgVO.setErrorMsg("[API] " + e.toString());
					throw BizExceptionFactoryBean.getInstance().createBizException("02", bizMsgVO);
				}
			}
			else {
				// 대상이 없다면 정상 완료 처리
				if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
					MSvcLogApiService.updateSuccessInstallStatus(String.valueOf(params.get("transactionId")));
				}
			}
		}
		else {
			BizMsgVO bizMsgVO = new BizMsgVO();
			bizMsgVO.setProcTransactionId(transactionId);
			bizMsgVO.setProcKey(serviceNo);
			bizMsgVO.setProcName("Installation");
			bizMsgVO.setProcMsg("NoTarget Data");
			bizMsgVO.setErrorMsg("[API] [" + insApiresult.get("userId") + "] IT IS NOT ASSIGNED CT CODE. ");
			throw BizExceptionFactoryBean.getInstance().createBizException("01", bizMsgVO);
		}

		logger.debug("### INSTALLATION FINAL PARAM : " + params.toString());

	    return ResponseEntity.ok(InstallationResultDto.create(transactionId));
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRES_NEW)
	public ResponseEntity<InstallFailJobRequestDto> installFailJobRequestProc(Map<String, Object> params) throws Exception {
		String serviceNo = String.valueOf(params.get("serviceNo"));
		SessionVO sessionVO1 = new SessionVO();
		int resultSeq = 0;
		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
			resultSeq = (Integer)params.get("resultSeq");
		}

		Date dt = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTime(dt);
		cal.add(Calendar.DATE, 1);
	    int year = cal.get(cal.YEAR);
	    String month = String.format("%02d", cal.get(cal.MONTH) + 1);
	    String date = String.format("%02d", cal.get(cal.DATE));
	    String todayPlusOne = (String.valueOf(date) + '/' + String.valueOf(month) + '/' + String.valueOf(year));

	    int isInsCnt = installationResultListService.isInstallAlreadyResult(params);

	    // IF STATUS ARE NOT ACTIVE
	    if (isInsCnt == 0) {
	    	String statusId = "21";

	    	// SAL0046D SELECT
	    	EgovMap installResult = MSvcLogApiService.getInstallResultByInstallEntryID(params);
	    	params.put("installEntryId", installResult.get("installEntryId"));

	    	EgovMap orderInfo = installationResultListService.getOrderInfo(params);

	    	String userId = MSvcLogApiService.getUseridToMemid(params);
	    	sessionVO1.setUserId(Integer.parseInt(userId));

	    	params.put("installStatus", String.valueOf(statusId));// 21
	    	params.put("statusCodeId", Integer.parseInt(params.get("installStatus").toString()));
	    	params.put("hidEntryId", String.valueOf(installResult.get("installEntryId")));
	    	params.put("hidCustomerId", String.valueOf(installResult.get("custId")));
	    	params.put("hidSalesOrderId", String.valueOf(installResult.get("salesOrdId")));
	    	params.put("hidTaxInvDSalesOrderNo", String.valueOf(installResult.get("salesOrdNo")));
	    	params.put("hidStockIsSirim", String.valueOf(installResult.get("isSirim")));
	    	params.put("hidStockGrade", installResult.get("stkGrad"));
	    	params.put("hidSirimTypeId", String.valueOf(installResult.get("stkCtgryId")));
	    	params.put("hiddeninstallEntryNo", String.valueOf(installResult.get("installEntryNo")));
	    	params.put("hidTradeLedger_InstallNo", String.valueOf(installResult.get("installEntryNo")));
	    	params.put("hidCallType", "257"); // fail시 전화타입 257
	    	params.put("CTID", String.valueOf(userId));
	    	params.put("installDate", "");
	    	params.put("updator", String.valueOf(userId));
	    	params.put("nextCallDate", todayPlusOne);
	    	params.put("refNo1", "0");
	    	params.put("refNo2", "0");
	    	params.put("codeId", String.valueOf(installResult.get("257")));
	    	params.put("failReason", String.valueOf(params.get("failReasonCode")));
	    	if (orderInfo != null) {
	    		params.put("hidOutright_Price", CommonUtils.nvl(String.valueOf(orderInfo.get("c5"))));
	    	}
	    	else {
	    		params.put("hidOutright_Price", "0");
	    	}
	    	params.put("hidAppTypeId", installResult.get("codeId"));

	    	if (installResult.get("sirimNo") != null) {
	    		params.put("sirimNo", installResult.get("sirimNo"));
	    	}
	    	else {
	    		params.put("sirimNo", "");
	    	}
	    	if (installResult.get("serialNo") != null) {
	    		params.put("serialNo", installResult.get("serialNo"));
	    	}
	    	else {
	    		params.put("serialNo", "");
	    	}

	    	/*
	         * params.put("hidStockIsSirim",String.valueOf(insTransLogs.get(i).get(
	         * "sirimNo")));
	         * params.put("hidSerialNo",String.valueOf(insTransLogs.get(i).get(
	         * "serialNo")));
	         * params.put("remark",insTransLogs.get(i).get("resultRemark"));
	         */

	    	logger.debug("### INSTALLATION FAIL JOB REQUEST PARAM : " + params.toString());

	    	Map rtnValue = installationResultListService.insertInstallationResult(params, sessionVO1);

	    	if (null != rtnValue) {
	    		HashMap spMap = (HashMap) rtnValue.get("spMap");
	    		if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
	    			rtnValue.put("logerr", "Y");
	    		}
	    		else {
	    			if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
	    				MSvcLogApiService.updateSuccessInsFailServiceLogs(resultSeq);
	    			}
	    		}

	    		// SP_SVC_LOGISTIC_REQUEST COMMIT DELETE
	    		servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
	    	}
	    }

	    return ResponseEntity.ok(InstallFailJobRequestDto.create(serviceNo));
	}
}
