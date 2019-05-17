package com.coway.trust.biz.eAccounting.scmActivityFund;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ScmActivityFundService {

	List<EgovMap> selectScmActivityFundList(Map<String, Object> params);

	List<EgovMap> selectTaxCodeScmActivityFundFlag();

	void insertScmActivityFundExp(Map<String, Object> params);

	List<EgovMap> selectScmActivityFundItems(String clmNo);

	EgovMap selectScmActivityFundInfo(Map<String, Object> params);

	List<EgovMap> selectAttachList(String atchFileGrpId);

	void updateScmActivityFundExp(Map<String, Object> params);

	void insertApproveManagement(Map<String, Object> params);

	void deleteScmActivityFundExpItem(Map<String, Object> params);

	void updateScmActivityFundExpTotAmt(Map<String, Object> params);

	List<EgovMap> selectScmActivityFundItemGrp(Map<String, Object> params);

	String selectNextClmNo();

	void editRejected(Map<String, Object> params);

}
