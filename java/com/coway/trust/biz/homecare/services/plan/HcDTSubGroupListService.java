package com.coway.trust.biz.homecare.services.plan;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcDTSubGroupListService.java
 * @Description : Homecare DT SubGroup Management Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 26.   KR-SH        First creation
 * </pre>
 */
public interface HcDTSubGroupListService {

	/**
	 * Search DT SubGroup List
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectDtSubGroupList(Map<String, Object> params);

	/**
	 * Search DT SubGroup Area List
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 */
	public List<EgovMap>  selectDTSubAreaGroupList(Map<String, Object> params);

	/**
	 * Search DT SubGroup DSC List
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 */
	public List<EgovMap>  selectDTSubGroupDscList(Map<String, Object> params);

	public List<EgovMap> selectLTSubGroupDscList(Map<String, Object> params);

	/**
	 * Select DTM By DSC
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 */
	public List<EgovMap>  selectDTMByDSC(Map<String, Object> params);

	/**
	 * Select DT Sub Group
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 */
	public List<EgovMap>  selectDTSubGrp(Map<String, Object> params);

	/**
	 * DT Sub Group Assign List
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 */
	public List<EgovMap>  selectAssignDTSubGroup(Map<String, Object> params);


}
