package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("complianceCallLogMapper")
public interface ComplianceCallLogMapper {


	List<EgovMap> selectComplianceLog(Map<String, Object> params);

	EgovMap getMemberDetail(Map<String, Object> params);

	void insertCom(Map<String, Object> params);

	void insertComSub(Map<String, Object> params);

	EgovMap selectCheckOrder(Map<String, Object> params);

	EgovMap selectComplianceOrderDetail(Map<String, Object> params);

	int selectComplianceId();

	void insertComplianceOrder(Map<String, Object> params);

	EgovMap selectComplianceNoValue(Map<String, Object> params);

	List<EgovMap> selectOrderDetailComplianceId(Map<String, Object> params);

	List<EgovMap> selectComplianceRemark(Map<String, Object> params);

	EgovMap selectOrder(Map<String, Object> params);

	void updateCo(Map<String, Object> params);

	void updateCom(Map<String, Object> params);

	void insertComCs(Map<String, Object> params);

	EgovMap selectAttachDownload(Map<String, Object> params);

	List<EgovMap> selectComplianceSOID(Map<String, Object> params);

	List<EgovMap> getPicList(Map<String, Object> params);

}

