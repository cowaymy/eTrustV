package com.coway.trust.biz.eAccounting.ePR;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ePRMapper")
public interface ePRMapper {
	EgovMap selectUserCostCenter(Map<String, Object> p);
	int selectRequestId();
	int insertRequestDraft(Map<String, Object> p);
	int updateRequestDraft(Map<String, Object> p);
	int updateRequest(Map<String, Object> p);
	int ePRApproval(Map<String, Object> p);
	int updateRequestFinal(Map<String, Object> p);
	int deleteDeliverDet(Map<String, Object> p);
	int insertDeliverDet(Map<String, Object> p);
	int insertEditHist(Map<String, Object> p);
	EgovMap currAF(Map<String, Object> p);
	void updateRciv(Map<String, Object> p);
	void updateAssign(Map<String, Object> p);
	int insertRequestItems(Map<String, Object> p);
	int insertApprovalLine(Map<String, Object> p);
	void deleteRequest(Map<String, Object> p);
	void deleteRequestItems(Map<String, Object> p);
	List<EgovMap> selectRequests(Map<String, Object> p);
	EgovMap selectRequest(Map<String, Object> p);
	int cancelEPR(Map<String, Object> p);
	List<EgovMap> selectDeliveryInfo(Map<String, Object> p);
	EgovMap getFinalApprv();
	EgovMap getCurrApprv(Map<String, Object> p);
	int updateRequestSPC(Map<String, Object> p);
	List<EgovMap> getSPCMembers();
	String getMemberEmail(Map<String, Object> p);
}