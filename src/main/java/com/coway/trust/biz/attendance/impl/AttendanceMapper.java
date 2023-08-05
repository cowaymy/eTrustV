package com.coway.trust.biz.attendance.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("AttendanceMapper")

public interface AttendanceMapper {

	int saveBatchCalMst(Map<String, Object> master);

	int saveBatchCalDetailList(Map<String, Object> detailList);

	int updateBatchCalMst(Map<String, Object> params);

	int disableBatchAtdRate(Map<String, Object> params);

	int disableBatchCalDtl(Map<String, Object> params);

	int deleteUploadBatch(Map<String, Object> params);

	List<EgovMap> getTransferData(Map<String, Object> p);

	int approveUploadBatch(Map<String, Object> params);

	int selectCurrentBatchId();

    List<EgovMap> searchAtdUploadList(Map<String, Object> params);

    List<EgovMap> searchAtdManagementList(Map<String, Object> params);

    List<EgovMap> selectYearList(Map<String, Object> params);

    int checkDup(Map<String, Object> params);

    void disableBatchCalMst(Map<String, Object> params);

    List<EgovMap> selectManagerCode(Map<String, Object> params);

    int checkIfHp(Map<String, Object> p);

    Map<String, Object> atdRateCalculation (Map<String, Object> param);

    int updateManagerCode(Map<String, Object> params);

    List<EgovMap> getDownline(Map<String, Object> params);

    List<EgovMap> getDownlineHP(Map<String, Object> params);

    List<EgovMap> getMemberInfo(Map<String, Object> params);

    List<EgovMap> selectExcelAttd(Map<String, Object> params);

    String getMemCode(Map<String, Object> params);

    List<EgovMap> selectHPReporting(Map<String, Object> p);

    List<EgovMap> getReportingBranch();

    String atdMigrateMonth();
}
