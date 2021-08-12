package com.coway.trust.biz.sales.trBook;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SalesTrBookService {

	List<EgovMap> selectTrBookList(Map<String, Object> params);

	EgovMap selectTrBookDetailInfo(Map<String, Object> params);

	List<EgovMap> selectTrBookDetailList(Map<String, Object> params);

	int selectTrBookDup(Map<String, Object> params);

	String saveNewTrBook(Map<String, Object> params);

	List<EgovMap> selectBranch(Map<String, Object> params);
	List<EgovMap> selectCourier(Map<String, Object> params);

	int selectTrBookDupBulk(Map<String, Object> params);

	String saveNewTrBookBulk(Map<String, Object> params);

	List<EgovMap> selectMember(Map<String, Object> params);

	String saveAssign(Map<String, Object> params);

	EgovMap selectTrBookInfo(Map<String, Object> params);

	EgovMap selectMemberInfoByCode(Map<String, Object> params);

	List<EgovMap> selectFeedBackCode();

	int selectTrBookDetails(Map<String, Object> params);

	void update_MSC0029D(Map<String, Object> params);

	String saveReTrBook(Map<String, Object> params);

	EgovMap updateReportLost(Map<String, Object> params, MultipartHttpServletRequest request) throws Exception;

	String saveTranSingle(Map<String, Object> params);

	List<EgovMap> getOrganizationCodeList(Map<String, Object> params);

	String saveTranBulk(Map<String, Object> params);

	List<EgovMap> selectTransitInfoList(Map<String, Object> params);

	List<EgovMap> getCreateByList() throws Exception;

	List<EgovMap> selelctRequestBahchList(Map<String, Object> params);

	EgovMap selelctRequestBahchInfo(Map<String, Object> params);

	void updateBkReqStus(Map<String, Object> params);

	EgovMap selelctMemberInfoByCode(Map<String, Object> params);

	EgovMap selelctUnderDCFRequest(Map<String, Object> params);

	EgovMap selelctDcfMaster(Map<String, Object> params);

	EgovMap saveReportLost(Map<String, Object> params);

	EgovMap reportLostWholefileUpload(Map<String, Object> params, MultipartHttpServletRequest request) throws Exception ;

	void updateTrBookM(Map<String, Object> params);

	List<EgovMap> selelctBoxList(Map<String, Object> params);

	void insertKeepIntoBox(Map<String, Object> params);

	String insertKeepIntoNewBox(Map<String, Object> params);

	List<EgovMap> selectTrBookListByMem(Map<String, Object> params);

}
