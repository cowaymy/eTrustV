package com.coway.trust.biz.payment.cardpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CardStatementService
{


	/**
	 * Credit Card Statement Master List  조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
    List<EgovMap> selectCardStatementMasterList(Map<String, Object> params);

    /**
	 * Credit Card Statement Detail List  조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
    List<EgovMap> selectCardStatementDetailList(Map<String, Object> params);

    /**
	 * Credit Card Statement Upload
	 * @param params
	 * @return
	 */
    Map<String, Object>  uploadCardStatement(Map<String, Object> masterParamMap, List<Object> detailParamList);

    /**
	 * Credit Statement Confirm Master List  조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
    List<EgovMap> selectCRCConfirmMasterList(Map<String, Object> params);


    /**
	 * Credit Card Statement Master Posting 처리
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
    void postCardStatement(Map<String, Object> params);

    /**
	 * Credit Card Statement Delete
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
    boolean deleteCardStatement(List<Object> paramList);

    /**
	 * Credit Card Statement updateCardStateDetail
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
    boolean updateCardStateDetail(List<Object> paramList);

    int getCustId(Map<String, Object> params);

}
