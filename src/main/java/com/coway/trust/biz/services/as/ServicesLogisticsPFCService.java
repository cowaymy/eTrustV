package com.coway.trust.biz.services.as;

import java.util.List;
import java.util.Map;


import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ServicesLogisticsPFCService {

	
	 Map<String, Object>   SP_LOGISTIC_REQUEST(Map<String, Object> param);
	 Map<String, Object>   SP_SVC_LOGISTIC_REQUEST(Map<String, Object> param);
	 void install_Active_SP_LOGISTIC_REQUEST(Map<String, Object> param);
	  
	
}
