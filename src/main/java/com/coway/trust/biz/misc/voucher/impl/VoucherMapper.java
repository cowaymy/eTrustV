package com.coway.trust.biz.misc.voucher.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("voucherMapper")
public interface VoucherMapper {
	int insertVoucherCampaign(Map<String, Object> params);
	int insertVoucherCampaignDetail(Map<String, Object> params);
	int getVoucherCampaignNextVal();
	List<EgovMap> getVoucherCampaignList(Map<String, Object> params);
	EgovMap getVoucherCampaignDetail(Map<String, Object> params);
	int editVoucherCampaign(Map<String, Object> params);
	List<EgovMap> getVoucherList(Map<String, Object> params);
	List<EgovMap> getVoucherListForExcel(Map<String, Object> params);
	List<EgovMap> selectPromotionList(Map<String, Object> params);
	int insertVoucherPromotionPackage(Map<String, Object> params);
	int isCampaignEditable(Map<String, Object> params);
	List<EgovMap> getVoucherCampaignPromotionDetail(Map<String, Object> params);
	int deleteVoucherPromotionPackage(Map<String, Object> params);
	int isPromotionExist(Map<String, Object> params);
	 Map<String, Object> SP_VOUCHER_GENERATE(Map<String, Object> params);
	 void voucherActivate(Map<String, Object> params);
	 void voucherDeactivate(Map<String, Object> params);
	 int isVoucherValidForDataUpload(Map<String, Object> params);
	 int isCampaignUploadable(Map<String, Object> params);
	 int updateVoucherCustomerInfo(Map<String, Object> params);
	 int isVoucherValidToApply(Map<String, Object> params);
	 List<EgovMap> getVoucherUsagePromotionId(Map<String, Object> params);
	 int updateVoucherCodeUseStatus(Map<String, Object> params);
	 EgovMap getVoucherInfo(Map<String, Object> params);
	 EgovMap getVoucherEmailAdditionalInfo(Map<String, Object> params);
	 List<EgovMap> getPendingEmailSendInfo();
	 int updateBatchEmailSuccess(Map<String, Object> params);
	 int editVoucherCampaignStatus(Map<String, Object> params);
	 int getBatchEmailNextVal();
	 int insertBatchEmailSender(Map<String, Object> params);
	 int isCampaignMasterCodeExist(Map<String, Object> params);
	 int isVoucherValidToApplyIneKeyIn(Map<String, Object> params);
	 int editVoucherCampaignDate(Map<String, Object> params);
}
