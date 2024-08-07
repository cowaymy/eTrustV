package com.coway.trust.biz.logistics.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("maintainMapper")
public interface MaintainMovementMapper {
	List<EgovMap> selectMaintainMovementList(Map<String, Object> params);
	
	void insMaintainMovement(Map<String, Object> params);
	
	void updMaintainMovement(Map<String, Object> params);
	
	void removeMaintainMovement(Map<String, Object> params);
}
