package com.coway.trust.biz.eAccounting.pettyCash;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PettyCashService {
	
	List<EgovMap> selectCustodianList(Map<String, Object> params);
	
	String selectUserNric(int userId);
	
	void insertCustodian(Map<String, Object> params);
	
}
