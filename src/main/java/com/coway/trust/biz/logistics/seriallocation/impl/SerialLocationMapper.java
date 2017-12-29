/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.seriallocation.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("SerialLocationMapper")
public interface SerialLocationMapper
{

	List<EgovMap> searchSerialLocationList(Map<String, Object> params);

	void updateItemGrade(Map<String, Object> params);

}
