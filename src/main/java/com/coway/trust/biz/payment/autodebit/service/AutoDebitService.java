package com.coway.trust.biz.payment.autodebit.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.payment.autodebit.AutoDebitApiDto;
import com.coway.trust.api.mobile.sales.customerApi.CustomerApiForm;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AutoDebitService {
	public List<EgovMap> orderNumberSearchMobile(Map<String, Object> params);

	public List<EgovMap> autoDebitHistoryMobileList(Map<String, Object> params);

	List<EgovMap> selectAutoDebitEnrollmentList(Map<String, Object> params);

	List<EgovMap> selectAutoDebitDetailInfo(Map<String, Object> params);

	List<EgovMap> selectCustomerCreditCardInfo(Map<String, Object> params);

	List<Map<String, Object>> selectAttachmentInfo(Map<String, Object> params);

	List<EgovMap> selectRejectReasonCode(Map<String, Object> params);

	void updateMobileAutoDebitAttachment(List<FileVO> list, FileType type, Map<String, Object> params,
			List<String> seqs);

	int updateAction(Map<String, Object> params);

	Map<String, Object> autoDebitMobileSubmissionSave(Map<String, Object> params);

	void sendSms(Map<String, Object> params);

	void sendEmail(Map<String, Object> params);

	int insertAttachmentMobileUpload(List<FileVO> list, Map<String, Object> param);

	EgovMap orderNumberSearchMobileCheckActivePadNo(Map<String, Object> params);

	EgovMap getProductDescription(Map<String, Object> params);

	Map<String, Object> getAutoDebitSignImg(Map<String, Object> params);

	List<EgovMap> selectCustomerList(CustomerApiForm param) throws Exception;

	int updateFailReason(Map<String, ArrayList<Object>> params, SessionVO sessionVO);
}
