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

  CommonApiDto checkAccess(CommonApiForm params) throws Exception;

  EgovMap returnResponseMessage(HttpServletRequest request, Map<String, Object> params, EgovMap responseData);

}
