package com.coway.trust.biz.eAccounting.creditCard;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CreditCardService {
	
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
	
	void insertReimbursement(Map<String, Object> params);
	
	List<EgovMap> selectReimbursementItems(String clmNo);
	
	EgovMap selectReimburesementInfo(Map<String, Object> params);
	
	EgovMap selectReimburesementInfoForAppv(Map<String, Object> params);
	
	List<EgovMap> selectAttachList(String atchFileGrpId);
	
	void updateReimbursement(Map<String, Object> params);
	
	void insertApproveManagement(Map<String, Object> params);
	
	void deleteReimbursement(Map<String, Object> params);
	
	void updateReimbursementTotAmt(Map<String, Object> params);
	
	List<EgovMap> selectCreditCardNoToMgmt();
	
	List<EgovMap> selectReimbursementItemGrp(Map<String, Object> params);
	
	List<EgovMap> selectReimbursementItemGrpForAppv(Map<String, Object> params);

}
