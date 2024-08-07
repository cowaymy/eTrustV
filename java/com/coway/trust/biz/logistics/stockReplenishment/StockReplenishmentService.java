package com.coway.trust.biz.logistics.stockReplenishment;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface StockReplenishmentService {

	List<EgovMap> selectWeekList(Map<String, Object> params);

	List<EgovMap> selectSroCodyList(Map<String, Object> params);

	List<EgovMap> selectSroRdcList(Map<String, Object> params);

	List<EgovMap> selectSroList(Map<String, Object> params);

	List<EgovMap> selectSroSafetyLvlList(Map<String, Object> params);

	int updateMergeLOG0119M(Map<String, Object> params);

	List<EgovMap> selectSroLocationType(Map<String, Object> params);

	List<EgovMap> selectSroStatus(Map<String, Object> params);

	List<EgovMap> selectWeeklyList(Map<String, Object> params);

	int saveSroCalendarGrid(List<Object> dataList, String userId);

	List<EgovMap> selectYearList(Map<String, Object> params);

	List<EgovMap> selectMonthList(Map<String, Object> params);

}
