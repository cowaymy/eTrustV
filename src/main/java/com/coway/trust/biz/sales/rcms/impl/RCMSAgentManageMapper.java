package com.coway.trust.biz.sales.rcms.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("rcmsAgentManageMapper")
public interface RCMSAgentManageMapper {

	List<EgovMap> selectAgentTypeList(Map<String, Object> params);

	List<EgovMap> selectRosCaller(Map<String, Object> params);

	List<EgovMap> selectAssignAgentList(Map<String, Object> params);

	int updateAgent(Map<String, Object> updateMap);

	EgovMap chkUserNameByUserId(Map<String, Object> params);

	int getSeqSAL0148M();

	void insAgentMaster(Map<String, Object> params);

	void updAgentMaster(Map<String, Object> params);

	EgovMap chkDupWebId(Map<String, Object> params);

	List<EgovMap> selectAgentList(Map<String, Object> updateMap);

	List<EgovMap> selectAgentGrpList(Map<String, Object> params);

	void updateCompany(Map<String, Object> updateMap);

	int checkOrderNo(Map<String, Object> params);

	int checkAgentId(Map<String, Object> params);

	EgovMap selectRcmsInfo(Map<String, Object> params);

	void updateRemark(Map<String, Object> params);

	List<EgovMap> selectAssignConvertList(Map<String, Object> params);

	List<EgovMap> selectAssignConvertItemList(Map<String, Object> params);

	List<EgovMap> selectRosCallDetailList(Map<String, Object> params);

	List<EgovMap> rentalStatusListForBadAcc(Map<String, Object> params);

	List<EgovMap> checkCustAgent(Map<String, Object> params);

	List<EgovMap> selectUploadedConversionList(Map<String, Object> params);

	String select_SeqSAL0239D(Map<String, Object> params);

	void insert_SAL0239D(Map<String, Object> params);

	void insert_SAL0240D(Map<String, Object> params);

	void insertUploadedConversionList(Map<String, Object> params);

	void deleteUploadedConversionList(Map<String, Object> params);

	List<EgovMap> selectAgentGroupList(Map<String, Object> updateMap);

	void insAgentGroupMaster(Map<String, Object> params);

	void updAgentGroupMaster(Map<String, Object> params);

	int getSeqSAL0324M();

}
