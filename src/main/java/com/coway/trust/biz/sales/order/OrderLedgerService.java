package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderLedgerService {

	EgovMap selectOrderLedgerView(Map<String, Object> params);
	EgovMap selectInsInfo(Map<String, Object> params);
	EgovMap selectMailInfo(Map<String, Object> params);
	EgovMap selectSalesInfo(Map<String, Object> params);
	List<EgovMap> getOderLdgr(Map<String, Object> params);
	List<EgovMap> getOderOutsInfo(Map<String, Object> params);
	List<EgovMap> selectAgreInfo(Map<String, Object> params);
	List<EgovMap> getOderLdgr2(Map<String, Object> params);
	List<EgovMap> selectPaymentDetailViewCndn(Map<String, Object> param);
	List<EgovMap> selectPaymentDetailView(Map<String, Object> param);
	EgovMap selectPayInfo(Map<String, Object> params);
	
	
}
