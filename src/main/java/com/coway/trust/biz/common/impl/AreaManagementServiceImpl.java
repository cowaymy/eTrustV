package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AreaManagementService;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("areaManagementService")
public class AreaManagementServiceImpl extends EgovAbstractServiceImpl implements AreaManagementService {

	@Resource(name = "areaManagementMapper")
	private AreaManagementMapper areaManagementMapper;

	@Override
	public List<EgovMap> selectAreaManagement(Map<String, Object> params) throws Exception {
		return areaManagementMapper.selectAreaManagement(params);
	}

	@Override
	public int udtAreaManagement(List<Object> udtList,String loginId) {

		int cnt=0;
		for (Object obj : udtList) {
			((Map<String, Object>) obj).put("updUserId", loginId);

			cnt=cnt+areaManagementMapper.udtAreaManagement((Map<String, Object>) obj);
		}
		return cnt;
	}

	@Override
	public int addCopyAddressMaster(List<Map<String, Object>> addList,String loginId) {
		int rtnCnt=0;
		int saveCnt = 0;

		for (Map<String, Object> obj : addList) {
			obj.put("crtUserId", loginId);
			obj.put("updUserId", loginId);

			saveCnt = areaManagementMapper.addCopyAddressMaster((Map<String, Object>) obj);
			if(saveCnt <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Copy Address Save Failed.");
			}
			rtnCnt += saveCnt;
		}
		return rtnCnt;
	}

	@Override
	public int addCopyOtherAddressMaster(List<Map<String, Object>> addList,String loginId) {
		int rtnCnt=0;
		int saveCnt = 0;

		for (Map<String, Object> obj : addList) {
			obj.put("crtUserId", loginId);
			obj.put("updUserId", loginId);

			saveCnt = areaManagementMapper.addCopyOtherAddressMaster((Map<String, Object>) obj);
			if(saveCnt <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Copy Address Save Failed.");
			}
			rtnCnt += saveCnt;
		}
		return rtnCnt;
	}

	@Override
	public int addOtherAddressMaster(List<Object> addList,String loginId) {

		int cnt=0;

		for (Object obj : addList) {

			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);

			cnt=cnt+areaManagementMapper.addOtherAddressMaster((Map<String, Object>) obj);
		}
		return cnt;
	}

	@Override
	public int addMyAddressMaster(List<Object> addList,String loginId) {

		int cnt=0;

		for (Object obj : addList) {

			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);

			cnt=cnt+areaManagementMapper.addMyAddressMaster((Map<String, Object>) obj);
		}
		return cnt;
	}

	@Override
	public List<EgovMap> selectMyPostcode(Map<String, Object> params) throws Exception {
		return areaManagementMapper.selectMyPostcode(params);
	}

	/**
	 * 동일한 Area 건수 조회.
	 * @Author KR-SH
	 * @Date 2019. 11. 18.
	 * @param paramList
	 * @return
	 * @see com.coway.trust.biz.common.AreaManagementService#isRedupAddCopyAddressMaster(java.util.List)
	 */
	@Override
	public boolean isRedupAddCopyAddressMaster(List<Map<String, Object>> paramList) {
		int cnt=0;

		for (Map<String, Object> obj : paramList) {
			cnt = areaManagementMapper.isRedupAddCopyAddressMaster((Map<String, Object>) obj);
			if(cnt > 0) return true;
		}

		return false;
	}

	@Override
	public List<EgovMap> selectBlackArea(Map<String, Object> params) throws Exception {

		return areaManagementMapper.selectBlackArea(params);
	}

	@Override
	public List<EgovMap> selectProductCategory(Map<String, Object> params) throws Exception {

		return areaManagementMapper.selectProductCategory(params);
	}

	@Override
	public List<EgovMap> selectBlacklistedArea(Map<String, Object> params) throws Exception {

		return areaManagementMapper.selectBlacklistedArea(params);
	}

	  @Override
	  public String insertBlacklistedArea(Map<String, Object> params) {

		List<Object> insList= (List<Object>)params.get(AppConstants.AUIGRID_ALL);
	    Map<String, Object> fMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

	    fMap.put("userId", params.get("userId"));

	    areaManagementMapper.updateBlackAreaStatus(fMap);

	    String seq = areaManagementMapper.selectBlackAreaGroupIdSeq(fMap);

	    fMap.put("seq", seq);

	    areaManagementMapper.updateSys0064mBlckAreaGrpId(fMap);

	    if (insList.size() > 0) {
	      for (int i = 0; i < insList.size(); i++) {
	        Map<String, Object> insMap = (Map<String, Object>) insList.get(i);

	        insMap.put("popAreaId", fMap.get("popAreaId"));
	        insMap.put("seq", seq);
	        insMap.put("userId", params.get("userId"));
	        areaManagementMapper.insBlacklistedArea(insMap);
	      }
	    }

	    return seq;

	  }

}
