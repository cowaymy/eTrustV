package com.coway.trust.biz.payment.payment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommDeductionService
{
	/**
	 * CommitionDeduction 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCommitionDeduction(Map<String, Object> params);

	/**
	 * Master로그에 존재하는 데이터 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectExistLogMList(Map<String, Object> params);

	/**
	 * Master및 Detail 데이터 저장
	 * @param params
	 * @return
	 */
	int addBulkData(Map<String, Object> master, List<Map<String, Object>> detail);

	/**
	 * Master데이터 저장
	 * @param params
	 * @return
	 */
	void insertMaster(Map<String, Object> params);

	/**
	 * Detail데이터 저장
	 * @param params
	 * @return
	 */
	void insertDetail(Map<String, Object> params);

	/**
	 * fileRefNo에 해당하는 Master View 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectMasterView(EgovMap params);

	/**
	 * logDetail 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectLogDetail(Map<String, Object> params);

	/**
	 * paymentResult에 대한 Detail
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDetailForPaymentResult(Map<String, Object> params);

	/**
	 * createPaymentProcedure
	 * @param params
	 * @return
	 */
	void createPaymentProcedure(EgovMap params);

	void deactivateCommissionDeductionStatus(Map<String, Object> params);
}
