package com.coway.trust.biz.eAccounting.vendorAdvance.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.eAccounting.vendorAdvance.VendorAdvanceService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("VendorAdvanceService")
public class VendorAdvanceServiceImpl implements VendorAdvanceService {

    private static final Logger LOGGER = LoggerFactory.getLogger(VendorAdvanceServiceImpl.class);

    @Resource(name = "VendorAdvanceMapper")
    private VendorAdvanceMapper vendorAdvanceMapper;

    @Resource(name = "webInvoiceMapper")
    private WebInvoiceMapper webInvoiceMapper;

    @Override
    public List<EgovMap> selectAdvanceList(Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.advanceListing ==========");
        LOGGER.debug("vendorAdvance.advanceListing :: params >>>>> ", params);

        String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
        params.put("userId", sessionVO.getUserId());

        if(!"A1101".equals(costCentr)) {
            params.put("loginUserId", sessionVO.getUserId());
        }

        String[] advType = request.getParameterValues("advType");
        String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
        String[] refundStus = request.getParameterValues("refundStus");

        params.put("advType", advType);
        params.put("appvPrcssStus", appvPrcssStus);
        params.put("refundStus", refundStus);

        return vendorAdvanceMapper.selectAdvanceList(params);
    }

    @Override
    public String insertVendorAdvReq(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.insertVendorAdvReq ==========");
        LOGGER.debug("vendorAdvance.insertVendorAdvReq :: params >>>>> ", params);

        if(params.containsKey("reqAdvType")) {
            params.put("advType", "5".equals(params.get("reqAdvType").toString()) ? "5" : "");
        }

        // Get Request Claim Number (
        params.put("clmType", "REQ");
        String clmNo = vendorAdvanceMapper.selectNextClmNo(params); // Claim Number prefix - R4
        params.put("clmNo", clmNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        // To open this section when staff's cost center and department are correctly mapped
        /*
        EgovMap deptDetails = (EgovMap) vendorAdvanceMapper.getDeptDetails(params);
        params.put("userBranch", deptDetails.get("userBranch"));
        params.put("userDept", deptDetails.get("userDept"));
        */

        params.put("glAccNo", "12400100");
        params.put("amt", params.get("totalAdv"));
        params.put("costCenterCode", params.get("reqCostCentr"));
        params.put("atchFileGrpId", params.get("reqAtchFileGrpId"));

        int mstIns = vendorAdvanceMapper.insertAdvMst_FCM27M(params);

        Map<String, Object> detParams = new HashMap<String, Object>();

        detParams.put("advType", params.get("advType"));
        detParams.put("clmNo", clmNo);
        detParams.put("clmSeq", "1");
        detParams.put("amt", params.get("totalAdv"));
        detParams.put("netAmt", params.get("totalAdv"));
        detParams.put("currency", params.get("advCurr"));
        // detParams.put("taxAmt", params.get("taxAmt")); // To enable this line if require tax code change/tax amount input
        detParams.put(CommonConstants.USER_ID, sessionVO.getUserId());

        int detIns = vendorAdvanceMapper.insertAdvDet_FCM28D(detParams);

        if(mstIns != 1 && detIns != 1) {
            clmNo = "";
        }

        return clmNo;
    }

    @Override
    public String insertVendorAdvSettlement(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.insertVendorAdvSettlement ==========");
        LOGGER.debug("vendorAdvance.insertVendorAdvSettlement :: params >>>>> ", params);

        if(params.containsKey("settlementType")) {
            params.put("advType", "6".equals(params.get("settlementType").toString()) ? "6" : "");
        }

        // Get Request Claim Number (
        params.put("clmType", "REF");
        String clmNo = vendorAdvanceMapper.selectNextClmNo(params); // Claim Number prefix - A3
        params.put("clmNo", clmNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        params.put("glAccNo", "22200400");
        params.put("amt", params.get("settlementTotAmt"));
        params.put("costCenterCode", params.get("settlementCostCenter"));
        params.put("atchFileGrpId", params.get("settlementAtchFileGrpId"));
        params.put("memAccId", params.get("settlementMemAccId"));

        int mstIns = vendorAdvanceMapper.insertAdvMst_FCM27M(params);

        List<Object> gridDataList = (List<Object>) params.get("gridData");

        int detIns = 0;
        for(int i = 0; i < gridDataList.size(); i++) {
            Map<String, Object> item = (Map<String, Object>) gridDataList.get(i);
            int clmSeq = vendorAdvanceMapper.selectNextClmSeq(clmNo);
            item.put("clmNo", clmNo);
            item.put("clmSeq", clmSeq);
            item.put("userId", sessionVO.getUserId());
            item.put("userName", sessionVO.getUserName());

            item.put("advType", "6".equals(params.get("settlementType").toString()) ? "6" : "");

            item.put("amt", item.get("totalAmt"));
            item.put("netAmt", item.get("totalAmt"));
            item.put("glAccNo", item.get("glAccCode"));
//            item.put("rem", item.get("desc"));

            int ins = vendorAdvanceMapper.insertAdvDet_FCM28D(item);
            detIns += ins > 0 ? 1 : 0;
        }

        int updReq = vendorAdvanceMapper.updateAdvReqRefd(params);

        if(mstIns == 0 || detIns == 0 || updReq == 0) clmNo = "";

        return clmNo;
    }

    @Override
    public int approveLineSubmit(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.approveLineSubmit ==========");
        LOGGER.debug("vendorAdvance.approveLineSubmit :: params >>>>> "+ params);

        int ins = 0;
        int fcm4m_ins = 0;
        int fcm5d_ins = 0;
        int fcm5d_m_ins = 0;
        int sys92_ins = 0;

        boolean mFlag = false;

        String appvPrcssNo = webInvoiceMapper.selectNextAppvPrcssNo();
        params.put("appvPrcssNo", appvPrcssNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());
        params.put("userName", sessionVO.getUserName());

        List<Object> apprGridList = (List<Object>) params.get("apprGridList");
        params.put("appvLineCnt", apprGridList.size());

        fcm4m_ins = vendorAdvanceMapper.insertApproveManagement(params);

        if(apprGridList.size() > 0) {
            Map hm = null;
            List<String> appvLineUserId = new ArrayList<>();

            for(Object map : apprGridList) {
                hm = (HashMap<String, Object>) map;
                hm.put("appvPrcssNo", appvPrcssNo);
                hm.put("userId", sessionVO.getUserId());
                hm.put("userName", sessionVO.getUserName());

                fcm5d_ins = vendorAdvanceMapper.insertApproveLineDetail(hm);

                appvLineUserId.add(hm.get("memCode").toString());
            }

            // Insert relevant last line approver's detail (FCM0023M) in FCM0005D
            params.put("clmType", params.get("clmNo").toString().substring(0, 2));

            EgovMap e1 = webInvoiceMapper.getFinApprover(params);
            String memCode = e1.get("apprMemCode").toString();
            memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;

            if(!appvLineUserId.contains(memCode)) {
                mFlag = true;
                Map mAppr = new HashMap<String, Object>();
                mAppr.put("appvPrcssNo", appvPrcssNo);
                mAppr.put("userId",sessionVO.getUserId());
                mAppr.put("memCode", memCode);

                vendorAdvanceMapper.insMissAppr(mAppr);
            }

            Map ntf = (HashMap<String, Object>) apprGridList.get(0);
            ntf.put("clmNo", params.get("clmNo"));

            EgovMap ntfDtls = new EgovMap();
            ntfDtls = (EgovMap) webInvoiceMapper.getClmDesc(params);
            ntf.put("codeName", ntfDtls.get("codeDesc"));

            ntfDtls = (EgovMap) webInvoiceMapper.getNtfUser(ntf);
            ntf.put("reqstUserId", ntfDtls.get("userName"));
            ntf.put("code", params.get("clmNo").toString().substring(0, 2));
            ntf.put("appvStus", "R");
            ntf.put("rejctResn", "Pending Approval.");

            sys92_ins = vendorAdvanceMapper.insertNotification(ntf);

            if(params.containsKey("clmNo")) {
                params.put("clmType", params.get("clmNo").toString().substring(0, 2));
            } else if(params.containsKey("reqNewClmNo")) {
                params.put("clmType", params.get("reqNewClmNo").toString().substring(0, 2));
                params.put("clmNo", params.get("reqNewClmNo"));
            }
            params.put("appvItmSeq", 1);


            if(params.containsKey("reqAdvType") && params.get("reqAdvType") != null && params.get("reqAdvType").equals("5"))
            {
            	params.put("expType", params.get("reqAdvType"));
            	params.put("expTypeNm", "Vendor Advance Expenses");
            	params.put("costCenter", params.get("reqCostCentr"));
                params.put("expDesc", params.get("advRem"));
                params.put("amt", params.get("totalAdv"));
                params.put("atchFileGrpId", params.get("reqAtchFileGrpId"));
            }
            else if(params.containsKey("settlementType") && params.get("settlementType") != null && params.get("settlementType").equals("6"))
            {
            	params.put("expTypeNm", "Vendor Advance Expenses Refund");
            	params.put("expType", params.get("settlementType"));
            	params.put("costCenter", params.get("settlementCostCenter"));
            	//params.put("amt", params.get("settlementTotAmt"));
            	params.put("amt", params.get("settlementTotalExp"));
            	params.put("expDesc", params.get("settlementRem"));
            	params.put("atchFileGrpId", params.get("settlementAtchFileGrpId"));
            	params.put("advCurr", "MYR");
            	params.put("memAccId", params.get("settlementMemAccId"));
            }

            vendorAdvanceMapper.insertAppvDetails(params);
        }

        vendorAdvanceMapper.updateAppvPrcssNo(params);

        if((!mFlag && fcm4m_ins == 1 && fcm5d_ins == 1 && sys92_ins == 1) ||
           (mFlag && fcm4m_ins == 1 && fcm5d_ins == 1 && fcm5d_m_ins == 1 && sys92_ins == 1)) {
            ins = 1;
        }

        return ins;
    }

    @Override
    public EgovMap selectVendorAdvanceDetails(String clmNo) {
        return vendorAdvanceMapper.selectVendorAdvanceDetails(clmNo);
    }

    @Override
    public List<EgovMap> selectVendorAdvanceItems(String clmNo) {
        return vendorAdvanceMapper.selectVendorAdvanceItems(clmNo);
    }

    @Override
    public EgovMap getAppvInfo(String appvPrcssNo) {
        return vendorAdvanceMapper.getAppvInfo(appvPrcssNo);
    }

    @Override
    public int updateVendorAdvReq(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.updateVendorAdvReq ==========");
        LOGGER.debug("vendorAdvance.updateVendorAdvReq :: params >>>>> ", params);

        params.put("advType", "5");
        params.put("clmNo", params.get("reqNewClmNo"));
        params.put("userId", sessionVO.getUserId());
        params.put("totAmt", params.get("totalAdv"));
        params.put("costCenterCode", params.get("reqCostCentr"));
        params.put("clmSeq", "1");

        int rtn = 0;

        int mstUpd = vendorAdvanceMapper.updateAdvMst_FCM27M(params);
        int dtlUpd = vendorAdvanceMapper.updateAdvDet_FCM28D(params);

        if(mstUpd > 0 && dtlUpd > 0) rtn = 1;

        return rtn;
    }

    @Override
    public int updateVendorAdvSettlement(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.updateVendorAdvSettlement ==========");
        LOGGER.debug("vendorAdvance.updateVendorAdvSettlement :: params >>>>> "+ params);

        int rtn = 0;

        /*
         * Update-able values :
         * 1. Event Date (From & To)
         * 2. Refund Mode
         * 3. Refund Reference
         * 4. Remarks
         * 5. Amount
         */
        params.put("advType", "6");
        params.put("clmNo", params.get("settlementNewClmNo"));
        params.put("userId", sessionVO.getUserId());
        params.put("totAmt", params.get("settlementTotalExp"));
        params.put("costCenterCode", params.get("settlementCostCenter"));

        int mstUpd = vendorAdvanceMapper.updateAdvMst_FCM27M(params);

        Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");

        List<Object> delList = (List<Object>) gridData.get("remove");
        List<Object> addList = (List<Object>) gridData.get("add");
        List<Object> updList = (List<Object>) gridData.get("update");

        int delCnt = 0;
        if(delList.size() > 0) {
            Map hm = null;
            for(Object map : delList) {
                hm = (HashMap<String, Object>) map;
                hm.put("clmNo", params.get("settlementNewClmNo"));
                hm.put("userId", sessionVO.getUserId());

                delCnt += vendorAdvanceMapper.deleteAdvDet_FCM28D(hm);
            }
        }

        int addCnt = 0;
        if(addList.size() > 0) {
            Map hm = null;
            for(Object map : addList) {
                hm = (HashMap<String, Object>) map;
                hm.put("clmNo", params.get("settlementNewClmNo"));

                int clmSeq = vendorAdvanceMapper.selectNextClmSeq((String) params.get("clmNo"));
                hm.put("clmSeq", clmSeq);
                hm.put("advType", "6");
                hm.put("userId", sessionVO.getUserId());

                addCnt += vendorAdvanceMapper.insertAdvDet_FCM28D(hm);
            }
        }

        int updCnt = 0;
        if(updList.size() > 0) {
            Map hm = null;
            for(Object map : updList) {
                hm = (HashMap<String, Object>) map;
                hm.put("clmNo", params.get("settlementNewClmNo"));
                hm.put("advType", "6");
                hm.put("userId", sessionVO.getUserId());
                LOGGER.debug("hm----->" + hm);
                updCnt += vendorAdvanceMapper.updateAdvDet_FCM28D(hm);
            }
        }

        if(mstUpd > 0) {
            rtn = 1;

            if(delList.size() > 0 && delCnt <= 0) rtn = 0;
            if(addList.size() > 0 && addCnt <= 0) rtn = 0;
            if(updList.size() > 0 && updCnt <= 0) rtn = 0;
        }

        return rtn;
    }

    @Override
    public int manualVendorAdvReqSettlement(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.manualVendorAdvReqSettlement ==========");
        LOGGER.debug("vendorAdvance.manualVendorAdvReqSettlement :: params >>>>> ", params);

        params.put("userId", sessionVO.getUserId());

        int rtn = vendorAdvanceMapper.manualVendorAdvReqSettlement(params);

        return rtn;
    }

    @Override
	public String selectNextReqNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
    	LOGGER.debug("selectNextReqNo =====================================>>  " + params);
		return vendorAdvanceMapper.selectNextReqNo(params);
	}

    @Override
    public void editRejected(Map<String, Object> params) {
        // TODO Auto-generated method stub

        LOGGER.debug("editRejected =====================================>>  " + params);

        EgovMap attachmentDetails = new EgovMap();
        attachmentDetails = (EgovMap) vendorAdvanceMapper.getAttachmenDetails(params);
        params.put("exFileAtchGrpId", attachmentDetails.get("atchFileGrpId"));
        params.put("exFileAtchId", attachmentDetails.get("atchFileId"));

        // Duplicate File ID
        int newFileAtchGrpId = vendorAdvanceMapper.getFileAtchGrpId();
        int newFileAtchId = vendorAdvanceMapper.getFileAtchId();
        params.put("newFileAtchGrpId", newFileAtchGrpId);
        params.put("newFileAtchId", newFileAtchId);

        // Insert SYS0070M
        vendorAdvanceMapper.insertSYS0070M_ER(params);

        vendorAdvanceMapper.insertSYS0071D_ER(params);

        if(params.get("reqType").equals("R4"))
        {
        	params.put("advType", 5);
        }
        else if(params.get("reqType").equals("A3"))
        {
        	params.put("advType", 6);
        }
        // Insert FCM0027M
        vendorAdvanceMapper.insertRejectM(params);
        // Insert FCM0028D
        vendorAdvanceMapper.insertRejectD(params);
    }

    @Override
    public EgovMap getAdvType(Map<String, Object> params) {
        return vendorAdvanceMapper.getAdvType(params);
    }

    @Override
    public List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params) {
        return vendorAdvanceMapper.selectAppvInfoAndItems(params);
    }

}
