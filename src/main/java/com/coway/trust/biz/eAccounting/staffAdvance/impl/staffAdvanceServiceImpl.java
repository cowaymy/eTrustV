package com.coway.trust.biz.eAccounting.staffAdvance.impl;

import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.eAccounting.staffAdvance.staffAdvanceService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("staffAdvanceService")
public class staffAdvanceServiceImpl implements staffAdvanceService {

	private static final Logger LOGGER = LoggerFactory.getLogger(staffAdvanceServiceImpl.class);

    @Resource(name = "staffAdvanceMapper")
    private staffAdvanceMapper staffAdvanceMapper;

    @Resource(name = "webInvoiceMapper")
    private WebInvoiceMapper webInvoiceMapper;

    @Autowired
	private AdaptorService adaptorService;

    @Override
    public List<EgovMap> selectAdvanceList(Map<String, Object> params) {
        return staffAdvanceMapper.selectAdvanceList(params);
    }

    @Override
    public EgovMap getAdvConfig(Map<String, Object> params) {
        return staffAdvanceMapper.getAdvConfig(params);
    }

    @Override
    public EgovMap getRqstInfo(Map<String, Object> params) {
        return staffAdvanceMapper.getRqstInfo(params);
    }

    @Override
    public String selectNextClmNo(Map<String, Object> params) {
        return staffAdvanceMapper.selectNextClmNo(params);
    }

    @Override
    public void insertRequest(Map<String, Object> params) {
        staffAdvanceMapper.insertRequest(params);
    }

    @Override
    public void editDraftRequestM(Map<String, Object> params) {
        staffAdvanceMapper.editDraftRequestM(params);
    }

    @Override
    public void editDraftRequestD(Map<String, Object> params) {
        staffAdvanceMapper.editDraftRequestD(params);
    }

    @Override
    public void insertTrvDetail(Map<String, Object> params) {
        staffAdvanceMapper.insertTrvDetail(params);
    }

    @Override
    public void insertApproveManagement(Map<String, Object> params) {
        webInvoiceMapper.insertApproveManagement(params);
    }

    @Override
    public void insertApproveLineDetail(Map<String, Object> params) {
        webInvoiceMapper.insertApproveLineDetail(params);
    }

    @Override
    public void insMissAppr(Map<String, Object> params) {
        webInvoiceMapper.insMissAppr(params);
    }

    @Override
    public EgovMap getClmDesc(Map<String, Object> params) {
        return webInvoiceMapper.getClmDesc(params);
    }

    @Override
    public EgovMap getNtfUser(Map<String, Object> params) {
        return webInvoiceMapper.getNtfUser(params);
    }

    @Override
    public void insertNotification(Map<String, Object> params) {
        webInvoiceMapper.insertNotification(params);
    }

    @Override
    public void updateAdvanceReqInfo(Map<String, Object> params) {
        staffAdvanceMapper.updateAdvanceReqInfo(params);
    }

    @Override
    public EgovMap getRefDtls(Map<String, Object> params) {
        return staffAdvanceMapper.getRefDtls(params);
    }

    @Override
    public void insertRefund(Map<String, Object> params) {
        staffAdvanceMapper.insertRefund(params);
    }

    @Override
    public void insertAppvDetails(Map<String, Object> params) {
        staffAdvanceMapper.insertAppvDetails(params);
    }

    @Override
    public void updateAdvRequest(Map<String, Object> params) {
        staffAdvanceMapper.updateAdvRequest(params);
    }

    @Override
    public EgovMap getAdvType(Map<String, Object> params) {
        return staffAdvanceMapper.getAdvType(params);
    }

    @Override
    public List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params) {
        return staffAdvanceMapper.selectAppvInfoAndItems(params);
    }

    @Override
    public EgovMap getAdvClmInfo(Map<String, Object> params) {
        return staffAdvanceMapper.getAdvClmInfo(params);
    }

    @Override
    public void updateTotal(Map<String, Object> params) {
        staffAdvanceMapper.updateTotal(params);
    }

    @Override
    public void saveAdvReq(Map<String, Object> params, SessionVO sessionVO) {
    	LOGGER.debug("=============== saveAdvReq.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        String pClmNo = params.get("clmNo").toString();

        if(pClmNo.isEmpty()) {
            String clmType = "";
            String glAccNo = "";
            int clmSeq = 1;

            if("1".equals(params.get("reqAdvType")) || "3".equals(params.get("reqAdvType"))) {
                clmType = "REQ";
                if("1".equals(params.get("reqAdvType"))) {
                    glAccNo = "1240300";
                } else {
                    glAccNo = "1240200";
                }
            } else if("2".equals(params.get("reqAdvType")) || "4".equals(params.get("reqAdvType"))) {
                clmType = "REF";
                glAccNo = "22200400";
            }

            params.put("clmType", clmType);
            params.put("glAccNo", glAccNo);

            String clmNo = selectNextClmNo(params);
            params.put("clmNo", clmNo);
            params.put("userId", sessionVO.getUserId());

            this.insertRequest(params);

            Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
            hmTrv.put("clmNo", clmNo);

            if("1".equals(params.get("reqAdvType"))) {
                // Staff Travel Request
                if(Double.parseDouble(params.get("accmdtAmt").toString()) != 0.00) {
                    hmTrv.put("clmSeq", clmSeq);
                    hmTrv.put("expType", "AD001");
                    hmTrv.put("expTypeNm", "Accommodation");
                    hmTrv.put("dAmt", params.get("accmdtAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    insertTrvDetail(hmTrv);
                    clmSeq++;
                }

                if(Double.parseDouble(params.get("mileageAmt").toString()) != 0.00) {
                    hmTrv.put("clmSeq", clmSeq);
                    hmTrv.put("expType", "AD002");
                    hmTrv.put("expTypeNm", "Mileage");
                    hmTrv.put("mileage", params.get("mileage"));
                    hmTrv.put("dAmt", params.get("mileageAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    insertTrvDetail(hmTrv);
                    hmTrv.put("mileage", "");
                    clmSeq++;
                }

                if(Double.parseDouble(params.get("tollAmt").toString()) != 0.00) {
                    hmTrv.put("clmSeq", clmSeq);
                    hmTrv.put("expType", "AD003");
                    hmTrv.put("expTypeNm", "Toll");
                    hmTrv.put("dAmt", params.get("tollAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    insertTrvDetail(hmTrv);
                    clmSeq++;
                }

                if(Double.parseDouble(params.get("othTrsptAmt").toString()) != 0.00) {
                    hmTrv.put("clmSeq", clmSeq);
                    hmTrv.put("expType", "AD004");
                    hmTrv.put("expTypeNm", "Other Transportation");
                    hmTrv.put("dAmt", params.get("othTrsptAmt"));
                    hmTrv.put("rem", params.get("trsptMode"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    insertTrvDetail(hmTrv);
                    clmSeq++;
                }
            } else if("3".equals(params.get("reqAdvType"))) {
                // Staff/Company Event Advance Request
            }

        } else {
            editDraftRequestM(params);

            Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
            hmTrv.put("clmNo", params.get("clmNo"));

            if("1".equals(params.get("reqAdvType"))) {

                hmTrv.put("advType", params.get("reqAdvType"));

                // Staff Travel Request
                if(Double.parseDouble(params.get("accmdtAmt").toString()) != 0.00) {
                    hmTrv.put("expType", "AD001");
                    hmTrv.put("expTypeNm", "Accommodation");
                    hmTrv.put("dAmt", params.get("accmdtAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    editDraftRequestD(hmTrv);
                }

                if(Double.parseDouble(params.get("mileageAmt").toString()) != 0.00) {
                    hmTrv.put("expType", "AD002");
                    hmTrv.put("expTypeNm", "Mileage");
                    hmTrv.put("mileage", params.get("mileage"));
                    hmTrv.put("dAmt", params.get("mileageAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    editDraftRequestD(hmTrv);
                    hmTrv.put("mileage", "");
                }

                if(Double.parseDouble(params.get("tollAmt").toString()) != 0.00) {
                    hmTrv.put("expType", "AD003");
                    hmTrv.put("expTypeNm", "Toll");
                    hmTrv.put("dAmt", params.get("tollAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    editDraftRequestD(hmTrv);
                }

                if(Double.parseDouble(params.get("othTrsptAmt").toString()) != 0.00) {
                    hmTrv.put("expType", "AD004");
                    hmTrv.put("expTypeNm", "Other Transportation");
                    hmTrv.put("dAmt", params.get("othTrsptAmt"));
                    hmTrv.put("rem", params.get("trsptMode"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    editDraftRequestD(hmTrv);
                }

                updateTotal(hmTrv);
            }
        }

        LOGGER.debug("staffadvancecontroller :: saveAdvReq :: " + params);
    }
    @Override
    public void submitAdvReq(Map<String, Object> params, SessionVO sessionVO) {
    	LOGGER.debug("=============== submitAdvReq.do ===============");
    	LOGGER.debug("params ==============================>> " + params);

    	params.put("userId", sessionVO.getUserId());
        params.put("userName", sessionVO.getUserName());

        if(params.containsKey("refClmNo")) {
            params.put("clmNo", params.get("refClmNo"));
            params.put("appvPrcssDesc", params.get("trvRepayRem"));
        }

        String appvPrcssNo = webInvoiceMapper.selectNextAppvPrcssNo();
        params.put("appvPrcssNo", appvPrcssNo);

        List<Object> apprGridList = (List<Object>) params.get("apprLineGrid");
        params.put("appvLineCnt", apprGridList.size());

        // Insert FCM0004M
        insertApproveManagement(params);
        LOGGER.debug("staffAdvance :: insertApproveManagement");

        if(apprGridList.size() > 0) {
            Map hm = null;
            List<String> appvLineUserId = new ArrayList<>();

            for(Object map : apprGridList) {
                hm = (HashMap<String, Object>) map;
                hm.put("appvPrcssNo", params.get("appvPrcssNo"));
                hm.put("userId", params.get("userId"));
                hm.put("userName", params.get("userName"));
                insertApproveLineDetail(hm);
            }

            if(params.containsKey("clmNo")) {
                params.put("clmType", params.get("clmNo").toString().substring(0, 2));
            } else if(params.containsKey("refClmNo")) {
                params.put("clmType", params.get("refClmNo").toString().substring(0, 2));
                params.put("clmNo", params.get("refClmNo"));
            }

            // Insert missed out final designated approver
            EgovMap e1 = webInvoiceMapper.getFinApprover(params);
            String memCode = e1.get("apprMemCode").toString();
            memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
            if(!appvLineUserId.contains(memCode)) {
                Map mAppr = new HashMap<String, Object>();
                mAppr.put("appvPrcssNo", params.get("appvPrcssNo"));
                mAppr.put("userId", params.get("userId"));
                mAppr.put("memCode", memCode);
                insMissAppr(mAppr);
            }

            Map ntf = (HashMap<String, Object>) apprGridList.get(0);
            if(params.containsKey("clmNo")) {
                ntf.put("clmNo", params.get("clmNo"));
            } else if(params.containsKey("refClmNo")) {
                ntf.put("clmNo", params.get("refClmNo"));
            }

            EgovMap ntfDtls = new EgovMap();
            ntfDtls = (EgovMap) getClmDesc(params);
            ntf.put("codeName", ntfDtls.get("codeDesc"));

            ntfDtls = (EgovMap) getNtfUser(ntf);
            ntf.put("reqstUserId", ntfDtls.get("userName"));
            ntf.put("code", params.get("clmNo").toString().substring(0, 2));
            ntf.put("appvStus", "R");
            ntf.put("rejctResn", "Pending Approval.");
            ntf.put("userId", sessionVO.getUserId());

            LOGGER.debug("ntf =====================================>>  " + ntf);

            insertNotification(ntf);
        }

        LOGGER.debug("staffAdvance :: insert approval details");
        // Insert Approval Details
        LOGGER.debug("staffAdvanceImpl :: params ================================" + params);
        Map hm = new HashMap<String, Object>();
        hm.put("appvPrcssNo", appvPrcssNo);
        String advType = "";
        if(params.containsKey("reqAdvType")) {
            advType = (String) params.get("reqAdvType");
        } else if(params.containsKey("refAdvType")) {
            advType = (String) params.get("refAdvType");
        }

        if("1".equals(advType) || "3".equals(advType)) {
            hm.put("appvItmSeq", "1");
            hm.put("memAccId", params.get("payeeCode"));
            hm.put("payDueDt", params.get("refdDate"));
            hm.put("expType", params.get("reqAdvType"));
            if("1".equals(advType)) {
                hm.put("expTypeNm", "Staff Travel Expenses");
                hm.put("glAccNo", "1240300");
                hm.put("glAccNm", "Advances-Staff Travel Expenses");
                hm.put("billPeriodFr", params.get("trvPeriodFr"));
                hm.put("billPeriodTo", params.get("trvPeriodTo"));
            } /*else {
                hm.put("expTypeNm", "Staff/Company Events");
                hm.put("glAccNo", "1240200");
                hm.put("glAccNm", "Advances-Staff(Company/Events)");
                //hm.put("billPeriodFr", params.get(key));
                //hm.put("billPeriodTo", params.get(key));
            }*/
            hm.put("costCenter", params.get("costCenterCode"));
            hm.put("costCenterNm", params.get("costCenterName"));
            hm.put("amt", params.get("reqTotAmt"));
            hm.put("expDesc", params.get("trvReqRem"));
            hm.put("atchFileGrpId", params.get("atchFileGrpId"));
            hm.put("userId", sessionVO.getUserId());

            insertAppvDetails(hm);
            LOGGER.debug("staffAdvance :: insertAppvDetails");

        } else if("2".equals(advType) || "4".equals(advType)) {

            hm.put("appvItmSeq", "1");
            hm.put("memAccId", params.get("refPayeeCode"));
            hm.put("invcNo", params.get("trvBankRefNo"));
            hm.put("invcDt", params.get("trvAdvRepayDate"));
            hm.put("expType", params.get("refAdvType"));
            if("2".equals(advType)) {
                hm.put("expTypeNm", "Staff Travel Expenses Repayment");
                hm.put("glAccNo", "12510100");
                hm.put("glAccNm", "CIMB Bhd 8000 58 6175");
            } /*else {
                hm.put("expTypeNm", "Staff/Company Events");
                hm.put("glAccNo", "1240200");
                hm.put("glAccNm", "Advances-Staff(Company/Events) Repayment");
                //hm.put("billPeriodFr", params.get(key));
                //hm.put("billPeriodTo", params.get(key));
            }*/
            hm.put("costCenter", params.get("refCostCenterCode"));
            hm.put("amt", params.get("trvAdvRepayAmt"));
            hm.put("expDesc", params.get("trvRepayRem"));
            hm.put("atchFileGrpId", params.get("refAtchFileGrpId"));
            hm.put("userId", sessionVO.getUserId());
            LOGGER.debug("staffAdvanceImpl :: hm ================================" + hm);
            insertAppvDetails(hm);

        }

        updateAdvanceReqInfo(params);

    	LOGGER.debug("staffadvanceimplementation :: saveAdvReq :: " + params);
    }

    @Override
    public void saveAdvRef(Map<String, Object> params, SessionVO sessionVO) {
    	LOGGER.debug("=============== saveAdvRef.do ===============");
    	LOGGER.debug("params ==============================>> " + params);

    	int clmSeq = 1;

        params.put("clmType", "REF");
        params.put("glAccNo", "22200400");

        if(params.get("refMode") != null && params.get("refMode").equals("DRAFT")){
        	params.put("clmNo", params.get("refClmNo"));
        }

        String pClmNo = params.containsKey("clmNo") ? params.get("clmNo").toString() : "";

        if(pClmNo.isEmpty()) {
            // Refund New Save

            String clmNo = selectNextClmNo(params);
            params.put("clmNo", clmNo);
            params.put("userId", sessionVO.getUserId());

            // Insert FCM0027M
            insertRefund(params);

            Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
            hmTrv.put("clmNo", clmNo);

            if("2".equals(params.get("refAdvType"))) {
                // Advance Refund for Staff Travelling Advance
                hmTrv.put("clmSeq", clmSeq);
                hmTrv.put("invcNo", params.get("trvBankRefNo"));
                hmTrv.put("invcDt", params.get("trvAdvRepayDate"));
                hmTrv.put("expType", "AD101");
                hmTrv.put("expTypeNm", "Refund Travel Advance");
                hmTrv.put("dAmt", params.get("trvAdvRepayAmt"));
                hmTrv.put("userId", sessionVO.getUserId());
                insertTrvDetail(hmTrv);

            } else if("4".equals(params.get("reqAdvType"))) {
                // Advance Refund for Staff/Company Event
            }
        } else {

        	if(params.get("refMode") != null && params.get("refMode").equals("DRAFT")){
        		if("2".equals(params.get("refAdvType"))) {
        			params.put("advType", params.get("refAdvType"));
        			params.put("bankInDt", params.get("trvAdvBankInDate"));
        		}
        		params.put("costCenterCode", params.get("refCostCenterCode"));
        		params.put("costCenterName", params.get("refCostCenterName"));
        		params.put("payeeCode", params.get("refPayeeCode"));
        		params.put("bankId", params.get("refBankId"));
        		params.put("bankAccNo", params.get("refBankAccNo"));
        		params.put("trvReqRem", params.get("trvRepayRem"));
        		params.put("refdDate", params.get("trvAdvRepayDate"));
        	}
        	editDraftRequestM(params);

            Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
            hmTrv.put("clmNo", params.get("clmNo"));

            if("2".equals(params.get("refAdvType"))) {
                // Advance Refund for Staff Travelling Advance
            	hmTrv.put("advType", params.get("refAdvType"));
                hmTrv.put("invcNo", params.get("trvBankRefNo"));
                hmTrv.put("invcDt", params.get("trvAdvRepayDate"));
                hmTrv.put("expType", "AD101");
                hmTrv.put("expTypeNm", "Refund Travel Advance");
                hmTrv.put("dAmt", params.get("trvAdvRepayAmt"));
                hmTrv.put("userId", sessionVO.getUserId());

                editDraftRequestD(hmTrv);

            }

        }

        updateAdvRequest(params);

    	LOGGER.debug("staffadvanceimplementation :: saveAdvRef :: " + params);
    }

    @Override
    public void editRejected(Map<String, Object> params) {
        // TODO Auto-generated method stub

        LOGGER.debug("editRejected =====================================>>  " + params);

        EgovMap attachmentDetails = new EgovMap();
        attachmentDetails = (EgovMap) staffAdvanceMapper.getAttachmenDetails(params);
        params.put("exFileAtchGrpId", attachmentDetails.get("atchFileGrpId"));
        params.put("exFileAtchId", attachmentDetails.get("atchFileId"));

        // Duplicate File ID
        int newFileAtchGrpId = staffAdvanceMapper.getFileAtchGrpId();
        int newFileAtchId = staffAdvanceMapper.getFileAtchId();
        params.put("newFileAtchGrpId", newFileAtchGrpId);
        params.put("newFileAtchId", newFileAtchId);

        // Insert SYS0070M
        staffAdvanceMapper.insertSYS0070M_ER(params);

        staffAdvanceMapper.insertSYS0071D_ER(params);

        if(params.get("reqType").equals("R2"))
        {
        	params.put("reqAdvType", 1);
        }
        else if(params.get("reqType").equals("A1"))
        {
        	params.put("reqAdvType", 2);
        }
        // Insert FCM0027M
        staffAdvanceMapper.insertRejectM(params);
        // Insert FCM0028D
        staffAdvanceMapper.insertRejectD(params);

        params.put("clmNo", params.get("newClmNo"));

        staffAdvanceMapper.updateAdvRequest(params);

    }

    @Override
	public List<EgovMap> selectBank() {
		// TODO Auto-generated method stub
		return staffAdvanceMapper.selectBank();
	}
}
