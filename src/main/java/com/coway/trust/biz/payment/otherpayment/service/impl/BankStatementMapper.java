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
	
	/**
	 * Bank Statement 마스터 삭제
	 * @param params
	 * @return
	 */
	int deleteBankStateMaster(Map<String, Object> params);
	
	/**
	 * Bank Statement 디테일 삭제
	 * @param params
	 * @return
	 */
	int deleteBankStateDetail(Map<String, Object> params);
	
	/**
	 * Bank Statement 디테일 업데이트
	 * @param params
	 * @return
	 */
	int updateBankStateDetail(Map<String, Object> params);
	
	/**
	 * Bank Statement Download List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectBankStatementDownloadList(Map<String, Object> params);
	
}
