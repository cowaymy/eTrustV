package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("orderLedgerMapper")
public interface OrderLedgerMapper {

	EgovMap selectOrderLedgerView(Map<String, Object> params);
	EgovMap selectInsInfo(Map<String, Object> params);
	EgovMap selectMailInfo(Map<String, Object> params);
	EgovMap selectSalesInfo(Map<String, Object> params);
	List<EgovMap> getOderLdgr(Map<String, Object> params);
	List<EgovMap> getOderOutsInfo(Map<String, Object> params);
	List<EgovMap> selectAgreInfo(Map<String, Object> params);
	void getOderLdgr2(Map<String, Object> params);
	List<EgovMap> selectPaymentDetailView(Map<String, Object> param);
	List<EgovMap> selectPaymentDetailViewCndn(Map<String, Object> param);
	EgovMap selectPayInfo(Map<String, Object> params);
	
}
