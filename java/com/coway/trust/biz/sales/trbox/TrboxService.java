package com.coway.trust.biz.sales.trbox;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface TrboxService {

	List<EgovMap> selectTrboxManagementList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectTrboxManageDetailList(Map<String, Object> params) throws Exception;

	String postNewTrboxManagementSave(Map<String, Object> params) throws Exception;

	void getUpdateKeepReleaseRemove(Map<String, Object> params) throws Exception;

	void getCloseReopn(Map<String, Object> params) throws Exception;

	List<EgovMap> selectTrboxManagement(Map<String, Object> params) throws Exception;

	List<EgovMap> selectTransferCodeList(Map<String, Object> params) throws Exception;

	String getTrBoxSingleTransfer(Map<String, Object> params) throws Exception;

	List<EgovMap> selectTrboxReceiveList(Map<String, Object> params) throws Exception;

	Map<String, Object> selectReceiveViewData(Map<String, Object> params) throws Exception;

	List<EgovMap> getSearchTrboxReceiveGridList(Map<String, Object> params) throws Exception;

	Map<String, Object> postTrboxReceiveInsertData(Map<String, Object> params) throws Exception;

	Map<String, Object> postTrboxTransferInsertData(Map<String, Object> params) throws Exception;

	List<EgovMap> selectUnkeepTRBookList(Map<String, Object> params) throws Exception;

	void KeepAddTRBookInsert(Map<String, Object> params) throws Exception;

}
