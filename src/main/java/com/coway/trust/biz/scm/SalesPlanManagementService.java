package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SalesPlanManagementService {
	List<EgovMap> selectSalesPlanHeader(Map<String, Object> params);
	List<EgovMap> selectSalesPlanInfo(Map<String, Object> params);
	List<EgovMap> selectSplitInfo(Map<String, Object> params);
	List<EgovMap> selectChildField(Map<String, Object> params);
	List<EgovMap> selectSalesPlanList(Map<String, Object> params);
	int insertSalesPlanMaster(Map<String, Object> params, SessionVO sessionVO);
	int updateSalesPlanDetail(List<Object> updList, SessionVO sessionVO);
	int updateSalesPlanMaster(Map<String, Object> params, SessionVO sessionVO);
}
