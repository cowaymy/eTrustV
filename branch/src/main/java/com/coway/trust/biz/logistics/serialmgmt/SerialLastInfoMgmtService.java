package com.coway.trust.biz.logistics.serialmgmt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialLastInfoMgmtService.java
 * @Description : Serial No. Last Info Management Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 22.   KR-OHK        First creation
 * </pre>
 */
public interface SerialLastInfoMgmtService {

	int selectSerialLastInfoListCnt(Map<String, Object> params);

	List<EgovMap> selectSerialLastInfoList(Map<String, Object> params);

	List<EgovMap> selectSerialLastInfoHistoryList(Map<String, Object> params);

	List<EgovMap> selectOrderBasicInfoByOrderId(Map<String, Object> params);

	void saveSerialLastInfo(Map<String, Object> params);

}
