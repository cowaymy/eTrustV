/**
 *
 */
package com.coway.trust.biz.organization.hasratCody.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author HQIT-HUIDING
 * @date Oct 12, 2020
 *
 */

@Mapper("hasratCodyMapper")
public interface HasratCodyMapper {

	List<EgovMap> selectHasratCodyList (Map<String, Object> params);
	void insertHasratCody(Map<String, Object> params);
	List<EgovMap> selectCodyBranchList (Map<String, Object> params);
	EgovMap selectUserInfo (Map<String, Object> params);
}
