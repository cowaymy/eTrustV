/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.payment.invoice.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("invoiceAdjMapper")
public interface InvoiceAdjMapper {
	/**
	 * InvoiceAdjustment(CN/DN) List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectInvoiceAdjList(Map<String, Object> params);

	/**
	 * New Invoice Master 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectNewAdjMaster(Map<String, Object> params);

	/**
	 * New Invoice Detail 조회
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
	 * Adjustment ID 채번
	 * @param params
	 * @return
	 */
	int getAdjustmentId();

	 /**
	 * Adjustment request Master 등록
	 * @param params
	 * @return
	 */
	void saveNewAdjMaster(Map<String, Object> params);

	/**
	 * Adjustment request Batch Info 등록
	 * @param params
	 * @return
	 */
	void saveBatchInfo(Map<String, Object> params);

	 /**
	 * Adjustment request Detail  등록
	 * @param params
	 * @return
	 */
	void saveNewAdjDetail(Map<String, Object> params);

	/**
	 * Adjustment Batch ID 채번
	 * @param params
	 * @return
	 */
	int getAdjBatchId();

	/**
	 * Adjustment History 등록
	 * @param params
	 * @return
	 */
	void saveNewAdjHist(Map<String, Object> params);

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
	* Approval Adjustment  - Approva / Reject Master
	* @param params
	* @param model
	* @return
	*/
	void approvalAdjustmentMaster(Map<String, Object> params);

	/**
	* Approval Adjustment  - Approva / Reject Details
	* @param params
	* @param model
	* @return
	*/
	void approvalAdjustmentDetails(Map<String, Object> params);

	/**
	 * 승인 데이터 처리에 필요한 메서드들 : Rental
	 * @param params
	 * @return
	 */

	int getNoteId();
    EgovMap selectAdjMasterForApprovalRental(Map<String, Object> params);
    void insertAccTaxDebitCreditNote(EgovMap params);
    List<EgovMap> selectAdjDetailsForApprovalRental(Map<String, Object> params);
    void insertAccTaxDebitCreditNoteSub(EgovMap params);
    void insertAccServiceContractLedger(Map<String, Object> params);
    void insertAccRentLedger(Map<String, Object> params);

    /**
	 * 승인 데이터 처리에 필요한 메서드들 : Outright
	 * @param params
	 * @return
	 */
    EgovMap selectAdjMasterForApprovalOutright(Map<String, Object> params);
    List<EgovMap> selectAdjDetailsForApprovalOutright(Map<String, Object> params);
    void insertAccTradeLedger(Map<String, Object> params);

    /**
	 * 승인 데이터 처리에 필요한 메서드들 : Misc
	 * @param params
	 * @return
	 */
    EgovMap selectAdjMasterForApprovalMisc(Map<String, Object> params);
    List<EgovMap> selectAdjDetailsForApprovalMisc(Map<String, Object> params);
    void insertASLedger(Map<String, Object> params);
    int selectQuotId(String quotNo);
    int selectSrvMemId(int quotId);
    void insertAccSrvMemLedger(Map<String, Object> params);

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
	 *  Adjustment CN/DN Batch Approval Pop-up History 조회
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

    String nextApprover(Map<String, Object> params);
}
