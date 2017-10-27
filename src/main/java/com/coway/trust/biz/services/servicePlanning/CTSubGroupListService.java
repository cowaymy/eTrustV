package com.coway.trust.biz.services.servicePlanning;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CTSubGroupListService {

	List<EgovMap>  selectCTSubGroupList(Map<String, Object> params);
	
	void insertCTSubGroup(List<Object> params);
}
