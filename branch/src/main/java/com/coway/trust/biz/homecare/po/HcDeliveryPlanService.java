package com.coway.trust.biz.homecare.po;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcDeliveryPlanService {

	// main List 조회
	public int selectHcDeliveryPlanMainListCnt(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectHcDeliveryPlanMainList(Map<String, Object> params) throws Exception;

	// Detail List 조회
	public List<EgovMap> selectHcDeliveryPlanSubList(Map<String, Object> params) throws Exception;

	// Plan 조회
	public List<EgovMap> selectHcDeliveryPlanPlan(Map<String, Object> params) throws Exception;

	// Plan Cnt 조회
	public int selectHcDeliveryPlanPlanCnt(Map<String, Object> params) throws Exception;


	public int deleteHcPoPlan(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	// save
	public int multiHcPoPlan(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

}