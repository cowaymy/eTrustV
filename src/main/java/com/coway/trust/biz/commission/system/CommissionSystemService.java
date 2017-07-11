package com.coway.trust.biz.commission.system;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommissionSystemService
{

	/**
     *  search Organization Master List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgGrList(Map<String, Object> params);
    
    /**
     * search Organization Detail List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgList(Map<String, Object> params);
    
    /**
     * search selectRuleBookMngListl List
     * @param params
     * @return
     */
    List<EgovMap> selectRuleBookMngList(Map<String, Object> params);
    
    /**
     * add Organization Detail Data
     * @param updateList
     * @return
     */
    int addCommissionGrid(List<Object> updateList);
    
    /**
     * update Organization Detail Data
     * @param addList
     * @return
     */
    int udtCommissionGrid(List<Object> addList);
    
    /**
     * delete Organization Detail Data
     * @param removeList
     * @return
     */
    int delCommissionGrid(List<Object> removeList);
}
