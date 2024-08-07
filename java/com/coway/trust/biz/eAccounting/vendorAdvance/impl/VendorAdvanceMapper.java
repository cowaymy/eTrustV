package com.coway.trust.biz.eAccounting.vendorAdvance.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("VendorAdvanceMapper")
public interface VendorAdvanceMapper {
    List<EgovMap> selectAdvanceList(Map<String, Object> params);

    String selectNextClmNo(Map<String, Object> params);

    /*
     * Insert FCM0027M, FCM0028D
     * Called by both request and settlement
     * GL Account data will be different alongside with claim number
     */
    int insertAdvMst_FCM27M(Map<String, Object> params);
    int insertAdvDet_FCM28D(Map<String, Object> params);

    // Get Detail Sequence Number
    int selectNextClmSeq(String clmNo);

    // Update Vendor Advance Request's refund claim number
    int updateAdvReqRefd(Map<String, Object> params);

    /*
     * e-Accounting approval insertion
     * e-Accounting notification insertion for submission
     */
    int insertApproveManagement(Map<String, Object> params);
    int insertApproveLineDetail(Map<String, Object> params);
    int insMissAppr(Map<String, Object> params);
    int insertNotification(Map<String, Object> params);
    void insertAppvDetails(Map<String, Object> params);

    void updateAppvPrcssNo(Map<String, Object> params);

    /*
     * Data retrieval for view/editing draft status
     * 1. FCM0027M + FCM0028D
     * 2. FCM0028D List data (Settlement Type)
     * 3. Attachment
     * 4. Approval details (If claim is in Approved/Rejected/Approval in Progress/Requested status)
     */
    List<EgovMap> selectVendorAdvanceDetails(String clmNo);
    List<EgovMap> selectVendorAdvanceDetailsGrid(String clmNo);
    List<EgovMap> selectVendorAdvanceDetailsList(Map<String, Object> params);
    List<EgovMap> selectVendorAdvanceItems(String clmNo);

    EgovMap selectVendorAdvanceDetailItem(String clmNo);
    EgovMap getAppvInfo(String appvPrcssNo);

    /*
     * Update FCM0027M, FCM0028D
     * Delete FCM0028D (settlement ONLY)
     * Called by both request and settlement
     */
    int updateAdvMst_FCM27M(Map<String, Object> params);
    int updateAdvDet_FCM28D(Map<String, Object> params);
    int deleteAdvDet_FCM28D(Map<String, Object> params);

    // FCM0027M update - Manual Settlement for Advance Vendor Request (R4) - Web invoice requested by invoice number + supplier matching
    int manualVendorAdvReqSettlement(Map<String, Object> params);

    //Insert into Interface table
    void insertVendorAdvInterface(Map<String, Object> params);
    EgovMap selectSettlementInfo(Map<String, Object> params);
    EgovMap selectBalanceInfo(Map<String, Object> params);

    //Edit Rejected - 27/12/2021 - Start
    String selectNextReqNo(Map<String, Object> params);
    EgovMap getAttachmenDetails(Map<String, Object> params);

	int getFileAtchGrpId();
	int getFileAtchId();

	void insertSYS0070M_ER(Map<String, Object> params);
	void insertSYS0071D_ER(Map<String, Object> params);

	void insertRejectM(Map<String, Object> params);
	void insertRejectD(Map<String, Object> params);
	// Edit Rejected - 27/12/2021 - End

	EgovMap getAdvType(Map<String, Object> params);
	List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params);
}
