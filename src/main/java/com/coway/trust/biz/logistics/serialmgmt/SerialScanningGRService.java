package com.coway.trust.biz.logistics.serialmgmt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialScanningGRService.java
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
public interface SerialScanningGRService {
	List<EgovMap> serialScanningGRCommonCode(Map<String, Object> params);
	String selectDefLocationType(Map<String, Object> params);
	String selectDefLocationCode(Map<String, Object> params);
	List<EgovMap> serialScanningGRDataList(Map<String, Object> params);
}