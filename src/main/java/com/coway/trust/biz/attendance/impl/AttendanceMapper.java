package com.coway.trust.biz.attendance.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("AttendanceMapper")

public interface AttendanceMapper {

	int saveBatchCalMst(Map<String, Object> master);

	int saveBatchCalDetailList(List<Map<String, Object>> detailList);

	int updateBatchCalMst(Map<String, Object> params);

	int disableBatchCalDtl(Map<String, Object> params);

	int deleteUploadBatch(Map<String, Object> params);

	int approveUploadBatch(Map<String, Object> params);

	int selectCurrentBatchId();

    void insertApproveLineDetail(Map<String, Object> params);

    void updateAttendanceBatch(Map<String, Object> params);

    List<EgovMap> searchAtdUploadList(Map<String, Object> params);

    List<EgovMap> searchAtdManagementList(Map<String, Object> params);

    int checkDup(Map<String, Object> params);

    void disableBatchCalMst(Map<String, Object> params);

    List<EgovMap> selectManagerCode(Map<String, Object> params);

    Map<String, Object>  SP_ATD_RATE_CALCULATION (Map<String, Object> param);

}
