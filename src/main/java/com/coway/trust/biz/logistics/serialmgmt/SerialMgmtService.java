/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.serialmgmt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SerialMgmtService
{

	List<EgovMap> selectDeliveryBalance(Map<String, Object> params);

	List<EgovMap> selectDeliveryList(Map<String, Object> params);

	List<EgovMap> selectScanList(Map<String, Object> params);

	List<EgovMap> selectBoxNoList(Map<String, Object> params);

	void insertScanItems(Map<String, Object> params);
}
