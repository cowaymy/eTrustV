/**
 *
 */
package com.coway.trust.biz.sales.mambership;

import java.util.List;


import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
public interface PayPopService {

	/**
	 *
	 * @param params
	 * @return
	 */
	List<EgovMap> selectTransferHistoryList(Map<String, Object> params);

	EgovMap selectHPCodyList(Map<String, Object> params);


}
