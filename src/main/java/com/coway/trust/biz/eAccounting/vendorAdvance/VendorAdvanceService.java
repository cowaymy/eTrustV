package com.coway.trust.biz.eAccounting.vendorAdvance;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface VendorAdvanceService {
    // Main Menu Listing
    List<EgovMap> selectAdvanceList(Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO);

    // FCM0027M + FCM0028D insertion - Advance Vendor Request (R4)
    String insertVendorAdvReq(Map<String, Object> params, SessionVO sessionVO);

    // FCM0027M + FCM0028D insertion - Advance Vendor Settlement (A3)
    String insertVendorAdvSettlement(Map<String, Object> params, SessionVO sessionVO);

    // FCM0004M + FCM0005D insertion - Advance Vendor Request and Settlement
    // FCM0015D insertion not required due to different table structure and content
    int approveLineSubmit(Map<String, Object> params, SessionVO sessionVO);

    /*
     * Querying for view, editing purposes
     * 1. FCM0027M + FCM0028D - 1 row
     * 2. FCM0028D for grid view listing
     */
    EgovMap selectVendorAdvanceDetails(String clmNo);
    List<EgovMap> selectVendorAdvanceItems(String clmNo);

    EgovMap getAppvInfo(String appvPrcssNo);

    // FCM0027M + FCM0028D update - Advance Vendor Request (R4)
    int updateVendorAdvReq(Map<String, Object> params, SessionVO sessionVO);

    // FCM0027M + FCM0028D update - Advance Vendor Settlement (A3)
    int updateVendorAdvSettlement(Map<String, Object> params, SessionVO sessionVO);
}
