package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("scmBatchMapper")
public interface ScmBatchMapper {
	void insertLog(Map<String, Object> params);
	
	//	Supply Plan RTP
	List<EgovMap> selectTodayWeekTh(Map<String, Object> params);
	List<EgovMap> selectScmIfSeq(Map<String, Object> params);
	List<EgovMap> selectBatchTarget(Map<String, Object> params);
	int updateSupplyPlanRpt(Map<String, Object> params);
	void mergeSupplyPlanRpt(Map<String, Object> params);
	
	//	Otd SO, PP, GI
	void updateOtdSo(Map<String, Object> params);
	void deleteOtdPp(Map<String, Object> params);
	void mergeOtdPp(Map<String, Object> params);
	void mergeOtdGi(Map<String, Object> params);
}