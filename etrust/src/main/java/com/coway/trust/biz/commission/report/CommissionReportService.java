package com.coway.trust.biz.commission.report;

import java.util.Map;

/**
 *  Commission System Management
 * @param params
 * @return
 */
public interface CommissionReportService
{
	/**
     *  select count member
     * @param params
     * @return
     */
    int selectMemberCount(Map<String, Object> param);
}
	