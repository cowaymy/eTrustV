/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.replenishment;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ReplenishmentService {

	Map<String, Object> excelDataSearch(Map<String, Object> params);

	void relenishmentSave(Map<String, Object> params, int userid);

	void relenishmentPopSave(Map<String, Object> params, int userid);

	List<EgovMap> searchList(Map<String, Object> params);

	List<EgovMap> searchListRdc(Map<String, Object> params);
}
