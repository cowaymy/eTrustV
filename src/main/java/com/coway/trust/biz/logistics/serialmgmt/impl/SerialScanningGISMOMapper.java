package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialScanningGISMOMapper.java
 * @Description : GI Serial No. Scanning (SMO) Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 21.   KR-OHK        First creation
 * </pre>
 */

@Mapper("serialScanningGISMOMapper")
public interface SerialScanningGISMOMapper
{

	List<EgovMap> selectSerialScanningGISMOList(Map<String, Object> params);

}
