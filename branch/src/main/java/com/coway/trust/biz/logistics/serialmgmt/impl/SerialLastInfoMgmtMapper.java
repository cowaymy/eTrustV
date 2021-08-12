package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialLastInfoMgmtMapper.java
 * @Description : Serial No. Last Info Management Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 22.   KR-OHK        First creation
 * </pre>
 */

@Mapper("serialLastInfoMgmtMapper")
public interface SerialLastInfoMgmtMapper {

	int selectSerialLastInfoListCnt(Map<String, Object> param);

	List<EgovMap> selectSerialLastInfoList(Map<String, Object> params);

	List<EgovMap> selectSerialLastInfoHistoryList(Map<String, Object> params);

	List<EgovMap> selectOrderBasicInfoByOrderId(Map<String, Object> params);

	EgovMap checkSerialLastInfoValid(Map<String, Object> params);

	void saveSerialLastInfo(Map<String, Object> params);

	void insertSerialLastInfoHistory(Map<String, Object> params);

}
