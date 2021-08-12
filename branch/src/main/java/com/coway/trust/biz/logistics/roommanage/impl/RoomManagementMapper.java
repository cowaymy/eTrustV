package com.coway.trust.biz.logistics.roommanage.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("roomManagementMapper")
public interface RoomManagementMapper {

	List<EgovMap> roomManagementList(Map<String, Object> params);

	List<EgovMap> roomBookingList(Map<String, Object> params);

	List<EgovMap> selectEditData(Map<String, Object> params);

	void saveNewEditData(Map<String, Object> params);

	void updateDeActive(Map<String, Object> params);

	int maxRoomId();
}
