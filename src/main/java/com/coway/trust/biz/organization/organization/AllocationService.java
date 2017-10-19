package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AllocationService {	
	List<EgovMap> selectList(Map<String, Object> params);
	
	List<EgovMap> selectDetailList(Map<String, Object> params);
	
}
