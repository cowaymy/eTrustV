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

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("calendarService")
public class CalendarServiceImpl extends EgovAbstractServiceImpl implements CalendarService {

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

	public List<EgovMap> selectEventListToManage(Map<String, Object> params) {
		return calendarMapper.selectEventListToManage(params);
	}

	@Override
	public int updRemoveCalItem(Map<String, Object> params) {
		return calendarMapper.updRemoveCalItem(params);
	}

	@Override
	public int saveCalEventChangeList(List<Object> updList, Integer updUserId) {
		int saveCnt = 0;

		for(Object obj : updList) {

			((Map<String, Object>) obj).put("updUserId", updUserId);
			logger.debug(" === Update Calendar event change === ");
			logger.debug(" eventId : {}", ((Map<String, Object>) obj).get("eventId"));
			logger.debug(" eventDt : {}", ((Map<String, Object>) obj).get("eventDt"));
			logger.debug(" memType : {}", ((Map<String, Object>) obj).get("memType"));
			logger.debug(" eventDesc : {}", ((Map<String, Object>) obj).get("eventDesc"));

			saveCnt++;

			calendarMapper.saveCalEventChangeList((Map<String, Object>) obj);
		}

		return saveCnt;
	}
}
