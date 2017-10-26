package com.coway.trust.biz.logistics.roommanage;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface RoomManagementService {

	List<EgovMap> roomManagementList(Map<String, Object> params);

}
