package com.coway.trust.biz.logistics.sirim;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SirimReceiveService {
	
	List<EgovMap> receiveWarehouseList(Map<String, Object> params);
	
	List<EgovMap> selectReceiveList(Map<String, Object> params);
	
	List<EgovMap> detailReceiveList(Map<String, Object> params);
	
	List<EgovMap> getSirimReceiveInfo(Map<String, Object> params);

	void InsertReceiveInfo(Map<String, Object> InsertReceiveMap, List<EgovMap> ItemsAddList,int loginId );
}
