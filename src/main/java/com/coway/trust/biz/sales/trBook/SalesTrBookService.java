package com.coway.trust.biz.sales.trBook;

import java.util.List;
import java.util.Map;

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

	EgovMap updateReportLost(Map<String, Object> params);

	String saveTranSingle(Map<String, Object> params);

	
	
}
