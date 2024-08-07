package com.coway.trust.biz.sales.ownershipTransfer;

import java.util.List;
import java.util.Map;

import org.springframework.ui.ModelMap;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OwnershipTransferService {

	List<EgovMap> selectStatusCode();

	List<EgovMap> selectRootList(Map<String, Object> params) throws Exception;

	List<EgovMap> rootCodeList(Map<String, Object> params);

	int saveRequest(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> getSalesOrdId(String params);

	Map<String, Object> selectLoadIncomeRange(Map<String, Object> params) throws Exception;

	EgovMap selectCcpInfoByCcpId(Map<String, Object> params) throws Exception;

	EgovMap selectRootDetails(Map<String, Object> params);

	List<EgovMap> selectRotCallLog(Map<String, Object> params) throws Exception;

	List<EgovMap> selectRotHistory(Map<String, Object> params) throws Exception;

	int insCallLog(List<Object> addList, String userId);

	int saveRotCCP(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> getAttachments(Map<String, Object> params);

	EgovMap getAttachmentInfo(Map<String, Object> params);

	EgovMap selectMemberByMemberIDCode(Map<String, Object> params);

	int saveRotDetail(Map<String, Object> params, SessionVO sessionVO); //for rot reason after validation

	EgovMap selectRequestorInfo(Map<String, Object> params);

	EgovMap checkBundleInfo(Map<String, Object> params) ;

	EgovMap checkBundleInfoCcp(Map<String, Object> params) ;

	EgovMap checkActRot(Map<String, Object> params) ;

	int getRootGrpID();

	int updRootGrpId(Map<String, Object> params);

	EgovMap checkRootGrpId(Map<String, Object> params) ;

}
