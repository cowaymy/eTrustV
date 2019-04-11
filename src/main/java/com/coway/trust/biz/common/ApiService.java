package com.coway.trust.biz.common;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 ***************************************/

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ApiService {

  EgovMap selectCowayCustNricOrPassport(HttpServletRequest request, Map<String, Object> params);

}
