package com.coway.trust.biz.eAccounting.creditCard.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("creditCardMapper")
public interface CreditCardMapper {

	List<EgovMap> selectCrditCardMgmtList(Map<String, Object> params);

	List<EgovMap> selectBankCode();

	int selectNextCrditCardSeq();

	void insertCreditCard(Map<String, Object> params);

	String selectNextIfKey();

	int selectNextSeq(String ifKey);

	void insertCrditCardInterface(Map<String, Object> params);

	EgovMap selectCrditCardInfo(Map<String, Object> params);

	void updateCreditCard(Map<String, Object> params);

	void removeCreditCard(Map<String, Object> params);

	List<EgovMap> selectReimbursementList(Map<String, Object> params);

	List<EgovMap> selectTaxCodeCreditCardFlag();

	EgovMap selectCrditCardInfoByNo(Map<String, Object> params);

	String selectNextClmNo();

	void insertReimbursement(Map<String, Object> params);

	int selectNextClmSeq(String clmNo);

	void insertReimbursementItem(Map<String, Object> params);

	List<EgovMap> selectReimbursementItems(Map<String, Object> params);

	EgovMap selectReimburesementInfo(Map<String, Object> params);

	EgovMap selectReimburesementInfoForAppv(Map<String, Object> params);

	List<EgovMap> selectAttachList(String atchFileGrpId);

	void updateReimbursement(Map<String, Object> params);

	void updateReimbursementItem(Map<String, Object> params);

	void insertApproveItems(Map<String, Object> params);

	void updateAppvPrcssNo(Map<String, Object> params);

	void deleteReimbursement(Map<String, Object> params);

	void updateReimbursementTotAmt(Map<String, Object> params);

	List<EgovMap> selectCreditCardNoToMgmt();

	List<EgovMap> selectReimbursementItemGrp(Map<String, Object> params);

	List<EgovMap> selectReimbursementItemGrpForAppv(Map<String, Object> params);

	void insertRejectM(Map<String, Object> params);

	void insertRejectD(Map<String, Object> params);

	List<EgovMap> getOldDisClamUn(Map<String, Object> params);

	void updateExistingClamUn(Map<String, Object> params);

	List<EgovMap> selectAvailableAllowanceAmt(Map<String, Object> params);

	List<EgovMap> selectTotalSpentAmt(Map<String, Object> params);

	List<EgovMap> selectExcelList(Map<String, Object> params);

	List<EgovMap> selectTotalCntrlSpentAmt(Map<String, Object> params);

	EgovMap selectCurrentActiveMasterAllowanceLimit(Map<String, Object> params);

	List<EgovMap> selectCostCenterList();

	List<EgovMap> selectCreditCardholderDetailList();

	List<EgovMap> selectAllowanceCardPicList();

	List<EgovMap> selectExcelListNew(Map<String, Object> params);

	EgovMap selectUserInfo(Map<String, Object> params);

	void insertCCApprovalLine(Map<String, Object> params);

	List<EgovMap> selectCCApprovalLineList(Map<String, Object> params);

	void deleteCCApprovalLine(Map<String, Object> params);
}
