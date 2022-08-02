package com.coway.trust.biz.attendance.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.attendance.AttendanceService;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("AttendanceService")
public class AttendanceServiceImpl implements AttendanceService {

	private static final Logger LOGGER = LoggerFactory.getLogger(AttendanceServiceImpl.class);

    @Resource(name = "AttendanceMapper")
    private AttendanceMapper attendanceMapper;

	@Override
	public int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {

		int masterSeq =0;

		int mResult = attendanceMapper.saveBatchCalMst(master); // INSERT INTO ATD0001M

		if(mResult > 0 && detailList.size() > 0) {

			masterSeq = attendanceMapper.selectCurrentBatchId();
			master.put("batchId", masterSeq);

			for (int i=0; i < detailList.size(); i++) {
				detailList.get(i).put("batchId", master.get("batchId"));
				detailList.get(i).put("batchMemType", master.get("batchMemType"));

			}

			attendanceMapper.saveBatchCalDetailList(detailList);  // INSERT INTO ATD0002D
			attendanceMapper.updateBatchCalMst(master);
		}

		return masterSeq;
	}

	@Override
	public void insertApproveLine(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params  insertApproveLine =====================================>>  " + params);

		List<Object> apprGridList = (List<Object>) params.get("apprGridList");
		List<Object> newGridList = (List<Object>) params.get("newGridList");

		params.put("appvLineCnt", apprGridList.size());

		if (apprGridList.size() > 0) {
			Map hm = null;

			for (Object map : apprGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveLineDetail =====================================>>  " + hm);
				// TODO appvLineDetailTable Insert
				attendanceMapper.insertApproveLineDetail(hm);
			}
		}

		attendanceMapper.updateAttendanceBatch(params);
	}



}
