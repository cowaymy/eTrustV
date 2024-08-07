package com.coway.trust.biz.eAccounting.staffAdvance.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("staffAdvanceMapper")
public interface staffAdvanceMapper {

    List<EgovMap> selectAdvanceList(Map<String, Object> params);

    EgovMap getAdvConfig(Map<String, Object> params);

    EgovMap getRqstInfo(Map<String, Object> params);

    String selectNextClmNo(Map<String, Object> params);

    void insertRequest(Map<String, Object> params);

    void editDraftRequestM(Map<String, Object> params);

    void editDraftRequestD(Map<String, Object> params);

    void insertTrvDetail(Map<String, Object> params);

    void updateAdvanceReqInfo(Map<String, Object> params);

    EgovMap getRefDtls(Map<String, Object> params);

    void insertRefund(Map<String, Object> params);

    void insertAppvDetails(Map<String, Object> params);

    void updateAdvRequest(Map<String, Object> params);

    EgovMap getAdvType(Map<String, Object> params);

    List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params);

    EgovMap getAdvClmInfo(Map<String, Object> params);

    void updateTotal(Map<String, Object> params);

  //Edit Rejected - 14/09/2023 - Start
    EgovMap getAttachmenDetails(Map<String, Object> params);

	int getFileAtchGrpId();
	int getFileAtchId();

	void insertSYS0070M_ER(Map<String, Object> params);
	void insertSYS0071D_ER(Map<String, Object> params);

	void insertRejectM(Map<String, Object> params);
	void insertRejectD(Map<String, Object> params);

	List<EgovMap> selectBank();
	// Edit Rejected - 14/09/2023 - End
}
