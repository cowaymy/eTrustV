package com.coway.trust.biz.logistics.agreement;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface agreementService {

    EgovMap getMemberInfo(Map<String, Object> params);

    EgovMap getMemHPpayment(Map<String, Object> params);

    List<EgovMap> memberList(Map<String, Object> params);

    List<EgovMap> getMemStatus(Map<String, Object> params);

    List<EgovMap> getMemLevel(Map<String, Object> params);

    List<EgovMap> getAgreementVersion(Map<String, Object> params);

}
