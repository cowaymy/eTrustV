package com.coway.trust.biz.payment.invoice.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface InvoiceAdjService {
    	 /**
      	 * InvoiceAdjustment List 조회
      	 * @param params
      	 * @return
      	 */
		List<EgovMap> selectInvoiceAdj(Map<String, Object> params);

      	/**
    	 * New InvoiceAdjustment Master 조회
    	 * @param params
    	 * @return
    	 */
        List<EgovMap> selectNewAdjMaster(Map<String, Object> params);

        /**
    	 * New InvoiceAdjustment Detail 조회
    	 * @param params
    	 * @return
    	 */
        List<EgovMap> selectNewAdjDetailList(Map<String, Object> params);

        /**
    	 * Adjustment CN/DN AccID  조회
    	 * @param params
    	 * @return
    	 */
        EgovMap getAdjustmentCnDnAccId(Map<String, Object> params);

        /**
    	 * Adjustment CN/DN request 등록
    	 * @param params
    	 * @return
    	 */
        String saveNewAdjList(boolean isBatch, int adjustmentType , Map<String, Object> masterParamMap, List<Object> detailParamList, List<Object> apprGridList);

        /**
    	 * Adjustment Batch ID 채번
    	 * @param params
    	 * @return
    	 */
        int getAdjBatchId();

        /**
    	 * Adjustment CN/DN Detail Pop-up Master 조회
    	 * @param params
    	 * @return
    	 */
        EgovMap selectAdjDetailPopMaster(Map<String, Object> params);

        /**
    	 * Adjustment CN/DN Detail Pop-up Detail List 조회
    	 * @param params
    	 * @return
    	 */
        List<EgovMap> selectAdjDetailPopList(Map<String, Object> params);

        /**
    	 * Adjustment CN/DN Detail Pop-up History 조회
    	 * @param params
    	 * @return
    	 */
        List<EgovMap> selectAdjDetailPopHist(Map<String, Object> params);

    	/**
    	* Approval Adjustment  - Approva / Reject
    	* @param params
    	* @param model
    	* @return
    	*/
        void approvalAdjustment(Map<String, Object> params);

        /**
    	 * Adjustment CN/DN Batch Approval Pop-up Master 조회
    	 * @param params
    	 * @return
    	 */
        EgovMap selectAdjBatchApprovalPopMaster(Map<String, Object> params);

        /**
    	 * Adjustment CN/DN Batch Approval Pop-up Detail 조회
    	 * @param params
    	 * @return
    	 */
        List<EgovMap> selectAdjBatchApprovalPopDetail(Map<String, Object> params);

        /**
    	 * Adjustment CN/DN Batch Approval Pop-up History 조회
    	 * @param params
    	 * @return
    	 */
        List<EgovMap> selectAdjBatchApprovalPopHist(Map<String, Object> params);

        /**
    	 *
    	 * @param params
    	 * @return
    	 */
        int countAdjustmentExcelList(Map<String, Object> params);

        EgovMap selectAdjDetailPopMasterOld(Map<String, Object> params);

        List<EgovMap> selectAdjDetailPopListOld(Map<String, Object> params);

        EgovMap getFinApprover();

        void insertAdjReqAppv(Map<String, Object> params);

        void updateAdjApprovalLine(Map<String, Object> params);

        void updateAdjNextAppvLine(Map<String, Object> params);

        EgovMap getAdjApprLine(Map<String, Object> params);

        List<EgovMap> selectAppvLineInfo(Map<String, Object> params);

        void insertNotification(Map<String, Object> params);

        String nextApprover(Map<String, Object> params);
}
