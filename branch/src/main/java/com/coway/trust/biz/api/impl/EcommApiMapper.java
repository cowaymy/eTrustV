package com.coway.trust.biz.api.impl;


/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2020/12/16           API for Common
 ***************************************/

import java.util.Map;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("EcommApiMapper")
public interface EcommApiMapper {

  int registerOrd(Map<String, Object> params);

  Map<String, Object> getCustomerInfo(Map<String, Object> param);

  EgovMap checkOrderStatus(Map<String, Object> params);

  EgovMap cardDiffNRIC(Map<String, Object> params);

  int insertNewAddr(Map<String, Object> params);

  Map<String, Object> cancelOrd(Map<String, Object> param);

  void updateEcommOrderStatus(SalesOrderMVO salesOrderMVO);

}
