package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialSearchPopMapper.java
 * @Description : Serial Search
 *
 * @History
 *
 * <pre>
 * Date               Author       Description
 * -------------  -----------  -------------
 * 2019.11.28.     KR-JUN       First creation
 * </pre>
 */
@Mapper("SerialSearchPopMapper")
public interface SerialSearchPopMapper {
	List<EgovMap> serialSearchDataList(Map<String, Object> params);
}
