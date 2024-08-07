/**
 *
 */
package com.coway.trust.biz.homecare.po.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.po.HcDeliveryPlanService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Service("hcDeliveryPlanService")
public class HcDeliveryPlanServiceImpl extends EgovAbstractServiceImpl implements HcDeliveryPlanService {

	//private static Logger logger = LoggerFactory.getLogger(HcPoIssueServiceImpl.class);

	@Resource(name = "hcDeliveryPlanMapper")
	private HcDeliveryPlanMapper hcDeliveryPlanMapper;

	@Override
	public int selectHcDeliveryPlanMainListCnt(Map<String, Object> params) throws Exception{
		return hcDeliveryPlanMapper.selectHcDeliveryPlanMainListCnt(params);
	}

	@Override
	public List<EgovMap> selectHcDeliveryPlanMainList(Map<String, Object> params) throws Exception{
		return hcDeliveryPlanMapper.selectHcDeliveryPlanMainList(params);
	}

	@Override
	public List<EgovMap> selectHcDeliveryPlanSubList(Map<String, Object> params) throws Exception{
		return hcDeliveryPlanMapper.selectHcDeliveryPlanSubList(params);
	}

	@Override
	public List<EgovMap> selectHcDeliveryPlanPlan(Map<String, Object> params) throws Exception{
		return hcDeliveryPlanMapper.selectHcDeliveryPlanPlan(params);
	}

	@Override
	public int selectHcDeliveryPlanPlanCnt(Map<String, Object> params) throws Exception{
		return hcDeliveryPlanMapper.selectHcDeliveryPlanPlanCnt(params);
	}

	@Override
	public int deleteHcPoPlan(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		return hcDeliveryPlanMapper.deleteHcPoPlan(params);
	}

	@Override
	public int multiHcPoPlan(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		int saveCnt = 0;
		List<Object> planList = (List<Object>)params.get("planData");

		Map<String, Object> delParam = new HashMap<String, Object>();
		delParam.put("poNo", ((Map<String, Object>) planList.get(0)).get("poNo"));
		deleteHcPoPlan(delParam, sessionVO);

		Map<String, Object> planMap = null;
		for (Object obj : planList) {
			planMap = (Map<String, Object>) obj;
			planMap.put("crtUserId", sessionVO.getUserId());
			planMap.put("updUserId", sessionVO.getUserId());

			hcDeliveryPlanMapper.insertHcPoPlan(planMap);

			saveCnt++;
		}

		List<EgovMap>  compare = hcDeliveryPlanMapper.selectPlanCompare(delParam);
		BigDecimal zero = new BigDecimal(0);
		for(EgovMap map : compare){
			if(((BigDecimal)map.get("different")).compareTo(zero) == -1 ){
				throw new ApplicationException(AppConstants.FAIL, "Production Qty cannot be greater than Confirm Qty.");
			}
		}

		return saveCnt;
	}

}