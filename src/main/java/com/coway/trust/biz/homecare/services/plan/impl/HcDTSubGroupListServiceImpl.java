package com.coway.trust.biz.homecare.services.plan.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.homecare.services.plan.HcDTSubGroupListService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcDTSubGroupListServiceImpl.java
 * @Description : Homecare DT SubGroup Management ServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 26.   KR-SH        First creation
 * </pre>
 */
@Service("hcDTSubGroupListService")
public class HcDTSubGroupListServiceImpl  extends EgovAbstractServiceImpl implements HcDTSubGroupListService {

	@Resource(name = "hcDTSubGroupListMapper")
	private HcDTSubGroupListMapper hcDTSubGroupListMapper;

	/**
	 * Search DT SubGroup List
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcDTSubGroupListService#selectDtSubGroupList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectDtSubGroupList(Map<String, Object> params) {
		return hcDTSubGroupListMapper.selectDtSubGroupList(params);
	}

	/**
	 * Search DT SubGroup Area List
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcDTSubGroupListService#selectDTSubAreaGroupList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectDTSubAreaGroupList(Map<String, Object> params) {
		return hcDTSubGroupListMapper.selectDTSubAreaGroupList(params);
	}

	/**
	 * Search DT SubGroup DSC List
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcDTSubGroupListService#selectDTSubGroupDscList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectDTSubGroupDscList(Map<String, Object> params) {
		return hcDTSubGroupListMapper.selectDTSubGroupDscList(params);
	}

	@Override
	public List<EgovMap> selectLTSubGroupDscList(Map<String, Object> params) {
		return hcDTSubGroupListMapper.selectLTSubGroupDscList(params);
	}

	/**
	 * Select DTM By DSC
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcDTSubGroupListService#selectDTMByDSC(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectDTMByDSC(Map<String, Object> params) {
		return hcDTSubGroupListMapper.selectDTMByDSC(params);
	}

	/**
	 * Select DT Sub Group
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcDTSubGroupListService#selectDTSubGrp(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectDTSubGrp(Map<String, Object> params) {
		return hcDTSubGroupListMapper.selectDTSubGrp(params);
	}

	/**
	 * DT Sub Group Assign List
	 * @Author KR-SH
	 * @Date 2019. 11. 28.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcDTSubGroupListService#selectAssignDTSubGroup(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectAssignDTSubGroup(Map<String, Object> params) {
		return hcDTSubGroupListMapper.selectAssignDTSubGroup(params);
	}

}
