package com.coway.trust.biz.eAccounting.creditCard;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CreditCardAllowancePlanService {
	List<EgovMap> getCreditCardHolderList(Map<String, Object> params);

	EgovMap getCreditCardHolderDetail(Map<String, Object> params);

	void updateAllowancePlanList(Map<String, Object> params);

	List<EgovMap> getAllowanceLimitDetailPlanList(Map<String, Object> params);

    ReturnMessage createAllowanceDetailLimitPlan(Map<String, Object> params, SessionVO sessionVO);

	ReturnMessage removeAllowanceLimitDetailPlan(Map<String, Object> params, SessionVO sessionVO);

	EgovMap getAllowanceLimitDetailPlan(Map<String, Object> params);

	ReturnMessage editAllowanceLimitDetailPlan(Map<String, Object> params, SessionVO sessionVO);
}
