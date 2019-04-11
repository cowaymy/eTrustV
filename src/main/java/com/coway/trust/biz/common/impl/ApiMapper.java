package com.coway.trust.biz.common.impl;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 ***************************************/

import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ApiMapper")
public interface ApiMapper {
  EgovMap selectCowayCustNricOrPassport(Map<String, Object> params);

  void insertApiAccessLog(Map<String, Object> params);
}
