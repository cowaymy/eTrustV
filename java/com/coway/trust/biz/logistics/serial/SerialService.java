package com.coway.trust.biz.logistics.serial;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SerialService {

	List<EgovMap> searchSeialList(Map<String, Object> params);

	List<EgovMap> selectSerialDetails(Map<String, Object> params);

	int updateSerial(List<Object> list, String loginId);

	int insertSerial(List<Object> addList, String loginId);

	List<EgovMap> searchSeialListPop(Map<String, Object> params);

	List<EgovMap> selectSerialExist(Map<String, Object> params);

	void insertExcelSerial(List<Object> addList, String loginId);

}
