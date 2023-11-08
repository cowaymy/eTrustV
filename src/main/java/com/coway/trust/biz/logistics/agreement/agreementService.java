package com.coway.trust.biz.logistics.agreement;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface agreementService {

    EgovMap prevAgreement(Map<String, Object> params);

    EgovMap getMemHPpayment(Map<String, Object> params);

    List<EgovMap> memberList(Map<String, Object> params);

    List<EgovMap> getMemStatus(Map<String, Object> params);

    List<EgovMap> getMemLevel(Map<String, Object> params);

    List<EgovMap> getAgreementVersion(Map<String, Object> params);

    EgovMap getBranchCd(Map<String, Object> params);

    List<EgovMap> branch();

    EgovMap cdEagmt1(Map<String, Object> params);

    int checkConsent(Map<String, Object> params);

    List<EgovMap> consentList(Map<String, Object> params);

	List<EgovMap> selectAgreementHistoryList(Map<String, Object> params);

	ReturnMessage agreementNamelistUpload(List<Map<String, Object>> params, SessionVO sessionVO);
}
