package com.coway.trust.biz.api.impl;

import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2020/12/16           API for Common
 ***************************************/

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("CommonApiMapper")
public interface CommonApiMapper {

  EgovMap checkAccess(Map<String, Object> params);
  void insertApiAccessLog(Map<String, Object> params);

}
