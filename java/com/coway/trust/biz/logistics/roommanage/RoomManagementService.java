package com.coway.trust.biz.logistics.roommanage;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface RoomManagementService {

	List<EgovMap> roomManagementList(Map<String, Object> params);

	List<EgovMap> roomBookingList(Map<String, Object> params);

	List<EgovMap> selectEditData(Map<String, Object> params);

	int saveNewEditData(Map<String, Object> params);

	void updateDeActive(Map<String, Object> params);

}
