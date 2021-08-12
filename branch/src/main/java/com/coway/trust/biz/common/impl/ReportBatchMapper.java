package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("reportBatchMapper")
public interface ReportBatchMapper {

  void insertLog(Map<String, Object> params);
}
