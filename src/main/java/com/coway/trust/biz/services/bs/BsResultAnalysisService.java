package com.coway.trust.biz.services.bs;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BsResultAnalysisService {

    EgovMap getUserInfo(Map<String, Object> params);

    List<EgovMap> selectAnalysisList(Map<String, Object> params);

    List<EgovMap> selResultAnalysisByMember(Map<String, Object> params);
}
