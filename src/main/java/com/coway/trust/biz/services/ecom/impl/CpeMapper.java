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
}
