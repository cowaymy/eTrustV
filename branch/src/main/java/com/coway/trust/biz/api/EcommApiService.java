package com.coway.trust.biz.api;

import javax.servlet.http.HttpServletRequest;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 *
 ***************************************/

import com.coway.trust.api.project.eCommerce.EComApiDto;
import com.coway.trust.api.project.eCommerce.EComApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface EcommApiService {

  EgovMap registerOrder(HttpServletRequest request,EComApiForm eComApiForm) throws Exception;
  EgovMap checkOrderStatus(HttpServletRequest request,EComApiForm eComApiForm) throws Exception;
  EgovMap cardDiffNRIC(HttpServletRequest request, EComApiForm eComApiForm) throws Exception;
  EgovMap insertNewAddr(HttpServletRequest request,EComApiForm eComApiForm) throws Exception;
  EgovMap cancelOrder(HttpServletRequest request,EComApiForm eComApiForm) throws Exception;

}
