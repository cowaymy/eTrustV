package com.coway.trust.biz.homecare.services.plan;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcTerritoryMgtService.java
 * @Description : Homecare Territory Management Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 13.   KR-SH        First creation
 * </pre>
 */
public interface HcTerritoryMgtService {

	/**
	 * select Homecare territoryList DetailList
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectHcTerritoryDetailList(Map<String, Object> params);

	/**
	 * Search Current Territory list
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectCurrentHcTerritory(Map<String, Object> params);

	/**
	 * update TerritoryList
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @return
	 */
	public boolean updateHcTerritoryList(Map<String, Object> params);

	/**
	 * Excel Update
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public EgovMap  uploadExcel(Map<String, Object> params,SessionVO sessionVO);

}
