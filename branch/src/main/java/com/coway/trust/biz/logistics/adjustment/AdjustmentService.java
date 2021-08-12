package com.coway.trust.biz.logistics.adjustment;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AdjustmentService {

	String insertNewAdjustment(Map<String, Object> params);

	List<EgovMap> selectAdjustmentList(Map<String, Object> params);

	List<EgovMap> selectAdjustmentLocationList(Map<String, Object> params);

	void insertAdjustmentList(Map<String, Object> params);

	int selectAdjustmentNo(Map<String, Object> params);

	List<EgovMap> selectCodeList(Map<String, Object> params);

	void insertAdjustmentLocAuto(Map<String, Object> params);

	void insertAdjustmentLocManual(Map<String, Object> params);

	List<EgovMap> selectAdjustmentLocationReqList(Map<String, Object> params);

	List<EgovMap> selectAdjustmentDetailLoc(Map<String, Object> params);

	List<EgovMap> selectAdjustmentCountingDetail(Map<String, Object> params);

	List<EgovMap> selectCheckSerial(Map<String, Object> params);

	void insertAdjustmentLocSerial(Map<String, Object> params);

	void insertAdjustmentLocCount(Map<String, Object> params);

	void insertExcel(Map<String, Object> params);

	int updateSaveYn(Map<String, Object> params);

	List<EgovMap> selectAdjustmentApproval(Map<String, Object> params);

	List<EgovMap> selectAdjustmentApprovalCnt(Map<String, Object> params);

	List<EgovMap> selectAdjustmentApprovalLineCheck(Map<String, Object> params);

	void updateApproval(Map<String, Object> params);

	void updateDoc(Map<String, Object> setmap);

	int selectInsertSerialCount(Map<String, Object> params);

	void updateStock(Map<String, Object> setmap);

	List<EgovMap> selectAdjustmentConfirmCheck(Map<String, Object> params);

	void updateAuditToClose(Map<String, Object> params);

}
