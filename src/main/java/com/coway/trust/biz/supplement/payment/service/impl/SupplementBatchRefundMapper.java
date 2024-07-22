package com.coway.trust.biz.supplement.payment.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("supplementBatchRefundMapper")
public interface SupplementBatchRefundMapper {
	List<EgovMap> selectBatchRefundList(Map<String, Object> params);

	EgovMap selectBatchRefundInfo(Map<String, Object> params);

	List<EgovMap> selectBatchRefundItem(Map<String, Object> params);

	List<EgovMap> selectAccNoList(Map<String, Object> params);

	List<EgovMap> selectCodeList(Map<String, Object> params);

	int selectNextBatchId();

	int insertBatchRefundM(Map<String, Object> params);

	int selectNextDetId();

	int insertBatchRefundD(Map<String, Object> params);

	int callBatchRefundVerifyDet(Map<String, Object> params);

	int batchRefundDeactivate(Map<String, Object> master);

	int batchRefundConfirm(Map<String, Object> master);

	int batchRefundItemDisab(Map<String, Object> params);

	void callConvertBatchRefund(Map<String, Object> params);

	String selectNextIfKey();

	void insertInterface(EgovMap params);

	List<EgovMap> getPaymentMode();

	List<EgovMap> getBatStatus();

	List<EgovMap> getBatConfirmtStatus();

	List<EgovMap> selectSupOrdList(String borNo);

	List<EgovMap> selectSupBatchRefundDtl(Map<String, Object> params);

	int updSupplementRtnRfnd(Map<String, Object> params);

}
