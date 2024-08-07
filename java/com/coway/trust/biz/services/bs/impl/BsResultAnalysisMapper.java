package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("bsResultAnalysisMapper")
public interface BsResultAnalysisMapper {

    EgovMap getUserInfo(Map<String, Object> params);

    List<EgovMap> selectAnalysisList(Map<String, Object> params);

    List<EgovMap> selResultAnalysisByMember(Map<String, Object> params);
}
