package com.coway.trust.biz.api;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.biz.api.vo.selfcarePortal.VerifyOderNoReqForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SelfcarePortalApiService {
	void rtnRespMsg( Map<String, Object> param );
	void insertApiLog(HttpServletRequest request, EgovMap params, String reqParam, String respTm, String apiUserId);
	String verifyOrderNoParam(HttpServletRequest request, VerifyOderNoReqForm param);
	void finalizeResultValue(EgovMap params, EgovMap resultValue);
	
	EgovMap getProductDetail( HttpServletRequest request, VerifyOderNoReqForm param ) throws Exception;
	EgovMap getServiceHistory( HttpServletRequest request, VerifyOderNoReqForm param ) throws Exception;
	EgovMap getFilterInfo( HttpServletRequest request, VerifyOderNoReqForm param ) throws Exception;
	EgovMap getUpcomingService( HttpServletRequest request, VerifyOderNoReqForm param ) throws Exception;
}
