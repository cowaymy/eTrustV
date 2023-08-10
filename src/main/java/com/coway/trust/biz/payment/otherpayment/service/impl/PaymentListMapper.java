package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("paymentListMapper")
public interface PaymentListMapper {


	/**
	 * Payment List 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	List<EgovMap> selectGroupPaymentList(Map<String, Object> params);

	/**
	 * Payment List 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	List<EgovMap> selectPaymentListByGroupSeq(Map<String, Object> params);

	/**
	 * Payment List 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	List<EgovMap> selectRequestDCFByGroupSeq(Map<String, Object> params);

	/**
	 * Payment List - Request DCF 정보 조회
	 * @param params
	 * @param model
	 * @return
	 */
    EgovMap selectReqDcfInfo(Map<String, Object> params);

    int invalidReverse(Map<String, Object> params);

    int invalidDCF(Map<String, Object> params);

	/**
	 * Payment List - Request DCF
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	void requestDCF(Map<String, Object> params);

	/**
	 * Payment List - Group Payment Rev Status 변경
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	void updateGroupPaymentRevStatus(Map<String, Object> params);

	/**
	 * Payment List - Group Payment Rev Status 변경
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	void rejectGroupPaymentRevStatus(Map<String, Object> params);

	/**
	 * Payment List - Request DCF 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
	List<EgovMap> selectRequestDCFList(Map<String, Object> params);

	/**
	 * Payment List - Approval / Reject DCF
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	void updateStatusDCF(Map<String, Object> params);

	int dcfDuplicates(Map<String, Object> params);

	/**
	 * Payment List - Approval DCF 처리
	 * @param params
	 * @param model
	 * @return
	 */
	Map<String, Object> approvalDCF(Map<String, Object> params);

	/**
	 * Payment List 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	List<EgovMap> selectFTOldData(Map<String, Object> params);

	int invalidFT(Map<String, Object> params);

	/**
	 * Payment List - Request FT
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	void requestFT(Map<String, Object> params);

	/**
	 * Payment List - Request FT 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
	List<EgovMap> selectRequestFTList(Map<String, Object> params);

	/**
	 * Payment List - Request FT 상세정보 조회
	 * @param params
	 * @param model
	 * @return
	 */
    EgovMap selectReqFTInfo(Map<String, Object> params);

    /**
	 * Payment List - Approval / Reject FT
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	void updateStatusFT(Map<String, Object> params);


	/**
	 * Payment List - Group Payment FT Status 변경
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	void updateGroupPaymentFTStatus(Map<String, Object> params);

	int ftDuplicates(Map<String, Object> params);

	/**
	 * Payment List - Approval FT 처리
	 * @param params
	 * @param model
	 * @return
	 */
	void approvalFT(Map<String, Object> params);


	/* CELESTE 20230306 [S] */
	List<EgovMap> selectRefundOldData(Map<String, Object> params);
	int invalidRefund(Map<String, Object> params);
	List<EgovMap> selectInvalidORType(Map<String, Object> params);
	int refundChecking(Map<String, Object> params);
	int getNextSeq();
	int invalidStatus(Map<String, Object> params);
	void requestRefundM(Map<String, Object> params);
	void requestRefundDOld(Map<String, Object> params);
	void requestRefundDNew(Map<String, Object> params);
	int insertFileGroup(Map<String, Object> params);
	int insertFileDetail(Map<String, Object> params);
	void insertApproveMaster(Map<String, Object> params);
	void insertApproveDetail(Map<String, Object> params);
	String getNextApprSeq();
	EgovMap getNtfUser(Map<String, Object> params);
	void insertNotification(Map<String, Object> params);
	List<EgovMap> selectRequestRefundList(Map<String, Object> params);
	List<EgovMap> selectRequestRefundByGroupSeq(Map<String, Object> params);
	EgovMap selectRequestRefundAppvDetails(Map<String, Object> params);
	EgovMap selectReqRefundInfo(Map<String, Object> params);
	List<EgovMap> selectReqRefundApprovalItem(Map<String, Object> params);
	int refundDuplicates(Map<String, Object> params);
	Map<String, Object> approvalRefund(Map<String, Object> params);
	int selectAppvLineCnt(String appvPrcssNo);
	int selectAppvLinePrcssCnt(String appvPrcssNo);
	void updateStatusRefundM(Map<String, Object> params);
	void updateStatusRefundD(Map<String, Object> params);
	void updateLastAppvLine(Map<String, Object> params);
	String selectRefundReqId(String appvPrcssNo);
	String getSalesOrdId(String salesOrdNo);
	List<EgovMap> selectAttachList(String atchFileGrpId);
	EgovMap selectAttachmentInfo(Map<String, Object> params);
	EgovMap selectAllowFlg (Map<String, Object> params);
	/* CELESTE 20230306 [E] */

	/* BOI DCF*/
	EgovMap selectReqDcfNewInfo(Map<String, Object> params);
    List<EgovMap> selectReqDcfNewAppv(Map<String, Object> params);
    List<EgovMap> selectRequestNewDCFByGroupSeq(Map<String, Object> params);
	EgovMap selectDcfInfo(Map<String, Object> params);
	int selectDcfCount(Map<String, Object> params);
	int getDcfMaxCount();
	void updateStatusNewDCF(Map<String, Object> params);
	void updateStatusNewDCFDet(Map<String, Object> params);
	EgovMap selectDcfAppvInfo(Map<String, Object> params);
	int dcfDuplicates2(Map<String, Object> params);
	Map<String, Object> approvalNewDCF(Map<String, Object> params);
	void updateFinalDcfStus(Map<String, Object> params);
	void requestDcfInfo(Map<String, Object> params);
	void insertOldDcf(Map<String, Object> params);
	void insertNewDcf(Map<String, Object> params);
	void insertDcfApprMas(EgovMap params);
	void insertDcfApprDet(Map<String, Object> params);
//	int getNextNotiSeq();
	void insertDcfNoti(Map<String, Object> params);
	EgovMap getPayInfo(Map<String, Object> params);
	List<EgovMap> getNewDcfInfo(Map<String, Object> params);
	void insertTmpPaymentInfo(Map<String, Object>params);
	int insertTmpNormalPaymentInfo(Map<String, Object>params);
	void insertTmpPaymentNoTrxIdInfo(Map<String, Object> params);
	void insertTmpPaymentOnlineInfo(Map<String, Object> params);
	void insertTmpBillingInfo(Map<String, Object> params);
	int processPayment(Map<String, Object> params);
	void processNormalPayment(Map<String, Object> params);
	List<EgovMap> selectProcessPaymentResult(Map<String, Object> params);
    EgovMap checkBankStateMapStus(Map<String, Object> params);
    void updateDcfBatchStatus(Map<String, Object> params);
    /* [END] BOI DCF*/
    List<EgovMap> selectRefundCodeList(Map<String, Object> params);
    List<EgovMap> selectBankListCode();
    void insertErrorRem(Map<String, String> error);
}
