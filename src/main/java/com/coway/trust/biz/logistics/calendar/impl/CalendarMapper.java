package com.coway.trust.biz.logistics.calendar.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("calendarMapper")
public interface CalendarMapper {

	List<EgovMap> selectCalendarEventList(Map<String, Object> params);

	int selectNextBatchId();

	int saveBatchCalMst(Map<String, Object> master);

	int getMSC0051DSEQ();

	int saveBatchCalDetailList(List<Map<String, Object>> detailList);

	void callBatchCalUpdList(Map<String, Object> params);

	List<EgovMap> selectEventListToManage(Map<String, Object> params);

	int updRemoveCalItem(Map<String, Object> params);

	int saveCalEventChangeList(Map<String, Object> obj);
}
