package com.coway.trust.biz.misc.voucher;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface VoucherService {

	ReturnMessage createVoucherCampaign(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> getVoucherCampaignList(Map<String, Object> params);

	EgovMap getVoucherCampaignDetail(Map<String, Object> params);

	ReturnMessage editVoucherCampaign(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> getVoucherList(Map<String, Object> params);

	List<EgovMap> selectPromotionList(Map<String, Object> params);

	List<EgovMap> getVoucherCampaignPromotionDetail(Map<String, Object> params);

	List<EgovMap> selectExistPromotionList(Map<String, Object> params);

	ReturnMessage deleteVoucherPromotionPackage(Map<String, Object> params, SessionVO sessionVO);

	ReturnMessage generateVoucher(Map<String, Object> params, SessionVO sessionVO);

	ReturnMessage deactivateVoucher(Map<String, Object> params, SessionVO sessionVO);

	ReturnMessage activateVoucher(Map<String, Object> params, SessionVO sessionVO);

	ReturnMessage voucherCustomerDataUpload(List<Map<String, Object>> params, int campaignId, SessionVO sessionVO);

	ReturnMessage isVoucherValidToApply(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> getVoucherUsagePromotionId(Map<String, Object> params);

	boolean updateVoucherUseStatus(String voucherCode, int isUsed);

	EgovMap getVoucherInfo(Map<String, Object> params);

	void sendEmail(Map<String, Object> params) throws JsonParseException, JsonMappingException, IOException;

	List<EgovMap> getVoucherListForExcel(Map<String, Object> params);

	ReturnMessage editVoucherCampaignStatus(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> getPendingEmailSendInfo();

	ReturnMessage isVoucherValidToApplyIneKeyIn(Map<String, Object> params, SessionVO sessionVO);

	ReturnMessage editVoucherCampaignDate(Map<String, Object> params, SessionVO sessionVO);
}
