package com.coway.trust.biz.payment.billinggroup.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.payment.billinggroup.service.BillingGroupService;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("billingGroupService")
public class BillingGroupServiceImpl extends EgovAbstractServiceImpl implements BillingGroupService {

    @Resource(name = "billingGroupMapper")
    private BillingGroupMapper billingGroupMapper;

    @Autowired
    private AdaptorService adaptorService;

    @Value("${autodebit.email.receiver}")
    private String emailReceiver;

    @Value("${billing.type.confirm.url}")
    private String billingTypeConfirmUrl;

    private static final Logger logger = LoggerFactory.getLogger(BillingGroupServiceImpl.class);

    /**
     * selectCustBillId 조회
     *
     * @param params
     * @return
     */
    @Override
    public String selectCustBillId(Map<String, Object> params) {
        return billingGroupMapper.selectCustBillId(params);
    }

    /**
     * selectBasicInfo 조회
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectBasicInfo(Map<String, Object> params) {
        return billingGroupMapper.selectBasicInfo(params);
    }

    /**
     * selectMaillingInfo 조회
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectMaillingInfo(Map<String, Object> params) {
        return billingGroupMapper.selectMaillingInfo(params);
    }

    /**
     * selectContractInfo 조회
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectContractInfo(Map<String, Object> params) {
        return billingGroupMapper.selectContractInfo(params);
    }

    /**
     * selectOrderGroupList 조회
     *
     * @param params
     * @return
     */
    @Override
    public List<EgovMap> selectOrderGroupList(Map<String, Object> params) {
        return billingGroupMapper.selectOrderGroupList(params);
    }

    /**
     * selectEstmReqHistory 조회
     *
     * @param params
     * @return
     */
    @Override
    public List<EgovMap> selectEstmReqHistory(Map<String, Object> params) {
        return billingGroupMapper.selectEstmReqHistory(params);
    }

    /**
     * selectBillGrpHistory 조회
     *
     * @param params
     * @return
     */
    @Override
    public List<EgovMap> selectBillGrpHistory(Map<String, Object> params) {
        return billingGroupMapper.selectBillGrpHistory(params);
    }

    /**
     * selectBillGrpOrder 조회
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectBillGrpOrder(Map<String, Object> params) {
        return billingGroupMapper.selectBillGrpOrder(params);
    }

    /**
     * selectBillGrpHistory 조회
     *
     * @param params
     * @return
     */
    @Override
    public List<EgovMap> selectBillGroupOrderView(Map<String, Object> params) {
        return billingGroupMapper.selectBillGroupOrderView(params);
    }

    /**
     * updRemark 업데이트
     *
     * @param params
     * @return
     */
    @Override
    public void updCustMaster(Map<String, Object> params) {
        billingGroupMapper.updCustMaster(params);
    }

    /**
     * updSalesOrderMaster 업데이트
     *
     * @param params
     * @return
     */
    @Override
    public void updSalesOrderMaster(Map<String, Object> params) {
        billingGroupMapper.updSalesOrderMaster(params);
    }

    /**
     * insRemarkHis
     *
     * @param params
     * @return
     */
    @Override
    public int insHistory(Map<String, Object> params) {
        return billingGroupMapper.insHistory(params);
    }

    /**
     * selectDetailHistoryView 조회
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectDetailHistoryView(Map<String, Object> params) {
        return billingGroupMapper.selectDetailHistoryView(params);
    }

    /**
     * selectMailAddrHistorty 조회
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectMailAddrHistorty(String param) {
        return billingGroupMapper.selectMailAddrHistorty(param);
    }

    /**
     * selectContPersonHistorty 조회
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectContPersonHistorty(String param) {
        return billingGroupMapper.selectContPersonHistorty(param);
    }

    /**
     * selectCustMailAddrList 조회
     *
     * @param params
     * @return
     */
    @Override
    public List<EgovMap> selectCustMailAddrList(Map<String, Object> params) {
        return billingGroupMapper.selectCustMailAddrList(params);
    }

    /**
     * selectSalesOrderM 조회
     *
     * @param params
     * @return
     */
    @Override
    public List<EgovMap> selectSalesOrderM(Map<String, Object> params) {
        return billingGroupMapper.selectSalesOrderM(params);
    }

    /**
     * selectContPersonList 조회
     *
     * @param params
     * @return
     */
    @Override
    public List<EgovMap> selectContPersonList(Map<String, Object> params) {
        return billingGroupMapper.selectContPersonList(params);
    }

    /**
     * selectCustBillMaster 조회
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectCustBillMaster(Map<String, Object> params) {
        return billingGroupMapper.selectCustBillMaster(params);
    }

    /**
     * selectReqMaster 조회
     *
     * @param params
     * @return
     */
    @Override
    public List<EgovMap> selectReqMaster(Map<String, Object> params) {
        return billingGroupMapper.selectReqMaster(params);
    }

    /**
     * updReqEstm
     *
     * @param params
     * @return
     */
    @Override
    public void updReqEstm(Map<String, Object> params) {
        billingGroupMapper.updReqEstm(params);
    }

    /**
     * selectDocNo
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectDocNo(Map<String, Object> params) {
        return billingGroupMapper.selectDocNo(params);
    }

    /**
     * updDocNo
     *
     * @param params
     * @return
     */
    @Override
    public void updDocNo(Map<String, Object> params) {
        billingGroupMapper.updDocNo(params);
    }

    /**
     * insEstmReq
     *
     * @param params
     * @return
     */
    @Override
    public void insEstmReq(Map<String, Object> params) {
        billingGroupMapper.insEstmReq(params);
    }

    /**
     * selectEstmReqHisView
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectEstmReqHisView(Map<String, Object> params) {
        return billingGroupMapper.selectEstmReqHisView(params);
    }

    /**
     * selectEStatementReqs
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectEStatementReqs(Map<String, Object> params) {
        return billingGroupMapper.selectEStatementReqs(params);
    }

    /**
     * selectBillGrpOrdView
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectBillGrpOrdView(Map<String, Object> params) {
        return billingGroupMapper.selectBillGrpOrdView(params);
    }

    /**
     * selectBillGrpOrdView
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectSalesOrderMs(Map<String, Object> params) {
        return billingGroupMapper.selectSalesOrderMs(params);
    }

    /**
     * selectReplaceOrder
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectReplaceOrder(Map<String, Object> params) {
        return billingGroupMapper.selectReplaceOrder(params);
    }

    /**
     * selectAddOrdList 조회
     *
     * @param params
     * @return
     */
    @Override
    public List<EgovMap> selectAddOrdList(Map<String, Object> params) {
        return billingGroupMapper.selectAddOrdList(params);
    }

    /**
     * selectMainOrderHistory
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectMainOrderHistory(Map<String, Object> params) {
        return billingGroupMapper.selectMainOrderHistory(params);
    }

    /**
     * insBillGrpMaster
     *
     * @param params
     * @return
     */
    @Override
    public void insBillGrpMaster(Map<String, Object> params) {
        billingGroupMapper.insBillGrpMaster(params);
    }

    /**
     * selectGetOrder
     *
     * @param params
     * @return
     */
    @Override
    public EgovMap selectGetOrder(Map<String, Object> params) {
        return billingGroupMapper.selectGetOrder(params);
    }

    /**
     * getSAL0024DSEQ
     *
     * @param params
     * @return
     */
    @Override
    public int getSAL0024DSEQ() {
        return billingGroupMapper.getSAL0024DSEQ();
    }

    @Override
    @Transactional
    public String saveAddNewGroup(Map<String, Object> params, SessionVO sessionVO) {

        String defaultDate = "1900-01-01";
        int userId = sessionVO.getUserId();
        String grpNo = "";
        params.put("defaultDate", defaultDate);

        EgovMap selectSalesOrderMs = billingGroupMapper.selectSalesOrderMs(params);

        if (selectSalesOrderMs != null && Integer.parseInt(String.valueOf(selectSalesOrderMs.get("salesOrdId"))) > 0) {
            params.put("custBillId", String.valueOf(selectSalesOrderMs.get("custBillId")));
            EgovMap selectCustBillMaster = billingGroupMapper.selectCustBillMaster(params);

            if (selectCustBillMaster != null
                    && Integer.parseInt(String.valueOf(selectCustBillMaster.get("custBillId"))) > 0) {

                // Insert history (Remove Order) - previous group
                // 인서트 셋팅 시작
                String salesOrderIDOld = String.valueOf(selectSalesOrderMs.get("salesOrdId"));
                String salesOrderIDNew = "0";
                String contactIDOld = "0";
                String contactIDNew = "0";
                String addressIDOld = "0";
                String addressIDNew = "0";
                String statusIDOld = "0";
                String statusIDNew = "0";
                String remarkOld = "";
                String remarkNew = "";
                String emailOld = "";
                String emailNew = "";
                String isEStatementOld = "0";
                String isEStatementNew = "0";
                String isSMSOld = "0";
                String isSMSNew = "0";
                String isPostOld = "0";
                String isPostNew = "0";
                String isEInvFlgOld = "0";
                String isEInvFlgNew = "0";
                String typeId = "1046";
                String sysHisRemark = "[System] Group Order - Remove Order";
                String emailAddtionalNew = "";
                String emailAddtionalOld = "";

                Map<String, Object> hisRemoveOrdMap = new HashMap<String, Object>();
                hisRemoveOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                hisRemoveOrdMap.put("userId", userId);
                hisRemoveOrdMap.put("reasonUpd", "[System] Move to new group.");
                hisRemoveOrdMap.put("salesOrderIDOld", salesOrderIDOld);
                hisRemoveOrdMap.put("salesOrderIDNew", salesOrderIDNew);
                hisRemoveOrdMap.put("contactIDOld", contactIDOld);
                hisRemoveOrdMap.put("contactIDNew", contactIDNew);
                hisRemoveOrdMap.put("addressIDOld", addressIDOld);
                hisRemoveOrdMap.put("addressIDNew", addressIDNew);
                hisRemoveOrdMap.put("statusIDOld", statusIDOld);
                hisRemoveOrdMap.put("statusIDNew", statusIDNew);
                hisRemoveOrdMap.put("remarkOld", remarkOld);
                hisRemoveOrdMap.put("remarkNew", remarkNew);
                hisRemoveOrdMap.put("emailOld", emailOld);
                hisRemoveOrdMap.put("emailNew", emailNew);
                hisRemoveOrdMap.put("isEStatementOld", isEStatementOld);
                hisRemoveOrdMap.put("isEStatementNew", isEStatementNew);
                hisRemoveOrdMap.put("isSMSOld", isSMSOld);
                hisRemoveOrdMap.put("isSMSNew", isSMSNew);
                hisRemoveOrdMap.put("isPostOld", isPostOld);
                hisRemoveOrdMap.put("isPostNew", isPostNew);
                hisRemoveOrdMap.put("isEInvFlgOld", isEInvFlgOld);
                hisRemoveOrdMap.put("isEInvFlgNew", isEInvFlgNew);
                hisRemoveOrdMap.put("typeId", typeId);
                hisRemoveOrdMap.put("sysHisRemark", sysHisRemark);
                hisRemoveOrdMap.put("emailAddtionalNew", emailAddtionalNew);
                hisRemoveOrdMap.put("emailAddtionalOld", emailAddtionalOld);
                billingGroupMapper.insHistory(hisRemoveOrdMap);

                if (String.valueOf(selectCustBillMaster.get("custBillSoId"))
                        .equals(String.valueOf(selectSalesOrderMs.get("salesOrdId")))) {

                    // Is Main Order in previous group
                    String changeOrderId = "0";
                    // Get first complete order
                    Map<String, Object> replaceOrdMap = new HashMap<String, Object>();
                    replaceOrdMap.put("replaceOrd", "Y");
                    replaceOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                    replaceOrdMap.put("salesOrdId", String.valueOf(selectSalesOrderMs.get("salesOrdId")));
                    EgovMap replcaceOrder_1 = billingGroupMapper.selectReplaceOrder(replaceOrdMap);

                    if (replcaceOrder_1 != null
                            && Integer.parseInt(String.valueOf(replcaceOrder_1.get("salesOrdId"))) > 0) {

                        changeOrderId = String.valueOf(replcaceOrder_1.get("salesOrdId"));

                    } else {

                        Map<String, Object> replaceOrd2Map = new HashMap<String, Object>();
                        replaceOrd2Map.put("replaceOrd2", "Y");
                        replaceOrd2Map.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                        replaceOrd2Map.put("salesOrdId", String.valueOf(selectSalesOrderMs.get("salesOrdId")));
                        EgovMap replcaceOrder_2 = billingGroupMapper.selectReplaceOrder(replaceOrd2Map);

                        if (replcaceOrder_2 != null
                                && Integer.parseInt(String.valueOf(replcaceOrder_2.get("salesOrdId"))) > 0) {

                            changeOrderId = String.valueOf(replcaceOrder_2.get("salesOrdId"));

                        } else {

                            Map<String, Object> replaceOrd3Map = new HashMap<String, Object>();
                            replaceOrd3Map.put("replaceOrd3", "Y");
                            replaceOrd3Map.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                            replaceOrd3Map.put("salesOrdId", String.valueOf(selectSalesOrderMs.get("salesOrdId")));
                            EgovMap replcaceOrder_3 = billingGroupMapper.selectReplaceOrder(replaceOrd3Map);

                            if (replcaceOrder_3 != null
                                    && Integer.parseInt(String.valueOf(replcaceOrder_3.get("salesOrdId"))) > 0) {
                                changeOrderId = String.valueOf(replcaceOrder_3.get("salesOrdId"));
                            }
                        }
                    }

                    if (Integer.parseInt(changeOrderId) > 0) {

                        // Got order to replace
                        // Insert history (Change Main Order) - previous group
                        String salesOrderIDOld2 = String.valueOf(selectSalesOrderMs.get("salesOrdId"));
                        String salesOrderIDNew2 = changeOrderId;
                        String contactIDOld2 = "0";
                        String contactIDNew2 = "0";
                        String addressIDOld2 = "0";
                        String addressIDNew2 = "0";
                        String statusIDOld2 = "0";
                        String statusIDNew2 = "0";
                        String remarkOld2 = "";
                        String remarkNew2 = "";
                        String emailOld2 = "";
                        String emailNew2 = "";
                        String isEStatementOld2 = "0";
                        String isEStatementNew2 = "0";
                        String isSMSOld2 = "0";
                        String isSMSNew2 = "0";
                        String isPostOld2 = "0";
                        String isPostNew2 = "0";
                        String isEInvFlgOld2 = "0";
                        String isEInvFlgNew2 = "0";
                        String typeId2 = "1046";
                        String sysHisRemark2 = "[System] Group Order - Auto Select Main Order";
                        String emailAddtionalNew2 = "";
                        String emailAddtionalOld2 = "";

                        Map<String, Object> hisChgOrdMap = new HashMap<String, Object>();
                        hisChgOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                        hisChgOrdMap.put("userId", userId);
                        hisChgOrdMap.put("reasonUpd", "[System] Move to new group.");
                        hisChgOrdMap.put("salesOrderIDOld", salesOrderIDOld2);
                        hisChgOrdMap.put("salesOrderIDNew", salesOrderIDNew2);
                        hisChgOrdMap.put("contactIDOld", contactIDOld2);
                        hisChgOrdMap.put("contactIDNew", contactIDNew2);
                        hisChgOrdMap.put("addressIDOld", addressIDOld2);
                        hisChgOrdMap.put("addressIDNew", addressIDNew2);
                        hisChgOrdMap.put("statusIDOld", statusIDOld2);
                        hisChgOrdMap.put("statusIDNew", statusIDNew2);
                        hisChgOrdMap.put("remarkOld", remarkOld2);
                        hisChgOrdMap.put("remarkNew", remarkNew2);
                        hisChgOrdMap.put("emailOld", emailOld2);
                        hisChgOrdMap.put("emailNew", emailNew2);
                        hisChgOrdMap.put("isEStatementOld", isEStatementOld2);
                        hisChgOrdMap.put("isEStatementNew", isEStatementNew2);
                        hisChgOrdMap.put("isSMSOld", isSMSOld2);
                        hisChgOrdMap.put("isSMSNew", isSMSNew2);
                        hisChgOrdMap.put("isPostOld", isPostOld2);
                        hisChgOrdMap.put("isPostNew", isPostNew2);
                        hisChgOrdMap.put("isEInvFlgOld", isEInvFlgOld2);
                        hisChgOrdMap.put("isEInvFlgNew", isEInvFlgNew2);
                        hisChgOrdMap.put("typeId", typeId2);
                        hisChgOrdMap.put("sysHisRemark", sysHisRemark2);
                        hisChgOrdMap.put("emailAddtionalNew", emailAddtionalNew2);
                        hisChgOrdMap.put("emailAddtionalOld", emailAddtionalOld2);
                        billingGroupMapper.insHistory(hisChgOrdMap);
                        // 인서트 셋팅 끝

                        Map<String, Object> updChangeMap = new HashMap<String, Object>();
                        updChangeMap.put("newGrpFlag", "Y");
                        updChangeMap.put("custBillSoId", changeOrderId);
                        updChangeMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                        billingGroupMapper.updCustMaster(updChangeMap);
                    } else {

                        // No replace order found - Inactive billing group
                        // Insert history (Change Main Order) - previous group
                        String salesOrderIDOld2 = "0";
                        String salesOrderIDNew2 = "0";
                        String contactIDOld2 = "0";
                        String contactIDNew2 = "0";
                        String addressIDOld2 = "0";
                        String addressIDNew2 = "0";
                        String statusIDOld2 = String.valueOf(selectCustBillMaster.get("custBillStusId"));
                        String statusIDNew2 = "8";
                        String remarkOld2 = "";
                        String remarkNew2 = "";
                        String emailOld2 = "";
                        String emailNew2 = "";
                        String isEStatementOld2 = "0";
                        String isEStatementNew2 = "0";
                        String isSMSOld2 = "0";
                        String isSMSNew2 = "0";
                        String isPostOld2 = "0";
                        String isPostNew2 = "0";
                        String isEInvFlgOld2 = "0";
                        String isEInvFlgNew2 = "0";
                        String typeId2 = "1046";
                        String sysHisRemark2 = "[System] Group Order - Auto Deactivate";
                        String emailAddtionalNew2 = "";
                        String emailAddtionalOld2 = "";

                        Map<String, Object> hisChgOrdMap = new HashMap<String, Object>();
                        hisChgOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                        hisChgOrdMap.put("userId", userId);
                        hisChgOrdMap.put("reasonUpd", "[System] Move to new group.");
                        hisChgOrdMap.put("salesOrderIDOld", salesOrderIDOld2);
                        hisChgOrdMap.put("salesOrderIDNew", salesOrderIDNew2);
                        hisChgOrdMap.put("contactIDOld", contactIDOld2);
                        hisChgOrdMap.put("contactIDNew", contactIDNew2);
                        hisChgOrdMap.put("addressIDOld", addressIDOld2);
                        hisChgOrdMap.put("addressIDNew", addressIDNew2);
                        hisChgOrdMap.put("statusIDOld", statusIDOld2);
                        hisChgOrdMap.put("statusIDNew", statusIDNew2);
                        hisChgOrdMap.put("remarkOld", remarkOld2);
                        hisChgOrdMap.put("remarkNew", remarkNew2);
                        hisChgOrdMap.put("emailOld", emailOld2);
                        hisChgOrdMap.put("emailNew", emailNew2);
                        hisChgOrdMap.put("isEStatementOld", isEStatementOld2);
                        hisChgOrdMap.put("isEStatementNew", isEStatementNew2);
                        hisChgOrdMap.put("isSMSOld", isSMSOld2);
                        hisChgOrdMap.put("isSMSNew", isSMSNew2);
                        hisChgOrdMap.put("isPostOld", isPostOld2);
                        hisChgOrdMap.put("isPostNew", isPostNew2);
                        hisChgOrdMap.put("isEInvFlgOld", isEInvFlgOld2);
                        hisChgOrdMap.put("isEInvFlgNew", isEInvFlgNew2);
                        hisChgOrdMap.put("typeId", typeId2);
                        hisChgOrdMap.put("sysHisRemark", sysHisRemark2);
                        hisChgOrdMap.put("emailAddtionalNew", emailAddtionalNew2);
                        hisChgOrdMap.put("emailAddtionalOld", emailAddtionalOld2);
                        billingGroupMapper.insHistory(hisChgOrdMap);
                        // 인서트 셋팅 끝

                        Map<String, Object> updChangeMap = new HashMap<String, Object>();
                        updChangeMap.put("newGrpFlag2", "Y");
                        updChangeMap.put("custBillStusId", "8");
                        updChangeMap.put("userId", userId);
                        updChangeMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                        billingGroupMapper.updCustMaster(updChangeMap);

                    }

                }
            }

            Map<String, Object> insBillGrpMap = new HashMap<String, Object>();
            insBillGrpMap.put("custBillSoId", String.valueOf(params.get("salesOrdId")));
            insBillGrpMap.put("custBillCustId", String.valueOf(params.get("custTypeId")));
            insBillGrpMap.put("custBillCntId", String.valueOf(params.get("custCntcId")));
            insBillGrpMap.put("custBillAddId", String.valueOf(params.get("custAddId")));
            insBillGrpMap.put("custBillStusId", "1");
            insBillGrpMap.put("custBillRem", String.valueOf(params.get("custBillRemark")));
            insBillGrpMap.put("userId", userId);
            insBillGrpMap.put("custBillPayTrm", "0");
            insBillGrpMap.put("custBillInchgMemId", "0");
            insBillGrpMap.put("custBillEmail", params.get("email") != null ? String.valueOf(params.get("email")) : "");
            insBillGrpMap.put("custBillIsEstm", "0");
            insBillGrpMap.put("custBillIsSms", String.valueOf(params.get("isSms")));
            insBillGrpMap.put("custBillIsPost", String.valueOf(params.get("isPost")));
            insBillGrpMap.put("custBillIsEInv", String.valueOf(params.get("isEInv")));

            int custBillIdSeq = billingGroupMapper.getSAL0024DSEQ();
            grpNo = billingGroupMapper.selectDocNo24Seq();
            insBillGrpMap.put("custBillIdSeq", custBillIdSeq);
            insBillGrpMap.put("grpNo", grpNo);
            billingGroupMapper.insBillGrpMaster(insBillGrpMap);

            Map<String, Object> updSalesMap = new HashMap<String, Object>();
            updSalesMap.put("userId", userId);
            updSalesMap.put("salesOrdId", String.valueOf(selectSalesOrderMs.get("salesOrdId")));
            updSalesMap.put("custBillId", custBillIdSeq);
            updSalesMap.put("newGrpFlag", "Y");
            // SALES ORDER MASTER UPDATE
            billingGroupMapper.updSalesOrderMaster(updSalesMap);

            String chkEstm = String.valueOf(params.get("isEstm"));
            if (chkEstm.equals("1") && !String.valueOf(params.get("email")).equals("")) {

                Map<String, Object> estmMap = new HashMap<String, Object>();
                estmMap.put("stusCodeId", "44");
                estmMap.put("custBillId", custBillIdSeq);
                estmMap.put("email", String.valueOf(params.get("email")));
                estmMap.put("cnfmCode", CommonUtils.getRandomNumber(10));
                estmMap.put("userId", userId);
                estmMap.put("defaultDate", defaultDate);
                estmMap.put("emailFailInd", "0");
                estmMap.put("emailFailDesc", "");
                estmMap.put("emailAdd", "");
                // estmReq 인서트
                billingGroupMapper.insEstmReq(estmMap);
            }
        }

        return grpNo;
    }

    @Override
    @Transactional
    public boolean saveNewAddr(Map<String, Object> params, SessionVO sessionVO) {

        String defaultDate = "1900-01-01";
        int userId = sessionVO.getUserId();
        params.put("defaultDate", defaultDate);
        params.put("userId", userId);

        // 베이직인포 조회.
        EgovMap selectBasicInfo = billingGroupMapper.selectBasicInfo(params);
        String custBillAddIdOld = selectBasicInfo.get("custBillAddId") != null
                ? String.valueOf(selectBasicInfo.get("custBillAddId")) : "";
        String custBillId = selectBasicInfo.get("custBillId") != null
                ? String.valueOf(selectBasicInfo.get("custBillId")) : "";

        if (selectBasicInfo != null && Integer.parseInt(custBillId) > 0) {

            // 인서트 셋팅 시작
            String salesOrderIDOld = "0";
            String salesOrderIDNew = "0";
            String contactIDOld = "0";
            String contactIDNew = "0";
            String addressIDOld = custBillAddIdOld;
            String addressIDNew = String.valueOf(params.get("custAddId"));
            String statusIDOld = "0";
            String statusIDNew = "0";
            String remarkOld = "";
            String remarkNew = "";
            String emailOld = "";
            String emailNew = "";
            String isEStatementOld = "0";
            String isEStatementNew = "0";
            String isSMSOld = "0";
            String isSMSNew = "0";
            String isPostOld = "0";
            String isPostNew = "0";
            String isEInvFlgOld = "0";
            String isEInvFlgNew = "0";
            String typeId = "1042";
            String sysHisRemark = "[System] Change Mailing Address";
            String emailAddtionalNew = "";
            String emailAddtionalOld = "";

            Map<String, Object> insHisMap = new HashMap<String, Object>();
            insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
            insHisMap.put("userId", userId);
            insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
            insHisMap.put("salesOrderIDOld", salesOrderIDOld);
            insHisMap.put("salesOrderIDNew", salesOrderIDNew);
            insHisMap.put("contactIDOld", contactIDOld);
            insHisMap.put("contactIDNew", contactIDNew);
            insHisMap.put("addressIDOld", addressIDOld);
            insHisMap.put("addressIDNew", addressIDNew);
            insHisMap.put("statusIDOld", statusIDOld);
            insHisMap.put("statusIDNew", statusIDNew);
            insHisMap.put("remarkOld", remarkOld);
            insHisMap.put("remarkNew", remarkNew);
            insHisMap.put("emailOld", emailOld);
            insHisMap.put("emailNew", emailNew);
            insHisMap.put("isEStatementOld", isEStatementOld);
            insHisMap.put("isEStatementNew", isEStatementNew);
            insHisMap.put("isSMSOld", isSMSOld);
            insHisMap.put("isSMSNew", isSMSNew);
            insHisMap.put("isPostOld", isPostOld);
            insHisMap.put("isPostNew", isPostNew);
            insHisMap.put("isEInvFlgOld", isEInvFlgOld);
            insHisMap.put("isEInvFlgNew", isEInvFlgNew);
            insHisMap.put("typeId", typeId);
            insHisMap.put("sysHisRemark", sysHisRemark);
            insHisMap.put("emailAddtionalNew", emailAddtionalNew);
            insHisMap.put("emailAddtionalOld", emailAddtionalOld);
            // 히스토리테이블 인서트
            billingGroupMapper.insHistory(insHisMap);

            // 마스터테이블 업데이트
            Map<String, Object> updCustMap = new HashMap<String, Object>();
            updCustMap.put("userId", userId);
            updCustMap.put("addrFlag", "Y");
            updCustMap.put("addressIDNew", String.valueOf(params.get("custAddId")));
            updCustMap.put("custBillId", custBillId);
            billingGroupMapper.updCustMaster(updCustMap);

            List<EgovMap> selectSalesOrderM = billingGroupMapper.selectSalesOrderM(params);
            if (selectSalesOrderM.size() > 0) {

                for (int i = 0; i < selectSalesOrderM.size(); i++) {
                    Map<String, Object> map = selectSalesOrderM.get(i);
                    String salesOrdId = String.valueOf(map.get("salesOrdId"));

                    Map<String, Object> updSalesMap = new HashMap<String, Object>();
                    updSalesMap.put("userId", userId);
                    updSalesMap.put("salesOrdId", salesOrdId);
                    updSalesMap.put("addressIDNew", String.valueOf(params.get("custAddId")));
                    updSalesMap.put("addrFlag", "Y");
                    // SALES ORDER MASTER UPDATE
                    billingGroupMapper.updSalesOrderMaster(updSalesMap);
                }
            }

            return true;

        } else {

            return false;
        }
    }

    @Override
    @Transactional
    public boolean saveNewContPerson(Map<String, Object> params, SessionVO sessionVO) {

        String defaultDate = "1900-01-01";
        int userId = sessionVO.getUserId();
        params.put("defaultDate", defaultDate);
        params.put("userId", userId);

        EgovMap selectCustBillMaster = billingGroupMapper.selectCustBillMaster(params);
        String custBillCntId = selectCustBillMaster.get("custBillCntId") != null
                ? String.valueOf(selectCustBillMaster.get("custBillCntId")) : "";
        String custBillId = selectCustBillMaster.get("custBillId") != null
                ? String.valueOf(selectCustBillMaster.get("custBillId")) : "";

        if (selectCustBillMaster != null && Integer.parseInt(custBillId) > 0) {

            // 인서트 셋팅 시작
            String salesOrderIDOld = "0";
            String salesOrderIDNew = "0";
            String contactIDOld = custBillCntId;
            String contactIDNew = String.valueOf(params.get("custCntcId"));
            String addressIDOld = "0";
            String addressIDNew = "0";
            String statusIDOld = "0";
            String statusIDNew = "0";
            String remarkOld = "";
            String remarkNew = "";
            String emailOld = "";
            String emailNew = "";
            String isEStatementOld = "0";
            String isEStatementNew = "0";
            String isSMSOld = "0";
            String isSMSNew = "0";
            String isPostOld = "0";
            String isPostNew = "0";
            String isEInvFlgOld = "0";
            String isEInvFlgNew = "0";
            String typeId = "1043";
            String sysHisRemark = "[System] Change Contact Person";
            String emailAddtionalNew = "";
            String emailAddtionalOld = "";

            Map<String, Object> insHisMap = new HashMap<String, Object>();
            insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
            insHisMap.put("userId", userId);
            insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
            insHisMap.put("salesOrderIDOld", salesOrderIDOld);
            insHisMap.put("salesOrderIDNew", salesOrderIDNew);
            insHisMap.put("contactIDOld", contactIDOld);
            insHisMap.put("contactIDNew", contactIDNew);
            insHisMap.put("addressIDOld", addressIDOld);
            insHisMap.put("addressIDNew", addressIDNew);
            insHisMap.put("statusIDOld", statusIDOld);
            insHisMap.put("statusIDNew", statusIDNew);
            insHisMap.put("remarkOld", remarkOld);
            insHisMap.put("remarkNew", remarkNew);
            insHisMap.put("emailOld", emailOld);
            insHisMap.put("emailNew", emailNew);
            insHisMap.put("isEStatementOld", isEStatementOld);
            insHisMap.put("isEStatementNew", isEStatementNew);
            insHisMap.put("isSMSOld", isSMSOld);
            insHisMap.put("isSMSNew", isSMSNew);
            insHisMap.put("isPostOld", isPostOld);
            insHisMap.put("isPostNew", isPostNew);
            insHisMap.put("isEInvFlgOld", isEInvFlgOld);
            insHisMap.put("isEInvFlgNew", isEInvFlgNew);
            insHisMap.put("typeId", typeId);
            insHisMap.put("sysHisRemark", sysHisRemark);
            insHisMap.put("emailAddtionalNew", emailAddtionalNew);
            insHisMap.put("emailAddtionalOld", emailAddtionalOld);

            // 마스터테이블 업데이트
            Map<String, Object> updCustMap = new HashMap<String, Object>();
            updCustMap.put("contPerFlag", "Y");
            updCustMap.put("custBillId", custBillId);
            updCustMap.put("custBillCntId", String.valueOf(params.get("custCntcId")));
            updCustMap.put("userId", userId);
            billingGroupMapper.updCustMaster(updCustMap);

            // 히스토리테이블 인서트
            billingGroupMapper.insHistory(insHisMap);

            List<EgovMap> selectSalesOrderM = billingGroupMapper.selectSalesOrderM(params);
            for (int i = 0; i < selectSalesOrderM.size(); i++) {
                Map<String, Object> map = selectSalesOrderM.get(i);
                String salesOrdId = String.valueOf(map.get("salesOrdId"));

                // SALES ORDER MASTER UPDATE
                Map<String, Object> updSalesMap = new HashMap<String, Object>();
                updSalesMap.put("userId", userId);
                updSalesMap.put("salesOrdId", salesOrdId);
                updSalesMap.put("conPerFlag", "Y");
                updSalesMap.put("custBillCntId", String.valueOf(params.get("custCntcId")));
                billingGroupMapper.updSalesOrderMaster(updSalesMap);
            }

            return true;

        } else {

            return false;

        }
    }

    @Override
    @Transactional
    public boolean saveNewReq(Map<String, Object> params, SessionVO sessionVO) {

        String defaultDate = "1900-01-01";
        int userId = sessionVO.getUserId();
        params.put("defaultDate", defaultDate);
        params.put("userId", userId);

        // master 조회.
        List<EgovMap> reqMaster = billingGroupMapper.selectBeforeReqIDs(params);
        EgovMap selectCustBillMaster = billingGroupMapper.selectCustBillMaster(params);
        String custBillEmail = selectCustBillMaster.get("custBillEmail") != null
                ? String.valueOf(selectCustBillMaster.get("custBillEmail")) : "";
        String custBillIsEstm = selectCustBillMaster.get("custBillIsEstm") != null
                ? String.valueOf(selectCustBillMaster.get("custBillIsEstm")) : "";
        String custBillIsSms = selectCustBillMaster.get("custBillIsSms") != null
                ? String.valueOf(selectCustBillMaster.get("custBillIsSms")) : "";
        String custBillIsPost = selectCustBillMaster.get("custBillIsPost") != null
                ? String.valueOf(selectCustBillMaster.get("custBillIsPost")) : "";
        String custBillId = selectCustBillMaster.get("custBillId") != null
                ? String.valueOf(selectCustBillMaster.get("custBillId")) : "0";

        // 인서트 셋팅 시작
        String salesOrderIDOld = "0";
        String salesOrderIDNew = "0";
        String contactIDOld = "0";
        String contactIDNew = "0";
        String addressIDOld = "0";
        String addressIDNew = "0";
        String statusIDOld = "0";
        String statusIDNew = "0";
        String remarkOld = "";
        String remarkNew = "";
        String emailOld = custBillEmail;
        String emailNew = String.valueOf(params.get("reqEmail")).trim();
        String isEStatementOld = custBillIsEstm;
        String isEStatementNew = custBillIsEstm;
        String isSMSOld = custBillIsSms;
        String isSMSNew = custBillIsSms;
        String isPostOld = custBillIsPost;
        String isPostNew = custBillIsPost;
        String isEInvFlgOld = "0";
        String isEInvFlgNew = "0";
        String typeId = "1047";
        String sysHisRemark = "[System] E-Statement Request";
        String emailAddtionalNew = String.valueOf(params.get("reqAdditionalEmail")).trim();
        String emailAddtionalOld = "";

        if (selectCustBillMaster != null && Integer.parseInt(custBillId) > 0) {

            if (reqMaster.size() > 0) {
                for (int i = 0; i < reqMaster.size(); i++) {
                    Map<String, Object> map = reqMaster.get(i);
                    params.put("reqId", String.valueOf(map.get("reqId")));
                    params.put("stusCodeId", 10);
                    // REQ마스터테이블 업데이트
                    billingGroupMapper.updReqEstm(params);
                }
            }

            //등록할 이메일의 직전의 이메일 정보를 취소 처리한다. : 하지만 사용하지 않음
//			EgovMap lateHistory = billingGroupMapper.selectEstmLatelyHistory(params);
//			if(lateHistory != null){
//				Map<String, Object> updCanMap = new HashMap<String, Object>();
//				updCanMap.put("reqId", String.valueOf(lateHistory.get("reqId")));
//				updCanMap.put("stusCodeId", "10");
//				billingGroupMapper.updReqEstm(updCanMap);
//			}

            Map<String, Object> insHisMap = new HashMap<String, Object>();
            insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
            insHisMap.put("userId", userId);
            insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
            insHisMap.put("salesOrderIDOld", salesOrderIDOld);
            insHisMap.put("salesOrderIDNew", salesOrderIDNew);
            insHisMap.put("contactIDOld", contactIDOld);
            insHisMap.put("contactIDNew", contactIDNew);
            insHisMap.put("addressIDOld", addressIDOld);
            insHisMap.put("addressIDNew", addressIDNew);
            insHisMap.put("statusIDOld", statusIDOld);
            insHisMap.put("statusIDNew", statusIDNew);
            insHisMap.put("remarkOld", remarkOld);
            insHisMap.put("remarkNew", remarkNew);
            insHisMap.put("emailOld", emailOld);
            insHisMap.put("emailNew", emailNew);
            insHisMap.put("isEStatementOld", isEStatementOld);
            insHisMap.put("isEStatementNew", isEStatementNew);
            insHisMap.put("isSMSOld", isSMSOld);
            insHisMap.put("isSMSNew", isSMSNew);
            insHisMap.put("isPostOld", isPostOld);
            insHisMap.put("isPostNew", isPostNew);
            insHisMap.put("isEInvFlgOld", isEInvFlgOld);
            insHisMap.put("isEInvFlgNew", isEInvFlgNew);
            insHisMap.put("typeId", typeId);
            insHisMap.put("sysHisRemark", sysHisRemark);
            insHisMap.put("emailAddtionalNew", emailAddtionalNew);
            insHisMap.put("emailAddtionalOld", emailAddtionalOld);

            // 히스토리테이블 인서트
            billingGroupMapper.insHistory(insHisMap);

            Map<String, Object> estmMap = new HashMap<String, Object>();
            estmMap.put("stusCodeId", "5");//approve
            estmMap.put("custBillId", String.valueOf(params.get("custBillId")));
            estmMap.put("email", String.valueOf(params.get("reqEmail")).trim());
            estmMap.put("cnfmCode", CommonUtils.getRandomNumber(10));
            estmMap.put("userId", userId);
            estmMap.put("defaultDate", defaultDate);
            estmMap.put("emailFailInd", "0");
            estmMap.put("emailFailDesc", "");
            estmMap.put("emailAdditional", String.valueOf(params.get("reqAdditionalEmail")).trim());
            // estmReq 인서트
            billingGroupMapper.insEstmReq(estmMap);
            //String reqId = String.valueOf(estmMap.get("reqIdSeq"));

            Map<String, Object> updCustMap = new HashMap<String, Object>();
            updCustMap.put("custBillId", String.valueOf(params.get("custBillId")));
            updCustMap.put("emailNew", String.valueOf(params.get("reqEmail")).trim());// new
            updCustMap.put("emailAdd", String.valueOf(params.get("reqAdditionalEmail")).trim());// email additional
            updCustMap.put("apprReqFlag", "Y");
            updCustMap.put("userId", userId);
            updCustMap.put("custBillIsEstm", "1");
            billingGroupMapper.updCustMaster(updCustMap);

            // E-mail 전송하기
//			EmailVO email = new EmailVO();
//			List<String> toList = new ArrayList<String>();
//
//			String additionalEmail = "";
//			additionalEmail = String.valueOf(params.get("reqAdditionalEmail")).trim();
//			toList.add(String.valueOf(params.get("reqEmail")).trim());
//			if (!"".equals(additionalEmail)) {
//				toList.add(additionalEmail);
//			}
//
//			email.setTo(toList);
//			email.setHtml(true);
//			email.setSubject("Coway E-Invoice Subscription Confirmation");
//			email.setText("Dear Sir/Madam, <br /><br />"
//					+ "Thank you for registering for 'Go Green Go E-invoice' with Coway. <br /><br />"
//					+ "Your email address have been registered as per below:- <br /><br />" + "Email 1: "
//					+ String.valueOf(params.get("reqEmail")).trim() + "<br />" + "Email 2: " + additionalEmail
//					+ "<br /><br /> "
//					//+ "To complete the registration, please confirm the above email addresses by clicking the link below:- <br /><br />"
//					+
//					// To-Be eTRUST시스템에서는 문구 삭제 요청함
//					// "<a href='" + billingTypeConfirmUrl + "?reqId=" + reqId + "' target='_blank'
//					// style='color:blue;font-weight:bold'>Verify Your Email Here</a><br /><br />" +
//					"Should you have any enquiries, please do not hesitate to contact our toll-free number at 1800 888 111 or email to"
//					+ "<a href='mailto:billing@coway.com.my' target='_top' style='color:blue;font-weight:bold'>billing@coway.com.my</a><br /><br /><br />"
//					+ "Yours faithfully,<br />" + "<b>Coway Malaysia</b>");
//
//			adaptorService.sendEmail(email, false);

            return true;

        } else {
            return false;
        }
    }

    @Override
    @Transactional
    public boolean saveRemark(Map<String, Object> params, SessionVO sessionVO) {

        EgovMap custBillMasters = billingGroupMapper.selectCustBillMaster(params);
        String custBillId = custBillMasters.get("custBillId") != null
                ? String.valueOf(custBillMasters.get("custBillId")) : "0";

        if (custBillMasters != null && Integer.parseInt(custBillId) > 0) {
            int userId = sessionVO.getUserId();
            String salesOrderIDOld = "0";
            String salesOrderIDNew = "0";
            String contactIDOld = "0";
            String contactIDNew = "0";
            String addressIDOld = "0";
            String addressIDNew = "0";
            String statusIDOld = "0";
            String statusIDNew = "0";
            String remarkOld = custBillMasters.get("custBillRem") != null
                    ? String.valueOf(custBillMasters.get("custBillRem")) : "";
            String remarkNew = String.valueOf(params.get("remarkNew"));
            String emailOld = "";
            String emailNew = "";
            String isEStatementOld = "0";
            String isEStatementNew = "0";
            String isSMSOld = "0";
            String isSMSNew = "0";
            String isPostOld = "0";
            String isPostNew = "0";
            String isEInvFlgOld = "0";
            String isEInvFlgNew = "0";
            String typeId = "1044";
            String sysHisRemark = "[System] Change Remark";
            String emailAddtionalNew = "";
            String emailAddtionalOld = "";

            Map<String, Object> insHisMap = new HashMap<String, Object>();
            insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
            insHisMap.put("userId", userId);
            insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
            insHisMap.put("salesOrderIDOld", salesOrderIDOld);
            insHisMap.put("salesOrderIDNew", salesOrderIDNew);
            insHisMap.put("contactIDOld", contactIDOld);
            insHisMap.put("contactIDNew", contactIDNew);
            insHisMap.put("addressIDOld", addressIDOld);
            insHisMap.put("addressIDNew", addressIDNew);
            insHisMap.put("statusIDOld", statusIDOld);
            insHisMap.put("statusIDNew", statusIDNew);
            insHisMap.put("remarkOld", remarkOld);
            insHisMap.put("remarkNew", remarkNew);
            insHisMap.put("emailOld", emailOld);
            insHisMap.put("emailNew", emailNew);
            insHisMap.put("isEStatementOld", isEStatementOld);
            insHisMap.put("isEStatementNew", isEStatementNew);
            insHisMap.put("isSMSOld", isSMSOld);
            insHisMap.put("isSMSNew", isSMSNew);
            insHisMap.put("isPostOld", isPostOld);
            insHisMap.put("isPostNew", isPostNew);
            insHisMap.put("isEInvFlgOld", isEInvFlgOld);
            insHisMap.put("isEInvFlgNew", isEInvFlgNew);
            insHisMap.put("typeId", typeId);
            insHisMap.put("sysHisRemark", sysHisRemark);
            insHisMap.put("emailAddtionalNew", emailAddtionalNew);
            insHisMap.put("emailAddtionalOld", emailAddtionalOld);

            // 마스터테이블 업데이트
            Map<String, Object> updCustMap = new HashMap<String, Object>();
            updCustMap.put("remarkNew", String.valueOf(params.get("remarkNew")));
            updCustMap.put("remarkFlag", "Y");
            updCustMap.put("custBillId", String.valueOf(params.get("custBillId")));
            updCustMap.put("userId", userId);
            billingGroupMapper.updCustMaster(updCustMap);

            // 히스토리테이블 인서트
            billingGroupMapper.insHistory(insHisMap);

            return true;

        } else {
            return false;
        }
    }

    @Override
    @Transactional
    public boolean saveChangeBillType(Map<String, Object> params, SessionVO sessionVO) {

        String defaultDate = "1900-01-01";
        int userId = sessionVO.getUserId();
        params.put("defaultDate", defaultDate);
        params.put("userId", userId);

        // master 조회.
        EgovMap selectBasicInfo = billingGroupMapper.selectBasicInfo(params);
        String custBillIsEstm = selectBasicInfo.get("custBillIsEstm") != null
                ? String.valueOf(selectBasicInfo.get("custBillIsEstm")) : "";
        String custBillIsSms = selectBasicInfo.get("custBillIsSms") != null
                ? String.valueOf(selectBasicInfo.get("custBillIsSms")) : "";
        String custBillIsPost = selectBasicInfo.get("custBillIsPost") != null
                ? String.valueOf(selectBasicInfo.get("custBillIsPost")) : "";
        String custBillEmail = selectBasicInfo.get("custBillEmail") != null
                ? String.valueOf(selectBasicInfo.get("custBillEmail")) : "";
        String custBillId = selectBasicInfo.get("custBillId") != null
                ? String.valueOf(selectBasicInfo.get("custBillId")) : "0";
        String custBillIsEInv = selectBasicInfo.get("eInvFlg") != null
                        ? String.valueOf(selectBasicInfo.get("eInvFlg")) : "";

        if (selectBasicInfo != null && Integer.parseInt(custBillId) > 0) {

            // 인서트 셋팅 시작
            String salesOrderIDOld = "0";
            String salesOrderIDNew = "0";
            String contactIDOld = "0";
            String contactIDNew = "0";
            String addressIDOld = "0";
            String addressIDNew = "0";
            String statusIDOld = "0";
            String statusIDNew = "0";
            String remarkOld = "";
            String remarkNew = "";
            String emailOld = custBillEmail;
            String emailNew = String.valueOf(params.get("estm")).equals("1")
                    ? String.valueOf(params.get("custBillEmail")) : "";
            String typeId = "1045";
            String isEStatementOld = custBillIsEstm;
            String isEStatementNew = String.valueOf(params.get("estm"));
            String isSMSOld = custBillIsSms;
            String isSMSNew = String.valueOf(params.get("sms"));
            String isPostOld = custBillIsPost;
            String isPostNew = String.valueOf(params.get("post"));
            String sysHisRemark = "[System] Change Billing Type";
            String emailAddtionalNew = "";
            String emailAddtionalOld = "";
            int isEInvFlgOld = Integer.parseInt(custBillIsEInv);
            int isEInvFlgNew = Integer.parseInt(String.valueOf(params.get("isEInvFlg")));

            Map<String, Object> insHisMap = new HashMap<String, Object>();
            insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
            insHisMap.put("userId", userId);
            insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
            insHisMap.put("salesOrderIDOld", salesOrderIDOld);
            insHisMap.put("salesOrderIDNew", salesOrderIDNew);
            insHisMap.put("contactIDOld", contactIDOld);
            insHisMap.put("contactIDNew", contactIDNew);
            insHisMap.put("addressIDOld", addressIDOld);
            insHisMap.put("addressIDNew", addressIDNew);
            insHisMap.put("statusIDOld", statusIDOld);
            insHisMap.put("statusIDNew", statusIDNew);
            insHisMap.put("remarkOld", remarkOld);
            insHisMap.put("remarkNew", remarkNew);
            insHisMap.put("emailOld", emailOld);
            insHisMap.put("emailNew", emailNew);
            insHisMap.put("isEStatementOld", isEStatementOld);
            insHisMap.put("isEStatementNew", isEStatementNew);
            insHisMap.put("isSMSOld", isSMSOld);
            insHisMap.put("isSMSNew", isSMSNew);
            insHisMap.put("isPostOld", isPostOld);
            insHisMap.put("isPostNew", isPostNew);
            insHisMap.put("typeId", typeId);
            insHisMap.put("sysHisRemark", sysHisRemark);
            insHisMap.put("emailAddtionalNew", emailAddtionalNew);
            insHisMap.put("emailAddtionalOld", emailAddtionalOld);
            insHisMap.put("isEInvFlgOld", isEInvFlgOld);
            insHisMap.put("isEInvFlgNew", isEInvFlgNew);

            // 히스토리테이블 인서트
            billingGroupMapper.insHistory(insHisMap);

            Map<String, Object> custMap = new HashMap<String, Object>();
            custMap.put("custBillIsPost", String.valueOf(params.get("post")));
            custMap.put("custBillIsSMS", String.valueOf(params.get("sms")));
            custMap.put("custBillIsEstm", String.valueOf(params.get("estm")));
            custMap.put("custBillIsEInv", String.valueOf(params.get("isEInvFlg")));

            if (String.valueOf(params.get("estm")).equals("1")) {
                custMap.put("custBillEmail", String.valueOf(params.get("custBillEmail")));
            } else {
                custMap.put("custBillEmail", "");
            }

            custMap.put("chgBillFlag", "Y");
            custMap.put("userId", userId);
            custMap.put("custBillId", String.valueOf(params.get("custBillId")));
            // 마스터테이블 업데이트
            billingGroupMapper.updCustMaster(custMap);

            return true;

        } else {
            return false;
        }
    }

    @Override
    @Transactional
    public boolean saveApprRequest(Map<String, Object> params, SessionVO sessionVO) {

        String defaultDate = "1900-01-01";
        int userId = sessionVO.getUserId();
        params.put("defaultDate", defaultDate);
        params.put("userId", userId);
        params.put("reqId", String.valueOf(params.get("reqId")));

        // master 조회.
        EgovMap selectEStatementReqs = billingGroupMapper.selectEStatementReqs(params);
        String reqId = selectEStatementReqs.get("reqId") != null ? String.valueOf(selectEStatementReqs.get("reqId"))
                : "0";
        String email = selectEStatementReqs.get("email") != null ? String.valueOf(selectEStatementReqs.get("email"))
                : "";
        String emailAdd = selectEStatementReqs.get("emailAdd") != null ? String.valueOf(selectEStatementReqs.get("emailAdd"))
                : "";

        if (selectEStatementReqs != null && Integer.parseInt(reqId) > 0) {
            EgovMap selectCustBillMaster = billingGroupMapper.selectCustBillMaster(params);
            String custBillId = selectCustBillMaster.get("custBillId") != null
                    ? String.valueOf(selectCustBillMaster.get("custBillId")) : "0";
            String custBillEmail = selectCustBillMaster.get("custBillEmail") != null
                    ? String.valueOf(selectCustBillMaster.get("custBillEmail")) : "";
            String custBillEmailAdd = selectCustBillMaster.get("custBillEmailAdd") != null
                    ? String.valueOf(selectCustBillMaster.get("custBillEmailAdd")) : "";


            if (selectCustBillMaster != null && Integer.parseInt(custBillId) > 0) {

                Map<String, Object> updCustMap = new HashMap<String, Object>();
                updCustMap.put("custBillId", custBillId);
                updCustMap.put("emailOld", custBillEmail);// old
                updCustMap.put("emailNew", email);// new
                updCustMap.put("emailAdd", emailAdd);// email additional
                updCustMap.put("apprReqFlag", "Y");
                updCustMap.put("userId", userId);
                updCustMap.put("custBillIsEstm", "1");
                billingGroupMapper.updCustMaster(updCustMap);

                // 인서트 셋팅 시작
                String salesOrderIDOld = "0";
                String salesOrderIDNew = "0";
                String contactIDOld = "0";
                String contactIDNew = "0";
                String addressIDOld = "0";
                String addressIDNew = "0";
                String statusIDOld = "0";
                String statusIDNew = "0";
                String remarkOld = "";
                String remarkNew = "";
                String emailOld = custBillEmail;
                String emailNew = email;
                String isEStatementOld = "0";
                String isEStatementNew = "1";
                String isSMSOld = "0";
                String isSMSNew = "0";
                String isPostOld = "0";
                String isPostNew = "0";
                String isEInvFlgOld = "0";
                String isEInvFlgNew = "0";
                String typeId = "1047";
                String sysHisRemark = "[System] E-Statement Approve";
                String emailAddtionalNew = emailAdd;
                String emailAddtionalOld = custBillEmailAdd;

                Map<String, Object> insHisMap = new HashMap<String, Object>();

                insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
                insHisMap.put("userId", userId);
                insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
                insHisMap.put("salesOrderIDOld", salesOrderIDOld);
                insHisMap.put("salesOrderIDNew", salesOrderIDNew);
                insHisMap.put("contactIDOld", contactIDOld);
                insHisMap.put("contactIDNew", contactIDNew);
                insHisMap.put("addressIDOld", addressIDOld);
                insHisMap.put("addressIDNew", addressIDNew);
                insHisMap.put("statusIDOld", statusIDOld);
                insHisMap.put("statusIDNew", statusIDNew);
                insHisMap.put("remarkOld", remarkOld);
                insHisMap.put("remarkNew", remarkNew);
                insHisMap.put("emailOld", emailOld);
                insHisMap.put("emailNew", emailNew);
                insHisMap.put("isEStatementOld", isEStatementOld);
                insHisMap.put("isEStatementNew", isEStatementNew);
                insHisMap.put("isSMSOld", isSMSOld);
                insHisMap.put("isSMSNew", isSMSNew);
                insHisMap.put("isPostOld", isPostOld);
                insHisMap.put("isPostNew", isPostNew);
                insHisMap.put("isEInvFlgOld", isEInvFlgOld);
                insHisMap.put("isEInvFlgNew", isEInvFlgNew);
                insHisMap.put("typeId", typeId);
                insHisMap.put("sysHisRemark", sysHisRemark);
                insHisMap.put("emailAddtionalNew", emailAddtionalNew);
                insHisMap.put("emailAddtionalOld", emailAddtionalOld);
                billingGroupMapper.insHistory(insHisMap);
                // 인서트 셋팅 끝

                Map<String, Object> updReqMap = new HashMap<String, Object>();
                updReqMap.put("reqId", reqId);
                updReqMap.put("stusCodeId", "5");
                billingGroupMapper.updReqEstm(updReqMap);

            }

            return true;

        } else {
            return false;
        }
    }

    @Override
    @Transactional
    public boolean saveCancelRequest(Map<String, Object> params, SessionVO sessionVO) {

        String defaultDate = "1900-01-01";
        int userId = sessionVO.getUserId();
        params.put("defaultDate", defaultDate);
        params.put("userId", userId);
        params.put("reqId", String.valueOf(params.get("reqId")));

        // master 조회.
        EgovMap selectEStatementReqs = billingGroupMapper.selectEStatementReqs(params);
        String reqId = selectEStatementReqs.get("reqId") != null ? String.valueOf(selectEStatementReqs.get("reqId"))
                : "0";
        String email = selectEStatementReqs.get("email") != null ? String.valueOf(selectEStatementReqs.get("email"))
                : "";

        if (selectEStatementReqs != null && Integer.parseInt(reqId) > 0) {

            Map<String, Object> updCanMap = new HashMap<String, Object>();
            updCanMap.put("reqId", reqId);
            updCanMap.put("stusCodeId", "10");
            billingGroupMapper.updReqEstm(updCanMap);

            // 인서트 셋팅 시작
            String salesOrderIDOld = "0";
            String salesOrderIDNew = "0";
            String contactIDOld = "0";
            String contactIDNew = "0";
            String addressIDOld = "0";
            String addressIDNew = "0";
            String statusIDOld = "0";
            String statusIDNew = "0";
            String remarkOld = "";
            String remarkNew = "";
            String emailOld = "";
            String emailNew = email;
            String isEStatementOld = "0";
            String isEStatementNew = "0";
            String isSMSOld = "0";
            String isSMSNew = "0";
            String isPostOld = "0";
            String isPostNew = "0";
            String isEInvFlgOld = "0";
            String isEInvFlgNew = "0";
            String typeId = "1047";
            String sysHisRemark = "[System] E-Statement Cancel";
            String emailAddtionalNew = "";
            String emailAddtionalOld = "";

            Map<String, Object> insHisMap = new HashMap<String, Object>();
            insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
            insHisMap.put("userId", userId);
            insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
            insHisMap.put("salesOrderIDOld", salesOrderIDOld);
            insHisMap.put("salesOrderIDNew", salesOrderIDNew);
            insHisMap.put("contactIDOld", contactIDOld);
            insHisMap.put("contactIDNew", contactIDNew);
            insHisMap.put("addressIDOld", addressIDOld);
            insHisMap.put("addressIDNew", addressIDNew);
            insHisMap.put("statusIDOld", statusIDOld);
            insHisMap.put("statusIDNew", statusIDNew);
            insHisMap.put("remarkOld", remarkOld);
            insHisMap.put("remarkNew", remarkNew);
            insHisMap.put("emailOld", emailOld);
            insHisMap.put("emailNew", emailNew);
            insHisMap.put("isEStatementOld", isEStatementOld);
            insHisMap.put("isEStatementNew", isEStatementNew);
            insHisMap.put("isSMSOld", isSMSOld);
            insHisMap.put("isSMSNew", isSMSNew);
            insHisMap.put("isPostOld", isPostOld);
            insHisMap.put("isPostNew", isPostNew);
            insHisMap.put("isEInvFlgOld", isEInvFlgOld);
            insHisMap.put("isEInvFlgNew", isEInvFlgNew);
            insHisMap.put("typeId", typeId);
            insHisMap.put("sysHisRemark", sysHisRemark);
            insHisMap.put("emailAddtionalNew", emailAddtionalNew);
            insHisMap.put("emailAddtionalOld", emailAddtionalOld);
            billingGroupMapper.insHistory(insHisMap);
            // 인서트 셋팅 끝

            return true;

        } else {
            return false;
        }
    }

    @Override
    @Transactional
    public boolean saveRemoveOrder(Map<String, Object> params, SessionVO sessionVO) {

        String defaultDate = "1900-01-01";
        int userId = sessionVO.getUserId();
        params.put("defaultDate", defaultDate);

        EgovMap selectSalesOrderMs = billingGroupMapper.selectSalesOrderMs(params);
        String salesOrdId = selectSalesOrderMs.get("salesOrdId") != null
                ? String.valueOf(selectSalesOrderMs.get("salesOrdId")) : "0";

        if (selectSalesOrderMs != null && Integer.parseInt(salesOrdId) > 0) {

            EgovMap selectCustBillMaster = billingGroupMapper.selectCustBillMaster(params);
            String custBillId = selectSalesOrderMs.get("custBillId") != null
                    ? String.valueOf(selectSalesOrderMs.get("custBillId")) : "0";

            if (selectCustBillMaster != null && Integer.parseInt(custBillId) > 0) {

                // Is Main Order Of Group
                String changeOrderId = "0";
                // Get first complete order
                Map<String, Object> replaceOrdMap = new HashMap<String, Object>();
                replaceOrdMap.put("replaceOrd", "Y");
                replaceOrdMap.put("custBillId", String.valueOf(params.get("custBillId")));
                replaceOrdMap.put("salesOrdId", String.valueOf(params.get("salesOrdId")));
                EgovMap replcaceOrder_1 = billingGroupMapper.selectReplaceOrder(replaceOrdMap);
                if (replcaceOrder_1 != null
                        && Integer.parseInt(String.valueOf(replcaceOrder_1.get("salesOrdId"))) > 0) {
                    String replaceSalesOrdId = replcaceOrder_1.get("salesOrdId") != null
                            ? String.valueOf(replcaceOrder_1.get("salesOrdId")) : "0";
                    changeOrderId = replaceSalesOrdId;

                } else {

                    Map<String, Object> replaceOrd2Map = new HashMap<String, Object>();
                    replaceOrd2Map.put("replaceOrd2", "Y");
                    replaceOrd2Map.put("custBillId", String.valueOf(params.get("custBillId")));
                    replaceOrd2Map.put("salesOrdId", String.valueOf(params.get("salesOrdId")));
                    EgovMap replcaceOrder_2 = billingGroupMapper.selectReplaceOrder(replaceOrd2Map);
                    if (replcaceOrder_2 != null
                            && Integer.parseInt(String.valueOf(replcaceOrder_2.get("salesOrdId"))) > 0) {
                        String replaceSalesOrdId2 = replcaceOrder_2.get("salesOrdId") != null
                                ? String.valueOf(replcaceOrder_2.get("salesOrdId")) : "0";
                        changeOrderId = replaceSalesOrdId2;
                    } else {

                        Map<String, Object> replaceOrd3Map = new HashMap<String, Object>();
                        replaceOrd3Map.put("replaceOrd3", "Y");
                        replaceOrd3Map.put("custBillId", String.valueOf(params.get("custBillId")));
                        replaceOrd3Map.put("salesOrdId", String.valueOf(params.get("salesOrdId")));
                        EgovMap replcaceOrder_3 = billingGroupMapper.selectReplaceOrder(replaceOrd3Map);

                        if (replcaceOrder_3 != null
                                && Integer.parseInt(String.valueOf(replaceOrd3Map.get("salesOrdId"))) > 0) {
                            String replaceSalesOrdId3 = replaceOrd3Map.get("salesOrdId") != null
                                    ? String.valueOf(replaceOrd3Map.get("salesOrdId")) : "0";
                            changeOrderId = replaceSalesOrdId3;
                        }
                    }

                }

                if (Integer.parseInt(changeOrderId) > 0) {

                    // Got order to replace
                    // Insert history (Change Main Order) - previous group
                    String salesOrderIDOld = salesOrdId;
                    String salesOrderIDNew = changeOrderId;
                    String contactIDOld = "0";
                    String contactIDNew = "0";
                    String addressIDOld = "0";
                    String addressIDNew = "0";
                    String statusIDOld = "0";
                    String statusIDNew = "0";
                    String remarkOld = "";
                    String remarkNew = "";
                    String emailOld = "";
                    String emailNew = "";
                    String isEStatementOld = "0";
                    String isEStatementNew = "0";
                    String isSMSOld = "0";
                    String isSMSNew = "0";
                    String isPostOld = "0";
                    String isPostNew = "0";
                    String isEInvFlgOld = "0";
                    String isEInvFlgNew = "0";
                    String typeId = "1046";
                    String sysHisRemark = "[System] Group Order - Remove Order";
                    String emailAddtionalNew = "";
                    String emailAddtionalOld = "";

                    Map<String, Object> insChangeHisMap = new HashMap<String, Object>();
                    insChangeHisMap.put("custBillId", custBillId);
                    insChangeHisMap.put("userId", userId);
                    insChangeHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
                    insChangeHisMap.put("salesOrderIDOld", salesOrderIDOld);
                    insChangeHisMap.put("salesOrderIDNew", salesOrderIDNew);
                    insChangeHisMap.put("contactIDOld", contactIDOld);
                    insChangeHisMap.put("contactIDNew", contactIDNew);
                    insChangeHisMap.put("addressIDOld", addressIDOld);
                    insChangeHisMap.put("addressIDNew", addressIDNew);
                    insChangeHisMap.put("statusIDOld", statusIDOld);
                    insChangeHisMap.put("statusIDNew", statusIDNew);
                    insChangeHisMap.put("remarkOld", remarkOld);
                    insChangeHisMap.put("remarkNew", remarkNew);
                    insChangeHisMap.put("emailOld", emailOld);
                    insChangeHisMap.put("emailNew", emailNew);
                    insChangeHisMap.put("isEStatementOld", isEStatementOld);
                    insChangeHisMap.put("isEStatementNew", isEStatementNew);
                    insChangeHisMap.put("isSMSOld", isSMSOld);
                    insChangeHisMap.put("isSMSNew", isSMSNew);
                    insChangeHisMap.put("isPostOld", isPostOld);
                    insChangeHisMap.put("isPostNew", isPostNew);
                    insChangeHisMap.put("isEInvFlgOld", isEInvFlgOld);
                    insChangeHisMap.put("isEInvFlgNew", isEInvFlgNew);
                    insChangeHisMap.put("typeId", typeId);
                    insChangeHisMap.put("sysHisRemark", sysHisRemark);
                    insChangeHisMap.put("emailAddtionalNew", emailAddtionalNew);
                    insChangeHisMap.put("emailAddtionalOld", emailAddtionalOld);
                    billingGroupMapper.insHistory(insChangeHisMap);

                    Map<String, Object> updChangeMap = new HashMap<String, Object>();
                    updChangeMap.put("userId", userId);
                    updChangeMap.put("removeOrdFlag", "Y");
                    updChangeMap.put("salesOrdId", changeOrderId);
                    updChangeMap.put("custBillId", custBillId);
                    billingGroupMapper.updSalesOrderMaster(updChangeMap);

                }

            }

            // 인서트 셋팅 시작
            String salesOrderIDOld = String.valueOf(params.get("salesOrdId"));
            String salesOrderIDNew = "0";
            String contactIDOld = "0";
            String contactIDNew = "0";
            String addressIDOld = "0";
            String addressIDNew = "0";
            String statusIDOld = "0";
            String statusIDNew = "0";
            String remarkOld = "";
            String remarkNew = "";
            String emailOld = "";
            String emailNew = "";
            String isEStatementOld = "0";
            String isEStatementNew = "0";
            String isSMSOld = "0";
            String isSMSNew = "0";
            String isPostOld = "0";
            String isPostNew = "0";
            String isEInvFlgOld = "0";
            String isEInvFlgNew = "0";
            String typeId = "1046";
            String sysHisRemark = "[System] Group Order - Remove Order";
            String emailAddtionalNew = "";
            String emailAddtionalOld = "";

            Map<String, Object> insHisMap = new HashMap<String, Object>();
            insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
            insHisMap.put("userId", userId);
            insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
            insHisMap.put("salesOrderIDOld", salesOrderIDOld);
            insHisMap.put("salesOrderIDNew", salesOrderIDNew);
            insHisMap.put("contactIDOld", contactIDOld);
            insHisMap.put("contactIDNew", contactIDNew);
            insHisMap.put("addressIDOld", addressIDOld);
            insHisMap.put("addressIDNew", addressIDNew);
            insHisMap.put("statusIDOld", statusIDOld);
            insHisMap.put("statusIDNew", statusIDNew);
            insHisMap.put("remarkOld", remarkOld);
            insHisMap.put("remarkNew", remarkNew);
            insHisMap.put("emailOld", emailOld);
            insHisMap.put("emailNew", emailNew);
            insHisMap.put("isEStatementOld", isEStatementOld);
            insHisMap.put("isEStatementNew", isEStatementNew);
            insHisMap.put("isSMSOld", isSMSOld);
            insHisMap.put("isSMSNew", isSMSNew);
            insHisMap.put("isPostOld", isPostOld);
            insHisMap.put("isPostNew", isPostNew);
            insHisMap.put("isEInvFlgOld", isEInvFlgOld);
            insHisMap.put("isEInvFlgNew", isEInvFlgNew);
            insHisMap.put("typeId", typeId);
            insHisMap.put("sysHisRemark", sysHisRemark);
            insHisMap.put("emailAddtionalNew", emailAddtionalNew);
            insHisMap.put("emailAddtionalOld", emailAddtionalOld);
            billingGroupMapper.insHistory(insHisMap);
            // 인서트 셋팅 끝

            Map<String, Object> updChangeMap = new HashMap<String, Object>();
            updChangeMap.put("userId", userId);
            updChangeMap.put("removeOrdFlag", "Y");
            updChangeMap.put("salesOrdId", String.valueOf(params.get("salesOrdId")));
            updChangeMap.put("custBillId", "0");
            billingGroupMapper.updSalesOrderMaster(updChangeMap);

            return true;

        } else {
            return false;
        }
    }

    @Override
    @Transactional
    public boolean saveChgMainOrd(Map<String, Object> params, SessionVO sessionVO) {

        String defaultDate = "1900-01-01";
        params.put("defaultDate", defaultDate);
        int userId = sessionVO.getUserId();

        EgovMap selectCustBillMaster = billingGroupMapper.selectCustBillMaster(params);
        String custBillId = selectCustBillMaster.get("custBillId") != null
                ? String.valueOf(selectCustBillMaster.get("custBillId")) : "0";

        if (selectCustBillMaster != null && Integer.parseInt(custBillId) > 0) {

            // 인서트 셋팅 시작
            String salesOrderIDOld = String.valueOf(params.get("custBillSoId"));
            String salesOrderIDNew = String.valueOf(params.get("salesOrdId"));
            String contactIDOld = "0";
            String contactIDNew = "0";
            String addressIDOld = "0";
            String addressIDNew = "0";
            String statusIDOld = "0";
            String statusIDNew = "0";
            String remarkOld = "";
            String remarkNew = "";
            String emailOld = "";
            String emailNew = "";
            String isEStatementOld = "0";
            String isEStatementNew = "0";
            String isSMSOld = "0";
            String isSMSNew = "0";
            String isPostOld = "0";
            String isPostNew = "0";
            String isEInvFlgOld = "0";
            String isEInvFlgNew = "0";
            String typeId = "1048";
            String sysHisRemark = "[System] Change Main Order";
            String emailAddtionalNew = "";
            String emailAddtionalOld = "";

            Map<String, Object> insHisMap = new HashMap<String, Object>();
            insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
            insHisMap.put("userId", userId);
            insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
            insHisMap.put("salesOrderIDOld", salesOrderIDOld);
            insHisMap.put("salesOrderIDNew", salesOrderIDNew);
            insHisMap.put("contactIDOld", contactIDOld);
            insHisMap.put("contactIDNew", contactIDNew);
            insHisMap.put("addressIDOld", addressIDOld);
            insHisMap.put("addressIDNew", addressIDNew);
            insHisMap.put("statusIDOld", statusIDOld);
            insHisMap.put("statusIDNew", statusIDNew);
            insHisMap.put("remarkOld", remarkOld);
            insHisMap.put("remarkNew", remarkNew);
            insHisMap.put("emailOld", emailOld);
            insHisMap.put("emailNew", emailNew);
            insHisMap.put("isEStatementOld", isEStatementOld);
            insHisMap.put("isEStatementNew", isEStatementNew);
            insHisMap.put("isSMSOld", isSMSOld);
            insHisMap.put("isSMSNew", isSMSNew);
            insHisMap.put("isPostOld", isPostOld);
            insHisMap.put("isPostNew", isPostNew);
            insHisMap.put("isEInvFlgOld", isEInvFlgOld);
            insHisMap.put("isEInvFlgNew", isEInvFlgNew);
            insHisMap.put("typeId", typeId);
            insHisMap.put("sysHisRemark", sysHisRemark);
            insHisMap.put("emailAddtionalNew", emailAddtionalNew);
            insHisMap.put("emailAddtionalOld", emailAddtionalOld);
            billingGroupMapper.insHistory(insHisMap);
            // 인서트 셋팅 끝

            Map<String, Object> updCustMap = new HashMap<String, Object>();
            updCustMap.put("changeMainFlag", "Y");
            updCustMap.put("userId", userId);
            updCustMap.put("custBillSoId", String.valueOf(params.get("salesOrdId")));
            updCustMap.put("custBillId", String.valueOf(params.get("custBillId")));
            billingGroupMapper.updCustMaster(updCustMap);

            return true;

        } else {
            return false;
        }
    }

    @Override
    @Transactional
    public String saveAddOrder(Map<String, Object> params, SessionVO sessionVO) {

        int userId = sessionVO.getUserId();
        String salesOrdNo = String.valueOf(params.get("salesOrdNo"));
        String salesOrdId = String.valueOf(params.get("salesOrdId"));
        String custBillId = String.valueOf(params.get("custBillId"));
        String reasonUpd = String.valueOf(params.get("reasonUpd")).trim();
        String[] salesOrdNoArr = salesOrdNo.split("\\:");
        String[] salesOrdIdArr = salesOrdId.split("\\:");
        int total = salesOrdNoArr.length;
        int successCnt = 0;
        int failCnt = 0;
        String message1 = "";
        String message2 = "";
        boolean valid = true;
        for (int i = 0; i < salesOrdNoArr.length; i++) {

            Map<String, Object> msMap = new HashMap<String, Object>();
            msMap.put("salesOrdId", salesOrdIdArr[i].trim());
            msMap.put("salesOrdNo", salesOrdNoArr[i].trim());
            EgovMap selectSalesOrderMs = billingGroupMapper.selectSalesOrderMs(msMap);

            if (selectSalesOrderMs != null
                    && Integer.parseInt(String.valueOf(selectSalesOrderMs.get("salesOrdId"))) > 0) {
                String msSalesOrdId = selectSalesOrderMs.get("salesOrdId") != null
                        ? String.valueOf(selectSalesOrderMs.get("salesOrdId")) : "";
                String msCustBillId = selectSalesOrderMs.get("custBillId") != null
                        ? String.valueOf(selectSalesOrderMs.get("custBillId")) : "";

                Map<String, Object> masterMap = new HashMap<String, Object>();
                masterMap.put("custBillId", msCustBillId);
                EgovMap selectCustBillMaster = billingGroupMapper.selectCustBillMaster(masterMap);

                if (selectCustBillMaster != null
                        && Integer.parseInt(String.valueOf(selectCustBillMaster.get("custBillId"))) > 0) {

                    if (!String.valueOf(selectCustBillMaster.get("custBillId")).equals(custBillId)) {

                        // 인서트 셋팅 시작
                        String salesOrderIDOld = msSalesOrdId;
                        String salesOrderIDNew = "0";
                        String contactIDOld = "0";
                        String contactIDNew = "0";
                        String addressIDOld = "0";
                        String addressIDNew = "0";
                        String statusIDOld = "0";
                        String statusIDNew = "0";
                        String remarkOld = "";
                        String remarkNew = "";
                        String emailOld = "";
                        String emailNew = "";
                        String isEStatementOld = "0";
                        String isEStatementNew = "0";
                        String isSMSOld = "0";
                        String isSMSNew = "0";
                        String isPostOld = "0";
                        String isPostNew = "0";
                        String isEInvFlgOld = "0";
                        String isEInvFlgNew = "0";
                        String typeId = "1046";
                        String sysHisRemark = "[System] Group Order - Remove Order";
                        String emailAddtionalNew = "";
                        String emailAddtionalOld = "";

                        Map<String, Object> hisRemoveOrdMap = new HashMap<String, Object>();
                        hisRemoveOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                        hisRemoveOrdMap.put("userId", userId);
                        hisRemoveOrdMap.put("reasonUpd", reasonUpd);
                        hisRemoveOrdMap.put("salesOrderIDOld", salesOrderIDOld);
                        hisRemoveOrdMap.put("salesOrderIDNew", salesOrderIDNew);
                        hisRemoveOrdMap.put("contactIDOld", contactIDOld);
                        hisRemoveOrdMap.put("contactIDNew", contactIDNew);
                        hisRemoveOrdMap.put("addressIDOld", addressIDOld);
                        hisRemoveOrdMap.put("addressIDNew", addressIDNew);
                        hisRemoveOrdMap.put("statusIDOld", statusIDOld);
                        hisRemoveOrdMap.put("statusIDNew", statusIDNew);
                        hisRemoveOrdMap.put("remarkOld", remarkOld);
                        hisRemoveOrdMap.put("remarkNew", remarkNew);
                        hisRemoveOrdMap.put("emailOld", emailOld);
                        hisRemoveOrdMap.put("emailNew", emailNew);
                        hisRemoveOrdMap.put("isEStatementOld", isEStatementOld);
                        hisRemoveOrdMap.put("isEStatementNew", isEStatementNew);
                        hisRemoveOrdMap.put("isSMSOld", isSMSOld);
                        hisRemoveOrdMap.put("isSMSNew", isSMSNew);
                        hisRemoveOrdMap.put("isPostOld", isPostOld);
                        hisRemoveOrdMap.put("isPostNew", isPostNew);
                        hisRemoveOrdMap.put("isEInvFlgOld", isEInvFlgOld);
                        hisRemoveOrdMap.put("isEInvFlgNew", isEInvFlgNew);
                        hisRemoveOrdMap.put("typeId", typeId);
                        hisRemoveOrdMap.put("sysHisRemark", sysHisRemark);
                        hisRemoveOrdMap.put("emailAddtionalNew", emailAddtionalNew);
                        hisRemoveOrdMap.put("emailAddtionalOld", emailAddtionalOld);
                        billingGroupMapper.insHistory(hisRemoveOrdMap);
                        // 인서트 셋팅 끝

                        if (msSalesOrdId.equals(String.valueOf(selectCustBillMaster.get("custBillSoId")))) {

                            String changeOrderId = "0";
                            Map<String, Object> replaceOrdMap = new HashMap<String, Object>();
                            replaceOrdMap.put("replaceOrd", "Y");
                            replaceOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                            replaceOrdMap.put("salesOrdId", msSalesOrdId);
                            EgovMap replcaceOrder_1 = billingGroupMapper.selectReplaceOrder(replaceOrdMap);

                            if (replcaceOrder_1 != null
                                    && Integer.parseInt(String.valueOf(replcaceOrder_1.get("salesOrdId"))) > 0) {

                                changeOrderId = String.valueOf(replcaceOrder_1.get("salesOrdId"));

                            } else {
                                Map<String, Object> replaceOrd2Map = new HashMap<String, Object>();
                                replaceOrd2Map.put("replaceOrd2", "Y");
                                replaceOrd2Map.put("custBillId",
                                        String.valueOf(selectCustBillMaster.get("custBillId")));
                                replaceOrd2Map.put("salesOrdId", msSalesOrdId);
                                EgovMap replcaceOrder_2 = billingGroupMapper.selectReplaceOrder(replaceOrd2Map);

                                if (replcaceOrder_2 != null
                                        && Integer.parseInt(String.valueOf(replcaceOrder_2.get("salesOrdId"))) > 0) {

                                    changeOrderId = String.valueOf(replcaceOrder_2.get("salesOrdId"));

                                } else {

                                    Map<String, Object> replaceOrd3Map = new HashMap<String, Object>();
                                    replaceOrd3Map.put("replaceOrd3", "Y");
                                    replaceOrd3Map.put("custBillId",
                                            String.valueOf(selectCustBillMaster.get("custBillId")));
                                    replaceOrd3Map.put("salesOrdId", msSalesOrdId);
                                    EgovMap replcaceOrder_3 = billingGroupMapper.selectReplaceOrder(replaceOrd3Map);

                                    if (replcaceOrder_3 != null && Integer
                                            .parseInt(String.valueOf(replcaceOrder_3.get("salesOrdId"))) > 0) {
                                        changeOrderId = String.valueOf(replcaceOrder_3.get("salesOrdId"));
                                    }

                                }

                            }

                            if (Integer.parseInt(changeOrderId) > 0) {

                                // Got order to replace
                                // Insert history (Change Main Order) - previous group
                                String salesOrderIDOld2 = msSalesOrdId;
                                String salesOrderIDNew2 = changeOrderId;
                                String contactIDOld2 = "0";
                                String contactIDNew2 = "0";
                                String addressIDOld2 = "0";
                                String addressIDNew2 = "0";
                                String statusIDOld2 = "0";
                                String statusIDNew2 = "0";
                                String remarkOld2 = "";
                                String remarkNew2 = "";
                                String emailOld2 = "";
                                String emailNew2 = "";
                                String isEStatementOld2 = "0";
                                String isEStatementNew2 = "0";
                                String isSMSOld2 = "0";
                                String isSMSNew2 = "0";
                                String isPostOld2 = "0";
                                String isPostNew2 = "0";
                                String isEInvFlgOld2 = "0";
                                String isEInvFlgNew2 = "0";
                                String typeId2 = "1046";
                                String sysHisRemark2 = "[System] Group Order - Auto Select Main Order";
                                String emailAddtionalNew2 = "";
                                String emailAddtionalOld2 = "";

                                Map<String, Object> hisChgOrdMap = new HashMap<String, Object>();
                                hisChgOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                                hisChgOrdMap.put("userId", userId);
                                hisChgOrdMap.put("reasonUpd", reasonUpd);
                                hisChgOrdMap.put("salesOrderIDOld", salesOrderIDOld2);
                                hisChgOrdMap.put("salesOrderIDNew", salesOrderIDNew2);
                                hisChgOrdMap.put("contactIDOld", contactIDOld2);
                                hisChgOrdMap.put("contactIDNew", contactIDNew2);
                                hisChgOrdMap.put("addressIDOld", addressIDOld2);
                                hisChgOrdMap.put("addressIDNew", addressIDNew2);
                                hisChgOrdMap.put("statusIDOld", statusIDOld2);
                                hisChgOrdMap.put("statusIDNew", statusIDNew2);
                                hisChgOrdMap.put("remarkOld", remarkOld2);
                                hisChgOrdMap.put("remarkNew", remarkNew2);
                                hisChgOrdMap.put("emailOld", emailOld2);
                                hisChgOrdMap.put("emailNew", emailNew2);
                                hisChgOrdMap.put("isEStatementOld", isEStatementOld2);
                                hisChgOrdMap.put("isEStatementNew", isEStatementNew2);
                                hisChgOrdMap.put("isSMSOld", isSMSOld2);
                                hisChgOrdMap.put("isSMSNew", isSMSNew2);
                                hisChgOrdMap.put("isPostOld", isPostOld2);
                                hisChgOrdMap.put("isPostNew", isPostNew2);
                                hisChgOrdMap.put("isEInvFlgOld", isEInvFlgOld2);
                                hisChgOrdMap.put("isEInvFlgNew", isEInvFlgNew2);
                                hisChgOrdMap.put("typeId", typeId2);
                                hisChgOrdMap.put("sysHisRemark", sysHisRemark2);
                                hisChgOrdMap.put("emailAddtionalNew", emailAddtionalNew2);
                                hisChgOrdMap.put("emailAddtionalOld", emailAddtionalOld2);
                                billingGroupMapper.insHistory(hisChgOrdMap);
                                // 인서트 셋팅 끝

                                Map<String, Object> updChangeMap = new HashMap<String, Object>();
                                updChangeMap.put("addOrdFlag", "Y");
                                updChangeMap.put("custBillSoId", changeOrderId);
                                updChangeMap.put("custBillId", custBillId);
                                updChangeMap.put("userId", userId);
                                billingGroupMapper.updCustMaster(updChangeMap);

                            } else {

                                // No replace order found - Inactive billing group
                                // Insert history (Change Main Order) - previous group
                                String salesOrderIDOld2 = "";
                                String salesOrderIDNew2 = "";
                                String contactIDOld2 = "0";
                                String contactIDNew2 = "0";
                                String addressIDOld2 = "0";
                                String addressIDNew2 = "0";
                                String statusIDOld2 = String.valueOf(selectCustBillMaster.get("custBillStusId"));
                                String statusIDNew2 = "8";
                                String remarkOld2 = "";
                                String remarkNew2 = "";
                                String emailOld2 = "";
                                String emailNew2 = "";
                                String isEStatementOld2 = "0";
                                String isEStatementNew2 = "0";
                                String isSMSOld2 = "0";
                                String isSMSNew2 = "0";
                                String isPostOld2 = "0";
                                String isPostNew2 = "0";
                                String isEInvFlgOld2 = "0";
                                String isEInvFlgNew2 = "0";
                                String typeId2 = "1046";
                                String sysHisRemark2 = "[System] Group Order - Auto Deactivate";
                                String emailAddtionalNew2 = "";
                                String emailAddtionalOld2 = "";

                                Map<String, Object> hisChgOrdMap = new HashMap<String, Object>();
                                hisChgOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                                hisChgOrdMap.put("userId", userId);
                                hisChgOrdMap.put("reasonUpd", reasonUpd);
                                hisChgOrdMap.put("salesOrderIDOld", salesOrderIDOld2);
                                hisChgOrdMap.put("salesOrderIDNew", salesOrderIDNew2);
                                hisChgOrdMap.put("contactIDOld", contactIDOld2);
                                hisChgOrdMap.put("contactIDNew", contactIDNew2);
                                hisChgOrdMap.put("addressIDOld", addressIDOld2);
                                hisChgOrdMap.put("addressIDNew", addressIDNew2);
                                hisChgOrdMap.put("statusIDOld", statusIDOld2);
                                hisChgOrdMap.put("statusIDNew", statusIDNew2);
                                hisChgOrdMap.put("remarkOld", remarkOld2);
                                hisChgOrdMap.put("remarkNew", remarkNew2);
                                hisChgOrdMap.put("emailOld", emailOld2);
                                hisChgOrdMap.put("emailNew", emailNew2);
                                hisChgOrdMap.put("isEStatementOld", isEStatementOld2);
                                hisChgOrdMap.put("isEStatementNew", isEStatementNew2);
                                hisChgOrdMap.put("isSMSOld", isSMSOld2);
                                hisChgOrdMap.put("isSMSNew", isSMSNew2);
                                hisChgOrdMap.put("isPostOld", isPostOld2);
                                hisChgOrdMap.put("isPostNew", isPostNew2);
                                hisChgOrdMap.put("isEInvFlgOld", isEInvFlgOld2);
                                hisChgOrdMap.put("isEInvFlgNew", isEInvFlgNew2);
                                hisChgOrdMap.put("typeId", typeId2);
                                hisChgOrdMap.put("sysHisRemark", sysHisRemark2);
                                hisChgOrdMap.put("emailAddtionalNew", emailAddtionalNew2);
                                hisChgOrdMap.put("emailAddtionalOld", emailAddtionalOld2);
                                billingGroupMapper.insHistory(hisChgOrdMap);
                                // 인서트 셋팅 끝

                                Map<String, Object> updChangeMap = new HashMap<String, Object>();
                                updChangeMap.put("userId", userId);
                                updChangeMap.put("addOrdFlag2", "Y");
                                updChangeMap.put("custBillStusId", "8");
                                updChangeMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
                                billingGroupMapper.updCustMaster(updChangeMap);

                            }
                        }
                    }
                }

                String salesOrderIDOld = "0";
                String salesOrderIDNew = msSalesOrdId;
                String contactIDOld = "0";
                String contactIDNew = "0";
                String addressIDOld = "0";
                String addressIDNew = "0";
                String statusIDOld = "0";
                String statusIDNew = "0";
                String remarkOld = "";
                String remarkNew = "";
                String emailOld = "";
                String emailNew = "";
                String isEStatementOld = "0";
                String isEStatementNew = "0";
                String isSMSOld = "0";
                String isSMSNew = "0";
                String isPostOld = "0";
                String isPostNew = "0";
                String isEInvFlgOld = "0";
                String isEInvFlgNew = "0";
                String typeId = "1046";
                String sysHisRemark = "[System] Group Order - Add Order";
                String emailAddtionalNew = "";
                String emailAddtionalOld = "";

                Map<String, Object> hisAddOrdMap = new HashMap<String, Object>();
                hisAddOrdMap.put("custBillId", String.valueOf(params.get("custBillId")));
                hisAddOrdMap.put("userId", userId);
                hisAddOrdMap.put("reasonUpd", reasonUpd);
                hisAddOrdMap.put("salesOrderIDOld", salesOrderIDOld);
                hisAddOrdMap.put("salesOrderIDNew", salesOrderIDNew);
                hisAddOrdMap.put("contactIDOld", contactIDOld);
                hisAddOrdMap.put("contactIDNew", contactIDNew);
                hisAddOrdMap.put("addressIDOld", addressIDOld);
                hisAddOrdMap.put("addressIDNew", addressIDNew);
                hisAddOrdMap.put("statusIDOld", statusIDOld);
                hisAddOrdMap.put("statusIDNew", statusIDNew);
                hisAddOrdMap.put("remarkOld", remarkOld);
                hisAddOrdMap.put("remarkNew", remarkNew);
                hisAddOrdMap.put("emailOld", emailOld);
                hisAddOrdMap.put("emailNew", emailNew);
                hisAddOrdMap.put("isEStatementOld", isEStatementOld);
                hisAddOrdMap.put("isEStatementNew", isEStatementNew);
                hisAddOrdMap.put("isSMSOld", isSMSOld);
                hisAddOrdMap.put("isSMSNew", isSMSNew);
                hisAddOrdMap.put("isPostOld", isPostOld);
                hisAddOrdMap.put("isPostNew", isPostNew);
                hisAddOrdMap.put("isEInvFlgOld", isEInvFlgOld);
                hisAddOrdMap.put("isEInvFlgNew", isEInvFlgNew);
                hisAddOrdMap.put("typeId", typeId);
                hisAddOrdMap.put("sysHisRemark", sysHisRemark);
                hisAddOrdMap.put("emailAddtionalNew", emailAddtionalNew);
                hisAddOrdMap.put("emailAddtionalOld", emailAddtionalOld);

                if (1 == billingGroupMapper.insHistory(hisAddOrdMap)) {
                    successCnt += 1;
                    message2 += String.valueOf(params.get("salesOrdNo")) + ": " + "Success <br />";
                } else {
                    failCnt += 1;
                    message2 += String.valueOf(params.get("salesOrdNo")) + ": " + "Failed <br />";
                }

                Map<String, Object> updChangeMap = new HashMap<String, Object>();
                updChangeMap.put("userId", userId);
                updChangeMap.put("addOrdFlag", "Y");
                updChangeMap.put("salesOrdId", salesOrdIdArr[i].trim());
                updChangeMap.put("custBillId", String.valueOf(params.get("custBillId")));
                billingGroupMapper.updSalesOrderMaster(updChangeMap);

            } else {
                valid = false;
            }
        }

        if (valid) {

            message1 += "Total order : " + total + " || " + "Total success : " + successCnt + " || " + "Total fail : "
                    + failCnt + "<br /><br />";

            return message1 + message2;

        } else {

            return "";

        }
    }

    @Override
    @Transactional
    public boolean updEStatementConfirm(EgovMap requestMaster, Map<String, Object> history) {

        Map<String, Object> custMsMap = new HashMap<String, Object>();
        custMsMap.put("custBillId", String.valueOf(requestMaster.get("custBillId")));
        EgovMap selectCustBillMaster = billingGroupMapper.selectCustBillMaster(custMsMap);

        String custBillId = selectCustBillMaster.get("custBillId") != null
                ? String.valueOf(selectCustBillMaster.get("custBillId")) : "0";
        String masterCustBillId = String.valueOf(requestMaster.get("custBillId"));
        if (selectCustBillMaster != null && Integer.parseInt(custBillId) > 0) {

            if (requestMaster != null && Integer.parseInt(masterCustBillId) > 0) {

                history.put("isSMSOld", String.valueOf(selectCustBillMaster.get("custBillIsSms")));
                history.put("isSMSNew", String.valueOf(selectCustBillMaster.get("custBillIsSms")));
                history.put("isPostOld", String.valueOf(selectCustBillMaster.get("custBillIsPost")));
                history.put("isPostNew", String.valueOf(selectCustBillMaster.get("custBillIsPost")));
                history.put("isEInvFlgOld", String.valueOf(selectCustBillMaster.get("custBillIsEInv")));
                history.put("isEInvFlgNew", String.valueOf(selectCustBillMaster.get("custBillIsEInv")));
                history.put("emailOld", String.valueOf(selectCustBillMaster.get("custBillEmail")));
                history.put("isEStatementOld", String.valueOf(selectCustBillMaster.get("custBillIsEstm")));
                billingGroupMapper.insHistory(history);

                Map<String, Object> updCustMap = new HashMap<String, Object>();
                updCustMap.put("custBillId", String.valueOf(requestMaster.get("custBillId")));
                updCustMap.put("custBillEmail", String.valueOf(requestMaster.get("email")));
                updCustMap.put("userId", history.get("userId"));
                updCustMap.put("custBillIsEstm", "1");
                billingGroupMapper.updCustBillMaster(updCustMap);

                Map<String, Object> updReqMap = new HashMap<String, Object>();
                updReqMap.put("reqId", String.valueOf(requestMaster.get("reqId")));
                updReqMap.put("stusCodeId", "5");
                billingGroupMapper.updReqEstm(updReqMap);
            }
        }

        return true;
    }

}
