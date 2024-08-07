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

	List<EgovMap> chkStockList2(Map<String, Object> params);

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

	void updateLOG0106MDetail(EgovMap params);

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

	 Map<String, Object> posBookingCallSP_LOGISTIC_POS(Map<String, Object> param);

	 Map<String, Object> posGICallSP_LOGISTIC_POS(Map<String, Object> params);


	/***** payment ****/

	void insertPayTrx(Map<String, Object> params);

	int getSeqPay0064D();

	void insertPayMaster(Map<String, Object> params);

	int getSeqPay0065D();

	void insertPayDetail(Map<String, Object> params);

	List<EgovMap> getpayBranchList (Map<String, Object> params);

	List<EgovMap> getDebtorAccList(Map<String, Object> params);

	List<EgovMap> getBankAccountList(Map<String, Object> parmas);

	EgovMap selectAccountIdByBranchId(Map<String, Object> params);

	void insertAccGlRoute(Map<String, Object> params);

	int getSeqPay0009D();

	List<EgovMap> isPaymentKnowOffByPOSNo(Map<String, Object> params);

	EgovMap posReversalPayDetail(Map<String, Object> params);

	EgovMap getPayInfoByPayId(Map<String, Object> params);

	void insertRePayMaster(Map<String, Object> params);

	EgovMap getTrxInfo(Map<String, Object> params);

	void insertRePayTrx(Map<String, Object> params);

	void updatePayMTrxId(Map<String, Object> params);

	List<EgovMap> getPayDetailListByPayId(Map<String, Object> params);

	void insertRePayDetail(Map<String, Object> params);

	EgovMap getAccGLRoutesInfoByRcpItmId(Map<String, Object> params);

	void insertReAccGlRoute(Map<String, Object> params);

	List<EgovMap> getPayDetailList(Map<String, Object> params);

	void insertTransactionLog(Map<String, Object> params);

	List<EgovMap> getDetailInfoList(Map<String, Object> params);

	EgovMap getPosNobyPosId(PosDetailVO pdvo);

	List<EgovMap> getPosItmIdListByPosIdAndMemId(PosMemberVO pmvo);

	EgovMap getPosNobyPosIdForMember(PosMemberVO pmvo);

	List<EgovMap> getPosItmIdListByPosNo(Map<String, Object> params);

	EgovMap chkMemIdByMemCode(Map<String, Object> params);

	EgovMap chkUserIdByUserName(Map<String, Object> params);

	List<EgovMap> chkOldReqSerial(Map<String, Object> params);

	void insertPayT(Map<String, Object> params);

	int getSeqPay0240T();

	List<EgovMap> getPosBillingDetailList(Map<String, Object> params);

	List<EgovMap> selectPosFlexiJsonList(Map<String, Object> params);

	List<EgovMap> selectPosFlexiItmList(Map<String, Object> params);

	List<EgovMap> chkFlexiStockList(Map<String, Object> params);

	EgovMap posFlexiDetail(Map<String, Object> params);

	void updatePosFlexiStatus(Map<String, Object> params);

	List<EgovMap> selectWhSOBrnchList(Map<String, Object> params);

	List<EgovMap> selectPOSFlexiItem(Map<String, Object> params);

	int  updatePOSFlexiItemActive(Map<String, Object> params);

	int  updatePOSFlexiItemInactive(Map<String, Object> params);

	// KR-OHK Serial Check add
	List<EgovMap> getFilterSerialNumLOG0100(Map<String, Object> params);

	// KR-OHK Serial Check add
	Map<String, Object> SP_LOGISTIC_POS_SERIAL(Map<String, Object> params);

	// KR-OHK Serial Check add
	Map<String, Object> SP_SALES_BARCODE_SAVE(Map<String, Object> params);

	List<EgovMap> selectLoyaltyRewardPointList (Map<String, Object> params);

	List<EgovMap> selectLoyaltyRewardPointDetails (Map<String, Object> params);

	EgovMap selectLoyaltyRewardPointByMemCode (Map<String, Object> params);

	int insertUploadedLoyaltyRewardMaster(Map<String, Object> params);

	void insertLoyaltyRewardPointItmBulk(Map<String, Object> params);

	int getSeqSAL0286M();

	int getSeqSAL0287D();

	void updateLoyaltyRewardPoint(Map<String, Object> params);

	void SP_POS_LRP_CONFIRM(Map<String, Object> params);

}
