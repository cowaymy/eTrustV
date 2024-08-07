package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("interfaceManagementMapper")
public interface InterfaceManagementMapper {
	List<EgovMap> selectInterfaceManagementList(Map<String, Object> params);

	void insertInterfaceManagementList(Map<String, Object> params);

	void insertInterfaceItfKey(Map<String, Object> params);

	void updateInterfaceManagementList(Map<String, Object> params);

	void deleteInterfaceManagementList(Map<String, Object> params);

}
