/**
 *
 */
package com.coway.trust.biz.services.bs;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author HQIT-HUIDING
 * @date Jul 21, 2020
 *
 */
public interface HsMaintenanceService {

	public List<EgovMap> selectCurrMonthHsList (Map<String, Object> params);

	public String updateAssignCodyBulk(Map<String, Object> params);
}
