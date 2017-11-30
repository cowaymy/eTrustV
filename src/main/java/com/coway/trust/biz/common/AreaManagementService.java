package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AreaManagementService {

	List<EgovMap> selectAreaManagement(Map<String, Object> params) throws Exception;

	int udtAreaManagement(List<Object> udtList, String loginId);
	
	int addCopyAddressMaster(List<Object> updateList , String loginId);
	
	int addCopyOtherAddressMaster(List<Object> updateList , String loginId);
	
	int addOtherAddressMaster(List<Object> updateList , String loginId);
	
	int addMyAddressMaster(List<Object> updateList , String loginId);
	
	List<EgovMap> selectMyPostcode(Map<String, Object> params) throws Exception;
	
}
