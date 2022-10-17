package com.coway.trust.biz.sales.ownershipTransfer.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ownershipTransferMapper")
public interface OwnershipTransferMapper {

	List<EgovMap> selectStatusCode();

	List<EgovMap> selectRootList(Map<String, Object> params) throws Exception;

	List<EgovMap> rootCodeList(Map<String, Object> params);

	List<EgovMap> getSalesOrdId(String params);

	// Request Save Data Insertion - Get ID data preparation
	int getRootID();

	EgovMap selectDocNo();

	int updateDocNo(Map<String, Object> params);

	int getRentPaySetID(Map<String, Object> params);

	int getInstID(Map<String, Object> params);

	// New CUST_BILL_ID for new group
	int getCustBillID();

	// New CCP ID for new ROT
	int getRotCcpId();

	// Request Save Data Insertion - Start
	// ROT Master
	int insertSAL0275M(Map<String, Object> params);

	// ROT Detail
	int insertSAL0276D(Map<String, Object> params);

	// ROT CCP Detail
	int insertSAL0277D(Map<String, Object> params);

	// ROT RentPaySet Staging
	int insertSAL0279D(Map<String, Object> params);

	// ROT Installation Staging
	int insertSAL0282D(Map<String, Object> params);

	// ROT Bill Grouping Staging (ROT Order new group INSERT)
	int insertSAL0280D_new(Map<String, Object> params);

	// ROT Bill Grouping ID Staging Update
	int updateSAL0276D_CustBill(Map<String, Object> params);

	// ROT Bill Grouping Staging (ROT Order exist group UPDATE)
	int insertSAL0280D_ex(Map<String, Object> params);

	// Request Save Data Insertion - End

	// ROT Update - Start
	List<EgovMap> getAttachments(Map<String, Object> params);

	EgovMap getAttachmentInfo(Map<String, Object> params);

	// ROT Update - CCP data fetching
	EgovMap getCcpByCcpId(Map<String, Object> params) throws Exception;

	EgovMap selectCcpInfoByCcpId(Map<String, Object> params) throws Exception;

	// ROT Update - ROT general data fetching
	EgovMap selectRootDetails(Map<String, Object> params);

	List<EgovMap> selectRotCallLog(Map<String, Object> params) throws Exception;

	List<EgovMap> selectRotHistory(Map<String, Object> params) throws Exception;

	// ROT Update - ROT Call Log insert
	int insCallLog(Map<String, Object> params);

	// ROT CCP related queries
	int updateCcpDecision(Map<String, Object> params) throws Exception;

	int updateCcpDecisionStatus(Map<String, Object> params) throws Exception;

	int insertCcpDecision(Map<String, Object> params) throws Exception;

	List<EgovMap> getCcpDecisionList(Map<String, Object> params) throws Exception;

	// ROT Final status update (Approved, Reject)
	int updateSAL0277D_stus(Map<String, Object> params) throws Exception;

	// ROT Approved merge from staging to actual tables
	int insertSAL0004D_ROT(Map<String, Object> params) throws Exception;

	int mergeSAL0074D_ROT(Map<String, Object> params) throws Exception;

	int insertSAL0024D_ROT(Map<String, Object> params) throws Exception;

	int updateSAL0001D_ROT(Map<String, Object> params) throws Exception;

	EgovMap getExistCustBill_SAL0280D(Map<String, Object> params) throws Exception;

	int updateSAL0280D_ex(Map<String, Object> params) throws Exception;

	int updateSAL0024D_ROT(Map<String, Object> params) throws Exception;

	int mergeSAL0045D_ROT(Map<String, Object> params) throws Exception;

	EgovMap selectMemberByMemberIDCode(Map<String, Object> params) ;

	int updateSAL0276D_rotReason(Map<String, Object> params);

	EgovMap selectRequestorInfo(Map<String, Object> params);

	EgovMap checkBundleInfo(Map<String, Object> params);

	EgovMap checkBundleInfoCcp(Map<String, Object> params);

	EgovMap checkActRot(Map<String, Object> params) ;

	int getRootGrpID();

	int updRootGrpId(Map<String, Object> params);

	EgovMap checkRootGrpId(Map<String, Object> params);
}
