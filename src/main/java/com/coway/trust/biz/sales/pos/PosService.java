package com.coway.trust.biz.sales.pos;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.pos.vo.PosGridVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PosService {

	List<EgovMap> selectPosModuleCodeList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectStatusCodeList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPosJsonList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectWhBrnchList() throws Exception;

	EgovMap selectWarehouse(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPosTypeList(Map<String, Object> params)throws Exception;

//	List<EgovMap> selectPIItmTypeList()throws Exception;

//	List<EgovMap> selectPIItmList(Map<String, Object> params)throws Exception;

	List<EgovMap> selectPosItmList(Map<String, Object> params) throws Exception;

	List<EgovMap> chkStockList(Map<String, Object> params) throws Exception;

	List<EgovMap> chkStockList2(Map<String, Object> params) throws Exception;

	EgovMap getMemCode(Map<String, Object> params)throws Exception;

	List<EgovMap> getReasonCodeList(Map<String, Object> params)throws Exception;

	List<EgovMap> getFilterSerialNum(Map<String, Object> params)throws Exception;

	List<EgovMap> getConfirmFilterListAjax(Map<String, Object> params) throws Exception;

	Map<String, Object> insertPos(Map<String, Object> params) throws Exception;

	List<EgovMap> getUploadMemList (Map<String, Object> params) throws Exception;

	EgovMap chkReveralBeforeReversal (Map<String, Object> params) throws Exception;

	EgovMap posReversalDetail(Map<String, Object> params) throws Exception;

	List<EgovMap> getPosDetailList(Map<String, Object> params)throws Exception;

	EgovMap insertPosReversal(Map<String, Object> params) throws Exception;

	List<EgovMap> getPurchMemList(Map<String, Object> params)throws Exception;

	Boolean  updatePosMStatus (PosGridVO pgvo, int userId) throws Exception;

	Boolean  updatePosDStatus (PosGridVO pgvo, int userId) throws Exception;

	Boolean updatePosMemStatus(PosGridVO pgvo, int userId) throws Exception;

	/*EgovMap chkPosType(Map<String, Object> params) throws Exception;*/

	List<EgovMap> getpayBranchList(Map<String, Object> params) throws Exception;

	List<EgovMap> getDebtorAccList(Map<String, Object> params) throws Exception;

	List<EgovMap> getBankAccountList(Map<String, Object> parmas)throws Exception;

	EgovMap selectAccountIdByBranchId(Map<String, Object> params)throws Exception;

	boolean isPaymentKnowOffByPOSNo(Map<String, Object> params)throws Exception;

	EgovMap posReversalPayDetail(Map<String, Object> params)throws Exception;

	List<EgovMap> getPayDetailList(Map<String, Object> params) throws Exception;

	void insertTransactionLog(Map<String, Object> params)throws Exception;

	EgovMap chkMemIdByMemCode(Map<String, Object> params)throws Exception;

	EgovMap chkUserIdByUserName(Map<String, Object> params)throws Exception;

	List<EgovMap> getPosBillingDetailList(Map<String, Object> params)throws Exception;

	EgovMap insertPosReversalItemBank(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPosFlexiJsonList(Map<String, Object> params) throws Exception;

	Map<String, Object> insertPosFlexi(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPosFlexiItmList(Map<String, Object> params) throws Exception;

	List<EgovMap> chkFlexiStockList(Map<String, Object> params) throws Exception;

	EgovMap posFlexiDetail(Map<String, Object> params) throws Exception;

	Map<String, Object> updatePosFlexiStatus(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

	List<EgovMap> selectWhSOBrnchList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPOSFlexiItem(Map<String, Object> params);

	int updatePOSFlexiItemActive(Map<String, Object> params, SessionVO sessionVO);

	int updatePOSFlexiItemInactive(Map<String, Object> params, SessionVO sessionVO);

	// KR-OHK Serial check add
	Map<String, Object> insertPosSerial(Map<String, Object> params) throws Exception;

	// KR-OHK Serial check add
	EgovMap insertPosReversalSerial(Map<String, Object> params) throws Exception;

	List<EgovMap> selectLoyaltyRewardPointList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectLoyaltyRewardPointDetails(Map<String, Object> params) throws Exception;

	EgovMap selectLoyaltyRewardPointByMemCode(Map<String, Object> params) throws Exception;

	void insertUploadedLoyaltyRewardList(Map<String, Object> params);

}
