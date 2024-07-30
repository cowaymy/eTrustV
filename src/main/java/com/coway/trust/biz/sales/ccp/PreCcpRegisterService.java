package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PreCcpRegisterService {

	int insertPreCcpSubmission(Map<String, Object> params) throws Exception;

	EgovMap getExistCustomer(Map<String, Object> params);

	List<EgovMap> searchOrderSummaryList(Map<String, Object> params);

	Map<String, Object> insertNewCustomerInfo(Map<String, Object> params);

	void updateCcrisScre(Map<String, Object> params);

	void updateCcrisId(Map<String, Object> params);

	Map<String, Object> insertNewCustomerDetails(Map<String, Object> params);

	EgovMap getPreccpResult(Map<String, Object> params);

	List<EgovMap> getPreCcpRemark(Map<String, Object> params);

	int editRemarkRequest(Map<String, Object> params) throws Exception;

	int insertRemarkRequest(Map<String, Object> params) ;

	EgovMap chkDuplicated(Map<String, Object> params);

	EgovMap getRegisteredCust(Map<String, Object> params);

	List <EgovMap> selectSmsConsentHistory(Map<String, Object> params);

	void updateSmsCount(Map<String, Object> params);

	EgovMap chkSendSmsValidTime(Map<String, Object> params);

	int resetSmsConsent();

	EgovMap chkSmsResetFlag();

	void updateResetFlag(Map<String, Object> params);

	EgovMap getCustInfo(Map<String, Object> params);

	void insertSmsHistory(Map<String, Object> params);

	int submitConsent(Map<String, Object> params) ;

	void updateCustomerScore(Map<String, Object> params);

	EgovMap checkStatus(Map<String, Object> params);

	List <EgovMap> selectPreCcpResult(Map<String, Object> params);

	List <EgovMap> selectViewHistory(Map<String, Object> params);

	int insertQuotaMaster(Map<String, Object> params);

	int getCurrVal();

    int insertQuotaDetails(Map<String, Object> params);

	void updateQuotaMaster(Map<String, Object> params);

	void updateCurrentOrgCode(Map<String, Object> params);

	List <EgovMap> selectQuota(Map<String, Object> params);

	List <EgovMap> selectQuotaDetails(Map<String, Object> params);

	int confirmForfeit(Map<String, Object> params) ;

	int updateRemark(Map<String, Object> params) ;

	EgovMap chkUpload(Map<String, Object> params);

	EgovMap chkPastMonth(Map<String, Object> params);

	EgovMap chkQuota(Map<String, Object> params);

	List <EgovMap> selectMonthList(Map<String, Object> params);

	List <EgovMap> selectYearList(Map<String, Object> params);

	List <EgovMap> selectViewQuotaDetails(Map<String, Object> params);

	List <EgovMap> selectOrganizationLevel(Map<String, Object> params);

	int confirmTransfer(Map<String, Object> params) ;

	EgovMap currentUser(Map<String, Object> params);

	int getSeqSAL0343D();

	EgovMap chkSmsResult(Map<String, Object> params);

	EgovMap checkNewCustomerResult(Map<String, Object> params);

	EgovMap chkAvailableQuota(Map<String, Object> params);

	ReturnMessage sendWhatsApp(Map<String, Object> params);

}