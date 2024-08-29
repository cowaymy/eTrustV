package com.coway.trust.biz.payment.govEInvoice.service;

import java.util.List;
import java.util.Map;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
public interface GovEInvoiceService{
	List<EgovMap> selectGovEInvoiceList(Map<String, Object> params);

	EgovMap selectGovEInvoiceMain(Map<String, Object> params);

	List<EgovMap> selectEInvStat(Map<String, Object> params);

	List<EgovMap> selectEInvCommonCode(Map<String, Object> params);

	List<EgovMap> selectGovEInvoiceDetail(Map<String, Object> params);

	Map<String, Object> createEInvClaim(Map<String, Object> param);

	Map<String, Object> createEInvClaimDaily(Map<String, Object> param);

	Map<String, Object> createTaxInvConsolidateClaim(Map<String, Object> params);

	int saveEInvDeactivateBatch(Map<String, Object> params);

	int saveEInvBatch(Map<String, Object> params);

	int updEInvJsonString(Map<String, Object> params);

	int updEInvByDocId(Map<String, Object> params);

	int insertApiDetailAccessLog(Map<String, Object> params);

	Map<String, Object> prepareEInvClaim(Map<String, Object> param);

	Map<String, Object> sendEInvClaim(Map<String, Object> param);

	Map<String, Object> callEinvoiceApi(Map<String, Object> params);

	Map<String, Object> clearTaxSubmitReqApi(Map<String, Object> params);

	Map<String, Object> rtnRespMsg(int respSeq, String pgmPath, String code, String msg, String respTm, String reqPrm,String respPrm, String apiUserId, String refNo);

	Map<String, Object> checkStatusEInvClaim(Map<String, Object> param);

	Map<String, Object> clearTaxCheckStatusReqApi(Map<String, Object> params);

	Map<String, Object> createTaxInvConsolidateClaimCNDN(Map<String, Object> params);

}
