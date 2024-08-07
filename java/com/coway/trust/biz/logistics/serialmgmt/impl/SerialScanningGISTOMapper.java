package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialScanningGISTOMapper.java
 * @Description : GI STO Serial NO Scanning
 *
 * @History
 *
 * <pre>
 * Date               Author       Description
 * -------------  -----------  -------------
 * 2019.11.21.     KR-JUN       First creation
 * </pre>
 */
@Mapper("SerialScanningGISTOMapper")
public interface SerialScanningGISTOMapper {
	List<EgovMap> serialScanningGISTODataList(Map<String, Object> params);
}
