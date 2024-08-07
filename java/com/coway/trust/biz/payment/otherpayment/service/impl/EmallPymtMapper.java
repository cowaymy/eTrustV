package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("emallPymtMapper")
public interface EmallPymtMapper {

  List<EgovMap> selectEmallPymtList(Map<String, Object> params);

  List<EgovMap> selectEmallPymtDetailsList(Map<String, Object> params);

  EgovMap getOrderDetail(Map<String, Object> params);

  int selectPay0356M_Seq();

  void insertPay0356M(Map<String, Object> params);

  void insertPay0357D(Map<String, Object> params);

  int updatePay0356mMaster(Map<String, Object> params);

  int updatePay0357dDetail(Map<String, Object> params);

}
