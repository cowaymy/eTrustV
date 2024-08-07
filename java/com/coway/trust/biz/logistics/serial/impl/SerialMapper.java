package com.coway.trust.biz.logistics.serial.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("serialMapper")
public interface SerialMapper {

	List<EgovMap> searchSeialList(Map<String, Object> params);

	List<EgovMap> selectSerialDetails(Map<String, Object> params);

	int updateSerial(Map<String, Object> param);

	List<EgovMap> searchSeialListPop(Map<String, Object> params);

	List<EgovMap> selectSerialExist(Map<String, Object> params);

	void insertExcelSerial(Map<String, Object> param);

}
