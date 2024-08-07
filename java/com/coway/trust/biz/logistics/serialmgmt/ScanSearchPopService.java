package com.coway.trust.biz.logistics.serialmgmt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ScanSearchPopService.java
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
public interface ScanSearchPopService {
	List<EgovMap> scanSearchDataList(Map<String, Object> params);
}