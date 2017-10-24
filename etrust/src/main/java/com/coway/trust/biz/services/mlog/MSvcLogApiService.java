package com.coway.trust.biz.services.mlog;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MSvcLogApiService {

	List<EgovMap> getHeartServiceJobList(Map<String, Object> params);

	List<EgovMap> getAfterServiceJobList(Map<String, Object> params);

	List<EgovMap> heartServiceResult(Map<String, Object> params); 
	
	
	
	
	
	
	
	
	
}
