package com.coway.trust.biz.logistics.sirim;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SirimService {

	List<EgovMap> selectWarehouseList(Map<String, Object> params);
	
	List<EgovMap> selectSirimList(Map<String, Object> params);
	
	String selectSirimNo(Map<String, Object> params);
	
	void insertSirimList(Map<String, Object> params);
	
	
}
