package com.coway.trust.biz.sales.trBook.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("salesTrBookMapper")
public interface SalesTrBookMapper {

	List<EgovMap> selectTrBookList(Map<String, Object> params);

	List<EgovMap> selectTrBookListByMem(Map<String, Object> params);

	EgovMap selectTrBookDetailInfo(Map<String, Object> params);

	List<EgovMap> selectTrBookDetailList(Map<String, Object> params);

	int selectTrBookDup(Map<String, Object> params);

	String getDocNo(Map<String, Object> params);

	void insertTrBookM(Map<String, Object> params);

	void insertTrRecord(Map<String, Object> params);

	void insertTrBookD(Map<String, Object> params);

	List<EgovMap> selectBranch(Map<String, Object> params);
	List<EgovMap> selectCourier(Map<String, Object> params);

	int selectTrBookDupBulk(Map<String, Object> params);

	void insertTrBookBulk(Map<String, Object> params);

	List<EgovMap> selectMember(Map<String, Object> params);

	void insertTrTransitM(Map<String, Object> params);

	void insertTrTransitD(Map<String, Object> params);

	EgovMap selectTrBookInfo(Map<String, Object> params);

	EgovMap selectMemberInfoByCode(Map<String, Object> params);

	List<EgovMap> selectFeedBackCode();

	int selectTrBookDetails(Map<String, Object> params);

	void update_MSC0029D(Map<String, Object> params);

	List<EgovMap> selectTrBookDetailsList(Map<String, Object> params);

	EgovMap selectBranchInfoByCode(Map<String, Object> params);

	void insertRequestMaster(Map<String, Object> params);

	void insertRequestDet(Map<String, Object> params);

	void insertRequestComField(Map<String, Object> params);

	EgovMap selectRequestMaster(Map<String, Object> params);

	List<EgovMap> selectDCFCompulsoryFieldListByRequestID(EgovMap reqMInfo);

	List<EgovMap> selectDCFChangeItemListByRequestID(EgovMap reqMInfo);

	void updateDCFRequestMs(Map<String, Object> reqM);

	void insertDCFResponseLogs(Map<String, Object> params);

	List<EgovMap> selectTransitInfoList(Map<String, Object> params);



	List<EgovMap> getOrgCodeListByMemTypeStaff(Map<String, Object> params);

	List<EgovMap> getOrgCodeListByMemType(Map<String, Object> params);

	List<EgovMap> getCreateByList() throws Exception;

	List<EgovMap> selelctRequestBahchList(Map<String, Object> params);

	EgovMap selelctRequestBahchInfo(Map<String, Object> params);

	void updateBkReqStus(Map<String, Object> params);

	EgovMap selelctMemberInfoByCode(Map<String, Object> params);

	EgovMap selelctUnderDCFRequest(Map<String, Object> params);

	EgovMap selelctDcfMaster(Map<String, Object> params);

	EgovMap selectTrBookM(EgovMap trBookInfo);

	void updateFileName(Map<String, Object> params);

	void updateTrBookM(Map<String, Object> params);

	List<EgovMap> selelctBoxList(Map<String, Object> params);

	void insertKeepIntoBoxD(Map<String, Object> params);

	void insertKeepIntoBox(Map<String, Object> params);

	void insertKeepIntoBoxRcord(Map<String, Object> params);
}
