package com.coway.trust.biz.api.impl;

import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2020/12/16           API for Common
 ***************************************/

import java.util.Map;

import com.coway.trust.api.project.eCommerce.EComApiDto;
import com.coway.trust.api.project.eCommerce.EComApiForm;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("EcommApiMapper")
public interface EcommApiMapper {

  int registerOrd(Map<String, Object> params);

  EgovMap checkOrderStatus(Map<String, Object> params);

  EgovMap cardDiffNRIC(Map<String, Object> params);

  int insertNewAddr(Map<String, Object> params);

  Map<String, Object> cancelOrd(Map<String, Object> param);

}
