package com.coway.trust.biz.payment.autodebit.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AutoDebitService {
	public List<EgovMap> orderNumberSearchMobile(Map<String, Object> params);

	public List<EgovMap> autoDebitHistoryMobileList(Map<String, Object> params);

	List<EgovMap> selectAutoDebitEnrollmentList(Map<String, Object> params);

	List<EgovMap> selectAutoDebitDetailInfo(Map<String, Object> params);

	List<EgovMap> selectCustomerCreditCardInfo(Map<String, Object> params);

	List<EgovMap> selectAttachmentInfo(Map<String, Object> params);

	List<EgovMap> selectRejectReasonCode(Map<String, Object> params);

	void updateMobileAutoDebitAttachment(List<FileVO> list, FileType type, Map<String, Object> params,
			List<String> seqs);

	int updateAction(Map<String, Object> params);

	int autoDebitMobileSubmissionSave(Map<String, Object> params);

	void sendSms(Map<String, Object> params);

	void sendEmail(Map<String, Object> params);

	int insertAttachmentMobileUpload(List<FileVO> list, Map<String, Object> param);
}
