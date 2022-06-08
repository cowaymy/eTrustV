package com.coway.trust.biz.eAccounting.ctDutyAllowance;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.type.FileType;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CtDutyAllowanceService {

	List<EgovMap> selectCtDutyAllowanceList(Map<String, Object> params);

	List<EgovMap> selectTaxCodeCtDutyAllowanceFlag();

	List<EgovMap> selectSearchInsOrderNo(Map<String, Object> params) throws Exception;
	List<EgovMap> selectSearchAsOrderNo(Map<String, Object> params) throws Exception;
	List<EgovMap> selectSearchPrOrderNo(Map<String, Object> params) throws Exception;

	List<EgovMap> selectSupplier(Map<String, Object> params);

	String selectCtDutyAllowanceMainSeq(Map<String, Object> params);

	String selectCtDutyAllowanceSubSeq(Map<String, Object> params);

	void updateCtDutyAllowanceMainSeq(Map<String, Object> params);

	void insertCtDutyAllowanceExp(Map<String, Object> params);

	List<EgovMap> selectCtDutyAllowanceItems(String clmNo);

	void updateCtDutyAllowanceExp(Map<String, Object> params);
	/*

	EgovMap selectCtDutyAllowanceInfo(Map<String, Object> params);

	List<EgovMap> selectAttachList(String atchFileGrpId);

	*/

	void deleteCtDutyAllowanceExpItem(Map<String, Object> params);

	void updateCtDutyAllowanceExpTotAmt(Map<String, Object> params);

	List<EgovMap> selectCtDutyAllowanceItemGrp(Map<String, Object> params);

	void deleteCtDutyAllowanceItem(Map<String, Object> params);

	int checkOnceAMonth(Map<String, Object> params);

	void insertApproveManagement(Map<String, Object> params);

	List<EgovMap> selectMemberViewByMemCode(Map<String, Object> params); // CT Info

	List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params);

	public List<EgovMap> getBch(Map<String, Object> params);

	void updateApprovalInfo(Map<String, Object> params);

	void updateRejectionInfo(Map<String, Object> params);
}
