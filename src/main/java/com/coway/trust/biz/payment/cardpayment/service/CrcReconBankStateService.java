package com.coway.trust.biz.payment.cardpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CrcReconBankStateService
{

	
	/**
	 * Mapped List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectMappingList(Map<String, Object> params);
    
    /**
	 * UnMapped(Crc) List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	List<EgovMap> selectUnMappedCrc(Map<String, Object> params);
	
	/**
	 * UnMapped(Bank) List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	List<EgovMap> selectUnMappedBank(Map<String, Object> params);
	
	/**
	 * MappingList 저장 및 업데이트
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	int updateMappingData(List<Object> gridList, int userId);

}
