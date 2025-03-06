package com.coway.trust.biz.api.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.api.vo.chatbotCallLog.CallLogAppointmentReqForm;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("chatbotCallLogApiMapper")
public interface ChatbotCallLogApiMapper {
	int checkIfCallLogEntryAppointmentValid(CallLogAppointmentReqForm params);

	void updateCBT0007MStatus(EgovMap params);

	void updateCCR0006DStatus(EgovMap params);

	List<EgovMap> selectAvailAllocationList(EgovMap params);

	EgovMap selectCallLogOrderInfo(EgovMap params);

	EgovMap selectCallLogCbtOrderInfo(EgovMap params);

	EgovMap selectDocNo(String docNoId);

	void updateDocNo(EgovMap installNo);

	Object installEntryIdSeq();

	void insertInstallEntry(Map<String, Object> installMaster);

	Map<String, Object> SP_LOGISTIC_REQUEST(Map<String, Object> logPram);

	void deleteInstallEntry(Map<String, Object> installMaster);

	Map<String, Object> SP_SVC_LOGISTIC_REQUEST(Map<String, Object> param);

	void updateCallEntry(Map<String, Object> param);

	String selectMaxId(Map<String, Object> param);

	void insertCallResult(Map<String, Object> param);

	EgovMap selectFirstAvailAllocationUser(Map<String, Object> param);

	EgovMap selectOrderEntry(String param);

	void updateASEntry(Map<String,Object> param);

	void insertSalesOrderLog(Map<String,Object> param);

	EgovMap selectRdcStock(Map<String,Object> param);

	EgovMap checkAccess(Map<String,Object> param);

	EgovMap selectAuxCallLogCbtOrderInfo(Map<String,Object> param);
}
