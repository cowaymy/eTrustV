package com.coway.trust.biz.homecare.report;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcPoStatusService {

	// Po Status List 조회
	public int selectHcPoStatusMainListCnt(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectHcPoStatusMainList(Map<String, Object> params) throws Exception;



}
