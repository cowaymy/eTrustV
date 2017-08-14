package com.coway.trust.biz.commission.calculation;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommissionCalculationService
{
	/**
     *  search Organization Gruop Code List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgGrCdListAll(Map<String, Object> params);
    
    /**
     *  search Organization Code List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgCdListAll(Map<String, Object> params);
    
    /**
     *  search Organization Code Item List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgItemList(Map<String, Object> params);
    
    Map<String, Object> callCommProcedure(Map<String, Object> param);
	
}
