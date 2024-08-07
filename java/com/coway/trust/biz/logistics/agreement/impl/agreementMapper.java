package com.coway.trust.biz.logistics.agreement.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("agreementMapper")
public interface agreementMapper {

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

    int insertUploadNamelist(Map<String, Object> params);

    int selectNextAplctnIdSeq();

    int insertNewAgreementPop(Map<String, Object> params);

    int updateMemberAgreementAplictnId(Map<String, Object> params);

    int selectCurrentUserRole(Map<String, Object> params);

    int isMemberExist(Map<String, Object> params);
}
