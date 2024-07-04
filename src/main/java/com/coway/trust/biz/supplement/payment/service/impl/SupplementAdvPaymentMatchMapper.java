package com.coway.trust.biz.supplement.payment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("supplementAdvPaymentMatchMapper")
public interface SupplementAdvPaymentMatchMapper {

	/**
   	 * Advance Payment Match - Advance KeyIn List
   	 * @param params
   	 * @param model
   	 * @return
   	 *
   	 */
	List<EgovMap> selectAdvKeyInList(Map<String, Object> paramMap);

	/**
   	 * Advance Payment Match - Bank Statement List
   	 * @param params
   	 * @param model
   	 * @return
   	 *
   	 */
	List<EgovMap> selectBankStateMatchList(Map<String, Object> paramMap);

	/**
	 * Advance Payment Matching - Mapping : Group Payment Mapping처리
	 * @param params
	 * @param model
	 * @return
	 */
	void mappingAdvGroupPayment(Map<String, Object> params);

	/**
	 * Advance Payment Matching - Mapping : Bank Statement Mapping
	 * @param params
	 * @param model
	 * @return
	 */
	void mappingBankStatementAdv(Map<String, Object> params);


	/**
   	 * Advance Payment Match - I/F
   	 * @param params
   	 * @param model
   	 * @return
   	 *
   	 */
	List<EgovMap> selectMappedData(Map<String, Object> paramMap);


	/**
	 *
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	void insertAdvPaymentMatchIF(EgovMap params);

	/**
	 * Debtor
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	void insertAdvPaymentDebtorIF(EgovMap params);

	void updateDiffTypeDiffAmt(Map<String, Object> params);

  List<EgovMap> getAccountList(Map<String, Object> params);

  List<EgovMap> selectPaymentListByGroupSeq(Map<String, Object> params);

  List<EgovMap>selectAdvKeyInReport(Map<String, Object> params);

}
