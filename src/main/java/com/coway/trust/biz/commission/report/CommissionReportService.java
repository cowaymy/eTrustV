package com.coway.trust.biz.commission.report;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

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
    EgovMap selectMemberCount(Map<String, Object> param);

    List<EgovMap> commissionGroupType(Map<String, Object> params);
    Map commSHIMemberSearch (Map<String, Object> params);
    List<EgovMap> commSPCRgenrawSHIIndexCall (Map<String, Object> params);
    List<EgovMap> commSHIIndexDetailsCall (Map<String, Object> params);

    /**
     *  search Organization Gruop List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgGrList(Map<String, Object> params);

    /**
     * search Organization List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgList(Map<String, Object> params);

    /**
     *  search Organization Code List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgCdListAll(Map<String, Object> params);

    List<EgovMap> selectCodyRawData(Map<String, Object> params);
    List<EgovMap> selectCMRawData(Map<String, Object> params);
    List<EgovMap> selectHPRawData(Map<String, Object> params);
    List<EgovMap> selectCTRawData(Map<String, Object> params);

    List<EgovMap> commSPCRgenrawSHIIndexCall2 (Map<String, Object> params);
    List<EgovMap> commSHIIndexDetailsCall2 (Map<String, Object> params);
}
