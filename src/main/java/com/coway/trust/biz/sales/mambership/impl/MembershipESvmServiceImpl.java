package com.coway.trust.biz.sales.mambership.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.billing.service.impl.AdvRentalBillingMapper;
import com.coway.trust.biz.payment.billing.service.impl.SrvMembershipBillingMapper;
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.biz.sales.mambership.MembershipESvmService;
import com.coway.trust.biz.sales.pos.impl.PosMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.text.DecimalFormat;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("membershipESvmService")
public class MembershipESvmServiceImpl extends EgovAbstractServiceImpl implements MembershipESvmService {

    @Resource(name = "membershipESvmMapper")
    private MembershipESvmMapper membershipESvmMapper;

    @Resource(name = "membershipRentalQuotationMapper")
    private MembershipRentalQuotationMapper membershipRentalQuotationMapper;

    @Resource(name = "posMapper")
    private PosMapper posMapper;

    @Resource(name = "advRentalBillingMapper")
    private AdvRentalBillingMapper advRentalBillingMapper;

    @Resource(name = "membershipConvSaleMapper")
    private MembershipConvSaleMapper membershipConvSaleMapper;

    @Resource(name = "srvMembershipBillingMapper")
    private SrvMembershipBillingMapper srvMembershipBillingMapper;

    @Resource(name = "commonPaymentService")
    private CommonPaymentService commonPaymentService;

    private static Logger logger = LoggerFactory.getLogger(MembershipConvSaleServiceImpl.class);

    @Override
    public List<EgovMap> selectESvmListAjax(Map<String, Object> params) {
        return membershipESvmMapper.selectESvmListAjax(params);
    }

    @Override
    public EgovMap selectESvmInfo(Map<String, Object> params) {
        return membershipESvmMapper.selectESvmInfo(params);
    }

    @Override
    public EgovMap selectMemberByMemberID(Map<String, Object> params) {
        return membershipESvmMapper.selectMemberByMemberID(params);
    }

    @Override
    public List<EgovMap> getESvmAttachList(Map<String, Object> params) {
        return membershipESvmMapper.selectESvmAttachList(params);
    }

    @Override
    public List<EgovMap> selectActionOption(Map<String, Object> params) {
        return membershipESvmMapper.selectActionOption(params);
    }

    @Override
    public List<EgovMap> selectCardMode(Map<String, Object> params) {
        return membershipESvmMapper.selectCardMode(params);
    }

    @Override
    public List<EgovMap> selectIssuedBank(Map<String, Object> params) {
        return membershipESvmMapper.selectIssuedBank(params);
    }

    @Override
    public List<EgovMap> selectCardType(Map<String, Object> params) {
        return membershipESvmMapper.selectCardType(params);
    }

    @Override
    public List<EgovMap> selectMerchantBank(Map<String, Object> params) {
        return membershipESvmMapper.selectMerchantBank(params);
    }

    @Override
    public EgovMap selectESvmPreSalesInfo(Map<String, Object> params) {
        return membershipESvmMapper.selectESvmPreSalesInfo(params);
    }

    @Override
    public EgovMap selectESvmPaymentInfo(Map<String, Object> params) {
        return membershipESvmMapper.selectESvmPaymentInfo(params);
    }

    @Override
    public String selectDocNo(Map<String, Object> params) {
        return membershipESvmMapper.getDocNo(params);
    }

    @Override
    public EgovMap selectMembershipQuotInfo(Map<String, Object> params) {
        return membershipESvmMapper.selectMembershipQuotInfo(params);
    }

    @Override
    public int updateAction(Map<String, Object> params) {
        int updSal298d = membershipESvmMapper.updateAction(params);
        int updPay312d = membershipESvmMapper.updateTR(params);

        if("6".equals(params.get("action").toString())) {
            params.put("reject", "8");
            membershipESvmMapper.updSal93(params);
        }

        int ret = 0;
        if(updSal298d > 0 && updPay312d > 0) {
            ret = 1;
        }

        return ret;
    }

    @Override
    public void updateTR(Map<String, Object> params) {
        membershipESvmMapper.updateTR(params);
    }

    @Override
    public EgovMap getHasBill(Map<String, Object> params) {
        return membershipESvmMapper.getHasBill(params);
    }

    @Override
    public String SAL0095D_insert(Map<String, Object> params) {

        boolean hasBill = false;
        EgovMap sal0001dData = null;
        EgovMap sal0090dData = null;
        EgovMap sal0093dData = null;
        EgovMap hasbillMap_PAY0024D = null;
        String memNo = "";
        String memBillNo = "";
        String trType = "";

        int o = -1;

        // 채번
        String srvMemId = String.valueOf(membershipESvmMapper.getSAL0095D_SEQ(params).get("seq"));
        params.put("srvMemId", srvMemId);

        //
        hasbillMap_PAY0024D = membershipESvmMapper.getHasBill(params);

        if (null != hasbillMap_PAY0024D) {
            hasBill = true;
        }

        logger.debug("hasBill  =========== ==>");
        logger.debug("hasBil ,{}" + hasBill);
        logger.debug("hasBill  =========== ==>");

        // GET sal0093dData
        sal0093dData = membershipESvmMapper.getSAL0093D_Data(params);

        if (hasBill == false) {

            logger.debug("params========>" + params);
            if (!params.get("docNo").equals("")) {
                memNo = (String) params.get("docNo");

                params.put("DOCNO", "19");
                memBillNo = String.valueOf(membershipESvmMapper.getDocNo(params));
            } else {
                params.put("DOCNO", "12");
                memNo = String.valueOf(membershipESvmMapper.getDocNo(params));

                params.put("DOCNO", "19");
                memBillNo = String.valueOf(membershipESvmMapper.getDocNo(params));
            }

            params.put("srvMemNo", memNo);
            params.put("srvMemBillNo", memBillNo);

            logger.debug("=================srvMemNo  =========== ==>");
            logger.debug("srvMemNo==>" + memNo);
            logger.debug("srvMemBillNo==>" + memBillNo);
            logger.debug("hasBill  =================================>");

            /////////////////////////////////////////////////////
            // master
            params.put("srvMemQuotId", String.valueOf(sal0093dData.get("srvMemQuotId")));
            params.put("srvMemSalesMemId", String.valueOf(sal0093dData.get("srvSalesMemId")));
            o = membershipESvmMapper.SAL0095D_insert(params);
            /////////////////////////////////////////////////////

            logger.debug("=================SAL0095D_insert  =========== ==>");
            logger.debug("[" + o + "]");
            logger.debug("hasBill  =================================>");

        }

        sal0001dData = membershipESvmMapper.getSAL0001D_Data(params);
        sal0090dData = membershipESvmMapper.getSAL0090D_Data(params);

        if (null != sal0090dData) {

            Map<String, Object> sal0088dDataMap = new HashMap<String, Object>();
            sal0088dDataMap.put("srvConfigId", sal0090dData.get("srvConfigId"));
            sal0088dDataMap.put("srvMbrshId", srvMemId);
            sal0088dDataMap.put("srvPrdStartDt", "01/01/1900");
            sal0088dDataMap.put("srvPrdExprDt", "01/01/1900");
            sal0088dDataMap.put("srvPrdDur", params.get("srvFreq"));
            sal0088dDataMap.put("srvPrdStusId", "1");
            sal0088dDataMap.put("srvPrdRem", "");
            sal0088dDataMap.put("srvPrdCrtDt", new Date());
            sal0088dDataMap.put("srvPrdCrtUserId", params.get("userId"));
            sal0088dDataMap.put("srvPrdUpdDt", new Date());

            logger.debug("sal0088dDataMap  ==>" + sal0088dDataMap.toString());
            int s88dCnt = membershipESvmMapper.SAL0088D_insert(sal0088dDataMap);
            logger.debug("s88dCnt  ==>" + s88dCnt);

            logger.debug("params  ==>" + params.toString());
            int s90upDataCnt = membershipESvmMapper.update_SAL0090D_Stus(params);
            logger.debug("s90upDataCnt  ==>" + s90upDataCnt);

        }

        if (null != sal0093dData) {

            Map<String, Object> sal0093dDataMap = new HashMap<String, Object>();
            sal0093dDataMap.put("srvMemId", srvMemId);
            sal0093dDataMap.put("srvMemQuotID", sal0093dData.get("srvMemQuotId"));

            logger.debug("sal0093dDataMap  ==>" + sal0093dDataMap.toString());
            int s93upDataCnt = membershipESvmMapper.update_SAL0093D_Stus(sal0093dDataMap);
            logger.debug("s93upDataCnt  ==>" + s93upDataCnt);
        }

        ///////////// processBills///////////////////
        this.processBills(hasBill, params, sal0093dData);
        ///////////// processBills///////////////////

        return memNo;

    }

    public void processBills(boolean hasBill, Map<String, Object> params, Map<String, Object> sal0093dData) {

        // int TAXRATE =0;
        String invoiceNum = "";
        double totalCharges = 0.00;
        double totalTaxes = 0.00;
        double totalAmountDue = 0.00;

        String zeroRatYn = "Y";
        String eurCertYn = "Y";

        params.put("srvSalesOrderId", params.get("srvSalesOrdId"));

        int zeroRat = membershipRentalQuotationMapper.selectGSTZeroRateLocation(params);
        int EURCert = membershipRentalQuotationMapper.selectGSTEURCertificate(params);

        // int package_TAXRATE =6; -- without GST 6% edited by TPY 23/05/2018
        int package_TAXRATE = 0;
        int package_TAXCODE = 32;

        // int filter_TAXRATE =6; -- without GST 6% edited by TPY 23/05/2018
        int filter_TAXRATE = 0;
        int filter_TAXCODE = 32;

        // package
        if (EURCert > 0) {
            package_TAXRATE = 0;
            package_TAXCODE = 28;

        }

        // FILTER
        if (zeroRat > 0) {
            filter_TAXRATE = 0;
            filter_TAXCODE = 39;
        }

        if (EURCert > 0) {
            filter_TAXRATE = 0;
            filter_TAXCODE = 28;
        }

        logger.debug("zeroRat ==========================>>  " + zeroRatYn);
        logger.debug("EURCert ==========================>>  " + eurCertYn);

        //////// get taxRate////////////////
        // TAXRATE = membershipConvSaleMapper.getTaxRate(params);
        //////// InvoiceNum 채번 ////////////////

        if (hasBill == false) {

            //////// InvoiceNum 채번 ////////////////
            params.put("DOCNO", "127");
            invoiceNum = String.valueOf(membershipESvmMapper.getDocNo(params));
            //////// InvoiceNum 채번 ////////////////
        }

        double filterCharge = 0.00;
        double filterPaid = 0.00;

        double srvMemBsAmt = Double.parseDouble(CommonUtils.nvl(params.get("srvMemBsAmt")));
        double srvMemPacAmt = Double.parseDouble(CommonUtils.nvl(params.get("srvMemPacAmt")));

        if (srvMemBsAmt > 0 && (srvMemBsAmt > srvMemPacAmt)) {
            filterCharge = (srvMemBsAmt - srvMemPacAmt);
        }

        // --------------------------------------------------------------------//
        // PACKAGE BILLING //
        // --------------------------------------------------------------------//
        double packageCharge = 0;
        double packagePaid = 0;

        if (srvMemPacAmt > 0) {
            packageCharge = srvMemPacAmt;
        }

        if (packageCharge > 0) {

            // bill
            Map<String, Object> pay0007dMap = new HashMap<String, Object>();
            pay0007dMap.put("billTypeId", "223");
            pay0007dMap.put("billSoId", params.get("srvSalesOrdId"));
            pay0007dMap.put("billMemId", "0");
            pay0007dMap.put("billAsId", "0");
            pay0007dMap.put("billPayTypeId", "386");

            if (hasBill) {
                pay0007dMap.put("billNo", "0");
                pay0007dMap.put("billMemShipNo", "0");

            } else {

                pay0007dMap.put("billNo", params.get("srvMemBillNo"));
                pay0007dMap.put("billMemShipNo", params.get("srvMemNo"));

                logger.debug("=================packageCharge  =========== ==>");
                logger.debug("srvMemNo==>" + params.get("srvMemNo"));
                logger.debug("srvMemBillNo==>" + params.get("srvMemBillNo"));
                logger.debug("hasBill  =================================>");

            }
            pay0007dMap.put("billDt", new Date());
            pay0007dMap.put("billAmt", packageCharge);
            pay0007dMap.put("billRem", "");
            pay0007dMap.put("billIsPaid", "0");
            pay0007dMap.put("billIsComm", "0");
            pay0007dMap.put("updUserId", params.get("userId"));
            pay0007dMap.put("updDt", new Date());
            pay0007dMap.put("syncChk", "0");
            pay0007dMap.put("coursId", "0");
            pay0007dMap.put("stusId", "1");

            logger.debug("package  pay0007dMap  ==>" + pay0007dMap.toString());
            int pay0007dMapCnt = membershipESvmMapper.PAY0007D_insert(pay0007dMap);
            logger.debug("package pay0007dMapCnt  ==>" + pay0007dMapCnt);

            //////////////////// Invoice sum////////////////////
            // totalCharges =totalCharges + packageCharge - ( packageCharge -
            //////////////////// (packageCharge * 100 / 106)); -- without GST 6%
            //////////////////// edited by TPY 23/05/2018
            // totalTaxes = totalTaxes + (packageCharge - (packageCharge * 100 /
            //////////////////// 106)); -- without GST 6% edited by TPY
            //////////////////// 23/05/2018
            totalCharges = totalCharges + packageCharge - (packageCharge - (packageCharge));
            totalTaxes = totalTaxes + (packageCharge - (packageCharge));
            totalAmountDue = totalAmountDue + packageCharge;
            //////////////////// Invoice sum////////////////////

            // Ledger
            Map<String, Object> pay0024dMap = new HashMap<String, Object>();
            if (hasBill) {
                pay0024dMap.put("srvMemId", params.get("srvMemId"));
                pay0024dMap.put("srvMemDocNo", params.get("srvMemId"));
            } else {
                pay0024dMap.put("srvMemId", params.get("srvMemId"));
                pay0024dMap.put("srvMemDocNo", params.get("srvMemBillNo"));
            }

            pay0024dMap.put("srvMemDocTypeId", "386");
            pay0024dMap.put("srvMemDtTm", new Date());
            pay0024dMap.put("srvMemAmt", packageCharge);
            pay0024dMap.put("srvMemInstNo", "0");
            pay0024dMap.put("srvMemBatchNo", invoiceNum); // srvMemBatchNo
            pay0024dMap.put("srvMemUpdUserId", params.get("userId"));
            pay0024dMap.put("srvMemUpdDt", "");
            pay0024dMap.put("srvMemOrdId", sal0093dData.get("srvSalesOrdId"));
            pay0024dMap.put("srvMemQotatId", sal0093dData.get("srvMemQuotId"));
            pay0024dMap.put("r01", "");

            logger.debug("package  pay0024dMapCnt  ==>" + pay0024dMap.toString());
            int pay0024dMapCnt = membershipESvmMapper.PAY0024D_insert(pay0024dMap);
            logger.debug("package pay0024dMapCnt  ==>" + pay0024dMapCnt);

            //////////// AccOrderBill////////////////////
            Map<String, Object> pay0016dMap = new HashMap<String, Object>();
            pay0016dMap.put("accBillTaskId", "0");
            pay0016dMap.put("accBillRefDt", new Date());
            pay0016dMap.put("accBillRefNo", "1000");
            pay0016dMap.put("accBillOrdId", params.get("srvSalesOrdId"));
            pay0016dMap.put("accBillTypeId", "1159");
            pay0016dMap.put("accBillModeId", "1143");
            pay0016dMap.put("accBillSchdulId", "0");
            pay0016dMap.put("accBillSchdulPriod", "0");
            pay0016dMap.put("accBillAdjId", "0");
            pay0016dMap.put("accBillSchdulAmt", packageCharge);
            pay0016dMap.put("accBillAdjAmt", "0");
            pay0016dMap.put("accBillNetAmt", packageCharge);
            pay0016dMap.put("accBillStus", "1");
            pay0016dMap.put("accBillRem", invoiceNum);
            pay0016dMap.put("accBillCrtDt", new Date());
            pay0016dMap.put("accBillCrtUserId", params.get("updator"));
            pay0016dMap.put("accBillGrpId", "0");

            pay0016dMap.put("accBillTaxCodeId", package_TAXCODE);
            pay0016dMap.put("accBillTaxRate", package_TAXRATE);

            if (package_TAXRATE == 6) {
                // pay0016dMap.put("accBillTxsAmt",Double.toString(
                // packageCharge - (packageCharge * 100 / 106))); -- without GST
                // 6% edited by TPY 23/05/2018
                pay0016dMap.put("accBillTxsAmt", Double.toString(packageCharge - (packageCharge)));
            } else {
                pay0016dMap.put("accBillTxsAmt", "0");
            }

            pay0016dMap.put("accBillAcctCnvr", "0");
            pay0016dMap.put("accBillCntrctId", "0");

            logger.debug("filter  pay0016dMap  ==>" + pay0016dMap.toString());
            int pay0016dMapCnt = membershipESvmMapper.PAY0016D_insert(pay0016dMap);
            logger.debug("filter pay0016dMapCnt  ==>" + pay0016dMapCnt);
            //////////// AccOrderBill////////////////////
        }

        // --------------------------------------------------------------------//
        // FILTER FILTER BILLING //
        // --------------------------------------------------------------------//

        if (filterCharge > 0) {

            /////////////// bill//////////////////////////////
            Map<String, Object> pay0007dMap = new HashMap<String, Object>();
            pay0007dMap.put("billTypeId", "542");
            pay0007dMap.put("billSoId", params.get("srvSalesOrdId"));
            pay0007dMap.put("billMemId", "0");
            pay0007dMap.put("billAsId", "0");
            pay0007dMap.put("billPayTypeId", "541");

            if (hasBill) {

                pay0007dMap.put("billNo", "0");
                pay0007dMap.put("billMemShipNo", "0");
            } else {

                logger.debug("=================filterCharge  =========== ==>");
                logger.debug("srvMemNo==>" + params.get("srvMemNo"));
                logger.debug("srvMemBillNo==>" + params.get("srvMemBillNo"));
                logger.debug("hasBill  =================================>");

                pay0007dMap.put("billNo", params.get("srvMemBillNo"));
                pay0007dMap.put("billMemShipNo", params.get("srvMemNo"));
            }

            pay0007dMap.put("billDt", new Date());
            pay0007dMap.put("billAmt", filterCharge);
            pay0007dMap.put("billRem", "");
            pay0007dMap.put("billIsPaid", "0");
            pay0007dMap.put("billIsComm", "0");
            pay0007dMap.put("updUserId", params.get("userId"));
            pay0007dMap.put("updDt", new Date());
            pay0007dMap.put("syncChk", "0");
            pay0007dMap.put("coursId", "0");
            pay0007dMap.put("stusId", "1");

            logger.debug("pay0007dMap  ==>" + pay0007dMap.toString());
            int pay0007dMapCnt = membershipESvmMapper.PAY0007D_insert(pay0007dMap);
            logger.debug("pay0007dMapCnt  ==>" + pay0007dMapCnt);
            /////////////// bill//////////////////////////////

            //////////////////// Invoice sum////////////////////

            /*
             * if(TAXRATE !=0){ totalCharges = totalCharges + filterCharge ;
             * totalTaxes = 0; totalAmountDue = totalAmountDue + filterCharge ;
             * }else{ totalCharges = totalCharges + ( (filterCharge) -
             * (filterCharge * 100 / 106)); totalTaxes = totalTaxes +
             * ((filterCharge) - (filterCharge * 100 / 106)); totalAmountDue =
             * totalAmountDue + filterCharge ; }
             */
            //////////////////// Invoice sum////////////////////

            ////////////// Ledger////////////////////////
            Map<String, Object> pay0024dMap = new HashMap<String, Object>();
            if (hasBill) {
                pay0024dMap.put("srvMemId", "0");
                pay0024dMap.put("srvMemDocNo", "0");
            } else {
                pay0024dMap.put("srvMemId", params.get("srvMemId"));
                pay0024dMap.put("srvMemDocNo", params.get("srvMemBillNo"));
            }

            pay0024dMap.put("srvMemDocTypeId", "542");
            pay0024dMap.put("srvMemDtTm", new Date());
            pay0024dMap.put("srvMemAmt", filterCharge);
            pay0024dMap.put("srvMemInstNo", "0");
            pay0024dMap.put("srvMemBatchNo", invoiceNum);
            pay0024dMap.put("srvMemUpdUserId", params.get("userId"));
            pay0024dMap.put("srvMemUpdDt", "");
            pay0024dMap.put("srvMemOrdId", sal0093dData.get("srvSalesOrdId"));
            pay0024dMap.put("srvMemQotatId", sal0093dData.get("srvMemQuotId"));
            pay0024dMap.put("r01", "");

            logger.debug("filter  pay0024dMapCnt  ==>" + pay0024dMap.toString());
            int pay0024dMapCnt = membershipESvmMapper.PAY0024D_insert(pay0024dMap);
            logger.debug("filter pay0024dMapCnt  ==>" + pay0024dMapCnt);
            ////////////// Ledger////////////////////////

            //////////// AccOrderBill////////////////////
            Map<String, Object> pay0016dMap = new HashMap<String, Object>();
            pay0016dMap.put("accBillTaskId", "0");
            pay0016dMap.put("accBillRefDt", new Date());
            pay0016dMap.put("accBillRefNo", "1000");
            pay0016dMap.put("accBillOrdId", params.get("srvSalesOrdId"));
            pay0016dMap.put("accBillTypeId", "1159");
            pay0016dMap.put("accBillModeId", "1147");
            pay0016dMap.put("accBillSchdulId", "0");
            pay0016dMap.put("accBillSchdulPriod", "0");
            pay0016dMap.put("accBillAdjId", "0");
            pay0016dMap.put("accBillSchdulAmt", filterCharge);
            pay0016dMap.put("accBillAdjAmt", "0");
            pay0016dMap.put("accBillNetAmt", filterCharge);
            pay0016dMap.put("accBillStus", "1");
            pay0016dMap.put("accBillRem", invoiceNum);
            pay0016dMap.put("accBillCrtDt", new Date());
            pay0016dMap.put("accBillCrtUserId", params.get("updator"));
            pay0016dMap.put("accBillGrpId", "0");
            pay0016dMap.put("accBillTaxCodeId", filter_TAXCODE);
            pay0016dMap.put("accBillTaxRate", filter_TAXRATE);

            if (filter_TAXRATE == 6) {
                pay0016dMap.put("accBillTxsAmt", Double.toString(filterCharge - (filterCharge)));
            } else {
                pay0016dMap.put("accBillTxsAmt", "0");
            }

            pay0016dMap.put("accBillAcctCnvr", "0");
            pay0016dMap.put("accBillCntrctId", "0");

            logger.debug("filter  pay0016dMap  ==>" + pay0016dMap.toString());
            int pay0016dMapCnt = membershipESvmMapper.PAY0016D_insert(pay0016dMap);
            logger.debug("filter pay0016dMapCnt  ==>" + pay0016dMapCnt);
            //////////// AccOrderBill////////////////////
        }

        if (hasBill == false) {
            //////////////// Invoice////////////////////
            this.processInvoice(invoiceNum, params, totalCharges, totalTaxes, totalAmountDue, package_TAXRATE,
                    package_TAXCODE, filter_TAXRATE, filter_TAXCODE);
            //////////////// Invoice////////////////////
        }
    }

    public int processInvoice(String invoiceNum, Map<String, Object> params, double totalCharges, double totalTaxes,
            double totalAmountDue, int package_TAXRATE, int package_TAXCODE, int filter_TAXRATE, int filter_TAXCODE) {

        int a = 0;

        Map<String, Object> pay31dMap = new HashMap<String, Object>();
        logger.debug("params : " + params);
        EgovMap newAddr = membershipESvmMapper.getNewAddr(params);

        // 채번
        int taxInvcId = posMapper.getSeqPay0031D();

        pay31dMap.put("taxInvcId", taxInvcId);
        pay31dMap.put("taxInvcRefNo", invoiceNum);
        pay31dMap.put("taxInvcRefDt", new Date());
        pay31dMap.put("taxInvcSvcNo", params.get("srvMemQuotNo"));
        pay31dMap.put("taxInvcType", "119");
        // pay31dMap.put("taxInvcCustName",params.get("srvMemQuotCustName"));
        // pay31dMap.put("taxInvcCntcPerson",params.get("srvMemQuotCntName"));
        pay31dMap.put("taxInvcCustName", newAddr.get("custName"));
        pay31dMap.put("taxInvcCntcPerson", newAddr.get("cntcName"));
        pay31dMap.put("taxInvcAddr1", "");
        pay31dMap.put("taxInvcAddr2", "");
        pay31dMap.put("taxInvcAddr3", "");
        pay31dMap.put("taxInvcAddr4", "");
        pay31dMap.put("taxInvcPostCode", "");
        pay31dMap.put("taxInvcStateName", "");
        pay31dMap.put("taxInvcCnty", "");
        pay31dMap.put("taxInvcTaskId", "");
        pay31dMap.put("taxInvcRem", "");
        pay31dMap.put("taxInvcChrg", Double.toString(totalCharges));
        pay31dMap.put("taxInvcTxs", Double.toString(totalTaxes));
        pay31dMap.put("taxInvcAmtDue", Double.toString(totalAmountDue));
        pay31dMap.put("taxInvcCrtDt", new Date());
        pay31dMap.put("taxInvcCrtUserId", params.get("updator"));
        pay31dMap.put("areaId", newAddr.get("areaId"));
        pay31dMap.put("addrDtl", newAddr.get("addrDtl"));
        pay31dMap.put("street", newAddr.get("street"));

        logger.debug(" in Invoice master   ==>" + pay31dMap.toString());
        int masterCnt = membershipESvmMapper.PAY0031D_insert(pay31dMap);
        logger.debug("in Invoice master   Cnt  ==>" + masterCnt);

        Map<String, Object> pay31dMap_update = new HashMap<String, Object>();
        pay31dMap_update.put("V_INVC_ITM_CHRG", totalCharges);
        pay31dMap_update.put("V_INVC_ITM_GST_TXS", totalTaxes);
        pay31dMap_update.put("V_INVC_ITM_AMT_DUE", totalAmountDue);

        pay31dMap_update.put("taxRate", filter_TAXRATE);
        pay31dMap_update.put("srvMemQuotId", params.get("srvMemQuotId"));
        pay31dMap_update.put("taxInvcId", taxInvcId);

        logger.debug(" in Invoice master   ==>" + pay31dMap.toString());
        int UPCnt = membershipESvmMapper.PAY0031D_INVC_ITM_UPDATE(pay31dMap_update);
        logger.debug("in Invoice master   Cnt  ==>" + masterCnt);

        // detail
        if (masterCnt > 0) {
            double srvMemBsAmt = Double.parseDouble(CommonUtils.nvl(params.get("srvMemBsAmt")));
            double srvMemPacAmt = Double.parseDouble(CommonUtils.nvl(params.get("srvMemPacAmt")));

            logger.debug(" srvMemBsAmt==>" + srvMemBsAmt);
            logger.debug(" srvMemPacAmt==>" + srvMemPacAmt);

            if (srvMemPacAmt > 0) { // Package
                Map<String, Object> pay32dMap = new HashMap<String, Object>();
                pay32dMap.put("taxInvcId", taxInvcId);
                pay32dMap.put("invcItmType", "1266");
                pay32dMap.put("invcItmOrdNo", params.get("srvSalesOrdNo"));
                pay32dMap.put("invcItmPoNo", params.get("poNo"));
                pay32dMap.put("invcItmCode", params.get("srvStockCode"));
                pay32dMap.put("invcItmDesc1", params.get("srvStockDesc")); //
                pay32dMap.put("invcItmDesc2", "");
                pay32dMap.put("invcItmSerialNo", "");
                pay32dMap.put("invcItmQty", Integer.parseInt(CommonUtils.nvl(params.get("srvDur"))) / 12);
                pay32dMap.put("invcItmUnitPrc", "");
                pay32dMap.put("invcItmGstRate", package_TAXRATE);

                pay32dMap.put("invcItmGstTxs", Double.toString(srvMemPacAmt - (srvMemPacAmt)));
                pay32dMap.put("invcItmChrg", Double.toString(srvMemPacAmt));

                pay32dMap.put("invcItmAmtDue", Double.toString(srvMemPacAmt));
                pay32dMap.put("invcItmAdd1", "");
                pay32dMap.put("invcItmAdd2", "");
                pay32dMap.put("invcItmAdd3", "");
                pay32dMap.put("invcItmAdd4", "");
                pay32dMap.put("invcItmPostCode", "");
                pay32dMap.put("invcItmAreaName", "");
                pay32dMap.put("invcItmStateName", "");
                pay32dMap.put("invcItmCnty", "");
                pay32dMap.put("invcItmInstallDt", "");
                pay32dMap.put("invcItmRetnDt", "");
                pay32dMap.put("invcItmBillRefNo", "");
                pay32dMap.put("areaId", newAddr.get("areaId"));
                pay32dMap.put("addrDtl", newAddr.get("addrDtl"));
                pay32dMap.put("street", newAddr.get("street"));

                logger.debug(" in package Invoice detail   ==>" + pay32dMap.toString());
                int detailCnt = membershipESvmMapper.PAY0032D_insert(pay32dMap);
                logger.debug("in package Invoice detail    Cnt  ==>" + detailCnt);

            }

            if ((srvMemBsAmt - srvMemPacAmt) > 0) { // Filter
                Map<String, Object> selMap = new HashMap<String, Object>();

                selMap.put("taxInvcId", taxInvcId);
                selMap.put("srvSalesOrdNo", params.get("srvSalesOrdNo"));
                selMap.put("taxRate", filter_TAXRATE);
                selMap.put("srvMemQuotId", params.get("srvMemQuotId"));
                List<EgovMap> list = membershipESvmMapper.getFilterListData(selMap);

                if (null != list) {
                    if (list.size() > 0) {
                        for (int i = 0; i < list.size(); i++) {
                            Map<String, Object> get2dMap = list.get(i);
                            Map<String, Object> pay32dMap = new HashMap();

                            pay32dMap.put("taxInvcId", taxInvcId);
                            pay32dMap.put("invcItmType", get2dMap.get("invcItmType"));
                            pay32dMap.put("invcItmOrdNo", get2dMap.get("invcItmOrdNo"));
                            pay32dMap.put("invcItmCode", get2dMap.get("invcItmCode"));
                            pay32dMap.put("invcItmDesc1", get2dMap.get("invcItmDesc1"));
                            pay32dMap.put("invcItmQty", get2dMap.get("invcItmQty"));
                            pay32dMap.put("invcItmGstRate", get2dMap.get("invcItmGstRate"));
                            pay32dMap.put("invcItmGstTxs", get2dMap.get("invcItmGstTxs"));
                            pay32dMap.put("invcItmChrg", get2dMap.get("invcItmChrg"));
                            pay32dMap.put("invcItmAmtDue", get2dMap.get("invcItmAmtDue"));

                            logger.debug(" in Filter Invoice detail   ==>" + pay32dMap.toString());
                            int detailCnt = membershipESvmMapper.PAY0032DFilter_insert(pay32dMap);
                            logger.debug("in Filter Invoice detail    Cnt  ==>" + detailCnt);

                        }
                    }
                }
            }
        }
        return a;
    }

    @Override
    public int genSrvMembershipBilling(Map<String, Object> params, SessionVO sessionVO) {
        logger.debug("========== MembershipESVMServiceImpl.genSrvMembershipBilling ==========");
        logger.debug("params {} ::", params);

        int result = 0;

        // SrvMembershipBillingController
        // Check duplicate by reference number
        EgovMap dupRef = membershipConvSaleMapper.getMembershipByRefNo(params);
        if(dupRef != null) {
            // Duplicate exist
            return result;
        }

        // SrvMembershipBillingServiceImpl
        result = 97;
        int userId = sessionVO.getUserId();
        int taskCount = 1; // 20211201 - Cater only for single order basis; Can be changed to cater >1 order
        int taskTotalAmount = Integer.parseInt(params.get("srvMemPacAmt").toString()) + Integer.parseInt(params.get("srvMemBsAmt").toString());

        Map<String, Object> taskOrderMap = new HashMap<String, Object>();

        int newTaskId = advRentalBillingMapper.getTaskIdSeq();

        taskOrderMap.put("salesOrdId", String.valueOf(params.get("srvSalesOrdId")));
        taskOrderMap.put("taskReferenceNo", String.valueOf(params.get("PONo")).replace("'","''"));
        taskOrderMap.put("taskBillTypeId", 223);
        taskOrderMap.put("taskBillUpdateBy", userId);
        taskOrderMap.put("taskBillAmt", new DecimalFormat("0.00").format(taskTotalAmount));
        taskOrderMap.put("taskBillInstNo", 0);
        taskOrderMap.put("taskBillBatchNo", String.valueOf(params.get("srvMemQuotNo")));
        taskOrderMap.put("taskBillGroupId", 0);
        taskOrderMap.put("taskBillRemark", String.valueOf(params.get("remark")).replace("'","''"));
        taskOrderMap.put("taskBillUpdateBy", userId);
        taskOrderMap.put("taskBillZRLocationId", 0);
        taskOrderMap.put("taskBillReliefCertificateId", 0);
        taskOrderMap.put("taskBillCnrctId", 0);
        taskOrderMap.put("newTaskId", newTaskId);
        taskOrderMap.put("taskSmqRefNo", String.valueOf(params.get("refNo")).replace("'","''"));

        // Insert PAY0048D
        advRentalBillingMapper.insTaskLogOrder(taskOrderMap);

        Map<String, Object> taskLogMap = new HashMap<String, Object>();
        Calendar calendar = Calendar.getInstance();
        taskLogMap.put("taskType", "MEMBERSHIP BILL");
        taskLogMap.put("billingYear", calendar.get(Calendar.YEAR));
        taskLogMap.put("billingMonth", calendar.get(Calendar.MONTH) + 1);
        taskLogMap.put("taskTotalAmount", taskTotalAmount);
        taskLogMap.put("taskCount", taskCount);
        taskLogMap.put("status", "SUCCESS");
        taskLogMap.put("isConfirmed", 0);
        taskLogMap.put("isInvoiceGenerate", 0);
        taskLogMap.put("createdBy", userId);
        taskLogMap.put("updatedBy", userId);
        taskLogMap.put("taskBillRemark", String.valueOf(params.get("mnlBill_invcRemark")).replace("'","''"));
        taskLogMap.put("newTaskId", newTaskId);

        // Insert PAY0047D
        advRentalBillingMapper.insBillTaskLog(taskLogMap);

        // BILL CREATION CONFIRM
        if(newTaskId > 0) {
            Map<String, Object> confMap = new HashMap<String, Object>();
            confMap.put("taskId", newTaskId);
            confMap.put("userId", userId);

            srvMembershipBillingMapper.confirmSrvMembershipBilll(confMap);
            int confirmVal = Integer.parseInt(String.valueOf(confMap.get("p1")));

            if(confirmVal == 1) {
                Map<String, Object> invoiceMap = new HashMap<String, Object>();
                invoiceMap.put("taskId", newTaskId);
                invoiceMap.put("userId", userId);

                // CREATE TAX INVOICE : MEMBERSHIP
                srvMembershipBillingMapper.createTaxInvoice(invoiceMap);
                int invcVal=Integer.parseInt(String.valueOf(invoiceMap.get("p1")));

                result = invcVal == 1 ? 1 : 99;
            } else {
                result = 98;
            }
        }

        return result;
    }

    @Override
    public String getPOSm(Map<String, Object> params) {
        return membershipESvmMapper.getPOSm(params);
    }

    @Override
    public Map<String, Object> eSVMNormalPayment(Map<String, Object> params, SessionVO sessionVO) {
        logger.debug("========== MembershipESVMServiceImpl.eSVMNormalPayment ==========");
        logger.debug("params {} ::", params);

        List<Object> formList = new ArrayList<Object>();
        Map<String, Object> formInfo = null;

        // Get PSM details
        EgovMap psmInfo = membershipESvmMapper.selectESvmInfo(params);
        EgovMap psmPayInfo = membershipESvmMapper.selectESvmPaymentInfo(params);

        // Check bank statement by transaction ID
        EgovMap bankStatementInfo = membershipESvmMapper.selectBankStatementInfo(params);
        if(bankStatementInfo == null) {
            throw new ApplicationException(AppConstants.FAIL, "Entered Transaction ID not found OR is mapped. Please check Transaction ID entered.");
        }

        // Get transaction ID's amount
        BigDecimal DoubleCrdit = BigDecimal.ZERO;
        if ("".equals(String.valueOf(bankStatementInfo.get("crdit")))) {
            DoubleCrdit = BigDecimal.ZERO;
        } else {
            DoubleCrdit = new BigDecimal(String.valueOf(bankStatementInfo.get("crdit")));
        }

        // Compare statement amount to quotation amount
        BigDecimal quotAmt = BigDecimal.ZERO;
        if(psmInfo.get("quoTot") != null) {
            quotAmt = quotAmt.add(new BigDecimal(String.valueOf(psmInfo.get("quoTot"))));
        }

        if(DoubleCrdit.compareTo(quotAmt) != 0) {
            throw new ApplicationException(AppConstants.FAIL, "Total quotation payment amount of " +  quotAmt.toPlainString() + " does not match with transaction ID's amount of " + DoubleCrdit.toPlainString() + ".");
        }

        // Form Setting - Payment Type
        String payMode = (String) bankStatementInfo.get("type");
        String payType = "";

        if("ONL".equals(payMode)) {
            payType = "108";
        } else if("CHQ".equals(payMode)) {
            payType = "106";
        } else {
            payType = "105";
        }

        Map<String, Object> formMap = null;

        EgovMap psmPay24Info = membershipESvmMapper.getPay0024D(params);

        if(new BigDecimal(String.valueOf(psmInfo.get("srvMemPacAmt"))).compareTo(BigDecimal.ZERO) > 0) {
            formMap = new HashMap<String, Object>();

            formMap.put("procSeq","1");
            formMap.put("appType","OUT_MEM");
            formMap.put("advMonth","0");
            formMap.put("billGrpId","0");
            formMap.put("billId","0");
            formMap.put("ordId",psmInfo.get("psmSalesOrdId"));
            formMap.put("mstRpf","0");
            formMap.put("mstRpfPaid","0");
            formMap.put("billNo",psmInfo.get(""));
            formMap.put("ordNo",psmPayInfo.get(""));
            formMap.put("billTypeId","164");
            formMap.put("billTypeNm","Membership Package");
            formMap.put("installment","0");
            formMap.put("billAmt",psmPay24Info.get("packageCharge"));
            formMap.put("paidAmt",psmPay24Info.get("packagePaid"));
            formMap.put("targetAmt",psmPay24Info.get("packageAmt"));
            formMap.put("billDt","1900-01-01");
            formMap.put("assignAmt","0");
            formMap.put("billStatus","");
            formMap.put("custNm",psmInfo.get("name"));
            formMap.put("srvcContractID","0");
            formMap.put("billAsId","0");
            formMap.put("discountAmt","0");
            formMap.put("srvMemId",psmInfo.get("cnvrMemId"));
            formMap.put("trNo",psmPayInfo.get("trRefNo"));
            formMap.put("trDt",psmPayInfo.get("trIssuedDt"));
            formMap.put("collectorCode",psmPayInfo.get("memCode"));
            formMap.put("collectorId",psmPayInfo.get("memId"));
            formMap.put("allowComm",psmPayInfo.get("allowComm"));

            formList.add(formMap);
        }

        if(new BigDecimal(String.valueOf(psmInfo.get("srvMemBsAmt"))).compareTo(BigDecimal.ZERO) > 0) {
            formMap = new HashMap<String, Object>();

            formMap.put("procSeq","2");
            formMap.put("appType","OUT_MEM");
            formMap.put("advMonth","0");
            formMap.put("billGrpId","0");
            formMap.put("billId","0");
            formMap.put("ordId",psmInfo.get("psmSalesOrdId"));
            formMap.put("mstRpf","0");
            formMap.put("mstRpfPaid","0");
            formMap.put("billNo",psmInfo.get(""));
            formMap.put("ordNo",psmPayInfo.get(""));
            formMap.put("billTypeId","542");
            formMap.put("billTypeNm","Filter (1st BS)");
            formMap.put("installment","0");
            formMap.put("billAmt",psmPay24Info.get("filterCharge"));
            formMap.put("paidAmt",psmPay24Info.get("filterPaid"));
            formMap.put("targetAmt",psmPay24Info.get("filterAmt"));
            formMap.put("billDt","1900-01-01");
            formMap.put("assignAmt","0");
            formMap.put("billStatus","");
            formMap.put("custNm",psmInfo.get("name"));
            formMap.put("srvcContractID","0");
            formMap.put("billAsId","0");
            formMap.put("discountAmt","0");
            formMap.put("srvMemId",psmInfo.get("cnvrMemId"));
            formMap.put("trNo",psmPayInfo.get("trRefNo"));
            formMap.put("trDt",psmPayInfo.get("trIssuedDt"));
            formMap.put("collectorCode",psmPayInfo.get("memCode"));
            formMap.put("collectorId",psmPayInfo.get("memId"));
            formMap.put("allowComm",psmPayInfo.get("allowComm"));

            formList.add(formMap);
        }

        formInfo = new HashMap<String, Object>();
        formInfo.put("chargeAmount", 0);
        formInfo.put("slipNo", psmPayInfo.get("slipNo"));
        formInfo.put("chqNo", psmPayInfo.get("chequeNo"));
        formInfo.put("bankType", 2729);
        formInfo.put("bankAcc", bankStatementInfo.get("bankAccId"));
        formInfo.put("trDate", bankStatementInfo.get("trnscDt"));

        formInfo.put("payItemIsLock", false);
        formInfo.put("payItemIsThirdParty", false);
        formInfo.put("payItemStatusId", 1);
        formInfo.put("isFundTransfer", false);
        formInfo.put("skipRecon", false);
        formInfo.put("payItemCardTypeId", 0);

        formInfo.put("keyInRoute", "WEB");
        formInfo.put("keyInScrn", "NOR");
        formInfo.put("amount", psmPayInfo.get("payAmt"));
        formInfo.put("keyInPayDate", psmPayInfo.get("crtDt"));
        formInfo.put("payType", payType);
        formInfo.put("userid", sessionVO.getUserId());

        // ************************************************************************************************

        // INSERT TO PAY0240T AND PAY0241T AND LATER EXECUTE SP_INST_NORMAL_PAYMENT
        Map<String, Object> resultList = commonPaymentService.saveNormalPayment(formInfo, formList, Integer.parseInt(params.get("trxId").toString()));
//        Map<String, Object> resultList = null;

        // RETURN WOR NO.
        return resultList;
    }
}
