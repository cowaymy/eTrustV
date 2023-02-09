package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 *
 * @ClassName : HomecareCmMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 2.   KR-SH        First creation
 * </pre>
 */
@Mapper("homecareCmMapper")
public interface HomecareCmMapper {

	/**
	 * Select Homecare Branch Code List
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

	/**
	 * Select AC Branch List For Aircon Branch in SYS0064M
	 * @Author KR-SH
	 * @Date 2023. 01. 18.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectAcBranchList();

	public int checkIfIsAcInstallationProductCategoryCode(String stkId);
}
