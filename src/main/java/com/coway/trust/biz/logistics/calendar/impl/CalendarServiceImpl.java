package com.coway.trust.biz.logistics.calendar.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.calendar.CalendarService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("calendarService")
public class CalendarServiceImpl implements CalendarService {

	@Resource(name = "calendarMapper")
	private CalendarMapper calendarMapper;

	private static final Logger logger = LoggerFactory.getLogger(CalendarServiceImpl.class);

	@Override
	public List<EgovMap> selectCalendarEventList(Map<String, Object> params) {
		return calendarMapper.selectCalendarEventList(params);
	}

	@Override
	public int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {

		int masterSeq = calendarMapper.selectNextBatchId();
		master.put("batchId", masterSeq);
		int mResult = calendarMapper.saveBatchCalMst(master); // INSERT INTO MSC0050M

		if(mResult > 0 && detailList.size() > 0) {
			for (int i=0; i < detailList.size(); i++) {
				detailList.get(i).put("batchId", masterSeq);
				detailList.get(i).put("batchMemType", master.get("batchMemType"));
		        logger.debug("detailList {}",detailList.get(i));
			}
			calendarMapper.saveBatchCalDetailList(detailList);  // INSERT INTO MSC0051D

			//CALL PROCEDURE
			calendarMapper.callBatchCalUpdList(master); // INSERT INTO MSC0052D
		}

		return masterSeq;
	}
}
