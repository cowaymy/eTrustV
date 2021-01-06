package com.coway.trust.biz.api;

import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 *
 ***************************************/

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.api.project.common.CommonApiDto;
import com.coway.trust.api.project.common.CommonApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommonApiService {

  EgovMap checkAccess(HttpServletRequest request, CommonApiForm params);

  EgovMap rtnRespMsg(HttpServletRequest request, String code, String msg, String respTm, Map<String, Object> reqPrm,
      Map<String, Object> respPrm, String apiUserId) ;

}
