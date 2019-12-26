package com.coway.trust.biz.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ReportBatchService {

	void insertLog(Map<String, Object> params);
}
