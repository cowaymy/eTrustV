package com.coway.trust.biz.services.servicePlanning;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CTSubGroupListService {

	List<EgovMap>  selectCTSubGroupList(Map<String, Object> params);

	void insertCTSubGroup(List<Object> params);

	void updateCTSubGroupByExcel(List<Map<String, Object>> updateList);

	List<EgovMap>  selectCTAreaSubGroupList(Map<String, Object> params);

	void insertCTSubAreaGroup(List<Object> params);

	void updateCTAreaByExcel(List<Map<String, Object>> updateList);

	List<EgovMap>  selectCTSubGroupDscList(Map<String, Object> params);

	List<EgovMap>  selectCTM(Map<String, Object> params);

	List<EgovMap>  selectCTMByDSC(Map<String, Object> params);

	List<EgovMap>  selectCTSubGrb(Map<String, Object> params);

	List<EgovMap> selectCTSubGroupMajor(Map<String, Object> params);

	int ctSubGroupSave(Map<String, Object> params, SessionVO sessionVO);

	/**
	 * 월단위 년달력 조회
	 * @Author KR-SH
	 * @Date 2019. 11. 21.
	 * @param params
	 * @return
	 */
	public Map<String, List<EgovMap>> selectYearCalendar(Map<String, Object> params);

	/**
	 * select Sub Group Service Day List
	 * @Author KR-SH
	 * @Date 2019. 11. 21.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectSubGroupServiceDayList(Map<String, Object> params);

	/**
	 * Save Sub Group Service Day List
	 * @Author KR-SH
	 * @Date 2019. 11. 22.
	 * @param params
	 * @return
	 */
	public ReturnMessage saveSubGroupServiceDayList(Map<String, Object> params, SessionVO sessionVO);

	/**
	 * Save All Sub Group Service Day List
	 * @Author KR-SH
	 * @Date 2019. 11. 25.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public ReturnMessage saveAllSubGroupServiceDayList(Map<String, Object> params, SessionVO sessionVO);

	/**
	 * Insert Sub Group Service Day
	 * @Author KR-SH
	 * @Date 2019. 11. 22.
	 * @param params
	 * @return
	 */
	public int insert_ORG0028M(Map<String, Object> params);

	/**
	 * Delete Sub Group Service Day
	 * @Author KR-SH
	 * @Date 2019. 11. 22.
	 * @param params
	 * @return
	 */
	public int delete_ORG0028M(Map<String, Object> params);

	/**
	 * Insert Sub Group Service Day - History Table
	 * @Author KR-SH
	 * @Date 2019. 11. 22.
	 * @param params
	 * @return
	 */
	public int insert_ORG0029H(Map<String, Object> params);

	/**
	 * Save CT Sub Group
	 * @Author KR-SH
	 * @Date 2019. 11. 28.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public ReturnMessage saveCTSubGroup(List<Map<String, Object>> params, SessionVO sessionVO);

}
