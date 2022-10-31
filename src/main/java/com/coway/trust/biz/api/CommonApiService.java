package com.coway.trust.biz.api;


/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 *
 ***************************************/

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;

import com.coway.trust.api.project.common.CommonApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommonApiService {

  EgovMap checkAccess(HttpServletRequest request, CommonApiForm params);

  EgovMap rtnRespMsg(HttpServletRequest request, String code, String msg, String respTm, Map<String, Object> reqPrm,
      Map<String, Object> respPrm, String apiUserId) ;

  EgovMap rtnRespMsg(HttpServletRequest request, String code, String msg, String respTm, String reqPrm,
	      Map<String, Object> respPrm, String apiUserId) ;

  EgovMap rtnRespMsg(String pgmPath, String code, String msg, String respTm, String reqPrm,
	      Map<String, Object> respPrm, String apiUserId) ;

  EgovMap rtnRespMsg(String pgmPath, String code, String msg, String respTm, String reqPrm,
	      String respPrm, String apiUserId, String refNo) ;

  String decodeJson(HttpServletRequest request) throws Exception;

  EgovMap verifyBasicAuth(HttpServletRequest request, Map<String, Object> params)  throws Exception ;

}
