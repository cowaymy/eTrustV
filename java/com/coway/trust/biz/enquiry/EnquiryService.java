package com.coway.trust.biz.enquiry;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.CustomerLoginVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface EnquiryService {

	EgovMap getCustomerLoginInfo(Map<String, Object> params);

	void updateLoginSession(Map<String, Object> params);

	void insertErrorLog(Map<String, Object> params);

	int checkDuplicatedLoginSession(Map<String, Object> params);

	CustomerLoginVO getCustomerInfo(Map<String, Object> params);

	List<EgovMap> selectCustomerInfoList(Map<String, Object> params);

	List<EgovMap> selectMagicAddressComboList(Map<String, Object> params) throws Exception;

	EgovMap getAreaId(Map<String, Object> params) throws Exception;

	List<EgovMap> searchMagicAddressPop(Map<String, Object> params);

	int insertNewInstallationAddress(Map<String, Object> params);

	void sendSms(Map<String, Object> smsList);

	int getTacNo(Map<String, Object> params, SessionVO sessionVO);

	EgovMap getCurrentPhoneNo(Map<String, Object> params);

	EgovMap checkExistRequest(Map<String, Object> params);

	EgovMap verifyTacNo(Map<String, Object> params);

	void disabledPreviousRequest(Map<String, Object> params);

	EgovMap getEmailDetails(Map<String, Object> params);

	EgovMap getSubmissionTimes(Map<String, Object> params);

}
