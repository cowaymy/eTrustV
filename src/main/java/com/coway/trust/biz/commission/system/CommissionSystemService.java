package com.coway.trust.biz.commission.system;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommissionSystemService
{

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
     * search selectRuleBookMngList List
     * @param params
     * @return
     */
    List<EgovMap> selectRuleBookMngList(Map<String, Object> params);
    
    /**
     * add coommission rule book management Data
     * @param updateList
     * @return
     */
    int addCommissionGrid(List<Object> updateList , String loginId);
    
    /**
     * update coommission rule book management Data
     * @param addList
     * @return
     */
    int udtCommissionGrid(List<Object> addList, String loginId);
    
    /**
     * delete coommission rule book management Data
     * @param removeList
     * @return
     */
    int delCommissionGrid(List<Object> removeList, String loginId);
}
