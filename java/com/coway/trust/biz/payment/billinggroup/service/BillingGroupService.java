package com.coway.trust.biz.payment.billinggroup.service;

import java.util.List;
import java.util.Map;
import com.coway.trust.cmmn.model.SessionVO;
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
	 * saveAddNewGroup
	 * @param params
	 * @return
	 */
    String saveAddNewGroup(Map<String, Object> params, SessionVO sessionVO);
    
    
    /**
	 * saveNewAddr
	 * @param params
	 * @return
	 */
    boolean saveNewAddr(Map<String, Object> params, SessionVO sessionVO);
    
    
    /**
	 * saveNewContPerson
	 * @param params
	 * @return
	 */
    boolean saveNewContPerson(Map<String, Object> params, SessionVO sessionVO);
    
    
    /**
	 * saveNewReq
	 * @param params
	 * @return
	 */
    boolean saveNewReq(Map<String, Object> params, SessionVO sessionVO);
    
    
    /**
	 * saveRemark
	 * @param params
	 * @return
	 */
    boolean saveRemark(Map<String, Object> params, SessionVO sessionVO);
    
    
    /**
	 * saveChangeBillType
	 * @param params
	 * @return
	 */
    boolean saveChangeBillType(Map<String, Object> params, SessionVO sessionVO);
    
    /**
	 * saveApprRequest
	 * @param params
	 * @return
	 */
    boolean saveApprRequest(Map<String, Object> params, SessionVO sessionVO);
    
    
    /**
	 * saveCancelRequest
	 * @param params
	 * @return
	 */
    boolean saveCancelRequest(Map<String, Object> params, SessionVO sessionVO);
    
    
    /**
	 * saveRemoveOrder
	 * @param params
	 * @return
	 */
    boolean saveRemoveOrder(Map<String, Object> params, SessionVO sessionVO);
    
    
    /**
	 * saveChgMainOrd
	 * @param params
	 * @return
	 */
    boolean saveChgMainOrd(Map<String, Object> params, SessionVO sessionVO);
    
    
    /**
	 * saveAddOrder
	 * @param params
	 * @return
	 */
    String saveAddOrder(Map<String, Object> params, SessionVO sessionVO);
    
    /**
	 * updEStatementConfirm
	 * @param params
	 * @return
	 */
    boolean updEStatementConfirm(EgovMap requestMaster, Map<String, Object> history);
    
}
