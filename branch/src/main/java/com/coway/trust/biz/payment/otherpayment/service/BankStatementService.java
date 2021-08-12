package com.coway.trust.biz.payment.otherpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BankStatementService
{

	
	/**
	 * Bank Statement Master List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectBankStatementMasterList(Map<String, Object> params);
    
    /**
	 * Bank Statement Detail List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectBankStatementDetailList(Map<String, Object> params);
    
    /**
	 * Bank Statement Upload
	 * @param params
	 * @return
	 */
    Map<String, Object> uploadBankStatement(Map<String, Object> masterParamMap, List<Object> detailParamList);
    
    
    /**
	 * Bank Statement Delete
	 * @param params
	 * @return
	 */
    boolean deleteBankStatement(List<Object> paramList);
    
    /**
	 * Bank Statement Update Detail
	 * @param params
	 * @return
	 */
    boolean updateBankStateDetail(List<Object> paramList);
    
    /**
	 * Bank Statement Download List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectBankStatementDownloadList(Map<String, Object> params);
    
}
