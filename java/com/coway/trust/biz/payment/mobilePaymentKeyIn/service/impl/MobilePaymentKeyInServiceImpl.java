package com.coway.trust.biz.payment.mobilePaymentKeyIn.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.MobileAppTicketApiCommonMapper;
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.biz.payment.common.service.impl.CommonPaymentMapper;
import com.coway.trust.biz.payment.mobilePaymentKeyIn.service.MobilePaymentKeyInService;
import com.coway.trust.biz.sales.mambership.MembershipPaymentService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.payment.mobilePaymentKeyIn.controller.MobilePaymentKeyInController;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobilePaymentKeyInServiceImpl.java
 * @Description : MobilePaymentKeyInServiceImpl
 *
 * @History
 *
 *          <pre>
 * Date               Author          Description
 * -------------  -----------  -------------
 * 2019. 10. 21.   KR-HAN        First creation
 * 2020. 02. 11    ONGHC         Add Payment Method ONL for saveMobilePaymentKeyInNormalPayment
 * 2020. 02. 12    ONGHC         Add Optional Value for Commission
 * 2020. 02. 25    KR-HAN        Payment Error Edit ( WOR Error,  convert to integer error )
 * 2020. 03. 09    ONGHC         Amend paidAmt's String value to integer
 *                                         Add TR Ref.No and TR Issue Date
 * 2020. 03.        KR-HAN        RPF Error Edit
 * 2020. 04. 01    KR-HAN        Payment Key-in Error Edit
 * 2020. 04. 10    ONGHC         Amend saveMobilePaymentKeyInNormalPayment to fixed payment amount comparison issue
 * 2020. 04. 22    KR-HAN        Payment Key-in - Calculation issue Edit
 * 2020. 05. 08    ONGHC         Amend saveMobilePaymentKeyInNormalPayment to add chqNo to formInfo map.
 * 2020. 06. 30    KR-HAN        Mobile payment key in Issue_29.05.2020 ( difference calculation error )
 * 2020. 07. 06    ONGHC        Add selectMemDetails
 * 2020. 07. 28    ONGHC        Revert 2020. 06. 30 Deployment.
 * 2020. 08. 05    ONGHC        Restructure saveMobilePaymentKeyInNormalPayment & saveMobilePaymentKeyInCard
 * 2020. 08. 09    ONGHC        Amend saveMobilePaymentKeyInCard
 * 2020. 08. 11    ONGHC        Amend saveMobilePaymentKeyInNormalPayment
 * 2020. 09. 03    ONGHC        Amend to cater RPF amount
 *          </pre>
 */
@Service("mobilePaymentKeyInService")
public class MobilePaymentKeyInServiceImpl extends EgovAbstractServiceImpl implements MobilePaymentKeyInService {

  private static final Logger LOGGER = LoggerFactory.getLogger(MobilePaymentKeyInServiceImpl.class);

  private Pattern patternInteger = Pattern.compile("^\\d+$");

  @Resource(name = "mobilePaymentKeyInMapper")
  private MobilePaymentKeyInMapper mobilePaymentKeyInMapper;

  @Resource(name = "mobileAppTicketApiCommonMapper")
  private MobileAppTicketApiCommonMapper mobileAppTicketApiCommonMapper;

  @Resource(name = "commonPaymentMapper")
  private CommonPaymentMapper commonPaymentMapper;

  @Resource(name = "commonPaymentService")
  private CommonPaymentService commonPaymentService;

  @Resource(name = "membershipPaymentService")
  private MembershipPaymentService membershipPaymentService;

  @Override
  public List<EgovMap> selectMobilePaymentKeyInList(Map<String, Object> params) {
    return mobilePaymentKeyInMapper.selectMobilePaymentKeyInList(params);
  }

  @Override
  public int saveMobilePaymentKeyInReject(Map<String, Object> param) throws Exception {

    int saveCnt = 0;
    List<Object> gridList = (List<Object>) param.get(AppConstants.AUIGRID_ALL); // IMPORT GRID DATA

    Map<String, Object> saveParam = null;

    for (int i = 0; i < gridList.size(); i++) {
      Map<String, Object> gridMap = (Map<String, Object>) gridList.get(i);
      Map<String, Object> itmeMap = (Map<String, Object>) gridMap.get("item");

      String mobTicketNo = String.valueOf(itmeMap.get("mobTicketNo"));
      String mobPayNo = String.valueOf(itmeMap.get("mobPayNo"));

      if (StringUtils.isEmpty(mobTicketNo)) {
        throw new ApplicationException(AppConstants.FAIL, "Please check the Request Number value.");
      }

      /*
       * if( StringUtils.isEmpty( param.get("reqStusId") )){ throw new
       * ApplicationException(AppConstants.FAIL,
       * "Please check the Request Status value."); }
       */

      if (StringUtils.isEmpty(param.get("userId"))) {
        throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
      }

      if (StringUtils.isEmpty(param.get("stus"))) {
        throw new ApplicationException(AppConstants.FAIL, "Reject reason value does not exist.");
      }

      if (StringUtils.isEmpty(param.get("resnId"))) {
        throw new ApplicationException(AppConstants.FAIL, "Reject reason value does not exist.");
      }

      if (StringUtils.isEmpty(param.get("etc"))) {
        throw new ApplicationException(AppConstants.FAIL, "Reject reason value does not exist.");
      }

      saveParam = new HashMap<String, Object>();

      saveParam.put("mobTicketNo", mobTicketNo);
      saveParam.put("etc", param.get("etc"));
      saveParam.put("mobPayNo", mobPayNo);
      saveParam.put("userId", param.get("userId"));
      saveParam.put("stus", param.get("stus"));
      saveParam.put("resnId", param.get("resnId"));

      saveCnt = mobilePaymentKeyInMapper.updateMobilePaymentKeyInReject(saveParam);

      // 티겟 상태 변경  - CHANGE TARGET STATUS
      Map<String, Object> ticketParam = new HashMap<String, Object>();
      ticketParam.put("ticketStusId", param.get("stus"));
      ticketParam.put("updUserId", param.get("userId"));
      ticketParam.put("mobTicketNo", mobTicketNo);
      mobileAppTicketApiCommonMapper.update(ticketParam);
    }
    return saveCnt;
  }

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 11. 19.
   * @param params
   * @param sUserId
   * @return
   * @see com.coway.trust.biz.payment.mobilePaymentKeyIn.service.MobilePaymentKeyInService#saveMobilePaymentKeyInCard(java.util.Map,
   *      java.lang.String)
   */
  @Override
  public List<EgovMap> saveMobilePaymentKeyInCard(Map<String, Object> params, String sUserId) {
    List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
    List<Object> gridFormList = (List<Object>) params.get(AppConstants.AUIGRID_FORM);

    LOGGER.debug("=================================saveMobilePaymentKeyInCard=================================");
    LOGGER.debug("= GRID LIST ALL : " + gridList.toString());
    LOGGER.debug("= GRID LIST FORM : " + gridFormList.toString());
    LOGGER.debug("=================================saveMobilePaymentKeyInCard=================================");

    // START
    List<Object> formList = new ArrayList<Object>();
    Map<String, Object> formInfo = null;
    Map<String, Object> gridListMap = null;

    BigDecimal totPayAmt = BigDecimal.ZERO;
    int iProcSeq = 1;
    String allowance = "0";
    String trRefNo = "";
    String trIssDt = "0";

    // ONGHC - MOVE TO TOP
    formInfo = new HashMap<String, Object>();
    if (gridFormList.size() > 0) {
      for (Object obj : gridFormList) {
        Map<String, Object> map = (Map<String, Object>) obj;
        formInfo.put((String) map.get("name"), map.get("value"));
      }
    }

    LOGGER.debug("= FORM LIST PART 1 : " + formInfo.toString());

    // ALLOWANCEE
    if (formInfo.get("allowance") != null) {
      allowance = "1";
    } else {
      allowance = "0";
    }

    // TR REF. NO.
    if (formInfo.get("trRefNo2") != null) {
      trRefNo = formInfo.get("trRefNo2").toString();
    } else {
      trRefNo = "";
    }

    // TR ISSUE DATE
    if (formInfo.get("trIssDt2") != null) {
      trIssDt = formInfo.get("trIssDt2").toString();
    } else {
      trIssDt = "";
    }

    LOGGER.debug("= FORM LIST PART 2 : " + formInfo.toString());

    for (int i = 0; i < gridList.size(); i++) {
      gridListMap = (Map<String, Object>) gridList.get(i);

      params.put("ordNo", gridListMap.get("salesOrdNo"));
      // SELECT SAL0001D TO GET ORDER ID, NO AND CUSTOMER ID
      EgovMap resultMap = commonPaymentService.selectOrdIdByNo(params);

      String salesOrdId = new BigDecimal(resultMap.get("salesOrdId").toString()).toPlainString();
      String salesOrdNo = new BigDecimal(resultMap.get("salesOrdNo").toString()).toPlainString();

      LOGGER.debug("= SALES ORDER ID : " + salesOrdId);
      LOGGER.debug("= SALES ORDER NO : " + salesOrdNo);

      params.put("orderId", salesOrdId);
      params.put("salesOrdId", salesOrdId);

      List<EgovMap> orderInfoRentalList = commonPaymentService.selectOrderInfoRental(params); // targetRenMstGridID

      // PAYMENT - BILL INFO RENTAL 조회
      BigDecimal rpf = new BigDecimal(orderInfoRentalList.get(0).get("rpf").toString()); // TOTAL RPF
      BigDecimal rpfPaid = new BigDecimal(orderInfoRentalList.get(0).get("rpfPaid").toString()); // TOTAL PAID RPF

      String excludeRPF = "";

      if (rpf.compareTo(BigDecimal.ZERO) >= 1) { // HAVE RPF
        if (rpfPaid.compareTo(rpf) >= 0) { // PAID RPF >= RPF
          excludeRPF = "N"; // NO NEED RPF
        } else {
          excludeRPF = "Y"; // RPF REQUIRED
        }
        excludeRPF = "Y"; // RPF REQUIRED
      }

      if (rpf.compareTo(BigDecimal.ZERO) == 0) { // IF RPF IS 0 THAN NO NEED RPF
        excludeRPF = "N";
      }

      LOGGER.debug("= RPF EXCLUDED? : " + excludeRPF);

      params.put("excludeRPF", excludeRPF);
      List<EgovMap> billInfoRentalList = commonPaymentService.selectBillInfoRental(params); // targetRenDetGridID

      LOGGER.debug("= BILL INFO RENTAL : " + billInfoRentalList.toString());

      // checkOrderOutstanding 정보 조회 - INFORMATION LOOKUP
      //EgovMap targetOutMstResult = commonPaymentService.checkOrderOutstanding(params); // targetOutMstGridID

      // if( "ROOT_1".equals(targetOutMstResult.get("rootState")) ){
      // System.out.println("++ No Outstanding" +
      // targetOutMstResult.get("msg"));
      // }

      // Colle 정보 조회
      params.put("COLL_MEM_CODE", gridListMap.get("crtUserNm"));
      List<EgovMap> paymentColleConfirm = membershipPaymentService.paymentColleConfirm(params);

      if (paymentColleConfirm.get(0) == null) {
        throw new ApplicationException(AppConstants.FAIL, "No record found for payment collection's member.");
      }

      EgovMap paymentColleConfirmMap = paymentColleConfirm.get(0);

      LOGGER.debug("= PAYMENT COLLECTION : " + paymentColleConfirmMap.toString());

      BigDecimal mstRpf = new BigDecimal(orderInfoRentalList.get(0).get("rpf").toString());
      BigDecimal mstRpfPaid = new BigDecimal(orderInfoRentalList.get(0).get("rpfPaid").toString());

      String mstCustNm = (String) orderInfoRentalList.get(0).get("custNm");
      BigDecimal mstCustBillId = new BigDecimal(orderInfoRentalList.get(0).get("custBillId").toString());

      LOGGER.debug("= MASTER RPF : " + mstRpf);
      LOGGER.debug("= MASTER RPF PAID : " + mstRpfPaid);
      LOGGER.debug("= MASTER CUSTOMER NAME : " + paymentColleConfirmMap.toString());
      LOGGER.debug("= MASTER CUSTOMER BILL ID : " + paymentColleConfirmMap.toString());
      LOGGER.debug("====================================================");

      Map<String, Object> formMap = null;

      //int maxSeq = 0;
      BigDecimal totTargetAmt = BigDecimal.ZERO;
      BigDecimal totRemainAmt = new BigDecimal( "".equals(CommonUtils.nvl(String.valueOf(gridListMap.get("payAmt")))) ? "0" : String.valueOf(gridListMap.get("payAmt")) );

      LOGGER.debug("======================== START ===========================");
      LOGGER.debug("= TOTAL TARGET AMOUNT  : " + totTargetAmt.toPlainString());
      LOGGER.debug("= TOTAL REMAINING AMOUNT  : " + totRemainAmt.toPlainString());
      LOGGER.debug("= ORDER INFO RENTAL LIST SIZE  : " + orderInfoRentalList.size());

      for (int j = 0; j < orderInfoRentalList.size(); j++) {
        // if( "1".equals(mstChkVal) ){
        // if ((mstRpf - mstRpfPaid > 0) && StringUtils.isEmpty(gridListMap.get("advMonth")) ) {

        BigDecimal vAdvAmt = new BigDecimal( "".equals(CommonUtils.nvl((gridListMap.get("advAmt")))) ? "0" : String.valueOf(gridListMap.get("advAmt")) ); // ADVANCE BUCKET
        BigDecimal vPayAmt = new BigDecimal( "".equals(CommonUtils.nvl((gridListMap.get("payAmt")))) ? "0" : String.valueOf(gridListMap.get("payAmt")) ); // PAYMENT AMOUNT BUCKET
        totRemainAmt = totRemainAmt.subtract(vAdvAmt); // TAKE OUT ADVANCE PAYMENT FROM REMAINING FIRST

        if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
          if (((mstRpf.subtract(mstRpfPaid)).compareTo(BigDecimal.ZERO) > 0)) { // IF HAVE REMAINING RPF
            LOGGER.debug("======== RPF PROCESSING - START ========");
            BigDecimal payAmt = new BigDecimal( "".equals(CommonUtils.nvl((gridListMap.get("payAmt")))) ? "0" : String.valueOf(gridListMap.get("payAmt")) );
            BigDecimal targetAmtRPF = BigDecimal.ZERO;

            LOGGER.debug("= PAYMENT AMOUNT : " + payAmt.toPlainString());
            LOGGER.debug("= PAYMENT TARGET RPF : " + targetAmtRPF.toPlainString());

            if ((mstRpf.subtract(mstRpfPaid)).compareTo(payAmt) > 0) {
              targetAmtRPF = payAmt; // IF REMAINING RPF MORE THAN PAYMENT AMOUNT DIRECT USE PAYMENT AMOUNT
            } else {
              targetAmtRPF = mstRpf.subtract(mstRpfPaid); // ELSE JUST POST
            }

            formMap = new HashMap<String, Object>();

            formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
            formMap.put("appType", "RENTAL");
            formMap.put("advMonth", (Integer) gridListMap.get("advMonth")); // 셋팅필요
            formMap.put("mstRpf", mstRpf);
            formMap.put("mstRpfPaid", mstRpfPaid);

            formMap.put("assignAmt", 0);
            formMap.put("billAmt", mstRpf);
            formMap.put("billDt", "1900-01-01");
            formMap.put("billGrpId", mstCustBillId);
            formMap.put("billId", 0);
            formMap.put("billNo", "0");
            formMap.put("billStatus", "");
            formMap.put("billTypeId", 161);
            formMap.put("billTypeNm", "RPF");
            formMap.put("custNm", mstCustNm);
            formMap.put("discountAmt", 0);
            formMap.put("installment", 0);
            formMap.put("ordId", salesOrdId);
            formMap.put("ordNo", salesOrdNo);
            formMap.put("paidAmt", mstRpfPaid);
            //formMap.put("targetAmt", payAmtDou);
            formMap.put("targetAmt", targetAmtRPF);
            formMap.put("srvcContractID", 0);
            formMap.put("billAsId", 0);
            formMap.put("srvMemId", 0);
            // item. = $("#rentalkeyInTrNo").val() ;
            formMap.put("trNo", trRefNo); //
            // item. = $("#rentalkeyInTrIssueDate").val() ;
            formMap.put("trDt", trIssDt); //
            // item.collectorCode = $("#rentalkeyInCollMemNm").val()
            formMap.put("collectorCode", paymentColleConfirmMap.get("memCode"));
            // item.collectorId = $("#rentalkeyInCollMemId").val() ;
            formMap.put("collectorId", paymentColleConfirmMap.get("memId"));
            // item.allowComm = $("#rentalcashIsCommChk").val()
            // formMap.put("allowComm", "1");
            formMap.put("allowComm", allowance);

            formList.add(formMap);

            vPayAmt = vPayAmt.subtract(targetAmtRPF);
            totRemainAmt = totRemainAmt.subtract(targetAmtRPF);

            LOGGER.debug("======== RPF FORM LIST : " + formList.toString());
            LOGGER.debug("======== RPF PROCESSING - END ========");
          }
        }

        // NO RPF TO PROCESS
        LOGGER.debug("======== OTHER PROCESSING - START ========");
        LOGGER.debug("= ADVANCE AMOUNT : " + vAdvAmt.toPlainString());
        LOGGER.debug("= PAYMENT AMOUNT : " + vPayAmt.toPlainString());
        LOGGER.debug("= TOTAL REMAINING AMOUNT : " + totRemainAmt.toPlainString());

        if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
          int detailRowCnt = billInfoRentalList.size();
          for (j = 0; j < detailRowCnt; j++) {
            Map billInfoRentalMap = billInfoRentalList.get(j);

            LOGGER.debug("= TOTAL REMAINING  AMOUNT PER RECORD : " + totRemainAmt.toPlainString());

            String detSalesOrdNo = (String) billInfoRentalMap.get("ordNo");
            if (salesOrdNo.equals(detSalesOrdNo)) {
              BigDecimal targetAmt = new BigDecimal(billInfoRentalMap.get("targetAmt").toString()); // AMOUNT TO BE DEDUCT
              if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
                if (totRemainAmt.compareTo(targetAmt) < 0) {
                  targetAmt = totRemainAmt;
                }

                LOGGER.debug("= PROCESSING SEQ : " + iProcSeq);
                LOGGER.debug("= BILLING TYPE ID : " + billInfoRentalMap.get("billTypeId"));
                LOGGER.debug("= BILLING TYPE : " + billInfoRentalMap.get("billTypeNm"));
                LOGGER.debug("= ORDER NO : " + billInfoRentalMap.get("ordNo"));
                LOGGER.debug("= ORDER PAY AMOUNT : " + billInfoRentalMap.get("paidAmt"));
                LOGGER.debug("= TARGET AMOUNT : " + targetAmt.toPlainString());

                formMap = new HashMap<String, Object>();

                formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
                formMap.put("appType", "RENTAL");
                formMap.put("advMonth", (Integer) gridListMap.get("advMonth")); // 셋팅필요
                formMap.put("mstRpf", mstRpf);
                formMap.put("mstRpfPaid", mstRpfPaid);

                formMap.put("assignAmt", 0);
                formMap.put("billAmt", billInfoRentalMap.get("billAmt"));
                formMap.put("billDt", billInfoRentalMap.get("billDt"));
                formMap.put("billGrpId", billInfoRentalMap.get("billGrpId"));
                formMap.put("billId", billInfoRentalMap.get("billId"));
                formMap.put("billNo", billInfoRentalMap.get("billNo"));
                formMap.put("billStatus", billInfoRentalMap.get("stusCode"));
                formMap.put("billTypeId", billInfoRentalMap.get("billTypeId"));
                formMap.put("billTypeNm", billInfoRentalMap.get("billTypeNm"));
                formMap.put("custNm", billInfoRentalMap.get("custNm"));
                formMap.put("discountAmt", 0);
                formMap.put("installment", billInfoRentalMap.get("installment"));
                formMap.put("ordId", billInfoRentalMap.get("ordId"));
                formMap.put("ordNo", billInfoRentalMap.get("ordNo"));
                formMap.put("paidAmt", billInfoRentalMap.get("paidAmt"));
                formMap.put("appType", "RENTAL");
                formMap.put("targetAmt", targetAmt);
                formMap.put("srvcContractID", 0);
                formMap.put("billAsId", 0);
                formMap.put("srvMemId", 0);

                // item. = $("#rentalkeyInTrNo").val() ;
                formMap.put("trNo", trRefNo); //
                // item. = $("#rentalkeyInTrIssueDate").val() ;
                formMap.put("trDt", trIssDt); //
                // item.collectorCode = $("#rentalkeyInCollMemNm").val()
                formMap.put("collectorCode", paymentColleConfirmMap.get("memCode"));
                // item.collectorId = $("#rentalkeyInCollMemId").val() ;
                formMap.put("collectorId", paymentColleConfirmMap.get("memId"));
                // item.allowComm = $("#rentalcashIsCommChk").val()
                // formMap.put("allowComm", "");
                formMap.put("allowComm", allowance);

                formList.add(formMap);
                totRemainAmt = totRemainAmt.subtract(targetAmt);
              } else {
                break;
              }
            }
          }
        }

        if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
          LOGGER.debug("= STILL HAVE REMAINING : " + totRemainAmt.toPlainString());
          vAdvAmt = vAdvAmt.add(totRemainAmt);
          LOGGER.debug("= ADD IN TO ADVANCE AMOUNT : " + vAdvAmt.toPlainString());
        }

        // ADVANCE PAYMENT
        if (vAdvAmt.compareTo(BigDecimal.ZERO) > 0) {
          LOGGER.debug("======== ADVANCE PROCESSING - START ========");
          LOGGER.debug("= PROCESSING SEQ : " + iProcSeq);
          LOGGER.debug("= ORDER NO : " + salesOrdNo);
          LOGGER.debug("= TARGET AMOUNT : " + vAdvAmt.toPlainString());

          formMap = new HashMap<String, Object>();

          formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
          formMap.put("appType", "RENTAL");
          formMap.put("advMonth", (Integer) gridListMap.get("advMonth"));
          formMap.put("mstRpf", mstRpf);
          formMap.put("mstRpfPaid", mstRpfPaid);

          formMap.put("assignAmt", 0);
          formMap.put("billAmt", gridListMap.get("advAmt"));
          formMap.put("billDt", "1900-01-01");
          formMap.put("billGrpId", mstCustBillId);
          formMap.put("billId", 0);
          formMap.put("billNo", "0");
          formMap.put("billStatus", "");
          formMap.put("billTypeId", 1032);
          formMap.put("billTypeNm", "General Advanced For Rental");
          formMap.put("custNm", mstCustNm);
          formMap.put("discountAmt", 0);
          formMap.put("installment", 0);
          formMap.put("ordId", salesOrdId);
          formMap.put("ordNo", salesOrdNo);
          formMap.put("paidAmt", 0);
          formMap.put("appType", "RENTAL");
          formMap.put("targetAmt", vAdvAmt);
          formMap.put("srvcContractID", 0);
          formMap.put("billAsId", 0);
          formMap.put("srvMemId", 0);

          // item. = $("#rentalkeyInTrNo").val() ;
          formMap.put("trNo", trRefNo); //
          // item. = $("#rentalkeyInTrIssueDate").val() ;
          formMap.put("trDt", trIssDt); //
          // item.collectorCode = $("#rentalkeyInCollMemNm").val()
          formMap.put("collectorCode", paymentColleConfirmMap.get("memCode"));
          // item.collectorId = $("#rentalkeyInCollMemId").val() ;
          formMap.put("collectorId", paymentColleConfirmMap.get("memId"));
          // item.allowComm = $("#rentalcashIsCommChk").val()
          // formMap.put("allowComm", "");
          formMap.put("allowComm", allowance);

          formList.add(formMap);

          LOGGER.debug("======== ADVANCE PROCESSING - END ========");
        }
      }

      totPayAmt = totPayAmt.add(new BigDecimal(String.valueOf(gridListMap.get("payAmt"))));
      LOGGER.debug("=TOTAL PAYMENT AMOUNT FOR SELECTED REQUEST : " + totPayAmt.toPlainString());

      // USER ID 세팅
      formInfo.put("userid", sUserId);

      // CREDIT CARD일때
      if ("107".equals(String.valueOf(formInfo.get("keyInPayType")))) {
        formInfo.put("keyInIsOnline", "1299".equals(String.valueOf(formInfo.get("keyInCardMode"))) ? 0 : 1);
        formInfo.put("keyInIsLock", 0);
        formInfo.put("keyInIsThirdParty", 0);
        formInfo.put("keyInStatusId", 1);
        formInfo.put("keyInIsFundTransfer", 0);
        formInfo.put("keyInSkipRecon", 0);
        formInfo.put("keyInPayItmCardType", formInfo.get("keyCrcCardType"));
        formInfo.put("keyInPayItmCardMode", formInfo.get("keyInCardMode"));
        formInfo.put("keyInPayType", "107");
        formInfo.put("keyInPayDate", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1)); // 임시
      }

      gridListMap.put("userId", sUserId);
      formInfo.put("userId", sUserId);

      iProcSeq = iProcSeq + 1; // 2020.02.24 : ADD iProcSeq
    }

    // UPDATE STATUS  HERE
    for (int i = 0; i < gridList.size(); i++) {
      gridListMap = (Map<String, Object>) gridList.get(i);
      // UPDATE PAY0297D
      mobilePaymentKeyInMapper.updateMobilePaymentKeyInUpdate(gridListMap);

      // UPDATE MOB0001D
      Map<String, Object> ticketParam = new HashMap<String, Object>();
      ticketParam.put("ticketStusId", 5);
      ticketParam.put("updUserId", sUserId);
      ticketParam.put("mobTicketNo", gridListMap.get("mobTicketNo"));
      mobileAppTicketApiCommonMapper.update(ticketParam);
    }

    List<EgovMap> resultList = null;
    // INSERT TO PAY0240T AND PAY0241T AND LATER EXECUTE SP_INST_NORMAL_PAYMENT
    resultList = commonPaymentService.savePayment(formInfo, formList);

    // WOR 번호 조회
    return resultList;
    // return rcList;
  }

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 11. 20.
   * @param paramMap
   * @param paramList
   * @param key
   * @return
   * @see com.coway.trust.biz.payment.mobilePaymentKeyIn.service.MobilePaymentKeyInService#saveMobilePaymentKeyInNormalPayment(java.util.Map,
   *      java.util.Map, int)
   */
  @Override
  public Map<String, Object> saveMobilePaymentKeyInNormalPayment(Map<String, Object> params, String sUserId) {
    List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // GRID DATA IMPORT
    List<Object> gridFormList = (List<Object>) params.get(AppConstants.AUIGRID_FORM); // FORM OBJECT DATA IMPORT

    LOGGER.debug("==================================================================");
    LOGGER.debug("= GRID LIST ALL : " + gridList.toString());
    LOGGER.debug("= GRID LIST FORM : " + gridFormList.toString());
    LOGGER.debug("==================================================================");

    // START
    List<Object> formList = new ArrayList<Object>();
    Map<String, Object> formInfo = null;
    Map<String, Object> gridListMap = null;
    // Double totPayAmt = 0.00; // 2020.02.24 : EDIT
    BigDecimal totPayAmt = BigDecimal.ZERO;
    String allowance = "0";
    String trRefNo = "";
    String trIssDt = "";

    formInfo = new HashMap<String, Object>();
    if (gridFormList.size() > 0) {
      for (Object obj : gridFormList) {
        Map<String, Object> map = (Map<String, Object>) obj;
        formInfo.put((String) map.get("name"), map.get("value"));
      }
    }

    LOGGER.debug("= FORM LIST PART 1 : " + formInfo.toString());

    // ALLOWANCE
    if (!"".equals(CommonUtils.nvl(formInfo.get("allowance")))) {
      allowance = "1";
    } else {
      allowance = "0";
    }

    // TR REF NO.
    if (!"".equals(CommonUtils.nvl(formInfo.get("trRefNo")))) {
      trRefNo = formInfo.get("trRefNo").toString();
    } else {
      trRefNo = "";
    }

    // TR ISSED DATE.
    if (!"".equals(CommonUtils.nvl(formInfo.get("trIssDt")))) {
      trIssDt = formInfo.get("trIssDt").toString();
    } else {
      trIssDt = "";
    }

    LOGGER.debug("= FORM LIST PART 2 : " + formInfo.toString());

    // VERIFY TRX ID AMOUNT VS SELECTED AMOUNT
    String key = (String) params.get("key"); // BANK STATEMENT ID
    //Matcher m = patternInteger.matcher(key);
    if (!patternInteger.matcher(key).matches()) {
      throw new ApplicationException(AppConstants.FAIL, "Entered transaction ID must be in number format.");
    }
    Map<String, Object> schParams = new HashMap<String, Object>();
    schParams.put("fTrnscId", key);

    LOGGER.debug("= START GET TRANSACTION ID DETAILS : " + key.toString());

    EgovMap selectBankStatementInfo = mobilePaymentKeyInMapper.selectBankStatementInfo(schParams);

    if (selectBankStatementInfo == null) {
      throw new ApplicationException(AppConstants.FAIL, "Entered Transaction ID not found OR is mapped. Please check Transaction ID entered.");
    }

    BigDecimal DoubleCrdit = BigDecimal.ZERO;

    if ("".equals(String.valueOf(selectBankStatementInfo.get("crdit")))) {
      DoubleCrdit = BigDecimal.ZERO;
    } else {
      DoubleCrdit = new BigDecimal(String.valueOf(selectBankStatementInfo.get("crdit")));
    }

    LOGGER.debug("= SUM UP ALL SELECTED REQUEST AMOUNT : START ");
    BigDecimal tPayAmt = BigDecimal.ZERO;
    for (int i = 0; i < gridList.size(); i++) {
      LOGGER.debug("= I : " + i);
      gridListMap = (Map<String, Object>) gridList.get(i);
      BigDecimal payAmtDou = BigDecimal.ZERO;

      if ("".equals(String.valueOf(gridListMap.get("payAmt")))) {
        payAmtDou = BigDecimal.ZERO;
      } else {
        payAmtDou = new BigDecimal(String.valueOf(gridListMap.get("payAmt")));
      }

      LOGGER.debug("= BEFORE ADD : " + tPayAmt.toPlainString());
      tPayAmt = tPayAmt.add(payAmtDou);
      LOGGER.debug("= AFTER ADD : " + tPayAmt.toPlainString());
    }
    LOGGER.debug("= SUM UP ALL SELECTED REQUEST AMOUNT : END " + tPayAmt.toPlainString());

    if (DoubleCrdit.compareTo(tPayAmt) != 0) {
      throw new ApplicationException(AppConstants.FAIL, "Total selected payment amount of " +  tPayAmt.toPlainString() + " does not match with transaction ID's amount of " + DoubleCrdit.toPlainString() + ".");
    }

    // TRANSACTION TYPE
    String paymentMode = (String) selectBankStatementInfo.get("type");
    String payType = "";

    // ONGHC - ADD FOR ONL TRANSACTION
    if ("ONL".equals(paymentMode)) {
      payType = "108";
    } else if ("CHQ".equals(paymentMode)) {
      payType = "106";
    } else {
      payType = "105";
    }

    // 2020.02.24 : ADD ProcSeq
    int iProcSeq = 1;

    for (int i = 0; i < gridList.size(); i++) {
      gridListMap = (Map<String, Object>) gridList.get(i);

      String payMode = "";

      if ("5697".equals(String.valueOf(gridListMap.get("payMode")))) {
        payMode = "CHQ";
      } else {
        if ("ONL".equals(paymentMode)) { // ONGHC - ADD FOR SOLVE ONL PAYMENT METHOD
          payMode = "ONL";
        } else {
          payMode = "CSH";
        }
      }

      LOGGER.debug("= PAY TYPE MATCHING: " + paymentMode + " = " + payMode);

      // PAYMENT MODE CHECKING
      if (!paymentMode.equals(payMode)) {
        throw new ApplicationException(AppConstants.FAIL, "Selected payment type does not match with entered transaction ID's payment type");
      }

      // 그리드 값 조회 후 다시 셋팅
      // Payment - Order Info 조회 : order No로 Order ID 조회하기
      params.put("ordNo", gridListMap.get("salesOrdNo"));
      // SELECT SAL0001D TO GET ORDER ID, NO AND CUSTOMER ID
      EgovMap resultMap = commonPaymentService.selectOrdIdByNo(params);

      //BigDecimal salesOrdId = (BigDecimal) resultMap.get("salesOrdId");
      String salesOrdId = new BigDecimal(resultMap.get("salesOrdId").toString()).toPlainString();
      String salesOrdNo = new BigDecimal(resultMap.get("salesOrdNo").toString()).toPlainString();

      LOGGER.debug("= SALES ORDER ID : " + salesOrdId);
      LOGGER.debug("= SALES ORDER NO : " + salesOrdNo);

      params.put("orderId", salesOrdId);
      params.put("salesOrdId", salesOrdId);

      // 주문 렌탈 정보 조회.
      List<EgovMap> orderInfoRentalList = commonPaymentService.selectOrderInfoRental(params); // targetRenMstGridID

      LOGGER.debug("= ORDER INFO RENTAL : " + orderInfoRentalList.toString());

      if (orderInfoRentalList.get(0) == null) {
        throw new ApplicationException(AppConstants.FAIL, "No record found for order [" + salesOrdNo + "] rental information.");
      }

      // Payment - Bill Info Rental 조회
      BigDecimal rpf = new BigDecimal(orderInfoRentalList.get(0).get("rpf").toString()); // TOTAL RPF
      BigDecimal rpfPaid = new BigDecimal(orderInfoRentalList.get(0).get("rpfPaid").toString()); // TOTAL PAID RPF

      LOGGER.debug("= RPF : " + rpf.toPlainString());
      LOGGER.debug("= RPF PAID : " + rpfPaid.toPlainString());

      String excludeRPF = "";

      if (rpf.compareTo(BigDecimal.ZERO) >= 1) { // HAVE RPF
        if (rpfPaid.compareTo(rpf) >= 0) { // PAID RPF >= RPF
          excludeRPF = "N"; // NO NEED RPF
        } else {
          excludeRPF = "Y"; // RPF REQUIRED
        }
        excludeRPF = "Y"; // RPF REQUIRED
      }

      if (rpf.compareTo(BigDecimal.ZERO) == 0) { // IF RPF IS 0 THAN NO NEED RPF
        excludeRPF = "N";
      }

      LOGGER.debug("= RPF EXCLUDED? : " + excludeRPF);

      params.put("excludeRPF", excludeRPF);

      List<EgovMap> billInfoRentalList = commonPaymentService.selectBillInfoRental(params); // targetRenDetGridID

      LOGGER.debug("= BILL INFO RENTAL : " + billInfoRentalList.toString());

      // checkOrderOutstanding 정보 조회
      //EgovMap targetOutMstResult = commonPaymentService.checkOrderOutstanding(params); // targetOutMstGridID

      // if( "ROOT_1".equals(targetOutMstResult.get("rootState")) ){
      // System.out.println("++ No Outstanding" +
      // targetOutMstResult.get("msg"));
      // throw new ApplicationException(AppConstants.FAIL, "[ERROR]" +
      // targetOutMstResult.get("msg") );
      // }

      // Colle 정보 조회
      params.put("COLL_MEM_CODE", gridListMap.get("crtUserNm"));
      List<EgovMap> paymentColleConfirm = membershipPaymentService.paymentColleConfirm(params);

      if (paymentColleConfirm.get(0) == null) {
        throw new ApplicationException(AppConstants.FAIL, "No record found for payment collection's member.");
      }

      EgovMap paymentColleConfirmMap = paymentColleConfirm.get(0);

      LOGGER.debug("= PAYMENT COLLECTION : " + paymentColleConfirmMap.toString());

      BigDecimal mstRpf = new BigDecimal(orderInfoRentalList.get(0).get("rpf").toString());
      BigDecimal mstRpfPaid = new BigDecimal(orderInfoRentalList.get(0).get("rpfPaid").toString());

      String mstCustNm = (String) orderInfoRentalList.get(0).get("custNm");
      BigDecimal mstCustBillId = new BigDecimal(orderInfoRentalList.get(0).get("custBillId").toString());

      LOGGER.debug("= MASTER RPF : " + mstRpf);
      LOGGER.debug("= MASTER RPF PAID : " + mstRpfPaid);
      LOGGER.debug("= MASTER CUSTOMER NAME : " + paymentColleConfirmMap.toString());
      LOGGER.debug("= MASTER CUSTOMER BILL ID : " + paymentColleConfirmMap.toString());
      LOGGER.debug("====================================================");

      Map<String, Object> formMap = null;

      //Double totTargetAmt = 0.00;
      BigDecimal totTargetAmt = BigDecimal.ZERO;
      BigDecimal totRemainAmt = new BigDecimal( "".equals(CommonUtils.nvl(String.valueOf(gridListMap.get("payAmt")))) ? "0" : String.valueOf(gridListMap.get("payAmt")) );

      LOGGER.debug("======================== START ===========================");
      LOGGER.debug("= TOTAL TARGET AMOUNT  : " + totTargetAmt.toPlainString());
      LOGGER.debug("= TOTAL REMAINING AMOUNT  : " + totRemainAmt.toPlainString());
      LOGGER.debug("= ORDER INFO RENTAL LIST SIZE  : " + orderInfoRentalList.size());

      for (int j = 0; j < orderInfoRentalList.size(); j++) {
        // if( "1".equals(mstChkVal) ){
        // if ((mstRpf - mstRpfPaid > 0) && StringUtils.isEmpty(gridListMap.get("advMonth")) ) {

        BigDecimal vAdvAmt = new BigDecimal( "".equals(CommonUtils.nvl((gridListMap.get("advAmt")))) ? "0" : String.valueOf(gridListMap.get("advAmt")) ); // ADVANCE BUCKET
        BigDecimal vPayAmt = new BigDecimal( "".equals(CommonUtils.nvl((gridListMap.get("payAmt")))) ? "0" : String.valueOf(gridListMap.get("payAmt")) ); // PAYMENT AMOUNT BUCKET
        totRemainAmt = totRemainAmt.subtract(vAdvAmt); // TAKE OUT ADVANCE PAYMENT FROM REMAINING FIRST

        if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
          if (((mstRpf.subtract(mstRpfPaid)).compareTo(BigDecimal.ZERO) > 0)) { // IF HAVE REMAINING RPF
            LOGGER.debug("======== RPF PROCESSING - START ========");
            BigDecimal payAmt = new BigDecimal( "".equals(CommonUtils.nvl((gridListMap.get("payAmt")))) ? "0" : String.valueOf(gridListMap.get("payAmt")) );
            BigDecimal targetAmtRPF = BigDecimal.ZERO;

            LOGGER.debug("= PAYMENT AMOUNT : " + payAmt.toPlainString());
            LOGGER.debug("= PAYMENT TARGET RPF : " + targetAmtRPF.toPlainString());

            if ((mstRpf.subtract(mstRpfPaid)).compareTo(payAmt) > 0) {
              targetAmtRPF = payAmt; // IF REMAINING RPF MORE THAN PAYMENT AMOUNT DIRECT USE PAYMENT AMOUNT
            } else {
              targetAmtRPF = mstRpf.subtract(mstRpfPaid); // ELSE JUST POST
            }

            formMap = new HashMap<String, Object>();

            formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
            formMap.put("appType", "RENTAL");
            formMap.put("advMonth", (Integer) gridListMap.get("advMonth")); // 셋팅필요
            formMap.put("mstRpf", mstRpf);
            formMap.put("mstRpfPaid", mstRpfPaid);
            formMap.put("assignAmt", 0);
            formMap.put("billAmt", mstRpf);
            formMap.put("billDt", "1900-01-01");
            formMap.put("billGrpId", mstCustBillId);
            formMap.put("billId", 0);
            formMap.put("billNo", "0");
            formMap.put("billStatus", "");
            formMap.put("billTypeId", 161);
            formMap.put("billTypeNm", "RPF");
            formMap.put("custNm", mstCustNm);
            formMap.put("discountAmt", 0);
            formMap.put("installment", 0);
            formMap.put("ordId", salesOrdId);
            formMap.put("ordNo", salesOrdNo);
            formMap.put("paidAmt", mstRpfPaid);
            //formMap.put("targetAmt", payAmtDou);
            formMap.put("targetAmt", targetAmtRPF);
            formMap.put("srvcContractID", 0);
            formMap.put("billAsId", 0);
            formMap.put("srvMemId", 0);
            // item. = $("#rentalkeyInTrNo").val() ;
            formMap.put("trNo", trRefNo); //
            // item. = $("#rentalkeyInTrIssueDate").val() ;
            formMap.put("trDt", trIssDt); //
            // item.collectorCode = $("#rentalkeyInCollMemNm").val()
            formMap.put("collectorCode", paymentColleConfirmMap.get("memCode"));
            // item.collectorId = $("#rentalkeyInCollMemId").val() ;
            formMap.put("collectorId", paymentColleConfirmMap.get("memId"));
            // item.allowComm = $("#rentalcashIsCommChk").val()
            // formMap.put("allowComm", "1");
            formMap.put("allowComm", allowance);

            formList.add(formMap);

            vPayAmt = vPayAmt.subtract(targetAmtRPF);
            totRemainAmt = totRemainAmt.subtract(targetAmtRPF);

            LOGGER.debug("======== RPF FORM LIST : " + formList.toString());
            LOGGER.debug("======== RPF PROCESSING - END ========");
          }
        }

        // NO RPF TO PROCESS
        LOGGER.debug("======== OTHER PROCESSING - START ========");
        LOGGER.debug("= ADVANCE AMOUNT : " + vAdvAmt.toPlainString());
        LOGGER.debug("= PAYMENT AMOUNT : " + vPayAmt.toPlainString());
        LOGGER.debug("= TOTAL REMAINING AMOUNT : " + totRemainAmt.toPlainString());

        if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
          int detailRowCnt = billInfoRentalList.size();
          for (j = 0; j < detailRowCnt; j++) {
            Map billInfoRentalMap = billInfoRentalList.get(j);

            LOGGER.debug("= TOTAL REMAINING  AMOUNT PER RECORD : " + totRemainAmt.toPlainString());

            String detSalesOrdNo = (String) billInfoRentalMap.get("ordNo");
            if (salesOrdNo.equals(detSalesOrdNo)) {
              BigDecimal targetAmt = new BigDecimal(billInfoRentalMap.get("targetAmt").toString()); // AMOUNT TO BE DEDUCT

              if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
                if (totRemainAmt.compareTo(targetAmt) < 0) {
                  targetAmt = totRemainAmt;
                }

                LOGGER.debug("= PROCESSING SEQ : " + iProcSeq);
                LOGGER.debug("= BILLING TYPE ID : " + billInfoRentalMap.get("billTypeId"));
                LOGGER.debug("= BILLING TYPE : " + billInfoRentalMap.get("billTypeNm"));
                LOGGER.debug("= ORDER NO : " + billInfoRentalMap.get("ordNo"));
                LOGGER.debug("= ORDER PAY AMOUNT : " + billInfoRentalMap.get("paidAmt"));
                LOGGER.debug("= TARGET AMOUNT : " + targetAmt.toPlainString());

                formMap = new HashMap<String, Object>();
                formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
                formMap.put("appType", "RENTAL");
                formMap.put("advMonth", (Integer) gridListMap.get("advMonth")); // 셋팅필요
                formMap.put("mstRpf", mstRpf);
                formMap.put("mstRpfPaid", mstRpfPaid);

                formMap.put("assignAmt", 0);
                formMap.put("billAmt", billInfoRentalMap.get("billAmt"));
                formMap.put("billDt", billInfoRentalMap.get("billDt"));
                formMap.put("billGrpId", billInfoRentalMap.get("billGrpId"));
                formMap.put("billId", billInfoRentalMap.get("billId"));
                formMap.put("billNo", billInfoRentalMap.get("billNo"));
                formMap.put("billStatus", billInfoRentalMap.get("stusCode"));
                formMap.put("billTypeId", billInfoRentalMap.get("billTypeId"));
                formMap.put("billTypeNm", billInfoRentalMap.get("billTypeNm"));
                formMap.put("custNm", billInfoRentalMap.get("custNm"));
                formMap.put("discountAmt", 0);
                formMap.put("installment", billInfoRentalMap.get("installment"));
                formMap.put("ordId", billInfoRentalMap.get("ordId"));
                formMap.put("ordNo", billInfoRentalMap.get("ordNo"));
                formMap.put("paidAmt", billInfoRentalMap.get("paidAmt"));
                formMap.put("appType", "RENTAL");
                formMap.put("targetAmt", targetAmt);
                formMap.put("srvcContractID", 0);
                formMap.put("billAsId", 0);
                formMap.put("srvMemId", 0);

                // item. = $("#rentalkeyInTrNo").val() ;
                formMap.put("trNo", trRefNo); //
                // item. = $("#rentalkeyInTrIssueDate").val() ;
                formMap.put("trDt", trIssDt); //
                // item.collectorCode = $("#rentalkeyInCollMemNm").val()
                formMap.put("collectorCode", paymentColleConfirmMap.get("memCode"));
                // item.collectorId = $("#rentalkeyInCollMemId").val() ;
                formMap.put("collectorId", paymentColleConfirmMap.get("memId"));
                // item.allowComm = $("#rentalcashIsCommChk").val()
                // formMap.put("allowComm", "");
                formMap.put("allowComm", allowance);

                formList.add(formMap);

                totRemainAmt = totRemainAmt.subtract(targetAmt);
              } else {
                break;
              }
            }
          }
        }

        if (totRemainAmt.compareTo(BigDecimal.ZERO) > 0) {
          LOGGER.debug("= STILL HAVE REMAINING : " + totRemainAmt.toPlainString());
          vAdvAmt = vAdvAmt.add(totRemainAmt);
          LOGGER.debug("= ADD IN TO ADVANCE AMOUNT : " + vAdvAmt.toPlainString());
        }

         // ADVANCE PAYMENT
         if (vAdvAmt.compareTo(BigDecimal.ZERO) > 0) {

           LOGGER.debug("======== ADVANCE PROCESSING - START ========");
           LOGGER.debug("= PROCESSING SEQ : " + iProcSeq);
           LOGGER.debug("= ORDER NO : " + salesOrdNo);
           LOGGER.debug("= TARGET AMOUNT : " + vAdvAmt.toPlainString());

           formMap = new HashMap<String, Object>();

           formMap.put("procSeq", iProcSeq); // 2020.02.24 : ADD procSeq
           formMap.put("appType", "RENTAL");
           formMap.put("advMonth", (Integer) gridListMap.get("advMonth"));
           formMap.put("mstRpf", mstRpf);
           formMap.put("mstRpfPaid", mstRpfPaid);
           formMap.put("assignAmt", 0);
           formMap.put("billAmt", gridListMap.get("advAmt"));
           formMap.put("billDt", "1900-01-01");
           formMap.put("billGrpId", mstCustBillId);
           formMap.put("billId", 0);
           formMap.put("billNo", "0");
           formMap.put("billStatus", "");
           formMap.put("billTypeId", 1032);
           formMap.put("billTypeNm", "General Advanced For Rental");
           formMap.put("custNm", mstCustNm);
           formMap.put("discountAmt", 0);
           formMap.put("installment", 0);
           formMap.put("ordId", salesOrdId);
           formMap.put("ordNo", salesOrdNo);
           formMap.put("paidAmt", 0);
           formMap.put("appType", "RENTAL");
           formMap.put("targetAmt", vAdvAmt);
           formMap.put("srvcContractID", 0);
           formMap.put("billAsId", 0);
           formMap.put("srvMemId", 0);

           // item. = $("#rentalkeyInTrNo").val() ;
           formMap.put("trNo", trRefNo); //
           // item. = $("#rentalkeyInTrIssueDate").val() ;
           formMap.put("trDt", trIssDt); //
           // item.collectorCode = $("#rentalkeyInCollMemNm").val()
           formMap.put("collectorCode", paymentColleConfirmMap.get("memCode"));
           // item.collectorId = $("#rentalkeyInCollMemId").val() ;
           formMap.put("collectorId", paymentColleConfirmMap.get("memId"));
           // item.allowComm = $("#rentalcashIsCommChk").val()
           // formMap.put("allowComm", "");
           formMap.put("allowComm", allowance);

           formList.add(formMap);

           LOGGER.debug("======== ADVANCE PROCESSING - END ========");
         }
      }

      totPayAmt = totPayAmt.add(new BigDecimal(String.valueOf(gridListMap.get("payAmt"))));
      LOGGER.debug("=TOTAL PAYMENT AMOUNT FOR SELECTED REQUEST : " + totPayAmt.toPlainString());

      iProcSeq = iProcSeq + 1; // 2020.02.24 : ADD iProcSeq

    }

    if (formInfo.get("chargeAmount") == null || formInfo.get("chargeAmount").equals("")) {
      formInfo.put("chargeAmount", 0);
    }

    if (formInfo.get("bankAcc") == null || formInfo.get("bankAcc").equals("")) {
      formInfo.put("bankAcc", 0);
    }

    formInfo.put("payItemIsLock", false);
    formInfo.put("payItemIsThirdParty", false);
    formInfo.put("payItemStatusId", 1);
    formInfo.put("isFundTransfer", false);
    formInfo.put("skipRecon", false);
    formInfo.put("payItemCardTypeId", 0);

    formInfo.put("keyInPayRoute", "WEB");
    formInfo.put("keyInScrn", "NOR");
    formInfo.put("amount", totPayAmt);
    formInfo.put("slipNo", gridListMap.get("slipNo"));
    formInfo.put("chqNo", gridListMap.get("chequeNo")); // ADD TO SET CHEQUE NO.
    formInfo.put("bankType", "2729");
    formInfo.put("keyInPayDate", gridListMap.get("crtDt"));

    formInfo.put("bankAcc", selectBankStatementInfo.get("bankAccId"));
    formInfo.put("trDate", selectBankStatementInfo.get("trnscDt"));

    // ONGHC - ADD FOR ONL PAYMENT TYPE
    formInfo.put("payType", payType);
    formInfo.put("userid", sUserId);

    // UPDATE STATUS  HERE
    for (int i = 0; i < gridList.size(); i++) {
      gridListMap = (Map<String, Object>) gridList.get(i);

      gridListMap.put("userId", sUserId); // 2020.02.28 : UPDATE USER ID ADD
      // UPDATE PAY0297D
      mobilePaymentKeyInMapper.updateMobilePaymentKeyInUpdate(gridListMap);

      // UPDATE MOB0001D
      Map<String, Object> ticketParam = new HashMap<String, Object>();
      ticketParam.put("ticketStusId", 5);
      ticketParam.put("updUserId", sUserId);
      ticketParam.put("mobTicketNo", gridListMap.get("mobTicketNo"));
      mobileAppTicketApiCommonMapper.update(ticketParam);
    }

    // INSERT TO PAY0240T AND PAY0241T AND LATER EXECUTE SP_INST_NORMAL_PAYMENT
    Map<String, Object> resultList = commonPaymentService.saveNormalPayment(formInfo, formList, Integer.parseInt(key));

    // RETURN WOR NO.
    return resultList;
  }

  @Override
  public EgovMap selectMemDetails(SessionVO sessionVO) {
    return mobilePaymentKeyInMapper.selectMemDetails(sessionVO.getUserName());
  }
}
