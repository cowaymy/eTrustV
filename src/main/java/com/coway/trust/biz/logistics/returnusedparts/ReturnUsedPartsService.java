package com.coway.trust.biz.logistics.returnusedparts;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ReturnUsedPartsService {

	List<EgovMap> returnPartsList(Map<String, Object> params);
		
	void returnPartsUpdate(Map<String, Object> params,int loginId);
	
	void returnPartsCanCle(Map<String, Object> params);
	
	//테스트 인서트 딜리트
	void returnPartsInsert(String param);
	
	void returnPartsdelete(String param);
	
}
