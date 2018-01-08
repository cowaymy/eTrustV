package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CcpCTOSB2BService {

	
	List<EgovMap> selectCTOSB2BList(Map<String, Object> params)throws Exception;
	
	List<EgovMap> getCTOSDetailList(Map<String, Object> params)throws Exception;
	
	Map<String, Object> getResultRowForCTOSDisplay(Map<String, Object> params)throws Exception;
}
