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
    List<EgovMap> selectRuleBookOrgMngList(Map<String, Object> params);
    
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
    
    /**
     *  search Organization Gruop Code List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgGrCdList(Map<String, Object> params);
    
    /**
     *  search Organization Code List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgCdList(Map<String, Object> params);
    
    /**
     *  search Organization Code Item List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgItemList(Map<String, Object> params);

    /**
     * search Rule Book Item management List
     * @param params
     * @return
     */
    List<EgovMap> selectRuleBookItemMngList(Map<String, Object> params);
    
    /**
     * add coommission rule book management Data
     * @param updateList
     * @return
     */
    int addCommissionItemGrid(List<Object> updateList , String loginId);
    
    /**
     * update coommission rule book management Data
     * @param addList
     * @return
     */
    int udtCommissionItemGrid(List<Object> addList, String loginId);
    
    /**
     * delete coommission rule book management Data
     * @param removeList
     * @return
     */
    
    /**
     * add coommission rule  management Data
     * @param updateList
     * @return
     */
    int addCommissionRuleData(Map<String, Object> params, String loginId);
    
    /**
     * search selectRuleBookMngList List
     * @param params
     * @return
     */
    List<EgovMap> selectRuleBookMngList(Map<String, Object> params);
    
    /**
     * update coommission rule  management Data
     * @param updateList
     * @return
     */
    int udtCommissionRuleData(Map<String, Object> params, String loginId);
}
