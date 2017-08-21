package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("gstZeroRateLocationMapper")
public interface GSTZeroRateLocationMapper {
	List<EgovMap> selectStateCodeList(Map<String, Object> params);

	List<EgovMap> selectSubAreaList(Map<String, Object> params);

	List<EgovMap> selectZRLocationList(Map<String, Object> params);

	List<EgovMap> selectPostCodeList(Map<String, Object> params);

	void updateZrLocStusId(Map<String, Object> params);

	void insertZrLocStusId(Map<String, Object> params);
}
