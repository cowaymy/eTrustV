package com.coway.trust.biz.services.servicePlanning;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HolidayService {
	
	boolean insertHoliday(List<Object> params,SessionVO sessionVO);
	
	boolean updateHoliday(List<Object> params,SessionVO sessionVO);
	
	List<EgovMap> selectHolidayList(Map<String, Object> params);
	
	List<EgovMap> selectCTList(Map<String, Object> params);
	
	List<EgovMap> selectCTAssignList(Map<String, Object> params);
	
	boolean insertCTAssign(List<Object> updList,Map<String , Object> formMap);

}
