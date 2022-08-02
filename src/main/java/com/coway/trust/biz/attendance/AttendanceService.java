package com.coway.trust.biz.attendance;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AttendanceService {

	int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList);

	void insertApproveLine(Map<String, Object> params);

}
