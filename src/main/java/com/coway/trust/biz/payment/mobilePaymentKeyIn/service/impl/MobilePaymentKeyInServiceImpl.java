package com.coway.trust.biz.payment.mobilePaymentKeyIn.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.MobileAppTicketApiCommonMapper;
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.biz.payment.common.service.impl.CommonPaymentMapper;
import com.coway.trust.biz.payment.mobilePaymentKeyIn.service.MobilePaymentKeyInService;
import com.coway.trust.biz.sales.mambership.MembershipPaymentService;
import com.coway.trust.cmmn.exception.ApplicationException;

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
 *          </pre>
 */
@Service("mobilePaymentKeyInService")
public class MobilePaymentKeyInServiceImpl extends EgovAbstractServiceImpl implements MobilePaymentKeyInService {

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

      if (StringUtils.isEmpty(param.get("etc"))) {
        throw new ApplicationException(AppConstants.FAIL, "Reject reason value does not exist.");
      }

      saveParam = new HashMap<String, Object>();

      saveParam.put("mobTicketNo", mobTicketNo);
      saveParam.put("etc", param.get("etc"));
      saveParam.put("mobPayNo", mobPayNo);
      saveParam.put("userId", param.get("userId"));

      saveCnt = mobilePaymentKeyInMapper.updateMobilePaymentKeyInReject(saveParam);

      // 티겟 상태 변경  - CHANGE TARGET STATUS
      Map<String, Object> ticketParam = new HashMap<String, Object>();
      ticketParam.put("ticketStusId", 6);
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
    List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // GRID DATA IMPORT
    List<Object> gridFormList = (List<Object>) params.get(AppConstants.AUIGRID_FORM); // FORM OBJECT DATA IMPORT
    // LIST 셋팅 시작 - START SETTING
    List<Object> formList = new ArrayList<Object>();
    Map<String, Object> formInfo = null;
    Map<String, Object> gridListMap = null;

    Double totPayAmt = 0.00;
    // 2020.02.24 : ADD ProcSeq
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

    for (int i = 0; i < gridList.size(); i++) {
      gridListMap = (Map<String, Object>) gridList.get(i);

      // 그리드 값 조회 후 다시 셋팅 - LOOKUP GRID VALUES AND SET THEM UP AGAIN
      // PAYMENT - ORDER INFO 조회 : ORDER NO로 ORDER ID 조회하기
      params.put("ordNo", gridListMap.get("salesOrdNo"));
      EgovMap resultMap = commonPaymentService.selectOrdIdByNo(params);

      BigDecimal salesOrdId = (BigDecimal) resultMap.get("salesOrdId");
      String salesOrdNo = (String) resultMap.get("salesOrdNo");

      params.put("orderId", salesOrdId);
      params.put("salesOrdId", salesOrdId);

      // 주문 렌탈 정보 조회. - ORDER RENTAL INFORMATION INQUIRY.
      List<EgovMap> orderInfoRentalList = commonPaymentService.selectOrderInfoRental(params); // targetRenMstGridID

      // PAYMENT - BILL INFO RENTAL 조회
      double rpf = (double) orderInfoRentalList.get(0).get("rpf");
      double rpfPaid = (double) orderInfoRentalList.get(0).get("rpfPaid");

      String excludeRPF = (rpf > 0 && rpfPaid >= rpf) ? "N" : "Y";
      if (rpf == 0)
        excludeRPF = "N";

      params.put("excludeRPF", excludeRPF);
      List<EgovMap> billInfoRentalList = commonPaymentService.selectBillInfoRental(params); // targetRenDetGridID

      // checkOrderOutstanding 정보 조회 - INFORMATION LOOKUP
      EgovMap targetOutMstResult = commonPaymentService.checkOrderOutstanding(params); // targetOutMstGridID

      // if( "ROOT_1".equals(targetOutMstResult.get("rootState")) ){
      // System.out.println("++ No Outstanding" +
      // targetOutMstResult.get("msg"));
      // }

      // Colle 정보 조회
      params.put("COLL_MEM_CODE", gridListMap.get("crtUserNm"));
      List<EgovMap> paymentColleConfirm = membershipPaymentService.paymentColleConfirm(params);
      EgovMap paymentColleConfirmMap = paymentColleConfirm.get(0);

      // String mstChkVal = (String) orderInfoRentalList.get(0).get("btnCheck");
      // String salesOrdNo = (String)
      // orderInfoRentalList.get(0).get("salesOrdNo");
      Double mstRpf = (Double) orderInfoRentalList.get(0).get("rpf");
      Double mstRpfPaid = (Double) orderInfoRentalList.get(0).get("rpfPaid");

      String mstCustNm = (String) orderInfoRentalList.get(0).get("custNm");
      BigDecimal mstCustBillId = (BigDecimal) orderInfoRentalList.get(0).get("custBillId");

      Map<String, Object> formMap = null;

      int maxSeq = 0;
      Double totTargetAmt = 0.00;

      for (int j = 0; j < orderInfoRentalList.size(); j++) {
          // if( "1".equals(mstChkVal) ){
          if ((mstRpf - mstRpfPaid > 0) && StringUtils.isEmpty(gridListMap.get("advMonth")) ) {

              String payAmt = String.valueOf(gridListMap.get("payAmt"));
              Double payAmtDou = Double.valueOf(payAmt);
              Double targetAmt = 0.0;

              if( (mstRpf - mstRpfPaid) > payAmtDou )
              {
              	targetAmt = payAmtDou;
              }else{
              	targetAmt = mstRpf - mstRpfPaid;
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
            formMap.put("targetAmt", payAmtDou);
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
          }else{
          	Double vAdvAmt = 0.00;
          	Double vPayAmt = 0.00;
          	if (!StringUtils.isEmpty(gridListMap.get("advMonth"))) {
          		vAdvAmt = Double.valueOf( String.valueOf(gridListMap.get("advAmt")));
          		vPayAmt = Double.valueOf( String.valueOf(gridListMap.get("payAmt")));
          	}else{

          	}

          	System.out.println("++++ ::" + ( vPayAmt -vAdvAmt ) );
//          	 && StringUtils.isEmpty(gridListMap.get("advMonth"))
          	if( ( vPayAmt -vAdvAmt  ) >= 0.00 )
          	{

                  int detailRowCnt = billInfoRentalList.size();

                  for (j = 0; j < detailRowCnt; j++) {
                    Map billInfoRentalMap = billInfoRentalList.get(j);
                    // String detChkVal = (String) billInfoRentalMap.get("btnCheck");
                    String detSalesOrdNo = (String) billInfoRentalMap.get("ordNo");

                    if (salesOrdNo.equals(detSalesOrdNo)) {

                      // ----------------------------------------------

                      Double targetAmt = (Double) billInfoRentalMap.get("targetAmt");
                      String payAmt = String.valueOf(gridListMap.get("payAmt"));
                      Double payAmtDou = Double.valueOf(payAmt);

                      if ((totTargetAmt + targetAmt) > payAmtDou) {

                        if (detailRowCnt - 1 == j) {
                      	  if( totTargetAmt < 0 ){
                      		  targetAmt = payAmtDou;
                      	  }else{
                          	  targetAmt = payAmtDou - totTargetAmt;
                      	  }

                        } else {
                      	  targetAmt = payAmtDou - totTargetAmt;
                        }

                      } else {
                  		targetAmt = targetAmt;
                      }

                      totTargetAmt = totTargetAmt + targetAmt;

                      if (totTargetAmt >= payAmtDou) {
                        if (!StringUtils.isEmpty(gridListMap.get("advMonth"))) {
                          break;
                        }
                      }

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

                      if (totTargetAmt >= payAmtDou) {
                        break;
                      }
                    }

                  }
          	}
              // Advance Month
              if (!StringUtils.isEmpty(gridListMap.get("advMonth"))) {
                formMap = new HashMap<String, Object>();

                if((vAdvAmt - totTargetAmt) < 0){

              	  vAdvAmt = vAdvAmt;

                }else{
              	  vAdvAmt = vAdvAmt - totTargetAmt;
                }

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

              }
           }
        }

      // formInfo = new HashMap<String, Object>();
      // if (gridFormList.size() > 0) {
      // for (Object obj : gridFormList) {
      // Map<String, Object> map = (Map<String, Object>) obj;
      // formInfo.put((String) map.get("name"), map.get("value"));
      // }
      // }

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

        formInfo.put("keyInPayDate", formInfo.get("keyInTrDate")); // 임시
      }

      gridListMap.put("userId", sUserId);
      formInfo.put("userId", sUserId);

      // 저장
      // System.out.println("++++ gridList ::" + gridList.toString() );
      // System.out.println("++++ formInfo ::" + formInfo.toString() );
      // System.out.println("++++ formList ::" + formList.toString() );

      iProcSeq = iProcSeq + 1; // 2020.02.24 : ADD iProcSeq
    }

    for (int i = 0; i < gridList.size(); i++) {
      gridListMap = (Map<String, Object>) gridList.get(i);

      // 상태 변경 - CHANGE STATUS
      mobilePaymentKeyInMapper.updateMobilePaymentKeyInUpdate(gridListMap);

      // 티겟 상태 변경 - CHANGE TARGET STATUS
      Map<String, Object> ticketParam = new HashMap<String, Object>();
      ticketParam.put("ticketStusId", 5);
      ticketParam.put("updUserId", sUserId);
      ticketParam.put("mobTicketNo", gridListMap.get("mobTicketNo"));
      mobileAppTicketApiCommonMapper.update(ticketParam);
    }

    List<EgovMap> resultList = null;
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

    // List 셋팅 시작 - START SETTING
    List<Object> formList = new ArrayList<Object>();
    Map<String, Object> formInfo = null;
    Map<String, Object> gridListMap = null;
    Double totPayAmt = 0.00; // 2020.02.24 : EDIT
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

    // ALLOWANCE
    if (formInfo.get("allowance") != null) {
      allowance = "1";
    } else {
      allowance = "0";
    }

    // TR REF NO.
    if (formInfo.get("trRefNo") != null) {
      trRefNo = formInfo.get("trRefNo").toString();
    } else {
      trRefNo = "";
    }

    // TR ISSED DATE.
    if (formInfo.get("trIssDt") != null) {
      trIssDt = formInfo.get("trIssDt").toString();
    } else {
      trIssDt = "";
    }

    // 금액 비교 - COMPARISON OF AMOUNTS
    // TRANSACTION
    String key = (String) params.get("key"); // BankStatement의 id값 가져오기
    Map<String, Object> schParams = new HashMap<String, Object>();
    schParams.put("fTrnscId", key);
    EgovMap selectBankStatementInfo = mobilePaymentKeyInMapper.selectBankStatementInfo(schParams);

    if (selectBankStatementInfo == null) {
      throw new ApplicationException(AppConstants.FAIL, "Transaction ID does not exist.");
    }

    String crdit = String.valueOf(selectBankStatementInfo.get("crdit"));
    //Double DoubleCrdit = Double.valueOf(crdit);
    BigDecimal DoubleCrdit = new BigDecimal(crdit);

    // 그리드 값 비교
    //Double tPayAmt = 0.00;
    //for (int i = 0; i < gridList.size(); i++) {
      //gridListMap = (Map<String, Object>) gridList.get(i);
      //String payAmt = String.valueOf(gridListMap.get("payAmt"));
      //System.out.println("++++ ::" + payAmt );
      //Double payAmtDou = Double.valueOf(payAmt);
      //System.out.println("++++ ::" + payAmtDou );

      //tPayAmt += payAmtDou;
    //}

    BigDecimal tPayAmt = BigDecimal.ZERO;
    for (int i = 0; i < gridList.size(); i++) {
      gridListMap = (Map<String, Object>) gridList.get(i);
      String payAmt = String.valueOf(gridListMap.get("payAmt"));
      BigDecimal payAmtDou = new BigDecimal(payAmt);
      tPayAmt = tPayAmt.add(payAmtDou);
    }

    //if (!DoubleCrdit.equals(tPayAmt)) {
      //throw new ApplicationException(AppConstants.FAIL, "Check the Payment Amt");
    //}
    if (DoubleCrdit.compareTo(tPayAmt) != 0) {
      throw new ApplicationException(AppConstants.FAIL, "Total selected payment amount does not match with transaction ID's amount provided.");
    }

    // Trnsc Id Payment ModegridListMap

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
        if ("ONL".equals(paymentMode)) { // ONGHC - ADD FOR SOLVE ONL PAYMENT
                                         // METHOD
          payMode = "ONL";
        } else {
          payMode = "CSH";
        }
      }

      // Payment Mode 비교
      if (!paymentMode.equals(payMode)) {
        throw new ApplicationException(AppConstants.FAIL, "Check the Payment Mode.");
      }

      // 그리드 값 조회 후 다시 셋팅
      // Payment - Order Info 조회 : order No로 Order ID 조회하기
      params.put("ordNo", gridListMap.get("salesOrdNo"));
      EgovMap resultMap = commonPaymentService.selectOrdIdByNo(params);

      BigDecimal salesOrdId = (BigDecimal) resultMap.get("salesOrdId");
      String salesOrdNo = (String) resultMap.get("salesOrdNo");

      params.put("orderId", salesOrdId);
      params.put("salesOrdId", salesOrdId);

      // 주문 렌탈 정보 조회.
      List<EgovMap> orderInfoRentalList = commonPaymentService.selectOrderInfoRental(params); // targetRenMstGridID

      // Payment - Bill Info Rental 조회
      double rpf = (double) orderInfoRentalList.get(0).get("rpf");
      double rpfPaid = (double) orderInfoRentalList.get(0).get("rpfPaid");

      String excludeRPF = (rpf > 0 && rpfPaid >= rpf) ? "N" : "Y";
      if (rpf == 0)
        excludeRPF = "N";

      params.put("excludeRPF", excludeRPF);
      List<EgovMap> billInfoRentalList = commonPaymentService.selectBillInfoRental(params); // targetRenDetGridID

      // checkOrderOutstanding 정보 조회
      EgovMap targetOutMstResult = commonPaymentService.checkOrderOutstanding(params); // targetOutMstGridID

      // if( "ROOT_1".equals(targetOutMstResult.get("rootState")) ){
      // System.out.println("++ No Outstanding" +
      // targetOutMstResult.get("msg"));
      // throw new ApplicationException(AppConstants.FAIL, "[ERROR]" +
      // targetOutMstResult.get("msg") );
      // }

      // Colle 정보 조회
      params.put("COLL_MEM_CODE", gridListMap.get("crtUserNm"));
      List<EgovMap> paymentColleConfirm = membershipPaymentService.paymentColleConfirm(params);
      EgovMap paymentColleConfirmMap = paymentColleConfirm.get(0);

      Double mstRpf = (Double) orderInfoRentalList.get(0).get("rpf");
      Double mstRpfPaid = (Double) orderInfoRentalList.get(0).get("rpfPaid");

      String mstCustNm = (String) orderInfoRentalList.get(0).get("custNm");
      BigDecimal mstCustBillId = (BigDecimal) orderInfoRentalList.get(0).get("custBillId");

      Map<String, Object> formMap = null;

      Double totTargetAmt = 0.00;

      // 금액 다시 계산
      for (int j = 0; j < orderInfoRentalList.size(); j++) {
        // if( "1".equals(mstChkVal) ){
        if ((mstRpf - mstRpfPaid > 0) && StringUtils.isEmpty(gridListMap.get("advMonth")) ) {

            String payAmt = String.valueOf(gridListMap.get("payAmt"));
            Double payAmtDou = Double.valueOf(payAmt);
            Double targetAmt = 0.0;

            if( (mstRpf - mstRpfPaid) > payAmtDou )
            {
            	targetAmt = payAmtDou;
            }else{
            	targetAmt = mstRpf - mstRpfPaid;
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
          formMap.put("targetAmt", payAmtDou);
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
        }else{
        	Double vAdvAmt = 0.00;
        	Double vPayAmt = 0.00;
        	if (!StringUtils.isEmpty(gridListMap.get("advMonth"))) {
        		if( !StringUtils.isEmpty( gridListMap.get("advAmt" ) ) ){
        		vAdvAmt = Double.valueOf( String.valueOf(gridListMap.get("advAmt" )));
        		}
        		if( !StringUtils.isEmpty( gridListMap.get("advAmt" ) ) ){
        		vPayAmt = Double.valueOf( String.valueOf(gridListMap.get("payAmt")));
        		}
        	}else{

        	}

        	System.out.println("++++ ::" + ( vPayAmt -vAdvAmt ) );
//        	 && StringUtils.isEmpty(gridListMap.get("advMonth"))
        	if( ( vPayAmt -vAdvAmt  ) >= 0.00 )
        	{

                int detailRowCnt = billInfoRentalList.size();

                for (j = 0; j < detailRowCnt; j++) {
                  Map billInfoRentalMap = billInfoRentalList.get(j);
                  // String detChkVal = (String) billInfoRentalMap.get("btnCheck");
                  String detSalesOrdNo = (String) billInfoRentalMap.get("ordNo");

                  if (salesOrdNo.equals(detSalesOrdNo)) {

                    // ----------------------------------------------

                    Double targetAmt = (Double) billInfoRentalMap.get("targetAmt");
                    String payAmt = String.valueOf(gridListMap.get("payAmt"));
                    Double payAmtDou = Double.valueOf(payAmt);

                    if ((totTargetAmt + targetAmt) > payAmtDou) {

                      if (detailRowCnt - 1 == j) {
                    	  if( totTargetAmt < 0 ){
                    		  targetAmt = payAmtDou;
                    	  }else{
                        	  targetAmt = payAmtDou - totTargetAmt;
                    	  }

                      } else {
                    	  targetAmt = payAmtDou - totTargetAmt;
                      }

                    } else {
                		targetAmt = targetAmt;
                    }

                    totTargetAmt = totTargetAmt + targetAmt;

                    if (totTargetAmt >= payAmtDou) {
                      if (!StringUtils.isEmpty(gridListMap.get("advMonth"))) {
                        break;
                      }
                    }

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

                    if (totTargetAmt >= payAmtDou) {
                      break;
                    }
                  }

                }
        	}
            // Advance Month
            if (!StringUtils.isEmpty(gridListMap.get("advMonth"))) {
              formMap = new HashMap<String, Object>();

              if((vAdvAmt - totTargetAmt) < 0){

            	  vAdvAmt = vAdvAmt;

              }else{
            	  vAdvAmt = vAdvAmt - totTargetAmt;
              }

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

            }
         }
      }

      // List 셋팅 종료
      // BankStatement 조회
      // String tmpKey = (String) params.get("key"); //BankStatement의 id값 가져오기
      // String key = (String) params.get("key"); //BankStatement의 id값 가져오기
      // System.out.println("++++ tmpKey ::" + tmpKey );
      // int key = Integer.parseInt(String.valueOf(tmpKey));

      // 합산 금액 셋팅
      totPayAmt += Double.parseDouble(String.valueOf(gridListMap.get("payAmt"))); // 2020.02.27
                                                                                  // :
                                                                                  // Double.parseDouble
                                                                                  // EDIT

      iProcSeq = iProcSeq + 1; // 2020.02.24 : ADD iProcSeq

    }
    // Map<String, Object> schParams = new HashMap<String, Object>();
    // schParams.put("fTrnscId", key);
    // EgovMap selectBankStatementInfo =
    // mobilePaymentKeyInMapper.selectBankStatementInfo(schParams);

    // formInfo = new HashMap<String, Object>();
    // if (gridFormList.size() > 0) {
    // for (Object obj : gridFormList) {
    // Map<String, Object> map = (Map<String, Object>) obj;
    // formInfo.put((String) map.get("name"), map.get("value"));
    // }
    // }

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
    formInfo.put("bankType", "2729");
    formInfo.put("keyInPayDate", gridListMap.get("crtDt"));

    formInfo.put("bankAcc", selectBankStatementInfo.get("bankAccId"));
    formInfo.put("trDate", selectBankStatementInfo.get("trnscDt"));

    // ONGHC - ADD FOR ONL PAYMENT TYPE
    formInfo.put("payType", payType);

    // User ID 세팅
    formInfo.put("userid", sUserId);

//     System.out.println("++++ 3 formInfo.toString() ::" +     formInfo.toString());
//     System.out.println("++++ 3-1 formList.toString() ::" +     formList.toString() );
//     System.out.println("++++ 5 key ::" + key );

    // =============================================================

    for (int i = 0; i < gridList.size(); i++) {
      gridListMap = (Map<String, Object>) gridList.get(i);

      // Mobile Paymet Key-in Update
      gridListMap.put("userId", sUserId); // 2020.02.28 : UPDATE USER ID ADD
      mobilePaymentKeyInMapper.updateMobilePaymentKeyInUpdate(gridListMap);

      // 티겟 상태 변경
      Map<String, Object> ticketParam = new HashMap<String, Object>();
      ticketParam.put("ticketStusId", 5);
      ticketParam.put("updUserId", sUserId);
      ticketParam.put("mobTicketNo", gridListMap.get("mobTicketNo"));
      mobileAppTicketApiCommonMapper.update(ticketParam);
    }
//     Map<String, Object> resultList = null; // 테스트
    Map<String, Object> resultList = commonPaymentService.saveNormalPayment(formInfo, formList, Integer.parseInt(key));

    // WOR 번호 조회
    return resultList;
  }
}
