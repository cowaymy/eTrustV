package com.coway.trust.web.payment.mobilePaymentKeyIn.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.biz.payment.mobilePaymentKeyIn.service.MobilePaymentKeyInService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobilePaymentKeyInController.java
 * @Description : MobilePaymentKeyInController
 *
 * @History
 *
 *          <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 21.   KR-HAN        First creation
 * 2020. 06. 19.   FARUQ         Amend Branch Code to Multiple Selection
 * 2020. 07. 06.   ONGHC        Add Extra Search Criteria for Organization, Group and Department Code
 *          </pre>
 */
@Controller
@RequestMapping(value = "/mobilePaymentKeyIn")
public class MobilePaymentKeyInController {

  private static final Logger LOGGER = LoggerFactory.getLogger(MobilePaymentKeyInController.class);

  @Resource(name = "memberListService")
  private MemberListService memberListService;

  @Resource(name = "mobilePaymentKeyInService")
  private MobilePaymentKeyInService mobilePaymentKeyInService;

  @Resource(name = "commonPaymentService")
  private CommonPaymentService commonPaymentService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 12. 3.
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/initMobilePaymentKeyIn.do")
  public String initMobilePaymentKeyIn(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
    List<EgovMap> userBranch = memberListService.selectUserBranch();

    EgovMap memDetail = mobilePaymentKeyInService.selectMemDetails(sessionVO);
    model.put("bfDay", bfDay);
    model.put("toDay", toDay);
    model.addAttribute("userBranch", userBranch);
    model.addAttribute("memDetail", memDetail);
    model.addAttribute("memLevel", sessionVO.getMemberLevel());
    model.addAttribute("memCode", sessionVO.getUserName());

        return "payment/mobilePaymentKeyIn/mobilePaymentKeyInList";
  }

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 12. 3.
   * @param params
   * @param request
   * @param model
   * @return
   */
  @RequestMapping(value = "/selectMobilePaymentKeyInJsonList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectMobilePaymentKeyInJsonList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> mobilePaymentKeyInJsonList = null;

    /*
     * String[] branchCode = request.getParameterValues("branchCode");
     * params.put("branchCode", branchCode);
     */

    LOGGER.debug(">>>>" + params.toString());

    String[] branchCode = request.getParameterValues("branchCode");
    String[] cmbRegion = request.getParameterValues("cmbRegion");
    String[] ticketStatus = request.getParameterValues("ticketStatus");

    params.put("branchCode", branchCode);
    params.put("cmbRegion", cmbRegion);
    params.put("ticketStatus", ticketStatus);

    LOGGER.debug(params.toString());

    LOGGER.info("##### selectMobilePaymentKeyInJsonList START #####");
    // List<EgovMap> mobilePaymentKeyInJsonList = null;
    mobilePaymentKeyInJsonList = mobilePaymentKeyInService.selectMobilePaymentKeyInList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(mobilePaymentKeyInJsonList);
  }

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 12. 3.
   * @param param
   * @param sessionVO
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/saveMobilePaymentKeyInReject.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveMobilePaymentKeyInReject(@RequestBody Map<String, Object> param,
      SessionVO sessionVO) throws Exception {
    param.put("userId", sessionVO.getUserId());
    mobilePaymentKeyInService.saveMobilePaymentKeyInReject(param);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    return ResponseEntity.ok(message);
  }

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 12. 3.
   * @param params
   * @param model
   * @param sessionVO
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/saveMobilePaymentKeyInPayment.do", method = RequestMethod.POST)
  public ResponseEntity<List<EgovMap>> saveMobilePaymentKeyInCard(@RequestBody Map<String, Object> params,
      ModelMap model, SessionVO sessionVO) throws Exception {

    System.out.println("++++ params.toString() ::" + params.toString());

    String sUserId = String.valueOf(sessionVO.getUserId());
    List<EgovMap> resultList = mobilePaymentKeyInService.saveMobilePaymentKeyInCard(params, sUserId);

    // Map<String, Object> gridList = (Map<String, Object>)
    // params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    // List<Object> gridFormList = (List<Object>)
    // params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

    // List<Object> formList = new ArrayList<Object>();
    //
    // // 그리드 값 조회 후 다시 셋팅
    // //Payment - Order Info 조회 : order No로 Order ID 조회하기
    // params.put("ordNo", gridList.get("salesOrdNo"));
    // EgovMap resultMap = commonPaymentService.selectOrdIdByNo(params);
    //
    // System.out.println( "++++ resultMap ::" + resultMap.toString() );
    //
    // BigDecimal salesOrdId = (BigDecimal) resultMap.get("salesOrdId");
    // String salesOrdNo = (String) resultMap.get("salesOrdNo");
    //
    // params.put("orderId", salesOrdId);
    // params.put("salesOrdId", salesOrdId);
    //
    // // 주문 렌탈 정보 조회.
    // List<EgovMap> orderInfoRentalList =
    // commonPaymentService.selectOrderInfoRental(params); // targetRenMstGridID
    //
    // System.out.println("++++ orderInfoRentalList ::" +
    // orderInfoRentalList.toString() );
    //
    // // Payment - Bill Info Rental 조회
    // double rpf = (double) orderInfoRentalList.get(0).get("rpf");
    // double rpfPaid = (double) orderInfoRentalList.get(0).get("rpfPaid");
    //
    // String excludeRPF = (rpf > 0 && rpfPaid >= rpf) ? "N" : "Y";
    // if (rpf == 0) excludeRPF = "N";
    //
    // System.out.println("++++ excludeRPF ::" + excludeRPF );
    //
    // params.put("excludeRPF", excludeRPF);
    // List<EgovMap> billInfoRentalList =
    // commonPaymentService.selectBillInfoRental(params); // targetRenDetGridID
    //
    // // checkOrderOutstanding 정보 조회
    // EgovMap targetOutMstResult =
    // commonPaymentService.checkOrderOutstanding(params); // targetOutMstGridID
    //
    // if( "ROOT_1".equals(targetOutMstResult.get("rootState")) ){
    // System.out.println("++ No Outstanding" + targetOutMstResult.get("msg"));
    // }
    //
    //// String mstChkVal = (String) orderInfoRentalList.get(0).get("btnCheck");
    //// String salesOrdNo = (String)
    // orderInfoRentalList.get(0).get("salesOrdNo");
    // Double mstRpf = (Double) orderInfoRentalList.get(0).get("rpf");
    // Double mstRpfPaid = (Double) orderInfoRentalList.get(0).get("rpfPaid");
    //
    // String mstCustNm = (String) orderInfoRentalList.get(0).get("custNm");
    // BigDecimal mstCustBillId = (BigDecimal)
    // orderInfoRentalList.get(0).get("custBillId");
    //
    //
    // Map<String, Object> formMap = null;
    //
    // int maxSeq = 0;
    //
    // System.out.println("++++ orderInfoRentalList.size() ::" +
    // orderInfoRentalList.size() );
    //
    // for (int j = 0; j < orderInfoRentalList.size(); j++) {
    //// if( "1".equals(mstChkVal) ){
    // if(mstRpf - mstRpfPaid > 0){
    // formMap = new HashMap<String, Object>();
    //
    // formMap.put("procSeq", maxSeq++);
    // formMap.put("appType", "RENTAL");
    // formMap.put("advMonth", ""); // 셋팅필요
    // formMap.put("mstRpf", mstRpf);
    // formMap.put("mstRpfPaid", mstRpfPaid);
    //
    // formMap.put("assignAmt", 0);
    // formMap.put("billAmt", mstRpf);
    // formMap.put("billDt", "1900-01-01");
    // formMap.put("billGrpId", mstCustBillId);
    // formMap.put("billId", 0);
    // formMap.put("billNo", "0");
    // formMap.put("billStatus", "");
    // formMap.put("billTypeId", 161);
    // formMap.put("billTypeNm", "RPF");
    // formMap.put("custNm", mstCustNm);
    // formMap.put("discountAmt", 0);
    // formMap.put("installment", 0);
    // formMap.put("ordId", salesOrdId);
    // formMap.put("ordNo", salesOrdNo);
    // formMap.put("paidAmt", "mstRpfPaid");
    // formMap.put("targetAmt", mstRpf - mstRpfPaid);
    // formMap.put("srvcContractID", 0);
    // formMap.put("billAsId", 0);
    // formMap.put("srvMemId", 0);
    //// item. = $("#rentalkeyInTrNo").val() ;
    // formMap.put("trNo", ""); //
    //// item. = $("#rentalkeyInTrIssueDate").val() ;
    // formMap.put("trDt", maxSeq++); //
    //// item.collectorCode = $("#rentalkeyInCollMemNm").val()
    // formMap.put("collectorCode", ""); //
    //// item.collectorId = $("#rentalkeyInCollMemId").val() ;
    // formMap.put("collectorId", "");
    //// item.allowComm = $("#rentalcashIsCommChk").val()
    // formMap.put("allowComm", "");
    //
    // formList.add(formMap);
    // }
    //
    // int detailRowCnt = billInfoRentalList.size();
    //
    // System.out.println("++++ detailRowCnt ::" + detailRowCnt );
    //
    // for(j = 0 ; j < detailRowCnt ; j++){
    // Map billInfoRentalMap = billInfoRentalList.get(j);
    //// String detChkVal = (String) billInfoRentalMap.get("btnCheck");
    // String detSalesOrdNo = (String) billInfoRentalMap.get("ordNo");
    //
    // if(salesOrdNo.equals(detSalesOrdNo)){
    // formMap = new HashMap<String, Object>();
    //
    // formMap.put("procSeq", maxSeq++);
    // formMap.put("appType", "RENTAL");
    // formMap.put("advMonth", ""); // 셋팅필요
    // formMap.put("mstRpf", mstRpf);
    // formMap.put("mstRpfPaid", mstRpfPaid);
    //
    // formMap.put("assignAmt",0);
    // formMap.put("billAmt", billInfoRentalMap.get("billAmt"));
    // formMap.put("billDt", billInfoRentalMap.get("billDt"));
    // formMap.put("billGrpId", billInfoRentalMap.get("billGrpId"));
    // formMap.put("billId", billInfoRentalMap.get("billId"));
    // formMap.put("billNo", billInfoRentalMap.get("billNo"));
    // formMap.put("billStatus", billInfoRentalMap.get("stusCode"));
    // formMap.put("billTypeId", billInfoRentalMap.get("billTypeId"));
    // formMap.put("billTypeNm", billInfoRentalMap.get("billTypeNm"));
    // formMap.put("custNm", billInfoRentalMap.get("custNm"));
    // formMap.put("discountAmt", 0);
    // formMap.put("installment", billInfoRentalMap.get("installment"));
    // formMap.put("ordId", billInfoRentalMap.get("ordId"));
    // formMap.put("ordNo", billInfoRentalMap.get("ordNo"));
    // formMap.put("paidAmt", billInfoRentalMap.get("paidAmt"));
    // formMap.put("appType", "RENTAL");
    // formMap.put("targetAmt", billInfoRentalMap.get("targetAmt"));
    // formMap.put("srvcContractID", 0);
    // formMap.put("billAsId", 0);
    // formMap.put("srvMemId", 0);
    //
    //// item. = $("#rentalkeyInTrNo").val() ;
    // formMap.put("trNo", ""); //
    //// item. = $("#rentalkeyInTrIssueDate").val() ;
    // formMap.put("trDt", maxSeq++); //
    //// item.collectorCode = $("#rentalkeyInCollMemNm").val()
    // formMap.put("collectorCode", ""); //
    //// item.collectorId = $("#rentalkeyInCollMemId").val() ;
    // formMap.put("collectorId", "");
    //// item.allowComm = $("#rentalcashIsCommChk").val()
    // formMap.put("allowComm", "");
    //
    // formList.add(formMap);
    // }
    // }
    //// }
    // }
    //
    // Map<String, Object> formInfo = new HashMap<String, Object> ();
    // if(formList.size() > 0){
    // for(Object obj : formList){
    // Map<String, Object> map = (Map<String, Object>) obj;
    // formInfo.put((String)map.get("name"), map.get("value"));
    // }
    // }
    //
    // //User ID 세팅
    // formInfo.put("userid", sessionVO.getUserId());
    //
    // //Credit Card일때
    //// if("107".equals(String.valueOf(formInfo.get("keyInPayType")))){
    // formInfo.put("keyInIsOnline",
    // "1299".equals(String.valueOf(formInfo.get("keyInCardMode"))) ? 0 : 1 );
    // formInfo.put("keyInIsLock", 0);
    // formInfo.put("keyInIsThirdParty", 0);
    // formInfo.put("keyInStatusId", 1);
    // formInfo.put("keyInIsFundTransfer", 0);
    // formInfo.put("keyInSkipRecon", 0);
    // formInfo.put("keyInPayItmCardType", formInfo.get("keyCrcCardType"));
    // formInfo.put("keyInPayItmCardMode", formInfo.get("keyInCardMode"));
    //// }
    // gridList.put("userId", sessionVO.getUserId());
    // formInfo.put("userId", sessionVO.getUserId());
    // // 저장
    // System.out.println("++++ formInfo ::" + formInfo.toString() );
    // System.out.println("++++ gridList ::" + gridList.toString() );
    // System.out.println("++++ formList ::" + formList.toString() );
    // System.out.println("++++ gridFormList.toString() ::" +
    // gridFormList.toString() );
    //
    //// Map<String, Object> formInfoMap = new HashMap<String, Object>();
    //// Map<String, ArrayList<Object>> formInfoMap1 = new HashMap<String,
    // ArrayList<Object>>();
    //// for (int i = 0; i < gridFormList.size(); i++) {
    //// }
    //
    // List<EgovMap> resultList = null;
    // mobilePaymentKeyInService.saveMobilePaymentKeyInCard(formInfo,gridList);
    //// List<EgovMap> resultList =
    // commonPaymentService.savePayment(gridFormList,formList);

    // 조회 결과 리턴.
    // ReturnMessage message = new ReturnMessage();
    // message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    // return ResponseEntity.ok(message);
    return ResponseEntity.ok(resultList);
  }

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 12. 3.
   * @param params
   * @param model
   * @param sessionVO
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/saveMobilePaymentKeyInNormalPayment.do", method = RequestMethod.POST)
  public ResponseEntity<Map<String, Object>> saveMobilePaymentKeyInNormalPayment(
      @RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {

    String sUserId = String.valueOf(sessionVO.getUserId());
    Map<String, Object> resultList = mobilePaymentKeyInService.saveMobilePaymentKeyInNormalPayment(params, sUserId);

    // System.out.println("++++ params.toString() ::" + params.toString() );
    //
    // Map<String, Object> gridList = (Map<String, Object>)
    // params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    // List<Object> formList = (List<Object>)
    // params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
    //
    //// Map<String, Object> tmpKey = (Map<String, Object>) params.get("key");
    // //BankStatement의 id값 가져오기
    // String tmpKey = (String) params.get("key"); //BankStatement의 id값 가져오기
    // int key = Integer.parseInt(String.valueOf(tmpKey));
    //
    // Map<String, Object> formInfo = new HashMap<String, Object> ();
    // if(formList.size() > 0){
    // for(Object obj : formList){
    // Map<String, Object> map = (Map<String, Object>) obj;
    // formInfo.put((String)map.get("name"), map.get("value"));
    // }
    // }
    //
    // //User ID 세팅
    // formInfo.put("userid", sessionVO.getUserId());
    //
    // if(formInfo.get("chargeAmount") == null ||
    // formInfo.get("chargeAmount").equals("")){
    // formInfo.put("chargeAmount", 0);
    // }
    //
    // if(formInfo.get("bankAcc") == null ||
    // formInfo.get("bankAcc").equals("")){
    // formInfo.put("bankAcc", 0);
    // }
    // formInfo.put("payItemIsLock", false);
    // formInfo.put("payItemIsThirdParty", false);
    // formInfo.put("payItemStatusId", 1);
    // formInfo.put("isFundTransfer", false);
    // formInfo.put("skipRecon", false);
    // formInfo.put("payItemCardTypeId", 0);
    //
    // System.out.println("++++ 3 formInfo.toString() ::" + formInfo.toString()
    // );
    // System.out.println("++++ 4 gridList.toString() ::" + gridList.toString()
    // );
    // System.out.println("++++ 5 key ::" + key );
    //
    // gridList.put("userId", sessionVO.getUserId());
    // formInfo.put("userId", sessionVO.getUserId());

    // 저장
    // Map<String, Object> resultList = null;
    // List<EgovMap> resultList =
    // mobilePaymentKeyInService.saveMobilePaymentKeyInNormalPayment(formInfo,gridList,key);
    // Map<String, Object> resultList =
    // commonPaymentService.saveNormalPayment(formInfo, gridList, key);
    String message = "";
    // 조회 결과 리턴.
    ReturnMessage msg = new ReturnMessage();
    msg.setCode(AppConstants.SUCCESS);
    msg.setMessage(message);
    return ResponseEntity.ok(resultList);
  }
}
