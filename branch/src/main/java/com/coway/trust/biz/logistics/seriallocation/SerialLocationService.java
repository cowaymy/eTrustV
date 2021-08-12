/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.seriallocation;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SerialLocationService
{

	List<EgovMap> searchSerialLocationList(Map<String, Object> params);

	void updateItemGrade(Map<String, Object> params);

}
