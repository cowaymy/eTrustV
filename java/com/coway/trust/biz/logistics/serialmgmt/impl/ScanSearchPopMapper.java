package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ScanSearchPopMapper.java
 * @Description : Scan Search
 *
 * @History
 *
 * <pre>
 * Date               Author       Description
 * -------------  -----------  -------------
 * 2019.11.26.     KR-JUN       First creation
 * </pre>
 */
@Mapper("ScanSearchPopMapper")
public interface ScanSearchPopMapper {
	List<EgovMap> scanSearchDataList(Map<String, Object> params);
}
