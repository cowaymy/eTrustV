package com.coway.trust.biz.eAccounting.ctDutyAllowance.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ctDutyAllowanceMapper")
public interface CtDutyAllowanceMapper {

	List<EgovMap> selectCtDutyAllowanceList(Map<String, Object> params);

	List<EgovMap> selectTaxCodeCtDutyAllowanceFlag();

	String selectNextClmNo(Map<String, Object> params);

	String selectNextSubClmNo(Map<String, Object> params);

	void insertCtDutyAllowanceExp(Map<String, Object> params);

	int selectNextClmSeq(String clmNo);

	void insertCtDutyAllowanceExpItem(Map<String, Object> params);

	List<EgovMap> selectCtDutyAllowanceItems(String clmNo);

	EgovMap selectCtDutyAllowanceInfo(Map<String, Object> params);

	List<EgovMap> selectAttachList(String atchFileGrpId);

	void updateCtDutyAllowanceExp(Map<String, Object> params);

	void updateCtDutyAllowanceExpItem(Map<String, Object> params);

	void insertApproveLineDetail(Map<String, Object> params);

	void insertApproveItems(Map<String, Object> params);

	void updateAppvPrcssNo(Map<String, Object> params);

	void deleteCtDutyAllowanceExpItem(Map<String, Object> params);

	void updateCtDutyAllowanceExpTotAmt(Map<String, Object> params);

	void updateCtDutyAllowanceMain(Map<String, Object> params);

	List<EgovMap> selectCtDutyAllowanceItemGrp(Map<String, Object> params);



	List<EgovMap> selectSearchInsOrderNo (Map<String, Object> params) throws Exception;
	List<EgovMap> selectSearchAsOrderNo (Map<String, Object> params) throws Exception;
	List<EgovMap> selectSearchPrOrderNo (Map<String, Object> params) throws Exception;

	List<EgovMap> selectSupplier(Map<String, Object> params);

	void updateClmNo(Map<String, Object> params);

	int checkOnceAMonth(Map<String, Object> params);

	List<EgovMap> selectMemberViewByMemCode(Map<String, Object> params); // CT Info

	List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params);

	List<EgovMap> getBch(Map<String, Object> params);

}
