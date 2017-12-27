package com.coway.trust.biz.payment.otherpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PaymentListService
{

	
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
    
    /**
	 * Payment List - Request DCF
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    EgovMap requestDCF(Map<String, Object> params);
    
    /**
	 * Payment List - Request DCF 리스트 조회 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectRequestDCFList(Map<String, Object> params);
    
    /**
	 * Payment List - Reject DCF
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    void rejectDCF(Map<String, Object> params);
    
    /**
	 * Payment List - Approval DCF 처리 
	 * @param params
	 * @param model
	 * @return
	 */
    void approvalDCF(Map<String, Object> params);
    
    /**
	 * Payment List 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectFTOldData(Map<String, Object> params);
    
    /**
	 * Request Fund Transfer
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
    EgovMap requestFT(Map<String, Object> paramMap, List<Object> paramList );
    
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
	 * Payment List - Reject FT
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    void rejectFT(Map<String, Object> params);
    
    /**
	 * Payment List - Approval FT 처리 
	 * @param params
	 * @param model
	 * @return
	 */
    void approvalFT(Map<String, Object> params);
    
    
}
