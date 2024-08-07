/**
 *
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.sales.mambership;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface KeyinConfigService {

	List<EgovMap> selectkeyinConfigList(Map<String, Object> params);

	public int updateAllowSalesStatus(Map<String, Object> params, SessionVO sessionVO) throws Exception;

}
