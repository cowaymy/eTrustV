package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommonService {

	List<EgovMap> selectCodeList(Map<String, Object> params);

	List<EgovMap> selectI18NList();
	
	List<EgovMap> getMstCommonCodeList(Map<String, Object> params);
	
	List<EgovMap> getDetailCommonCodeList(Map<String, Object> params);
}
