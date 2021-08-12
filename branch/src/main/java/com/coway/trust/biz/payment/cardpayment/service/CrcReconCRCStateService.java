package com.coway.trust.biz.payment.cardpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CrcReconCRCStateService
{

	
	/**
	 * selectCrcStatementMappingList
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectCrcStatementMappingList(Map<String, Object> params);
    
    
    /**
	 * selectCrcKeyInList
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectCrcKeyInList(Map<String, Object> params);
    
    /**
	 * selectCrcKeyInList
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectCrcStateList(Map<String, Object> params);
    
    /**
	 * updCrcReconState
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    boolean updCrcReconState(int userId, List<Object> paramList);
    
    /**
	 * updCrcReconState
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    void updIncomeCrcStatement(Map<String, Object> params);
    
}
