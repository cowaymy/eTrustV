package com.coway.trust.biz.attendance;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AttendanceService {

	int saveCsvUpload(Map<String, Object> params);

	int saveBatchCalMst(Map<String, Object> master);

	int deleteUploadBatch(Map<String, Object> params);

	int approveUploadBatch(Map<String, Object> params);

	int checkDup(Map<String, Object> master);

	int disableBatchCalDtl(Map<String, Object> master);

	int disableBatchAtdRate(Map<String, Object> master);

	List<EgovMap> searchAtdUploadList(Map<String, Object> params);

	List<EgovMap> searchAtdManagementList(Map<String, Object> params);

	void disableBatchCalMst(Map<String, Object> params);

	List<EgovMap> selectManagerCode(Map<String, Object> params);

	int checkIfHp(Map<String, Object> p);

	List<EgovMap> selectYearList(Map<String, Object> params);

	List<EgovMap> getDownline(Map<String, Object> params);

	List<EgovMap> getDownlineHP(Map<String, Object> params);

	List<EgovMap> getMemberInfo(Map<String, Object> params);

	List<EgovMap> selectExcelAttd(Map<String, Object> params);

	String getMemCode(Map<String, Object> params);

	List<EgovMap> selectHPReporting(Map<String, Object> p);

	List<EgovMap> getReportingBranch();

	String atdMigrateMonth();

	String getAttendanceRaw(Map<String, Object> params) throws ParseException;
}
