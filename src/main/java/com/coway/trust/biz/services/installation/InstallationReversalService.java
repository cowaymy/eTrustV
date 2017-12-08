package com.coway.trust.biz.services.installation;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface InstallationReversalService {

	List<EgovMap> selectOrderList(Map<String, Object> params);
	
	EgovMap installationReversalSearchDetail1(Map<String, Object> params);
	
	EgovMap installationReversalSearchDetail2(Map<String, Object> params);
	
	EgovMap installationReversalSearchDetail3(Map<String, Object> params);
	
	EgovMap installationReversalSearchDetail4(Map<String, Object> params);
	
	EgovMap installationReversalSearchDetail5(Map<String, Object> params);
		
}
