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
    List<Map<String, Object>> selectAttachmentInfo(Map<String, Object> params);
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
	EgovMap getEmailDescription(Map<String, Object> params);
	EgovMap getPadDetail(Map<String, Object> params);
	EgovMap getCreditDebitCardDetail(Map<String, Object> params);
	EgovMap getCurrentPaymentChannelDetail(Map<String, Object> params);
	int updatePaymentChannel(Map<String, Object> params);
	EgovMap orderNumberSearchMobileCheckActivePadNo(Map<String, Object> params);
	EgovMap getUserOrganization(Map<String, Object> params);
	int getUserID(String param);
	EgovMap getProductDescription(Map<String, Object> params);
	Map<String, Object> getAutoDebitSignImg(Map<String, Object> params);
	List<EgovMap> selectCustomerList(Map<String, Object> params);
	int updateFailReason(Map<String, Object> params);
}
