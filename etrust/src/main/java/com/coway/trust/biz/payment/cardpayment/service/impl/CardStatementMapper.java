package com.coway.trust.biz.payment.cardpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("cardStatementMapper")
public interface CardStatementMapper {

	
	/**
	 * Credit Statement Master List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	List<EgovMap> selectCardStatementMasterList(Map<String, Object> params);
	
	/**
	 * Credit Statement Detail List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	List<EgovMap> selectCardStatementDetailList(Map<String, Object> params);
	
	/**
	 * Credit Card Statement RunningNo 가져오기
	 * @return
	 */
	String getCRCStatementRunningNo(Map<String, Object> params);
	
	/**
	 * Credit Card Statement Master 등록
	 * @param params
	 * @return
	 */
	void insertCardStatementMaster(Map<String, Object> params);
	
	/**
	 * Credit Card Statement Detail 등록
	 * @param params
	 * @return
	 */
	void insertCardStatementDetail(Map<String, Object> params);
	
}
