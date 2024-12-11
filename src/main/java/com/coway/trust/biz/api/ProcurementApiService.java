package com.coway.trust.biz.api;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.biz.api.vo.procurement.CostCenterReqForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ProcurementApiService {
	void rtnRespMsg( Map<String, Object> param );
	void insertApiLog(HttpServletRequest request, EgovMap params, String reqParam, String respTm, String apiUserId);
	EgovMap getCostCtrGLaccBudgetCdInfo (HttpServletRequest request, CostCenterReqForm param) throws Exception;
	EgovMap getVendorPaymentRecord (HttpServletRequest request) throws Exception;
	String verifyBasicAPIAuth(HttpServletRequest request);
	void finalizeResultValue(EgovMap params, EgovMap resultValue);
}
