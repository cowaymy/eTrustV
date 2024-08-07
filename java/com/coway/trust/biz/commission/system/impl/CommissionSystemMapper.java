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

	int cntUpdateData(Map<String, Object> params);

	void udtRuleDescData(Map<String, Object> params);

	List<EgovMap> selectRuleValueType(Map<String, Object> params);

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

	/**
	 * simulation Version Mng List
	 * @param params
	 * @return
	 */
	List<EgovMap> selectSimulationMngList(Map<String, Object> params);

	/**
	 * simulation rule endDate update
	 * @param params
	 */
	void udtVersionItemEndDt (Map<String, Object> params);

	/**
	 * simulation rule book vaild Search
	 * @param itemCd
	 * @return
	 */
	String varsionVaildSearch (String itemCd);

	/**
	 * simulation rule insert
	 * @param params
	 */
	void versionItemInsert(Map<String, Object> params);

	/**
	 * actual rule book item list select(new Seq)
	 * @param params
	 * @return
	 */
	List<EgovMap> selectVersionRuleBookList(Map<String, Object> params);

	/**
	 * simulation item insert
	 * @param params
	 */
	void addCommVersionRuleData(Map<String, Object> params);

	/**
	 * simulation item endDate update
	 * @param params
	 */
	void udtCommVersionRuleEndDt(Map<String, Object> params);

	/**
	 * simulation rule book item list select
	 * @param params
	 * @return
	 */
	List<EgovMap> selectVersionRuleBookMngList(Map<String, Object> params);

	/**
	 * simulation item update type cnt
	 * @param params
	 * @return
	 */
	int cntSimulUpdateData(Map<String, Object> params);

	/**
	 * simulation item description update
	 * @param params
	 * @return
	 */
	void udtSimulRuleDescData(Map<String, Object> params);

	/**
	 * simulation update data valid list
	 * @param params
	 * @return
	 */
	List<EgovMap>selectSimulRuleMngChk(Map<String, Object> params);


    List<EgovMap> selectHPDeptCodeListByLv(Map<String, Object> params);

    List<EgovMap> selectHPDeptCodeListByCode(Map<String, Object> params);

}
