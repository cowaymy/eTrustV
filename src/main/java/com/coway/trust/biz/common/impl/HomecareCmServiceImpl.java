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

}