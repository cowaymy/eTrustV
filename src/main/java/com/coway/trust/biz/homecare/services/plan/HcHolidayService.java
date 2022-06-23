package com.coway.trust.biz.homecare.services.plan;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcHolidayService.java
 * @Description : Homecare Holiday Management Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 14.   KR-SH        First creation
 * </pre>
 */
public interface HcHolidayService {

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
	 * Save Homecare Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public ReturnMessage saveHcHoliday(Map<String, List<Map<String, Object>>> params, SessionVO sessionVO)  throws Exception;

	/**
	 * Check Duplication Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param insertValue
	 * @return
	 */
	public boolean checkAlreadyHoliday(Map<String, Object> insertValue);

	/**
	 * Insert Homecare Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public boolean insertHcHoliday(List<Map<String, Object>> params,SessionVO sessionVO);

	/**
	 * update Homecare Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public boolean updateHcHoliday(List<Map<String, Object>> params,SessionVO sessionVO);

	/**
	 * Delete Homecare Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public boolean deleteHcHoliday(List<Map<String, Object>> params,SessionVO sessionVO);


	/**
	 * Save DT Assign
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public ReturnMessage DTAssignSave(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	public ReturnMessage LTAssignSave(Map<String, Object> params, SessionVO sessionVO) throws Exception;

}
