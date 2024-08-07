package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AllocationService {
	List<EgovMap> selectList(Map<String, Object> params);

	List<EgovMap> selectDetailList(Map<String, Object> params);

	public List<EgovMap> isMergeHoliDay(Map<String, Object> params);

	public EgovMap isVacation(Map<String, Object> params);

	public List<EgovMap> getBaseList(Map<String, Object> params);

	public int isMergeNosvcDay(Map<String, Object> params);

}
