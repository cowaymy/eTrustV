package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommonMyPopService {	
	List<EgovMap> selectCommonMyPopList(Map<String, Object> params);
}
