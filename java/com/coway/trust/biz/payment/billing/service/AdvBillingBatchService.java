package com.coway.trust.biz.payment.billing.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AdvBillingBatchService
{
	/**
	 * CommitionDeduction 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBillingBatch(Map<String, Object> params);
	
	/**
	 * SalesMaster정보 조회
	 * @param params
	 * @return
	 */
	EgovMap selectSalesOrderMaster(String params);
	
	/**
	 * DB에 저장
	 * @param params
	 * @return
	 */
	boolean doSaveBatchAdvBilling(Map<String, Object> advBillBatchM, List<Map<String, Object>> advBillBatchList);
	
	/**
	 * Master정보 저장
	 * @param params
	 * @return
	 */
	void insertAccAdvanceBillBatchM(Map<String, Object> params);
	
	/**
	 * Sub정보 저장
	 * @param params
	 * @return
	 */
	void insertAccAdvanceBillBatchD(Map<String, Object> params);
	
	/**
	 * SalesNo가 Sales Master에 있는지 조회
	 * @param params
	 * @return
	 */
	boolean isCheckOrderNoIsExistAndRentalType(String param);

	/**
	 * Master정보 Update
	 * @param params
	 * @return
	 */
	void updateAccAdvanceBillBatchM(Map<String, Object> params);
	
	/**
	 * 마스터 정보 조회
	 * @param params
	 * @return
	 */
	EgovMap selectBatchMasterInfo(Map<String, Object> params);
	
	/**
	 * 디테일 정보 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBatchDetailInfo(Map<String, Object> params);
	
	/**
	 * doDeactivate
	 * @param params
	 * @return
	 */
	boolean doDeactivateAdvanceBillBatach(Map<String, Object>params);
	
	/**
	 * Master정보 Update
	 * @param params
	 * @return
	 */
	void updateAccAdvanceBillBatchM2(Map<String, Object> params);
	
	/**
	 * Detail정보 Update
	 * @param params
	 * @return
	 */
	void updateAccAdvanceBillBatchD2(Map<String, Object> params);
	
	/**
	 * RunBillBatchUpload
	 * @param params
	 * @return
	 */
	boolean updBillBatchUpload(Map<String, Object> params);
}
