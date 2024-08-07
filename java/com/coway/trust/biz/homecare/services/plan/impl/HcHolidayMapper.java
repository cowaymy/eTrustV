package com.coway.trust.biz.homecare.services.plan.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcHolidayMapper.java
 * @Description : Homecare Holiday Management Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 14.   KR-SH        First creation
 * </pre>
 */
@Mapper("hcHolidayMapper")
public interface HcHolidayMapper {

	/**
	 * Select Homecare Holiday List
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectHcHolidayList(Map<String, Object> params);

	/**
	 * Select DT Branch(HDC) Assign Holiday List
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectDTAssignList(Map<String, Object> params);

	public List<EgovMap> selectLTAssignList(Map<String, Object> params);
	/**
	 * Check Duplication Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @return
	 */
	public int selectAlreadyHoliday(Map<String, Object> params);

	/**
	 * Insert Homecare Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 */
	public int  insertHcHoliday(Map<String, Object> params);

	/**
	 * update Homecare Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @return
	 */
	public int  updateHcHoliday(Map<String, Object> params);

	/**
	 * Delete Homecare Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @return
	 */
	public int  deleteHcHoliday(Map<String, Object> params);

	public void insertDTLTAssign(Map<String, Object> insertValue);

	public List<EgovMap> selectDTLTInfo(Map<String, Object> insertValue);

	public void deleteDTLTAssign(Map<String, Object> delValue);

}
