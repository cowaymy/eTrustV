package com.coway.trust.biz.homecare.services.plan.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.services.plan.HcCapacityListService;
import com.coway.trust.biz.organization.organization.SessionCapacityListService;
import com.coway.trust.biz.organization.organization.impl.SessionCapacityListMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.homecare.HomecareConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("hcCapacityListService")
public class HcCapacityListServiceImpl extends EgovAbstractServiceImpl implements HcCapacityListService{

	@Resource(name = "sessionCapacityListMapper")
	private SessionCapacityListMapper sessionCapacityListMapper;

	@Resource(name = "sessionCapacityListService")
	private SessionCapacityListService sessionCapacityListService;

	/**
	 * Homecare Capacity List 저장
	 * @Author KR-SH
	 * @Date 2019. 11. 19.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcCapacityListService#saveHcCapacityList(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public boolean saveHcCapacityList(Map<String, List<Map<String, Object>>> params, SessionVO sessionVO) {
		if(params == null) return false;

		List<Map<String, Object>> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList

		if(udtList != null) {
			Map<String, Object> selParam = (Map<String, Object>) udtList.get(0);
			selParam.put("memType", HomecareConstants.MEM_TYPE.DT);

			int ctmCnt = sessionCapacityListService.selectCountSsCapacityCTM(selParam);

			updateHcCapacity(udtList, sessionVO);
			// CTM이 하나인 경우만 update 한다.
			if(ctmCnt == 1) {
				updateDTMCapacity(udtList, sessionVO);
			}
			deleteHcCapacity(udtList);
		}

		return true;
	}

	/**
	 * Update Homecare Capacity
	 * @Author KR-SH
	 * @Date 2019. 11. 19.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcCapacityListService#updateHcCapacity(java.util.List, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public int updateHcCapacity(List<Map<String, Object>> params, SessionVO sessionVO) {
		int rtnCnt = 0;
		int upCnt = 0;

		if(params.size() > 0) {
    		for(Map<String, Object>param : params) {
    			param.put("memType", HomecareConstants.MEM_TYPE.DT);
    			param.put("userId", sessionVO.getUserId());

    			upCnt = sessionCapacityListMapper.updateCapacity(param);
    			if(upCnt <= 0) {
    				throw new ApplicationException(AppConstants.FAIL, "Homecare Capacity update Failed.");
    			}
    			rtnCnt += upCnt;
    		}
		}

		return rtnCnt;
	}

	/**
	 * Update Homecare DTM Capacity
	 * @Author KR-SH
	 * @Date 2019. 11. 19.
	 * @param udtList
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcCapacityListService#updateDTMCapacity(java.util.List, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public int updateDTMCapacity(List<Map<String, Object>> params, SessionVO sessionVO) {
		int rtnCnt = 0;

		if(params.size() > 0) {
			Map<String, Object> param = params.get(0);

			param.put("memType", HomecareConstants.MEM_TYPE.DT);
			param.put("userId", sessionVO.getUserId());

			rtnCnt = sessionCapacityListMapper.updateCTMCapacity(param);
			if(rtnCnt <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Homecare Capacity update Failed.");
			}
		}
		return rtnCnt;
	}

	/**
	 * Delete Homecare Capacity
	 * @Author KR-SH
	 * @Date 2019. 11. 19.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcCapacityListService#deleteHcCapacity(java.util.List)
	 */
	@Override
	public int deleteHcCapacity(List<Map<String, Object>> params) {
		return sessionCapacityListMapper.deleteCapacity(params.get(0));
	}

	/**
	 * Homecare Capacity ExcelList 저장
	 * @Author KR-SH
	 * @Date 2019. 11. 19.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcCapacityListService#saveHcCapacityByExcel(java.util.List, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public boolean saveHcCapacityByExcel(List<Map<String, Object>> params, SessionVO sessionVO) {
		if(params != null) {
			Map<String, Object> selParam = (Map<String, Object>) params.get(0);
			selParam.put("memType", HomecareConstants.MEM_TYPE.DT);

			int ctmCnt = sessionCapacityListService.selectCountSsCapacityCTM(selParam);

			sessionCapacityListService.updateCapacityByExcel(params, sessionVO);
			// CTM이 하나인 경우만 update 한다.
			if(ctmCnt == 1) {
				updateDTMCapacity(params, sessionVO);
			}
			deleteHcCapacity(params);
		} else {
			return false;
		}

		return true;
	}

}
