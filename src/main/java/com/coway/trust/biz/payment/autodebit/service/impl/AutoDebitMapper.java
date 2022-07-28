package com.coway.trust.biz.payment.autodebit.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("autoDebitMapper")
public interface AutoDebitMapper {
    List<EgovMap> orderNumberSearchMobile(Map<String, Object> params);
    List<EgovMap> autoDebitHistoryMobileList(Map<String, Object> params);
    List<EgovMap> selectAutoDebitEnrollmentList(Map<String, Object> params);
    List<EgovMap> selectCustomerCreditCardInfo(Map<String, Object> params);
    List<EgovMap> selectAutoDebitDetailInfo(Map<String, Object> params);
    List<EgovMap> selectAttachmentInfo(Map<String, Object> params);
    List<EgovMap> selectRejectReasonCode(Map<String, Object> params);
    int selectNextFileId();
    int selectNextFileGroupId();
    int selectNextPadId();
    int insertFileGroup(Map<String, Object> params);
	int insertFileDetail(Map<String, Object> params);
	int updateAction(Map<String, Object> params);
	EgovMap selectCreatorInfo(String memCode);
	int insertAutoDebitMobileSubmmisionData(Map<String, Object> params);
	String getSmsTemplate(Map<String, Object> params);
	EgovMap selectCustCardBankInformation(Map<String, Object> params);
	String getEmailTitle(Map<String, Object> params);
	EgovMap getEmailDescription(Map<String, Object> params);;
}
