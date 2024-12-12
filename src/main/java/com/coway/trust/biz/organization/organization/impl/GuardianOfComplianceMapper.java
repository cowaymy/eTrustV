package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("guardianOfComplianceMapper")
public interface GuardianOfComplianceMapper {


	List<EgovMap> selectGuardianofComplianceList(Map<String, Object> params);

	List<EgovMap> selectGuardianofComplianceListCodyHP(Map<String, Object> params);

	int   saveGuardian(Map<String, Object> params);

	List<EgovMap> selectSalesOrdNoInfo(Map<String, Object> params);

	EgovMap selectGuardianofComplianceInfo(Map<String, Object> params);

	List<EgovMap> selectGuardianRemark(Map<String, Object> params);

	EgovMap selectGuardianNoValue(Map<String, Object> params);

	void updateGuar(Map<String, Object> params);

	void insertGuarSub(Map<String, Object> params);

	void insertCom(Map<String, Object> params);

	int selectComplianceId();

	void insertComplianceOrder(Map<String, Object> params);

	void insertComSub(Map<String, Object> params);

	List<EgovMap> selectOrderList(Map<String, Object> params);

	EgovMap selectMemberByMemberIDCode(Map<String, Object> params);

	EgovMap selectAttachDownload(Map<String, Object> params);

	void updateGuarContent(Map<String, Object> params);

    List<EgovMap> selectReasonCodeList(Map<String, Object> params);

	EgovMap selectDocNoExpand(String code);

	void updateDocNo(Map<String, Object> params);

	List<EgovMap> selectGuardianofComplianceListSearch(Map<String, Object> params);

	List<EgovMap> getSubCatList(Map<String, Object> params);

	void gocApprove(Map<String, Object> params);

	void gocReject(Map<String, Object> params);

	void insertGuarSubApprove(Map<String, Object> params);
}

