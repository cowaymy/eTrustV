package com.coway.trust.biz.services.as;

import java.util.List;
import java.util.Map;


import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface InHouseRepairService {

	List<EgovMap> selInhouseList(Map<String, Object> params);
	
	List<EgovMap> selInhouseDetailList(Map<String, Object> params);
	
	
	
	
	
}
