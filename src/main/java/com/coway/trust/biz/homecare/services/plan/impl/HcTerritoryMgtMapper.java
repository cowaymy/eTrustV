package com.coway.trust.biz.homecare.services.plan.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcTerritoryMgtMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 13.   KR-SH        First creation
 * </pre>
 */
@Mapper("hcTerritoryMgtMapper")
public interface HcTerritoryMgtMapper {

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
	 * Insert Territory Management
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @return
	 */
	public int insertHDC(Map<String, Object> params);
	public int insertDSC(Map<String, Object> params);

	public int insertHDCLT(Map<String, Object> params);


	/**
	 * Select Table - ORG0019M
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @return
	 */
	public List<EgovMap> select19M(Map<String, Object> params);

	/**
	 * update Table - SYS0064M
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @return
	 */
	public int updateSYS0064M(EgovMap params);

	/**
	 * update Table - ORG0019M(Flag)
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @return
	 */
	public int updateORG0019MFlag(EgovMap params);

	/**
	 * update Table - ORG0019M
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @return
	 */
	public int updateORG0019M(EgovMap params);

	public int updateSYS0064MLT(EgovMap egovMap);
	public int updateSYS0064MAC(EgovMap egovMap);

}
