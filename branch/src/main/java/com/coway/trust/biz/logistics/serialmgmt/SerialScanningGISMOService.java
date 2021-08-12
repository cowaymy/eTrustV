package com.coway.trust.biz.logistics.serialmgmt;

import java.util.List;
import java.util.Map;

/**
 * @ClassName : SerialScanningGISMOService.java
 * @Description : GI Serial No. Scanning (SMO) Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 21.   KR-OHK        First creation
 * </pre>
 */
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SerialScanningGISMOService
{

	List<EgovMap> selectSerialScanningGISMOList(Map<String, Object> params);

}
