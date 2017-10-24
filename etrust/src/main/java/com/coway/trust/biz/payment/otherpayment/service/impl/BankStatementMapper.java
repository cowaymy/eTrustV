package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("bankStatementMapper")
public interface BankStatementMapper {

	
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
	 * Bank Statement Master 등록
	 * @param params
	 * @return
	 */
	void insertBankStatementMaster(Map<String, Object> params);
	
	/**
	 * Bank Statement Detail 등록
	 * @param params
	 * @return
	 */
	void insertBankStatementDetail(Map<String, Object> params);
	
	/**
	 * Bank Statement Interface 데이터 등록
	 * @param params
	 * @return
	 */
	void insertBankStatementITF(Map<String, Object> params);
	
	
	
}
