package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.HomecareCmService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HomecareCmServiceImpl.java
 * @Description : Homeccare Common ServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 2.   KR-SH        First creation
 * </pre>
 */
@Service("homecareCmService")
public class HomecareCmServiceImpl implements HomecareCmService {

	@Resource(name = "homecareCmMapper")
	private HomecareCmMapper homecareCmMapper;

	/**
	 * Select Homecare Branch Code List
	 * @Author KR-SH
	 * @Date 2019. 12. 3.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.common.HomecareCmService#selectHomecareBranchCd(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectHomecareBranchCd(Map<String, Object> params) {
		return homecareCmMapper.selectHomecareBranchCd(params);
	}

	/**
	 * Select Homecare Branch List
	 * @Author KR-SH
	 * @Date 2019. 12. 3.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.common.HomecareCmService#selectHomecareBranchList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectHomecareBranchList(Map<String, Object> params) {
		return homecareCmMapper.selectHomecareBranchList(params);
	}

	/**
	 * Select Homecare Branch List
	 * @Author MY-HLTANG
	 * @Date 2023. 02.09.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.common.HomecareCmService#selectHomecareAndDscBranchList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectHomecareAndDscBranchList(Map<String, Object> params) {
		return homecareCmMapper.selectHomecareAndDscBranchList(params);
	}

	/**
	 * Select AC Branch List For Aircon Branch in SYS0064M
	 * @Author FRANGO
	 * @Date 2023. 01. 18.
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectAcBranchList() {
		return homecareCmMapper.selectAcBranchList();
	}

	@Override
	public int checkIfIsAcInstallationProductCategoryCode(Map<String, Object> params) {
		// TODO Auto-generated method stub

		return homecareCmMapper.checkIfIsAcInstallationProductCategoryCode(params.get("stkId").toString());
	}
}