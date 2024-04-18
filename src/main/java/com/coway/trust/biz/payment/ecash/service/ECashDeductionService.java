package com.coway.trust.biz.payment.ecash.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ECashDeductionService
{

    List<EgovMap> selectECashDeductList(Map<String, Object> params);

    EgovMap selectECashDeductById(Map<String, Object> params);

    List<EgovMap>  selectECashDeductSubById(Map<String, Object> params);

    int  selectECashDeductSubByIdCnt(Map<String, Object> params);

    int selectECashDeductCCSubByIdCnt(Map<String, Object> params);

    int selectECashDeductBatchGen(Map<String, Object> params);

    List<EgovMap> selectECashDeductSubList(Map<String, Object> params);

    Map<String, Object> createECashDeduction(Map<String, Object> param);

    void deactivateECashDeductionStatus(Map<String, Object> params);

    void updateECashDeductionResultItem(Map<String, Object> eCashMap, List<Object> resultItemList );

    void updateECashDeductionResult(Map<String, Object> eCashMap);

    Map<String, Object> createECashGrpDeduction(Map<String, Object> param);

    void updateECashGrpDeductionResult(Map<String, Object> eCashMap);

    void updateECashDeductionResultItemBulk(Map<String, Object> bulkMap) throws Exception;

    EgovMap selectECashBankResult(Map<String, Object> eCashMap);

	void deleteECashDeductionResultItem(Map<String, Object> eCashMap);

	EgovMap selectMstConf(Map<String, Object> params);

	List<EgovMap> selectSubConf(Map<String, Object> params);

}
