/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.hsfilterforecast;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HSFilterForecastService
{

	List<EgovMap> selectHSFilterForecastList(Map<String, Object> params);

	List<EgovMap> selectForecastDetailsList(Map<String, Object> params);
}
