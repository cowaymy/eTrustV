package com.coway.trust.biz.payment.cardpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("crcReconBankStateMapper")
public interface CrcReconBankStateMapper {

	
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
	 * crc 업데이트
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	void updateCrc(Map<String, Object> params);
	
	/**
	 * bank 업데이트
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	void updateBank(Map<String, Object> params);
	
	/**
	 * CRC Detail 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	List<EgovMap> selectCrcIdList(Map<String, Object> params);
	
	/**
	 * 인터페이스 테이블에 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	void insertInterfaceTb(Map<String, Object> params);
	
	
	void insertCardPaymentMatchIF(Map<String, Object> params);
	

}
