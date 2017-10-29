package com.coway.trust.biz.services.as;

import java.util.List;
import java.util.Map;


import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CompensationService {

	List<EgovMap> selCompensationList(Map<String, Object> params);
	
	  
	
}
