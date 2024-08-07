package com.coway.trust.biz.sales.trbox.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Mapper("trboxMapper")
public interface TrboxMapper {

	List<EgovMap> selectTrboxManagementList (Map<String, Object> params);

	List<EgovMap> selectTrboxManageDetailList (Map<String, Object> params);

	Map<String , Object> selectTrboxManageBoxNo(String param);

	void newTrboxManageInsert(Map<String, Object> params);

	void newTrboxRecordCardInsert(Map<String, Object> params);

	void trboxdocnoUpdate(Map<String, Object> params);

	void getUpdateKeepReleaseRemove(Map<String, Object> params);

	void getCloseReopn(Map<String, Object> params);

	void updateTrboxInfo(Map<String, Object> params);

	List<EgovMap> selectBranchList(Map<String, Object> params);

	List<EgovMap> selectCourierList(Map<String, Object> params);

	void transferMaterInsert(Map<String, Object> params);

	String selectTransferId();

	void transferDetailInsert(Map<String, Object> params);

	void transferRecordCardInsert(Map<String, Object> params);

	List<EgovMap> selectTrboxReceiveList(Map<String, Object> params);

	Map<String, Object> selectReceiveViewData(Map<String, Object> params);

	Map selectReceiveViewCnt(Map<String, Object> params);

	List<EgovMap> selectReceiveViewList(Map<String, Object> params);

	int selectTrBoxTransitDsCnt(String param);

	void receiveTrboxRecordCardInsert(Map<String, Object> params);

	void updateTrboxTransitDetail(Map<String, Object> params);

	void TRBoxTransitMasterUpdate(Map<String, Object> params);

	List<EgovMap> selectUnkeepTRBookList (Map<String, Object> params);
	
	void KeepAddTRBookInsert(Map<String, Object> params);

}
