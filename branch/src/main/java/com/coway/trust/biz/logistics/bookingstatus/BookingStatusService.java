/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.bookingstatus;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BookingStatusService
{

	List<EgovMap> searchBookingStatusList(Map<String, Object> params);

}
