/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.bookingstatus.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("BookingStatusMapper")
public interface BookingStatusMapper
{

	List<EgovMap> searchBookingStatusList(Map<String, Object> params);

}
