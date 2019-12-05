package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialScanningGRMapper.java
 * @Description : GR Serial NO Scanning
 *
 * @History
 *
 * <pre>
 * Date               Author       Description
 * -------------  -----------  -------------
 * 2019.11.21.     KR-JUN       First creation
 * </pre>
 */
@Mapper("SerialScanningGRMapper")
public interface SerialScanningGRMapper {
	List<EgovMap> serialScanningGRCommonCode(Map<String, Object> params);
	String selectDefLocationType(Map<String, Object> params);
	String selectDefLocationCode(Map<String, Object> params);
	List<EgovMap> serialScanningGRDataList(Map<String, Object> params);
}
