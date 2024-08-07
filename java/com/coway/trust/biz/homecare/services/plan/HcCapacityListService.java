package com.coway.trust.biz.homecare.services.plan;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

public interface HcCapacityListService {

	/**
	 * Homecare Capacity List 저장
	 * @Author KR-SH
	 * @Date 2019. 11. 19.
	 * @param udtList
	 * @param sessionVO
	 * @return
	 */
	public boolean saveHcCapacityList(Map<String, List<Map<String, Object>>> params, SessionVO sessionVO);

	/**
	 * Homecare Capacity ExcelList 저장
	 * @Author KR-SH
	 * @Date 2019. 11. 19.
	 * @param udtList
	 * @param sessionVO
	 * @return
	 */
	public boolean saveHcCapacityByExcel(List<Map<String, Object>> params, SessionVO sessionVO);

	/**
	 * Update Homecare Capacity
	 * @Author KR-SH
	 * @Date 2019. 11. 19.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public int updateHcCapacity(List<Map<String, Object>> params, SessionVO sessionVO);

	/**
	 * Update Homecare DTM Capacity
	 * @Author KR-SH
	 * @Date 2019. 11. 19.
	 * @param udtList
	 * @param sessionVO
	 * @return
	 */
	public int updateDTMCapacity(List<Map<String, Object>> params, SessionVO sessionVO);

	/**
	 * Delete Homecare Capacity
	 * @Author KR-SH
	 * @Date 2019. 11. 19.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public int deleteHcCapacity(List<Map<String, Object>> params);

}



