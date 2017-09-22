/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 */
package com.coway.trust.biz.commission.system.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * Commissio Mapper
 *      </pre>
 */
@Mapper("commissionSystemMapper")
public interface CommissionSystemMapper {
	/**
	 * search Organization Gruop List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgGrList(Map<String, Object> params);

	/**
	 * search Organization  List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgList(Map<String, Object> params);

	/**
	 * search selectRuleBookOrgMngList List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectRuleBookOrgMngList(Map<String, Object> params);

	/**
	 * check rulebook data 
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectRuleBookMngChk(Map<String, Object> params);

	/**
	 * add coommission rule book management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int addCommissionGrid(Map<String, Object> params);

	/**
	 * update coommission rule book management Data : use_yn
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int udtCommissionGridUseYn(Map<String, Object> params);

	/**
	 * update coommission rule book management Data : end_dt
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int udtCommissionGridEndDt(Map<String, Object> params);

	/**
	 * delete coommission rule book management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int delCommissionGrid(Map<String, Object> params);
	
	/**
	 * search Organization Gruop Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgGrCdListAll(Map<String, Object> params);
	
	/**
	 * search Organization Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgCdListAll(Map<String, Object> params);
	
	/**
	 * search Organization Gruop Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgGrCdList(Map<String, Object> params);
	
	/**
	 * search Organization Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgCdList(Map<String, Object> params);
	
	/**
	 * search Organization Item List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgItemList(Map<String, Object> params);
	
	
	/**
	 * search Rule Book Mng List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectRuleBookItemMngList(Map<String, Object> params);
	
	/**
	 * check rulebook Item data 
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectRuleBookItemMngChk(Map<String, Object> params);
	
	/**
	 * update coommission rule book Item management Data : end_dt
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int udtCommissionItemGridEndDt(Map<String, Object> params);

	/**
	 * add coommission rule book management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int addCommissionItemGrid(Map<String, Object> params);
	
	/**
	 * add coommission rule book Item management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int udtCommissionItemGridUseYn(Map<String, Object> params);
	
	/**
	 * add coommission rule management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int addCommissionRuleData(Map<String, Object> params);
	
	/**
	 * check rulebook Item data 
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectRuleMngChk(Map<String, Object> params);
	
	/**
	 * update coommission rule book Item management Data : end_dt
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int udtCommissionRuleEndDt(Map<String, Object> params);

	/**
	 * search Rule Book Mng List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectRuleBookMngList(Map<String, Object> params);
	
	int cntUpdateDate(Map<String, Object> params);
	
	void udtRuleDescData(Map<String, Object> params);
	
	/**
	 * search Organization Gruop List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectWeeklyList(Map<String, Object> params);
	
	/**
	 * add coommission rule book management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int addWeeklyCommissionGrid(Map<String, Object> params);

	/**
	 * update coommission rule book management Data : use_yn
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int udtWeeklyCommissionGrid(Map<String, Object> params);
}
