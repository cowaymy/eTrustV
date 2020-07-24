/**
 *
 */
package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author HQIT-HUIDING
 * @date Jul 21, 2020
 *
 */
@Mapper("hsMaintenanceMapper")
public interface HsMaintenanceMapper {

	public List<EgovMap> selectCurrMonthHsList(Map<String, Object> params);

	public void updateAssignCodyBulk(Map<String, Object> params);
}
