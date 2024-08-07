package com.coway.trust.biz.logistics.importbl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ImportService {
	
	List<EgovMap> importBLList(Map<String, Object> params);
	
	List<EgovMap> importLocationList(Map<String, Object> params);

	List<EgovMap> searchSMO(Map<String, Object> params);

}
