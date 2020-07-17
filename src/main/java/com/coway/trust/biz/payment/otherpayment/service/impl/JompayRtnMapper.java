package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("jompayRtnMapper")
public interface JompayRtnMapper {

  List<EgovMap> selectJompayRtnList(Map<String, Object> params);

  List<EgovMap> selectJompayRtnDetailsList(Map<String, Object> params);
}
