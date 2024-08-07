package com.coway.trust.biz.payment.cardpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("crcReconCRCStateMapper")
public interface CrcReconCRCStateMapper {

	
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
	 * selectCrcStateList
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	List<EgovMap> selectCrcStateList(Map<String, Object> params);
	
	/**
	 * Crc KeyIn 테이블 매핑처리
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	void updCrcStatement(Map<String, Object> params);
	
	/**
	 * Crc Statement 테이블 매핑처리
	 * @param params
	 * @return
	 */
	void updCrcKeyIn(Map<String, Object> params);
	
	/**
	 * insertCrcStatementITF
	 * @param params
	 * @return
	 */
	void insertCrcStatementITF(Map<String, Object> params);
	
	/**
	 * selectCrcKeyInOrNoList
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	List<EgovMap> selectCrcKeyInOrNoList(Map<String, Object> params);
	
	/**
	 * insertCrcStatementITF
	 * @param params
	 * @return
	 */
	void updIncomeCrcStatementIF(Map<String, Object> params);
	
}
