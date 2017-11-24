package com.coway.trust.biz.sales.pos.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.pos.vo.PosDetailVO;
import com.coway.trust.biz.sales.pos.vo.PosMasterVO;
import com.coway.trust.biz.sales.pos.vo.PosMemberVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("posMapper")
public interface PosMapper {

	List<EgovMap> selectPosModuleCodeList (Map<String, Object> params);
	
	List<EgovMap> selectStatusCodeList(Map<String, Object> params);
	
	List<EgovMap> selectPosJsonList(Map<String, Object> params);
	
	List<EgovMap> selectWhBrnchList();
	
	EgovMap selectWarehouse(Map<String, Object> params);
	
	List<EgovMap> selectPosTypeList(Map<String, Object> params);
	
	//List<EgovMap> selectPIItmTypeList();
	
	//List<EgovMap> selectPIItmList(Map<String, Object> params);
	
	List<EgovMap> selectPosItmList(Map<String, Object> params);
	
	List<EgovMap> chkStockList(Map<String, Object> params);
	
	EgovMap getMemCode(Map<String, Object> params);
	
	List<EgovMap> getReasonCodeList(Map<String, Object> params);
	
	List<EgovMap> getFilterSerialNum(Map<String, Object> params);
	
	String getDocNo(Map<String, Object> params);
	
	EgovMap getItemBankAccCodeByItemTypeID(Map<String, Object> params);
	
	EgovMap getUserFullName(Map<String, Object> params);
	
	/*SEQ*/
	int getSeqSal0057D();
	
	int getSeqSal0058D();
	
	int getSeqPay0007D();
	
	int getSeqPay0016D();
	
	int getSeqPay0031D();
	
	int getSeqPay0032D();
	
	int getSeqLog0014D();
	
	int getSeqPay0069D();
	
	int getSeqSal0147M();
	
	void insertPosMaster(Map<String, Object> params);
	
	void insertPosDetail(Map<String, Object> params);
	
	void insertDeductionPosDetail(Map<String, Object> params);
	
	void insertPosBilling(Map<String, Object> params);
	
	void updatePosMasterPosBillId(Map<String, Object> params);
	
	void insertPosOrderBilling(Map<String, Object> params);
	
	void insertPosTaxInvcMisc(Map<String, Object> params);
	
	void insertPosTaxInvcMiscSub(Map<String, Object> params);
	
	void insertStkRecord(Map<String, Object> params);
	
	void insertSerialNo(Map<String, Object> params);
	
	List<EgovMap> getUploadMemList(Map<String, Object> params);
	
	EgovMap posReversalDetail(Map<String, Object> params);
	
	List<EgovMap> getPosDetailList(Map<String, Object> params);
	
	EgovMap chkReveralBeforeReversal(Map<String, Object> params);
	
	void insertPosReversalMaster (Map<String, Object> params);
	
	List<EgovMap> getOldDetailList(Map<String, Object> params);
	
	void insertPosReversalDetail(EgovMap params);
	
	EgovMap getBillInfo(Map<String, Object> params);
	
	void insertPosReversalBilling(EgovMap params);
	
	EgovMap getTaxInvoiceMisc(Map<String, Object> params);
	
	EgovMap getAccOrderBill(Map<String, Object> params);
	
	void updateAccOrderBillingWithPosReversal(Map<String, Object> params);
	
	int getSeqPay0011D();
	
	void insertInvAdjMemo(Map<String, Object> params);
	
	int getSeqPay0027D();
	
	void insertTaxDebitCreditNote(Map<String, Object> params);
	
	List<EgovMap> getMiscSubList(Map<String, Object> params);
	
	int getSeqPay0012D();
	
	void insertInvAdjMemoSub(Map<String, Object> params);
	
	int getSeqPay0028D();
	
	void insertTaxDebitCreditNoteSub(Map<String, Object> params);
	
	int getSeqPay0017D();
	
	void insertAccOrderVoidInv(Map<String, Object> parmas);
	
	int getSeqPay0018D();
	
	void insertAccOrderVoidInvSub(Map<String, Object> params);
	
	List<EgovMap> selectStkCardRecordList(Map<String, Object> params);
	
	void insertStkCardRecordReversal(EgovMap params);
	
	List<EgovMap> getPurchMemList(Map<String, Object> params);
	
	void updatePosMStatus(PosMasterVO pvo);
	
	void updatePosDStatus(PosMasterVO pvo);
	
	EgovMap selectMemberByMemberIDCode(Map<String, Object> params);
	
	void updatePosDStatusByPosItmId(PosDetailVO pdvo);
	
	void updatePosMemStatus(PosMemberVO pmvo);
	
	/*EgovMap chkPosType(Map<String, Object> params);*/
	
	/**** call procedure ****/
	
	 Map<String, Object> posBookingCallSP_LOGISTIC_REQUEST(Map<String, Object> param);
	
}
