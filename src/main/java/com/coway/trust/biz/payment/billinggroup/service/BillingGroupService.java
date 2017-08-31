package com.coway.trust.biz.payment.billinggroup.service;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.util.EgovMap;
public interface BillingGroupService{

	
	/**
	 * selectCustBillId 조회
	 * @param params
	 * @return
	 */
    String selectCustBillId(Map<String, Object> params);
    
    /**
	 * selectBasicInfo 조회
	 * @param params
	 * @return
	 */
    EgovMap selectBasicInfo(Map<String, Object> params);
    
    /**
	 * selectMaillingInfo 조회
	 * @param params
	 * @return
	 */
    EgovMap selectMaillingInfo(Map<String, Object> params);
    
    /**
	 * selectContractInfo 조회
	 * @param params
	 * @return
	 */
    EgovMap selectContractInfo(Map<String, Object> params);
    
    /**
	 * selectOrderGroupList 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectOrderGroupList(Map<String, Object> params);
    
    /**
	 * selectEstmReqHistory 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectEstmReqHistory(Map<String, Object> params);
    
    /**
	 * selectEstmReqHistory 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectBillGrpHistory(Map<String, Object> params);
    
    /**
	 * selectBillGrpOrder 조회
	 * @param params
	 * @return
	 */
    EgovMap selectBillGrpOrder(Map<String, Object> params);
    
    /**
	 * selectBillGroupOrderView 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectBillGroupOrderView(Map<String, Object> params);
    
    /**
	 * updCustMaster 업데이트
	 * @param params
	 * @return
	 */
    void updCustMaster(Map<String, Object> params);
    
    
    /**
	 * updSalesOrderMaster 업데이트
	 * @param params
	 * @return
	 */
    void updSalesOrderMaster(Map<String, Object> params);
    
    /**
	 * insRemarkHis
	 * @param params
	 * @return
	 */
    int insHistory(Map<String, Object> params);
    
    /**
	 * selectDetailHistoryView 조회
	 * @param params
	 * @return
	 */
    EgovMap selectDetailHistoryView(Map<String, Object> params);
    
    /**
	 * selectMailAddrHistorty 조회
	 * @param params
	 * @return
	 */
    EgovMap selectMailAddrHistorty(String param);
    
    /**
	 * selectContPersonHistorty 조회
	 * @param params
	 * @return
	 */
    EgovMap selectContPersonHistorty(String param);
    
    /**
	 * selectCustMailAddrList 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectCustMailAddrList(Map<String, Object> params);
    
    /**
	 * selectAddrKeywordList 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectAddrKeywordList(Map<String, Object> params);
    
    /**
	 * selectSalesOrderM 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectSalesOrderM(Map<String, Object> params);
    
    /**
	 * selectContPersonList 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectContPersonList(Map<String, Object> params);
    
    /**
	 * selectContPerKeywordList 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectContPerKeywordList(Map<String, Object> params);
    
    /**
	 * selectMailAddrHistorty 조회
	 * @param params
	 * @return
	 */
    EgovMap selectCustBillMaster(Map<String, Object> params);
    
    /**
	 * selectReqMaster 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectReqMaster(Map<String, Object> params);
    
    /**
	 * updReqEstm
	 * @param params
	 * @return
	 */
    void updReqEstm(Map<String, Object> params);
    
    /**
	 * selectDocNo 조회
	 * @param params
	 * @return
	 */
    EgovMap selectDocNo(Map<String, Object> params);
    
    /**
	 * updDocNo
	 * @param params
	 * @return
	 */
    void updDocNo(Map<String, Object> params);
    
    /**
	 * insEstmReq
	 * @param params
	 * @return
	 */
    void insEstmReq(Map<String, Object> params);
    
    /**
	 * selectEstmReqHisView 조회
	 * @param params
	 * @return
	 */
    EgovMap selectEstmReqHisView(Map<String, Object> params);
    
    /**
	 * selectEStatementReqs 조회
	 * @param params
	 * @return
	 */
    EgovMap selectEStatementReqs(Map<String, Object> params);
    
    /**
   	 * selectBillGrpOrdView 조회
   	 * @param params
   	 * @return
   	 */
    EgovMap selectBillGrpOrdView(Map<String, Object> params);
    
    /**
   	 * selectSalesOrderMs 조회
   	 * @param params
   	 * @return
   	 */
    EgovMap selectSalesOrderMs(Map<String, Object> params);
    
    /**
   	 * selectSalesOrderMs 조회
   	 * @param params
   	 * @return
   	 */
    EgovMap selectReplaceOrder(Map<String, Object> params);
    
    /**
	 * selectAddOrdList 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectAddOrdList(Map<String, Object> params);
    
    /**
   	 * selectMainOrderHistory 조회
   	 * @param params
   	 * @return
   	 */
    EgovMap selectMainOrderHistory(Map<String, Object> params);
    
    /**
	 * insBillGrpMaster
	 * @param params
	 * @return
	 */
    void insBillGrpMaster(Map<String, Object> params);
    
    /**
   	 * selectGetOrder 조회
   	 * @param params
   	 * @return
   	 */
    EgovMap selectGetOrder(Map<String, Object> params);
    
    /**
	 * getSAL0024DSEQ
	 * @param params
	 * @return
	 */
    int getSAL0024DSEQ();
    
    /**
	 * docNoCreateSeq
	 * @param params
	 * @return
	 */
    String docNoCreateSeq();
}
