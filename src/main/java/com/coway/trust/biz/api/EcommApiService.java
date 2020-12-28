package com.coway.trust.biz.api;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 *
 ***************************************/

import com.coway.trust.api.project.eCommerce.EComApiDto;
import com.coway.trust.api.project.eCommerce.EComApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface EcommApiService {

  EComApiDto checkOrderStatus(EComApiForm params) throws Exception;
  EgovMap isCardExists(EComApiForm params) throws Exception;

}
