package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HomecareCmService.java
 * @Description : Homeccare Common Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 2.   KR-SH        First creation
 * </pre>
 */
public interface HomecareCmService {

	/**
	 * Select Homecare Branch CodeList
	 * @Author KR-SH
	 * @Date 2019. 12. 2.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectHomecareBranchCd(Map<String, Object> params);

	/**
	 * Select Homecare Branch List
	 * @Author KR-SH
	 * @Date 2019. 12. 2.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectHomecareBranchList(Map<String, Object> params);

	public List<EgovMap> selectHomecareAndDscBranchList(Map<String, Object> params);

	int checkIfIsAcInstallationProductCategoryCode(Map<String, Object> params);

	public List<EgovMap> selectAcBranchList();

}