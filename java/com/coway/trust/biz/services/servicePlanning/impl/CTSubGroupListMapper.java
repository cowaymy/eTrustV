package com.coway.trust.biz.services.servicePlanning.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("CTSubGroupListMapper")
public interface CTSubGroupListMapper {

	List<EgovMap> selectCTSubGroupList(Map<String, Object> params);

	void insertCTSubGroup(Map<String, Object> params);

	List<EgovMap> selectCTAreaSubGroupList(Map<String, Object> params);

	void insertCTSubAreaGroup(Map<String, Object> params);

	List<EgovMap> selectCTSubGroupDscList(Map<String, Object> params);

	List<EgovMap> selectCTM(Map<String, Object> params);

	List<EgovMap> selectCTMByDSC(Map<String, Object> params);

	List<EgovMap> selectCTSubGrb(Map<String, Object> params);

	List<EgovMap> selectCTSubGroupMajor(Map<String, Object> params);

	int selectOneCTSubGrb(Map<String, Object> insertValue);

	int insertSvc0054m(Map<String, Object> insertValue);

	int deleteSvc0054m(Map<String, Object> insertValue);

	List<EgovMap> selectNotChooseCTSubGrb(Map<String, Object> insertValue);

	int selectOneMainGroup(Map<String, Object> params);

	int insertMajorgroup(Map<String, Object> params);

	int updateMajorgroup(Map<String, Object> params);

	int updateNotMajorGroup(Map<String, Object> params);

	EgovMap selectAlreadyCTSubGrb(Map<String, Object> insertValue);

	/**
	 * 월달력 조회
	 * @Author KR-SH
	 * @Date 2019. 11. 21.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectMonthCalendar(Map<String, Object> params);

	/**
	 * select Sub Group Service Day List
	 * @Author KR-SH
	 * @Date 2019. 11. 21.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectSubGroupServiceDayList(Map<String, Object> params);

	/**
	 * Insert Sub Group Service Day
	 * @Author KR-SH
	 * @Date 2019. 11. 25.
	 * @param params
	 * @return
	 */
	public int insert_ORG0028M(Map<String, Object> params);

	/**
	 * Delete Sub Group Service Day
	 * @Author KR-SH
	 * @Date 2019. 11. 25.
	 * @param params
	 * @return
	 */
	public int delete_ORG0028M(Map<String, Object> params);

	/**
	 * Insert Sub Group Service Day - History Table
	 * @Author KR-SH
	 * @Date 2019. 11. 25.
	 * @param params
	 * @return
	 */
	public int insert_ORG0029H(Map<String, Object> params);

	/**
	 * Insert Sub Group Service Day
	 * @Author KR-SH
	 * @Date 2019. 11. 25.
	 * @param params
	 * @return
	 */
	public void saveAllSubGroupServiceDayList(Map<String, Object> params);

}
