package com.coway.trust.biz.logistics.serialmgmt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialSearchPopService.java
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
public interface SerialSearchPopService {
	List<EgovMap> serialSearchDataList(Map<String, Object> params);
}