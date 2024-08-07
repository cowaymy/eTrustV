package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("advPaymentMatchMapper")
public interface AdvPaymentMatchMapper {

	/**
   	 * Advance Payment Match - Advance KeyIn List 조회
   	 * @param params
   	 * @param model
   	 * @return
   	 *
   	 */
	List<EgovMap> selectAdvKeyInList(Map<String, Object> paramMap);

	/**
   	 * Advance Payment Match - Bank Statement List 조회
   	 * @param params
   	 * @param model
   	 * @return
   	 *
   	 */
	List<EgovMap> selectBankStateMatchList(Map<String, Object> paramMap);

	/**
	 * Advance Payment Matching - Mapping 처리 : Group Payment Mapping처리
	 * @param params
	 * @param model
	 * @return
	 */
	void mappingAdvGroupPayment(Map<String, Object> params);

	/**
	 * Advance Payment Matching - Mapping 처리 : Bank Statement Mapping 처리
	 * @param params
	 * @param model
	 * @return
	 */
	void mappingBankStatementAdv(Map<String, Object> params);


	/**
   	 * Advance Payment Match - I/F에 등록할 데이터 조회
   	 * @param params
   	 * @param model
   	 * @return
   	 *
   	 */
	List<EgovMap> selectMappedData(Map<String, Object> paramMap);


	/**
	 * 인터페이스 테이블에 저장
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	void insertAdvPaymentMatchIF(EgovMap params);

	/**
	 * 인터페이스 테이블에 저장 : Debtor
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	void insertAdvPaymentDebtorIF(EgovMap params);

	List<EgovMap> selectJompayMatchList(Map<String, Object> paramMap);

	EgovMap saveJompayPaymentMapping(Map<String, Object> params);

	void updateDiffTypeDiffAmt(Map<String, Object> params);

  List<EgovMap> selectAdvanceMatchList(Map<String, Object> params);

  EgovMap saveAdvancePaymentMapping(Map<String, Object> params);

}
