package com.coway.trust.biz.eAccounting.scmActivityFund.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("scmActivityFundMapper")
public interface ScmActivityFundMapper {

	List<EgovMap> selectScmActivityFundList(Map<String, Object> params);

	List<EgovMap> selectTaxCodeScmActivityFundFlag();

	String selectNextClmNo();

	void insertScmActivityFundExp(Map<String, Object> params);

	int selectNextClmSeq(String clmNo);

	void insertScmActivityFundExpItem(Map<String, Object> params);

	List<EgovMap> selectScmActivityFundItems(String clmNo);

	EgovMap selectScmActivityFundInfo(Map<String, Object> params);

	List<EgovMap> selectAttachList(String atchFileGrpId);

	void updateScmActivityFundExp(Map<String, Object> params);

	void updateScmActivityFundExpItem(Map<String, Object> params);

	void insertApproveItems(Map<String, Object> params);

	void updateAppvPrcssNo(Map<String, Object> params);

	void deleteScmActivityFundExpItem(Map<String, Object> params);

	void updateScmActivityFundExpTotAmt(Map<String, Object> params);

	List<EgovMap> selectScmActivityFundItemGrp(Map<String, Object> params);

	void insertRejectM(Map<String, Object> params);

	void insertRejectD(Map<String, Object> params);

	List<EgovMap> getOldDisClamUn(Map<String, Object> params);

	void updateExistingClamUn(Map<String, Object> params);

}
