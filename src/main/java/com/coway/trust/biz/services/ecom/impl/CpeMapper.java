package com.coway.trust.biz.services.ecom.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("cpeMapper")
public interface CpeMapper {

	public List<EgovMap> getCpeStat(Map<String, Object> params);

	public List<EgovMap> selectMainDept();

	public List<EgovMap> selectSubDept(Map<String, Object> params);

	public EgovMap getOrderId(Map<String, Object> params);

	public List<EgovMap> selectSearchOrderNo(Map<String, Object> params) throws Exception;

	public List<EgovMap> selectRequestType();

	public List<EgovMap> getSubRequestTypeList(Map<String, Object> params);

	public void insertCpeReqst(Map<String, Object> params);

	public int selectNextCpeId();

	public String selectNextCpeAppvPrcssNo();

	void insertCpeApproveManagement(Map<String, Object> params);

	public void insertCpeApproveLineDetail(Map hm);

	public void insertCpeRqstApproveItems(Map<String, Object> params);

	public void updateCpeRqstAppvPrcssNo(Map<String, Object> params);

	public List<EgovMap> selectCpeRequestList(Map<String, Object> params);

	public EgovMap selectRequestInfo(Map<String, Object> params);

	public void insertCpeRqstDetail(Map<String, Object> params);

	public List<EgovMap> selectCpeDetailList(Map<String, Object> params);

	public void updateCpeStatusMain(Map<String, Object> params);

	public List<EgovMap> getApproverList(Map<String, Object> params);

	public EgovMap getOrderDscCode(String orderDscCode);

	public List<EgovMap> selectIssueTypeList(Map<String, Object> params);

	public List<EgovMap> selectCpeHistoryDetailPop(Map<String, Object> params);

	public EgovMap selectUserBranch(Map<String, Object> params);

	public EgovMap selectUserMemberLevel(Map<String, Object> params);

	public int checkExistingCpeRequestStatusActive(Map<String, Object> params);

	public int checkExistingEcpeRequestStatusActive(Map<String, Object> params);

	public EgovMap selectOrderInfo(Map<String, Object> params);

	public List<EgovMap> selectReason();

	public List<EgovMap> selectEcpeMainDept();

	public void insertEcpeReqst(Map<String, Object> params);

	public int selectNextEcpeId();

	public List<EgovMap> selectEcpeRequestList(Map<String, Object> params);

	public EgovMap selectEcpeCurrentRequestInfo(Map<String, Object> params);

	public List<EgovMap> getEcpeHistoryList(Map<String, Object> params);

	public void ecpeTransfer(Map<String, Object> params);

	List<EgovMap> selectDscBranch(Map<String, Object> params);

	public void ecpeApprove(Map<String, Object> params);

	public void ecpeReject(Map<String, Object> params);

	int insertAddNewAddress(Map<String, Object> param);

	int insertCustContact(Map<String, Object> param);

	public void updateStatusAddId(Map<String, Object> params);

	public void updateStatusCntcId(Map<String, Object> params);

	public void updateEcpeSal0001d(Map<String, Object> params);

	public void updateEcpeSal0045d(Map<String, Object> params);

	void updateCustBillMaster(Map<String, Object> params);
}
