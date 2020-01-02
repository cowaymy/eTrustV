package com.coway.trust.biz.homecare.services.as.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.services.as.HcASManagementListService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 * -----------------------------------------------------------------------------
 * 11/12/2019    KR-JIN      1.0.0       - Restructure File
 *********************************************************************************************/

@Service("hcASManagementListService")
public class HcASManagementListServiceImpl extends EgovAbstractServiceImpl implements HcASManagementListService {

	@Resource(name = "hcASManagementListMapper")
	private HcASManagementListMapper hcASManagementListMapper;

	@Override
	public String getSearchDtRange() throws Exception{
		return hcASManagementListMapper.getSearchDtRange();
	}

	@Override
	public List<EgovMap> selectAsTyp() throws Exception{
		return hcASManagementListMapper.selectAsTyp();
	}

	@Override
	public List<EgovMap> selectAsStat() throws Exception{
		return hcASManagementListMapper.selectAsStat();
	}

	@Override
	public List<EgovMap> selectHomeCareBranchWithNm() throws Exception{
		return hcASManagementListMapper.selectHomeCareBranchWithNm();
	}

	@Override
	public List<EgovMap> selectCTByDSC(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.selectCTByDSC(params);
	}

	@Override
	public List<EgovMap> selectCTByDSCSearch(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.selectCTByDSCSearch(params);
	}

	@Override
	public List<EgovMap> getErrMstList(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getErrMstList(params);
	}

	@Override
	public List<EgovMap> selectASManagementList(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.selectASManagementList(params);
	}

	@Override
	public EgovMap selectOrderBasicInfo(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.selectOrderBasicInfo(params);
	}

	@Override
	public List<EgovMap> getASHistoryList(Map<String, Object> params) throws Exception{
	    return hcASManagementListMapper.getASHistoryList(params);
	}

	@Override
	public List<EgovMap> getBSHistoryList(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getBSHistoryList(params);
	}

	@Override
	public List<EgovMap> getBrnchId(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getBrnchId(params);
	}

	@Override
	public List<EgovMap> assignCtList(Map<String, Object> params) throws Exception{
	    return hcASManagementListMapper.assignCtList(params);
	}

	@Override
	public List<EgovMap> assignCtOrderList(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.assignCtOrderList(params);
	}

	@Override
	public List<EgovMap> getASFilterInfo(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getASFilterInfo(params);
	}
	@Override
	public List<EgovMap> getASFilterInfoOld(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getASFilterInfoOld(params);
	}

	@Override
	public List<EgovMap> getASRulstSVC0004DInfo(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getASRulstSVC0004DInfo(params);
	}

    @Override
    public int updateAssignCT(Map<String, Object> params) throws Exception{
      List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
      int rtnValue = -1;

      if (updateItemList.size() > 0) {

        for (int i = 0; i < updateItemList.size(); i++) {
          Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
          updateMap.put("updator", params.get("updator"));
          rtnValue = hcASManagementListMapper.updateAssignCT(updateMap);
        }
      }
      return rtnValue;
    }

    @Override
    public List<EgovMap> selectLbrFeeChr() throws Exception{
    	return hcASManagementListMapper.selectLbrFeeChr();
    }

}
