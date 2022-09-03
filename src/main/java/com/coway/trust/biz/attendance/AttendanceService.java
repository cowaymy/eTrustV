package com.coway.trust.biz.attendance;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AttendanceService {

	int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList);

	int saveCsvUpload2(List<Map<String, Object>> detailList, String batchId, String batchMemType);

	int deleteUploadBatch(Map<String, Object> params);

	int approveUploadBatch(Map<String, Object> params);

	int checkDup(Map<String, Object> master);

	int disableBatchCalDtl(Map<String, Object> master);

	void insertApproveLine(Map<String, Object> params);

	List<EgovMap> searchAtdUploadList(Map<String, Object> params);

	List<EgovMap> searchAtdManagementList(Map<String, Object> params);

	void disableBatchCalMst(Map<String, Object> params);

	List<EgovMap> selectManagerCode(Map<String, Object> params);

	List<EgovMap> selectYearList(Map<String, Object> params);


}
