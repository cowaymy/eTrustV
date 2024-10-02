package com.coway.trust.web.sales.customer;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.StringJoiner;

import javax.annotation.Resource;
import javax.net.ssl.*;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.customer.CustomerBVO;
import com.coway.trust.biz.sales.customer.CustomerCVO;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.customer.CustomerVO;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/customer")
public class CustomerController {

  private static final Logger LOGGER = LoggerFactory.getLogger(CustomerController.class);

  @Resource(name = "customerService")
  private CustomerService customerService;

  @Resource(name = "orderRegisterMapper")
  private OrderRegisterMapper orderRegisterMapper;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  @Value("${payment.mc.urlPath}")
  private String mcPaymentUrl;

  @RequestMapping(value = "/selectIssueBank.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectIssueBank(@RequestParam Map<String, Object> params, Model model) {
    List<EgovMap> bankList = customerService.selectIssueBank(params);
    LOGGER.debug("bankList :::::   " + bankList.toString());
    return ResponseEntity.ok(bankList);
  }

  //////////////////////////////////////////////////  CHECK_EXIST_NRIC  ///////////////////////////////////////////////////

    @RequestMapping(value = "/checkNricExist.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> checkNricExist(@RequestParam Map<String, Object> params, ModelMap model)
        throws Exception {

      EgovMap resultMap = customerService.checkNricExist(params);

      return ResponseEntity.ok(resultMap);
  }
  //////////////////////////////////////////////////  CHECK_EXIST_NRIC  ///////////////////////////////////////////////////
  /**
   * Customer List 초기화 화면
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/selectCustomerList.do")
  public String selectCustomerList(@ModelAttribute("customerVO") CustomerVO customerVO,
      @RequestParam Map<String, Object> params, ModelMap model) {

    return "sales/customer/customerList";
  }

  /**
   * Customer List 데이터조회
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/selectCustomerJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCustomerJsonList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    List<EgovMap> customerList = null;

    String[] typeId = request.getParameterValues("cmbTypeId"); // Customer Type
                                                               // 콤보박스 값
    String[] cmbCorpTypeId = request.getParameterValues("cmbCorpTypeId"); // Company
                                                                          // Type
                                                                          // 콤보박스
                                                                          // 값
    String[] cmbCustTierId = request.getParameterValues("cmbCorpTypeIdList"); // Customer Tier
    params.put("typeIdList", typeId);
    params.put("cmbCorpTypeIdList", cmbCorpTypeId);
    params.put("cmbCustTierIdList", cmbCustTierId);

    LOGGER.info("##### customerList START #####");
    customerList = customerService.selectCustomerList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(customerList);
  }

  /**
   * New Customer Registration
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/customerRegistPop.do")
  public String insertPop(@RequestParam Map<String, Object> params, ModelMap model) {
    LOGGER.info("##### customerRegist START #####");
    model.put("callPrgm", params.get("callPrgm"));

    return "sales/customer/customerRegistPop";
  }

  /**
   * New Customer Registration
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/customerRegistPopESales.do")
  public String insertPopESales(@RequestParam Map<String, Object> params, ModelMap model) {

    LOGGER.debug("params ======================================>>> " + params);
    LOGGER.info("##### customerRegist START #####");
    model.put("callPrgm", params.get("callPrgm"));
    model.put("nric", params.get("nric"));

    return "sales/customer/customerRegistPopESales";
  }

  /**
   * New Customer Add Credit Card Pop
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/customerAddCreditCardPop.do")
  public String customerAddCreditCardPop(@RequestParam Map<String, Object> params, ModelMap model) {
    LOGGER.info("##### customerRegist START #####");

    List<EgovMap> bankList = customerService.selectIssueBank(params);
    model.addAttribute("bankList", bankList);
    model.addAttribute("nric", params.get("nric"));
    model.put("mcPaymentUrl", mcPaymentUrl);

    return "sales/customer/customerCreditCardPop";
  }

  /**
   * New Customer Add Credit Card Pop
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/customerAddCreditCardeSalesPop.do")
  public String customerAddCreditCardeSalesPop(@RequestParam Map<String, Object> params, ModelMap model) {
    LOGGER.info("##### customerRegist START #####");

    List<EgovMap> bankList = customerService.selectIssueBank(params);
    model.addAttribute("bankList", bankList);
    model.addAttribute("nric", params.get("nric"));
    model.put("mcPaymentUrl", mcPaymentUrl);

    return "sales/customer/customerCreditCardeSalesPop";
  }

  /**
   * New Customer Add Bank Account Pop
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/customerAddBankAccountPop.do")
  public String customerAddBankAccountPop(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> accBankList = customerService.selectAccBank(params);
    model.addAttribute("accBankList", accBankList);

    return "sales/customer/customerBankAccountPop";
  }

  /**
   * New Customer Add Bank Account Pop
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/customerBankAccountAddPop.do")
  public String customerBankAccountAddPop(@RequestParam Map<String, Object> params, ModelMap model) {

    model.put("custId", params.get("custId"));
    model.put("callPrgm", params.get("callPrgm"));

    return "sales/customer/customerBankAccountAddPop";
  }

  @RequestMapping(value = "/customerCreditCardAddPop.do")
  public String customerCreditCardAddPop(@RequestParam Map<String, Object> params, ModelMap model) {

    model.put("custId", params.get("custId"));
    model.put("callPrgm", params.get("callPrgm"));
    model.put("nric", params.get("nric"));
    model.put("mcPaymentUrl", mcPaymentUrl);

    return "sales/customer/customerCreditCardAddPop";
  }

  @RequestMapping(value = "/customerCreditCardeSalesAddPop.do")
  public String customerCreditCardeSalesAddPop(@RequestParam Map<String, Object> params, ModelMap model) {

    model.put("custId", params.get("custId"));
    model.put("callPrgm", params.get("callPrgm"));
    model.put("nric", params.get("nric"));
    model.put("mcPaymentUrl", mcPaymentUrl);

    return "sales/customer/customerCreditCardeSalesAddPop";
  }

  @RequestMapping(value = "/insertBankAccountInfo2.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertBankAccountInfo2(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws ParseException {

    int custAccId = customerService.insertBankAccountInfo2(params, sessionVO);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage("New bank account added.");
    message.setData(custAccId);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/insertCreditCardInfo2.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertCreditCardInfo2(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws ParseException {

      LOGGER.debug("params :: " + params);

//      params.put("cardNo", params.get("custCrcNoMask"));

      int custCrcId = customerService.insertCreditCardInfo2(params, sessionVO);

      params.put("custCrcId", custCrcId);
      customerService.tokenCrcUpdate1(params);

      // 결과 만들기
      ReturnMessage message = new ReturnMessage();
      message.setCode(AppConstants.SUCCESS);
      // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
      message.setMessage("New credit card added.");
      message.setData(custCrcId);

      return ResponseEntity.ok(message);
  }

  /**
   * Customer 상세 조회 Address List
   *
   * @param params
   * @param model
   * @return ResponseEntity
   */
  @RequestMapping(value = "/selectCustomerAddressJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCustomerAddressJsonList(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    List<EgovMap> addresslist = null;
    LOGGER.info("##### customer Address Parsing START #####");
    addresslist = customerService.selectCustomerAddressJsonList(params);

    return ResponseEntity.ok(addresslist);
  }

  /**
   * Customer 상세 조회 Contact List
   *
   * @param params
   * @param model
   * @return ResponseEntity
   */
  @RequestMapping(value = "/selectCustomerContactJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCustomerContactJsonList(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    List<EgovMap> contactlist = null;
    // params
    LOGGER.info("##### customer Contact Parsing START #####");
    contactlist = customerService.selectCustomerContactJsonList(params);
    // 데이터 리턴.
    return ResponseEntity.ok(contactlist);
  }

  @RequestMapping(value = "/customerConctactSearchPop.do")
  public String customerPop(@RequestParam Map<String, Object> params, ModelMap model) {

    model.put("callPrgm", params.get("callPrgm"));
    model.put("custId", params.get("custId"));

    return "sales/customer/customerContactSearchPop";
  }

  /**
   * Customer 상세 조회 Contact List
   *
   * @param params
   * @param model
   * @return ResponseEntity
   */
  @RequestMapping(value = "/selectCustCareContactList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCustCareContactList(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {
    List<EgovMap> contactlist = customerService.selectCustCareContactList(params);
    return ResponseEntity.ok(contactlist);
  }

  /**
   * Billing Group 상세 조회 Contact List
   *
   * @param params
   * @param model
   * @return ResponseEntity
   */
  @RequestMapping(value = "/selectBillingGroupByKeywordCustIDList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectBillingGroupByKeywordCustIDList(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {
    List<EgovMap> grpList = customerService.selectBillingGroupByKeywordCustIDList(params);
    return ResponseEntity.ok(grpList);
  }

  @RequestMapping(value = "/customerAddressSearchPop.do")
  public String customerAddressSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

    model.put("callPrgm", params.get("callPrgm"));
    model.put("custId", params.get("custId"));

    return "sales/customer/customerAddressSearchPop";
  }

  @RequestMapping(value = "/customerBankAccountSearchPop.do")
  public String customerBankAccountSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

    model.put("callPrgm", params.get("callPrgm"));
    model.put("custId", params.get("custId"));

    return "sales/customer/customerBankAccountSearchPop";
  }

  @RequestMapping(value = "/customerBillGrpSearchPop.do")
  public String customerBillGrpSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

    model.put("callPrgm", params.get("callPrgm"));
    model.put("custId", params.get("custId"));
    LOGGER.info("callPrgm @@@@@@@@@@@@@@@@ :: " + params.get("callPrgm"));
    return "sales/customer/customerBillGrpSearchPop";
  }

  @RequestMapping(value = "/customerCreditCardSearchPop.do")
  public String customerCreditCardSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

    model.put("callPrgm", params.get("callPrgm"));
    model.put("custId", params.get("custId"));

    return "sales/customer/customerCreditCardSearchPop";
  }

  /**
   *
   * Customer View Bank List
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.21
   */
  @RequestMapping(value = "/selectCustomerBankAccJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCustomerBankAccJsonList(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    List<EgovMap> banklist = null;
    // params
    LOGGER.info("##### customer Bank List Parsing START #####");
    banklist = customerService.selectCustomerBankAccJsonList(params);

    return ResponseEntity.ok(banklist);
  }

  /**
   *
   * Customer View CreditCard List
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.21
   */
  @RequestMapping(value = "/selectCustomerCreditCardJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCustomerCreditCardJsonList(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    List<EgovMap> cardlist = null;
    LOGGER.info("##### customer Card List Parsing START #####");
    cardlist = customerService.selectCustomerCreditCardJsonList(params);

    return ResponseEntity.ok(cardlist);
  }

  /**
   *
   * Customer View Own Order List
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.21
   */
  @RequestMapping(value = "/selectCustomerOwnOrderJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCustomerOwnOrderJsonList(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    List<EgovMap> ownorderlist = null;
    LOGGER.info("##### customer Own Order Parsing START #####");
    ownorderlist = customerService.selectCustomerOwnOrderJsonList(params);

    return ResponseEntity.ok(ownorderlist);
  }

  /**
   *
   * Customer View Third Party Order List
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.21
   */
  @RequestMapping(value = "/selectCustomerThirdPartyJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCustomerThirdPartyJsonList(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    List<EgovMap> thirdpartylist = null;
    LOGGER.info("##### customer Third Party Parsing START #####");
    thirdpartylist = customerService.selectCustomerThirdPartyJsonList(params);

    return ResponseEntity.ok(thirdpartylist);
  }

  /**
  *
  * Customer View Coway Rewards List
  *
  * @param params
  * @param model
  * @return
  * @author 이석희 2022.11.29
  */
 @RequestMapping(value = "/selectCustomerCowayRewardsJsonList", method = RequestMethod.GET)
 public ResponseEntity<List<EgovMap>> selectCustomerCowayRewardsJsonList(@RequestParam Map<String, Object> params,
     ModelMap model) throws Exception {

   List<EgovMap> cowayRewardslist = null;
   LOGGER.info("##### customer coway rewards Parsing START #####");
   cowayRewardslist = customerService.selectCustomerCowayRewardsJsonList(params);

   return ResponseEntity.ok(cowayRewardslist);
 }

  /**
   *
   * Customer Address Detail View 주소 리스트의 해당 상세화면
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.20
   */
  @RequestMapping(value = "/selectCustomerAddrDetailViewPop.do")
  public String selectCustomerAddrDetailViewPop(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap detailaddr = null;
    LOGGER.info("##### selectCustomerDetailAddr START #####");
    detailaddr = customerService.selectCustomerAddrDetailViewPop(params);
    LOGGER.info("##### detailaddr : " + detailaddr.toString());
    model.addAttribute("detailaddr", detailaddr);

    return "sales/customer/customerAddressPop";
  }

  /**
   *
   * Customer Contact Detail View 연락처 리스트의 해당 상세화면
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.25
   */
  @RequestMapping(value = "/selectCustomerContactDetailViewPop.do")
  public String selectCustomerContactDetailViewPop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) throws Exception {

    EgovMap detailcontact = null;

    LOGGER.info("##### selectCustomerDetailContact START #####");
    detailcontact = customerService.selectCustomerContactDetailViewPop(params);
    model.addAttribute("detailcontact", detailcontact);

    return "sales/customer/customerContactPop";
  }

  /**
   *
   * Customer Bank Detail View 은행 리스트의 해당 상세화면
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.20
   */
  @RequestMapping(value = "/selectCustomerBankDetailViewPop.do")
  public String selectCustomerBankDetailViewPop(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap detailbank = null;
    LOGGER.info("##### selectCustomerDetailBank START #####");
    detailbank = customerService.selectCustomerBankDetailViewPop(params);
    model.addAttribute("detailbank", detailbank);

    return "sales/customer/customerBankPop";
  }

  /**
   *
   * Customer Card Detail View Card 리스트의 해당 상세화면
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.20
   */
  @RequestMapping(value = "/selectCustomerCreditCardDetailViewPop.do")
  public String selectCustomerCreditCardDetailViewPop(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap detailcard = null;
    LOGGER.info("##### selectCustomerDetail Credit Card START #####");
    detailcard = customerService.selectCustomerCreditCardDetailViewPop(params);

    model.addAttribute("detailcard", detailcard);

    return "sales/customer/customerCardPop";
  }

  /**
   *
   * Customer View 상세화면
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.20
   */
  @RequestMapping(value = "/selectCustomerView.do")
  public String selectCustomerView(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    EgovMap basicinfo = null;
    EgovMap addresinfo = null;
    EgovMap contactinfo = null;

    LOGGER.info("##### customeView START #####");
    basicinfo = customerService.selectCustomerViewBasicInfo(params);
    addresinfo = customerService.selectCustomerViewMainAddress(params);
    contactinfo = customerService.selectCustomerViewMainContact(params);

    // ajax param
    model.addAttribute("custId", params.get("custId"));
    model.addAttribute("custAddrId", params.get("custAddrId"));
    model.addAttribute("custCntcId", params.get("custCntcId"));
    // infomation param
    model.addAttribute("result", basicinfo);
    model.addAttribute("addresinfo", addresinfo);
    model.addAttribute("contactinfo", contactinfo);

    return "sales/customer/customerViewPop";
  }

  /**
   *
   * Basic Customer Info 등록
   *
   * @param params
   * @param model.
   * @return
   * @author
   */
  @RequestMapping(value = "/insCustBasicInfo.do", method = RequestMethod.POST)
  public ResponseEntity<Integer> insCustBasicInfo(@RequestBody CustomerForm customerForm, Model model)
      throws Exception {

    int getCustCareCntId = 0;
    String defaultDate = "01/01/1900";
    SessionVO sessionVo = sessionHandler.getCurrentSessionInfo();
    CustomerVO vo = customerForm.getCustomerVO();

    // Credit Card addList
    GridDataSet<CustomerCardListGridForm> dataSet = customerForm.getDataSet();
    List<CustomerCardListGridForm> addList = dataSet.getAdd();
    List<CustomerCVO> customerCardVOList = new ArrayList<>();
    // Bank Account addList
    GridDataSet<CustomerBankAccListGridForm> dataSetBank = customerForm.getDataSetBank();
    List<CustomerBankAccListGridForm> addBankList = dataSetBank.getAdd();
    List<CustomerBVO> customerBankVOList = new ArrayList<>();

    getCustCareCntId = customerService.getCustCareCntIdSeq();

    LOGGER.info("##########getCustCareCntId :::::::   " + getCustCareCntId);

    Map<String, Object> insmap = new HashMap();

    Map<String, Object> ins29Dmap = new HashMap();

    // Basic Info
    int tempCustSeq = 0;
    tempCustSeq = customerService.getCustIdSeq();

    final int customerId = tempCustSeq;

    insmap.put("custSeq", tempCustSeq);
    insmap.put("custName", vo.getCustName());
    insmap.put("cmbNation", String.valueOf(vo.getCmbNation()) != null ? vo.getCmbNation() : 0);
    if (vo.getDob() != null && !"".equals(vo.getDob())) {
      insmap.put("dob", vo.getDob());
    } else {
      insmap.put("dob", defaultDate);
    }
    insmap.put("nric", vo.getNric() != null ? vo.getNric() : "");
    insmap.put("oldNric", vo.getOldNric() != null ? vo.getOldNric() : "");
    LOGGER.info("##########vo.getGender() :::::::   " + vo.getGender());
    insmap.put("gender", vo.getGender() != null ? vo.getGender() : "");
    insmap.put("cmbRace", String.valueOf(vo.getCmbRace()) != null ? vo.getCmbRace() : 0);
    insmap.put("email", vo.getEmail() != null ? vo.getEmail() : "");
    if (vo.getRem() != null) {
      insmap.put("rem", vo.getRem());
    } else {
      insmap.put("rem", null);
    }
    insmap.put("stusCodeId", 1); // 고정
    insmap.put("updUserId", sessionVo.getUserId());
    insmap.put("renGrp", ""); // 고정
    insmap.put("pstTerms", 0); // 고정
    insmap.put("idOld", 0); // 고정
    insmap.put("crtUserId", sessionVo.getUserId());
    insmap.put("cmbTypeId", vo.getCmbTypeId());
    insmap.put("pasSportExpr", vo.getPasSportExpr() != null ? vo.getPasSportExpr() : defaultDate);
    insmap.put("visaExpr", vo.getVisaExpr() != null ? vo.getVisaExpr() : defaultDate);
    insmap.put("cmbCorpTypeId", vo.getCmbTypeId() == 965 ? vo.getCmbCorpTypeId() : 0);
    insmap.put("gstRgistNo", vo.getGstRgistNo() != null ? vo.getGstRgistNo() : "");

    // 98 9920 0068 7067

    String getCustVano = "";
    int custseqLenghth = Integer.toString(tempCustSeq).length();
    String tempCustSeqVa = String.valueOf(tempCustSeq);
    LOGGER.info("##########custseqLenghth :::::::   " + custseqLenghth);
    LOGGER.info("##########tempCustSeqVa :::::::   " + tempCustSeqVa);
    if (custseqLenghth == 4) {
      getCustVano = "98 9920 0000" + tempCustSeqVa;
    } else if (custseqLenghth == 5) {
      getCustVano = "98 9920 000" + tempCustSeqVa.substring(0, 1) + " " + tempCustSeqVa.substring(1);
    } else if (custseqLenghth == 6) {
      getCustVano = "98 9920 00" + tempCustSeqVa.substring(0, 2) + " " + tempCustSeqVa.substring(2);
    } else if (custseqLenghth == 7) {
      getCustVano = "98 9920 0" + tempCustSeqVa.substring(0, 3) + " " + tempCustSeqVa.substring(3);
    } else if (custseqLenghth == 8) {
      getCustVano = "98 9920 " + tempCustSeqVa.substring(0, 4) + " " + tempCustSeqVa.substring(4);
    }

    ins29Dmap.put("getCustVano", getCustVano);
    ins29Dmap.put("custSeq", tempCustSeq);
    ins29Dmap.put("custName", vo.getCustName());
    ins29Dmap.put("cmbNation", String.valueOf(vo.getCmbNation()) != null ? vo.getCmbNation() : 0);
    if (vo.getDob() != null && !"".equals(vo.getDob())) {
      ins29Dmap.put("dob", vo.getDob());
    } else {
      ins29Dmap.put("dob", defaultDate);
    }
    ins29Dmap.put("nric", vo.getNric() != null ? vo.getNric() : "");
    ins29Dmap.put("oldNric", vo.getOldNric() != null ? vo.getOldNric() : "");
    LOGGER.info("########## vo.getGender() :::::::   " + vo.getGender());
    ins29Dmap.put("gender", vo.getGender() != null ? vo.getGender() : "");
    ins29Dmap.put("cmbRace", String.valueOf(vo.getCmbRace()) != null ? vo.getCmbRace() : 0);
    ins29Dmap.put("email", vo.getEmail() != null ? vo.getEmail() : "");
    if (vo.getRem() != null) {
      ins29Dmap.put("rem", vo.getRem());
    } else {
      ins29Dmap.put("rem", null);
    }
    ins29Dmap.put("stusCodeId", 1); // 고정
    ins29Dmap.put("updUserId", sessionVo.getUserId());
    ins29Dmap.put("renGrp", ""); // 고정
    ins29Dmap.put("pstTerms", 0); // 고정
    ins29Dmap.put("idOld", 0); // 고정
    ins29Dmap.put("crtUserId", sessionVo.getUserId());
    ins29Dmap.put("cmbTypeId", vo.getCmbTypeId());
    ins29Dmap.put("pasSportExpr", vo.getPasSportExpr() != null ? vo.getPasSportExpr() : defaultDate);
    ins29Dmap.put("visaExpr", vo.getVisaExpr() != null ? vo.getVisaExpr() : defaultDate);
    ins29Dmap.put("cmbCorpTypeId", vo.getCmbTypeId() == 965 ? vo.getCmbCorpTypeId() : 0);
    ins29Dmap.put("gstRgistNo", vo.getGstRgistNo() != null ? vo.getGstRgistNo() : "");
    ins29Dmap.put("receivingMarketingMsgStatus",vo.getReceivingMarketingMsgStatus());

    // Address
    insmap.put("addrDtl", vo.getAddrDtl());
    insmap.put("areaId", vo.getAreaId());
    insmap.put("streetDtl", vo.getStreetDtl());

    // insmap.put("addr3", vo.getAddr3());
    // insmap.put("addr4", ""); //고정
    // insmap.put("postCodeId", String.valueOf(vo.getCmbPostCd()) != null ?
    // vo.getCmbPostCd() : 0);
    // insmap.put("postCode", ""); //고정
    // insmap.put("areaId", String.valueOf(vo.getCmbArea()) != null ?
    // vo.getCmbArea() : 0);
    // insmap.put("area", ""); //고정
    // insmap.put("stateId", String.valueOf(vo.getMstate()) != null ?
    // vo.getMstate() : 0);
    // insmap.put("cntyId", 1); //고정 (cmbCoountry)
    insmap.put("stusCodeId", 9); // 고정
    insmap.put("addrRem", vo.getAddrRem()); // 고정
    insmap.put("idOld", 0); // 고정
    insmap.put("soId", 0); // 고정
    insmap.put("idcm", 0); // 고정

    // additional service contact
    insmap.put("getCustCareCntId", getCustCareCntId);
    insmap.put("custInitial", String.valueOf(vo.getCustInitial()) != null ? vo.getCustInitial() : 0);
    insmap.put("pos", ""); // 고정
    insmap.put("telM1", vo.getTelM1());
    insmap.put("telM2", ""); // 고정
    insmap.put("telO", vo.getTelO());
    insmap.put("telR", vo.getTelR());
    insmap.put("telF", vo.getTelF());
    insmap.put("dept", ""); // 고정
    insmap.put("dcm", 0); // 고정
    insmap.put("ext", vo.getExt());

    insmap.put("asTelM", vo.getAsTelM());
    insmap.put("asTelO", vo.getAsTelO());
    insmap.put("asTelR", vo.getAsTelR());
    insmap.put("asTelF", vo.getAsTelF());
    insmap.put("asExt", vo.getAsExt());
    insmap.put("asEmail", vo.getAsEmail());
    insmap.put("asCustName", vo.getAsCustName());

    /* NRIC Dup Check */

    EgovMap nricDupMap = customerService.nricDupChk(insmap);
    if (nricDupMap != null) {
      return null;
    }

    // Cust TIN & SST Registration No

    ins29Dmap.put("sstRgistNo", vo.getSstRgistNo());

    Map<String, Object> ins416map = new HashMap();

    if(!vo.getTin().equals(null) && !vo.getTin().equals("")){

        int tempTinSeq = 0;
        tempTinSeq = customerService.getCustTinIdSeq();

        ins29Dmap.put("custTinId",tempTinSeq);

        ins416map.put("custTinId",tempTinSeq);
        ins416map.put("basicCustId", tempCustSeq);
        ins416map.put("basicCustTin", vo.getTin());
        ins416map.put("status", "1");
        /*ins416map.put("isEInvoice", String.valueOf(vo.geteInvFlg()) != null ? vo.geteInvFlg() : 0);*/
        ins416map.put("userId", sessionVo.getUserId());
    }



    LOGGER.info("########## ins29Dmap :::::::   " + ins29Dmap.toString());

    customerService.insertCustomerInfo(ins29Dmap);
    if(ins416map != null && !ins416map.isEmpty()){
    	customerService.insertCustomerTinId(ins416map);
    }
    customerService.insertAddressInfo(insmap);
    customerService.insertContactInfo(insmap);
    customerService.insertCareContactInfo(insmap);

    // insert Credit Card Info
    if (addList != null) {
        String tokenRefNo = "";
      // int getCustCrcIdSeq = customerService.getCustCrcIdSeq();
      addList.forEach(form -> {
        CustomerCVO customerCVO = new CustomerCVO();
        customerCVO.setGetCustId(customerId);
        customerCVO.setCrcType(form.getCrcType());
        customerCVO.setBank(form.getBank());
        customerCVO.setCardType(form.getCardType());
        customerCVO.setCardRem(null); // 임시
        // customerCVO.setGetCustCrcIdSeq(getCustCrcIdSeq);
        customerCVO.setCrcNo(form.getCreditCardNo()); // 암호화 코드
        customerCVO.setCreditCardNo(form.getCreditCardNo());
        customerCVO.setEncCrcNo(form.getEncCrcNo()); // 암호화 코드
        customerCVO.setNmCard(form.getNmCard());
        customerCVO.setCrcStusId(1); // 고정
        customerCVO.setCrcUpdId(sessionVo.getUserId()); // 임시
        customerCVO.setCrcCrtId(sessionVo.getUserId()); // 임시
        customerCVO.setCrcToken(form.getCrcToken());    // LaiKW 2019-08-01 Tokenization
        customerCVO.setTokenRefNo(form.getTokenRefNo());// LaiKW 2020-03-10 Tokenization

        /*
        // Commented on 09/03/2020 - LaiKW - MC Payment PCI DSS Compliance enhancement.
        String cardExpiry = form.getCardExpiry();
        if (cardExpiry != null) {
          cardExpiry = cardExpiry.substring(0, 2) + cardExpiry.substring(5, 7);
        } else {
          cardExpiry = null;
        }
        customerCVO.setCardExpiry(cardExpiry);
        */
        customerCVO.setCardExpiry(form.getCardExpiry());
        customerCVO.setCrcIdOld(0); // 고정
        customerCVO.setSoId(0); // 고정
        customerCVO.setCrcIdcm(0); // 고정

        customerCardVOList.add(customerCVO);

      });

      customerService.insertCreditCardInfo(customerCardVOList);
      LOGGER.info("추가 : {}", addList.toString());

      /*
      Map<String, Object> tokenCrcParam = new HashMap<>();
      tokenCrcParam.put("custId", customerId);
      tokenCrcParam.put("userId", sessionVo.getUserId());
      tokenCrcParam.put("customerCardVOList", customerCardVOList);
      customerService.tokenCrcUpdate(tokenCrcParam);*/
    }

    // insert Bank Account Info
    if (addBankList != null) {
      // int getCustAccIdSeq = customerService.getCustAccIdSeq();
      addBankList.forEach(form -> {
        CustomerBVO customerBVO = new CustomerBVO();
        // customerBVO.setGetCustAccIdSeq(getCustAccIdSeq);
        customerBVO.setAccNo(form.getAccNo());
        customerBVO.setEncAccNo(form.getEncAccNo());
        customerBVO.setAccOwner(form.getAccOwner());
        customerBVO.setAccTypeId(form.getAccTypeId()); // 0
        customerBVO.setAccBankId(form.getAccBankId()); // 0
        customerBVO.setAccBankBrnch(form.getAccBankBrnch());
        customerBVO.setAccRem(form.getAccRem());
        customerBVO.setAccStusId(1);
        customerBVO.setAccUpdUserId(sessionVo.getUserId()); // 임시
        customerBVO.setAccNric(""); // 고정
        customerBVO.setAccIdOld(0); // 고정
        customerBVO.setSoId(0); // 고정
        customerBVO.setAccIdcm(0); // 고정
        customerBVO.setHlbbId(0); // 고정
        customerBVO.setAccCrtUserId(sessionVo.getUserId()); // 임시
        customerBVO.setDdtChnlCde(form.getDdtChnlCde());

        customerBankVOList.add(customerBVO);
      });

      customerService.insertBankAccountInfo(customerBankVOList);
      LOGGER.info("Bank추가 : {}", addBankList.toString());
    }

    Map<String, Object> updatePreccpData = new HashMap();
    updatePreccpData.put("custId", customerId);
    customerService.updatePreccpData(updatePreccpData);

    /*
     * ReturnMessage message = new ReturnMessage();
     * message.setCode(AppConstants.SUCCESS);
     * message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
     */

    return ResponseEntity.ok(tempCustSeq);
  }

  @RequestMapping(value = "/insCustBasicInfoEkeyin.do", method = RequestMethod.POST)
  public ResponseEntity<Integer> insCustBasicInfoEkeyin(@RequestBody CustomerForm customerForm, Model model)
      throws Exception {
    int getCustCareCntId = 0;
    String defaultDate = "01/01/1900";
    SessionVO sessionVo = sessionHandler.getCurrentSessionInfo();
    CustomerVO vo = customerForm.getCustomerVO();

    // Credit Card addList
    GridDataSet<CustomerCardListGridForm> dataSet = customerForm.getDataSet();
    List<CustomerCardListGridForm> addList = dataSet.getAdd();
    List<CustomerCVO> customerCardVOList = new ArrayList<>();
    // Bank Account addList
    GridDataSet<CustomerBankAccListGridForm> dataSetBank = customerForm.getDataSetBank();
    List<CustomerBankAccListGridForm> addBankList = dataSetBank.getAdd();
    List<CustomerBVO> customerBankVOList = new ArrayList<>();

    getCustCareCntId = customerService.getCustCareCntIdSeq();

    LOGGER.info("##########getCustCareCntId :::::::   " + getCustCareCntId);

    Map<String, Object> insmap = new HashMap();

    Map<String, Object> ins29Dmap = new HashMap();

    // Basic Info
    int tempCustSeq = 0;
    tempCustSeq = customerService.getCustIdSeq();

    final int customerId = tempCustSeq;

    insmap.put("custSeq", tempCustSeq);
    insmap.put("custName", vo.getCustName());
    insmap.put("cmbNation", String.valueOf(vo.getCmbNation()) != null ? vo.getCmbNation() : 0);
    if (vo.getDob() != null && !"".equals(vo.getDob())) {
      insmap.put("dob", vo.getDob());
    } else {
      insmap.put("dob", defaultDate);
    }
    insmap.put("nric", vo.getNric() != null ? vo.getNric() : "");
    insmap.put("oldNric", vo.getOldNric() != null ? vo.getOldNric() : "");
    LOGGER.info("##########vo.getGender() :::::::   " + vo.getGender());
    insmap.put("gender", vo.getGender() != null ? vo.getGender() : "");
    insmap.put("cmbRace", String.valueOf(vo.getCmbRace()) != null ? vo.getCmbRace() : 0);
    insmap.put("email", vo.getEmail() != null ? vo.getEmail() : "");
    if (vo.getRem() != null) {
      insmap.put("rem", vo.getRem());
    } else {
      insmap.put("rem", null);
    }
    insmap.put("stusCodeId", 9); // 고정 Set main contact and service contact's status to MAIN
    insmap.put("updUserId", sessionVo.getUserId());
    insmap.put("renGrp", ""); // 고정
    insmap.put("pstTerms", 0); // 고정
    insmap.put("idOld", 0); // 고정
    insmap.put("crtUserId", sessionVo.getUserId());
    insmap.put("cmbTypeId", vo.getCmbTypeId());
    insmap.put("pasSportExpr", vo.getPasSportExpr() != null ? vo.getPasSportExpr() : defaultDate);
    insmap.put("visaExpr", vo.getVisaExpr() != null ? vo.getVisaExpr() : defaultDate);
    insmap.put("cmbCorpTypeId", vo.getCmbTypeId() == 965 ? vo.getCmbCorpTypeId() : 0);
    insmap.put("gstRgistNo", vo.getGstRgistNo() != null ? vo.getGstRgistNo() : "");

    // 98 9920 0068 7067

    String getCustVano = "";
    int custseqLenghth = Integer.toString(tempCustSeq).length();
    String tempCustSeqVa = String.valueOf(tempCustSeq);
    LOGGER.info("##########custseqLenghth :::::::   " + custseqLenghth);
    LOGGER.info("##########tempCustSeqVa :::::::   " + tempCustSeqVa);
    if (custseqLenghth == 4) {
      getCustVano = "98 9920 0000" + tempCustSeqVa;
    } else if (custseqLenghth == 5) {
      getCustVano = "98 9920 000" + tempCustSeqVa.substring(0, 1) + " " + tempCustSeqVa.substring(1);
    } else if (custseqLenghth == 6) {
      getCustVano = "98 9920 00" + tempCustSeqVa.substring(0, 2) + " " + tempCustSeqVa.substring(2);
    } else if (custseqLenghth == 7) {
      getCustVano = "98 9920 0" + tempCustSeqVa.substring(0, 3) + " " + tempCustSeqVa.substring(3);
    } else if (custseqLenghth == 8) {
      getCustVano = "98 9920 " + tempCustSeqVa.substring(0, 4) + " " + tempCustSeqVa.substring(4);
    }

    ins29Dmap.put("getCustVano", getCustVano);
    ins29Dmap.put("custSeq", tempCustSeq);
    ins29Dmap.put("custName", vo.getCustName());
    ins29Dmap.put("cmbNation", String.valueOf(vo.getCmbNation()) != null ? vo.getCmbNation() : 0);
    if (vo.getDob() != null && !"".equals(vo.getDob())) {
      ins29Dmap.put("dob", vo.getDob());
    } else {
      ins29Dmap.put("dob", defaultDate);
    }
    ins29Dmap.put("nric", vo.getNric() != null ? vo.getNric() : "");
    ins29Dmap.put("oldNric", vo.getOldNric() != null ? vo.getOldNric() : "");
    LOGGER.info("########## vo.getGender() :::::::   " + vo.getGender());
    ins29Dmap.put("gender", vo.getGender() != null ? vo.getGender() : "");
    ins29Dmap.put("cmbRace", String.valueOf(vo.getCmbRace()) != null ? vo.getCmbRace() : 0);
    ins29Dmap.put("email", vo.getEmail() != null ? vo.getEmail() : "");
    if (vo.getRem() != null) {
      ins29Dmap.put("rem", vo.getRem());
    } else {
      ins29Dmap.put("rem", null);
    }
    ins29Dmap.put("stusCodeId", 1); // 고정
    ins29Dmap.put("updUserId", sessionVo.getUserId());
    ins29Dmap.put("renGrp", ""); // 고정
    ins29Dmap.put("pstTerms", 0); // 고정
    ins29Dmap.put("idOld", 0); // 고정
    ins29Dmap.put("crtUserId", sessionVo.getUserId());
    ins29Dmap.put("cmbTypeId", vo.getCmbTypeId());
    ins29Dmap.put("pasSportExpr", vo.getPasSportExpr() != null ? vo.getPasSportExpr() : defaultDate);
    ins29Dmap.put("visaExpr", vo.getVisaExpr() != null ? vo.getVisaExpr() : defaultDate);
    ins29Dmap.put("cmbCorpTypeId", vo.getCmbTypeId() == 965 ? vo.getCmbCorpTypeId() : 0);
    ins29Dmap.put("gstRgistNo", vo.getGstRgistNo() != null ? vo.getGstRgistNo() : "");
    ins29Dmap.put("receivingMarketingMsgStatus",vo.getReceivingMarketingMsgStatus());

    // Cust TIN & SST Registration No

    ins29Dmap.put("sstRgistNo", vo.getSstRgistNo());

    Map<String, Object> ins416map = new HashMap();

    if(!vo.getTin().equals(null) && !vo.getTin().equals("")){

        int tempTinSeq = 0;
        tempTinSeq = customerService.getCustTinIdSeq();

        ins29Dmap.put("custTinId",tempTinSeq);

        ins416map.put("custTinId",tempTinSeq);
        ins416map.put("basicCustId", tempCustSeq);
        ins416map.put("basicCustTin", vo.getTin());
        ins416map.put("status", "1");
        /*ins416map.put("isEInvoice", String.valueOf(vo.geteInvFlg()) != null ? vo.geteInvFlg() : 0);*/
        ins416map.put("userId", sessionVo.getUserId());
    }

    // Address
    insmap.put("addrDtl", vo.getAddrDtl());
    insmap.put("areaId", vo.getAreaId());
    insmap.put("streetDtl", vo.getStreetDtl());

    // insmap.put("addr3", vo.getAddr3());
    // insmap.put("addr4", ""); //고정
    // insmap.put("postCodeId", String.valueOf(vo.getCmbPostCd()) != null ?
    // vo.getCmbPostCd() : 0);
    // insmap.put("postCode", ""); //고정
    // insmap.put("areaId", String.valueOf(vo.getCmbArea()) != null ?
    // vo.getCmbArea() : 0);
    // insmap.put("area", ""); //고정
    // insmap.put("stateId", String.valueOf(vo.getMstate()) != null ?
    // vo.getMstate() : 0);
    // insmap.put("cntyId", 1); //고정 (cmbCoountry)
    // insmap.put("stusCodeId", 9); // 고정
    // insmap.put("addrRem", vo.getAddrRem()); // 고정
    // insmap.put("idOld", 0); // 고정
    // insmap.put("soId", 0); // 고정
    // insmap.put("idcm", 0); // 고정

    // additional service contact
    insmap.put("getCustCareCntId", getCustCareCntId);
    insmap.put("custInitial", String.valueOf(vo.getCustInitial()) != null ? vo.getCustInitial() : 0);
    insmap.put("pos", ""); // 고정
    insmap.put("telM1", vo.getTelM1());
    insmap.put("telM2", ""); // 고정
    insmap.put("telO", vo.getTelO());
    insmap.put("telR", vo.getTelR());
    insmap.put("telF", vo.getTelF());
    insmap.put("dept", ""); // 고정
    insmap.put("dcm", 0); // 고정
    insmap.put("ext", vo.getExt());

    insmap.put("asTelM", vo.getAsTelM());
    insmap.put("asTelO", vo.getAsTelO());
    insmap.put("asTelR", vo.getAsTelR());
    insmap.put("asTelF", vo.getAsTelF());
    insmap.put("asExt", vo.getAsExt());
    insmap.put("asEmail", vo.getAsEmail());
    insmap.put("asCustName", vo.getAsCustName());

    /* NRIC Dup Check */

    EgovMap nricDupMap = customerService.nricDupChk(insmap);
    if (nricDupMap != null) {
      return null;
    }

    LOGGER.info("########## ins29Dmap :::::::   " + ins29Dmap.toString());

    customerService.insertCustomerInfo(ins29Dmap);
    //customerService.insertAddressInfo(insmap);
    if(ins416map != null && !ins416map.isEmpty()){
    	customerService.insertCustomerTinId(ins416map);
    }
    customerService.insertContactInfo(insmap);
    customerService.insertCareContactInfo(insmap);

    // insert Credit Card Info
    if (addList != null) {
      // int getCustCrcIdSeq = customerService.getCustCrcIdSeq();
      addList.forEach(form -> {
        CustomerCVO customerCVO = new CustomerCVO();
        customerCVO.setGetCustId(customerId);
        customerCVO.setCrcType(form.getCrcType());
        customerCVO.setBank(form.getBank());
        customerCVO.setCardType(form.getCardType());
        customerCVO.setCardRem(null); // 임시
        // customerCVO.setGetCustCrcIdSeq(getCustCrcIdSeq);
        customerCVO.setCrcNo(null); // 암호화 코드
        customerCVO.setCreditCardNo(form.getCreditCardNo());
        customerCVO.setEncCrcNo(null); // 암호화 코드
        customerCVO.setNmCard(form.getNmCard());
        customerCVO.setCrcStusId(1); // 고정
        customerCVO.setCrcUpdId(sessionVo.getUserId()); // 임시
        customerCVO.setCrcCrtId(sessionVo.getUserId()); // 임시

        String cardExpiry = form.getCardExpiry();
        if (cardExpiry != null) {
          cardExpiry = cardExpiry.substring(0, 2) + cardExpiry.substring(5, 7);
        } else {
          cardExpiry = null;
        }
        customerCVO.setCardExpiry(cardExpiry);
        customerCVO.setCrcIdOld(0); // 고정
        customerCVO.setSoId(0); // 고정
        customerCVO.setCrcIdcm(0); // 고정

        customerCardVOList.add(customerCVO);

      });

      customerService.insertCreditCardInfo(customerCardVOList);
      LOGGER.info("추가 : {}", addList.toString());
    }

    // insert Bank Account Info
    if (addBankList != null) {
      // int getCustAccIdSeq = customerService.getCustAccIdSeq();
      addBankList.forEach(form -> {
        CustomerBVO customerBVO = new CustomerBVO();
        // customerBVO.setGetCustAccIdSeq(getCustAccIdSeq);
        customerBVO.setAccNo(form.getAccNo());
        customerBVO.setEncAccNo(form.getEncAccNo());
        customerBVO.setAccOwner(form.getAccOwner());
        customerBVO.setAccTypeId(form.getAccTypeId()); // 0
        customerBVO.setAccBankId(form.getAccBankId()); // 0
        customerBVO.setAccBankBrnch(form.getAccBankBrnch());
        customerBVO.setAccRem(form.getAccRem());
        customerBVO.setAccStusId(1);
        customerBVO.setAccUpdUserId(sessionVo.getUserId()); // 임시
        customerBVO.setAccNric(""); // 고정
        customerBVO.setAccIdOld(0); // 고정
        customerBVO.setSoId(0); // 고정
        customerBVO.setAccIdcm(0); // 고정
        customerBVO.setHlbbId(0); // 고정
        customerBVO.setAccCrtUserId(sessionVo.getUserId()); // 임시
        customerBVO.setDdtChnlCde(form.getDdtChnlCde());

        customerBankVOList.add(customerBVO);
      });

      customerService.insertBankAccountInfo(customerBankVOList);
      LOGGER.info("Bank추가 : {}", addBankList.toString());
    }

    /*
     * ReturnMessage message = new ReturnMessage();
     * message.setCode(AppConstants.SUCCESS);
     * message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
     */

    return ResponseEntity.ok(tempCustSeq);
  }

  /**
   *
   * NRIC / Company No 중복체크
   *
   * @param params
   * @param model.
   * @return
   * @author
   */
  @RequestMapping(value = "/nricDupChk.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> nricDupChk(@RequestBody Map<String, Object> params, ModelMap model) throws Exception {
    LOGGER.debug("NRIC  :::::::::::::::::::::::::::::::::::::::::::::: {}", params.get("nric"));
    EgovMap dupMap = null;

    dupMap = customerService.nricDupChk(params);

    return ResponseEntity.ok(dupMap);
  }

  // Customer Edit Controller
  /**
   *
   * Customer Basic Info Edit 기본 정보 수정
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.27
   */
  @RequestMapping(value = "/updateCustomerBasicInfoPop.do")
  public String updateCustomerBasicInfoPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    EgovMap basicinfo = null;
    EgovMap addresinfo = null;
    EgovMap contactinfo = null;
    // custId custAddId custCntcId

    basicinfo = customerService.selectCustomerViewBasicInfo(params);
    addresinfo = customerService.selectCustomerViewMainAddress(params);
    contactinfo = customerService.selectCustomerViewMainContact(params);
    // page param
    model.addAttribute("custId", params.get("custId"));
    model.addAttribute("custAddId", params.get("custAddId"));
    model.addAttribute("custCntcId", params.get("custCntcId"));
    model.addAttribute("selectParam", params.get("selectParam"));
    // infomation param
    model.addAttribute("result", basicinfo);
    model.addAttribute("addresinfo", addresinfo);
    model.addAttribute("contactinfo", contactinfo);

    return "sales/customer/customerBasicEditPop";
  }

  /**
   *
   * Customer Address Edit 기본 정보 수정
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.28
   */
  @RequestMapping(value = "/updateCustomerAddressPop.do")
  public String updateCustomerAddressPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    EgovMap basicinfo = null;
    EgovMap addresinfo = null;
    EgovMap contactinfo = null;

    LOGGER.info("##### customer Address Edit START #####");
    LOGGER.info("##### selParam :  ##### = " + params.get("selectParam"));
    basicinfo = customerService.selectCustomerViewBasicInfo(params);
    addresinfo = customerService.selectCustomerViewMainAddress(params);
    contactinfo = customerService.selectCustomerViewMainContact(params);

    // page param
    model.addAttribute("custId", params.get("custId"));
    model.addAttribute("custAddId", params.get("custAddId"));
    model.addAttribute("custCntcId", params.get("custCntcId"));
    model.addAttribute("selectParam", params.get("selectParam"));
    // infomation param
    model.addAttribute("result", basicinfo);
    model.addAttribute("addresinfo", addresinfo);
    model.addAttribute("contactinfo", contactinfo);

    return "sales/customer/customerAddressEditPop";
  }

  /**
   *
   * Customer Contact Edit 기본 정보 수정
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.28
   */
  @RequestMapping(value = "/updateCustomerContactPop.do")
  public String updateCustomerContactPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    EgovMap basicinfo = null;
    EgovMap addresinfo = null;
    EgovMap contactinfo = null;

    LOGGER.info("##### customer Contact Edit START #####");
    basicinfo = customerService.selectCustomerViewBasicInfo(params);
    addresinfo = customerService.selectCustomerViewMainAddress(params);
    contactinfo = customerService.selectCustomerViewMainContact(params);
    // page param
    model.addAttribute("custId", params.get("custId"));
    model.addAttribute("custAddId", params.get("custAddId"));
    model.addAttribute("custCntcId", params.get("custCntcId"));
    model.addAttribute("selectParam", params.get("selectParam"));
    // infomation param
    model.addAttribute("result", basicinfo);
    model.addAttribute("addresinfo", addresinfo);
    model.addAttribute("contactinfo", contactinfo);

    return "sales/customer/customerContactEditPop";
  }

  /**
   *
   * Customer Bank Account Edit 기본 정보 수정
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.28
   */
  @RequestMapping(value = "/updateCustomerBankAccountPop.do")
  public String updateCustomerBankAccountPop(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap basicinfo = null;
    EgovMap addresinfo = null;
    EgovMap contactinfo = null;

    LOGGER.info("##### customer Bank Acc Edit START #####");
    basicinfo = customerService.selectCustomerViewBasicInfo(params);
    addresinfo = customerService.selectCustomerViewMainAddress(params);
    contactinfo = customerService.selectCustomerViewMainContact(params);

    // page param
    model.addAttribute("custId", params.get("custId"));
    model.addAttribute("custAddId", params.get("custAddId"));
    model.addAttribute("custCntcId", params.get("custCntcId"));
    model.addAttribute("selectParam", params.get("selectParam"));
    // infomation param
    model.addAttribute("result", basicinfo);
    model.addAttribute("addresinfo", addresinfo);
    model.addAttribute("contactinfo", contactinfo);

    return "sales/customer/customerBankAccEditPop";
  }

  /**
   *
   * Customer Credit Card Edit 기본 정보 수정
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.28
   */
  @RequestMapping(value = "/updateCustomerCreditCardPop.do")
  public String updateCustomerCreditCardPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    EgovMap basicinfo = null;
    EgovMap addresinfo = null;
    EgovMap contactinfo = null;

    LOGGER.info("##### customer Credit Card Edit START #####");
    basicinfo = customerService.selectCustomerViewBasicInfo(params);
    addresinfo = customerService.selectCustomerViewMainAddress(params);
    contactinfo = customerService.selectCustomerViewMainContact(params);

    // page param
    model.addAttribute("custId", params.get("custId"));
    model.addAttribute("custAddId", params.get("custAddId"));
    model.addAttribute("custCntcId", params.get("custCntcId"));
    model.addAttribute("selectParam", params.get("selectParam"));
    model.addAttribute("custNric", params.get("_custNric"));
    // infomation param
    model.addAttribute("result", basicinfo);
    model.addAttribute("addresinfo", addresinfo);
    model.addAttribute("contactinfo", contactinfo);
    model.put("mcPaymentUrl", mcPaymentUrl);

    return "sales/customer/customerCreditCardEditPop";
  }

  /**
   *
   * Customer Basic Info (Limitation) Edit 기본 정보 수정
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.07.28
   */

  @RequestMapping(value = "/updateCustomerBasicInfoLimitPop.do")
  public String updateCustomerBasicInfoLimitPop(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap basicinfo = null;
    EgovMap addresinfo = null;
    EgovMap contactinfo = null;

    LOGGER.info("##### customer Basic Limit Edit START #####");
    basicinfo = customerService.selectCustomerViewBasicInfo(params);

    if (null == params.get("custAddId") || "" == params.get("custAddId")) {
      params.put("custAddId", basicinfo.get("custAddId"));
    }

    if (null == params.get("custCntcId") || "" == params.get("custCntcId")) {
      params.put("custCntcId", basicinfo.get("custCntcId"));
    }

    addresinfo = customerService.selectCustomerViewMainAddress(params);
    contactinfo = customerService.selectCustomerViewMainContact(params);

    // page param
    model.addAttribute("custId", params.get("custId"));
    model.addAttribute("custAddId", params.get("custAddId"));
    model.addAttribute("custCntcId", params.get("custCntcId"));
    model.addAttribute("selectParam", params.get("selectParam"));
    // infomation param
    model.addAttribute("result", basicinfo);
    model.addAttribute("addresinfo", addresinfo);
    model.addAttribute("contactinfo", contactinfo);
    // ComboBox params
    if (null != params.get("useDisable")) {
      model.addAttribute("selVisible", "1");
    }

    return "sales/customer/customerBasicLimitEditPop";
  }

  /**
   *
   * Customer Basic Info Edit After 기본 정보 수정 DB Update
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.08.02
   */
  @RequestMapping(value = "/updateCustomerBasicInfoAf.do")
  public ResponseEntity<ReturnMessage> updateCustomerBasicInfoAf(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {
    // Session
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // service
    customerService.updateCustomerBasicInfoAf(params);

    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  /**
   *
   * Customer Address Info Edit Set Main 주소 정보 메인 설정
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.08.02
   */
  @RequestMapping(value = "/updateCustomerAddressSetMain.do")
  public ResponseEntity<ReturnMessage> updateCustomerAddressSetMain(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    LOGGER.info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ " + params.get("custId"));
    // service
    /* customerService.updateCustomerAddressSetActive(params); */
    customerService.updateCustomerAddressSetMain(params);
    // set message
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  /**
   *
   * Customer Address Info Edit Pop up Window 주소 정보 수정창
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.08.02
   */
  @RequestMapping(value = "/updateCustomerAddressInfoPop.do")
  public String updateCustomerAddressInfoPop(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    /*
     * LOGGER.info("팝업창 파라미터 확인 :  custId = " + params.get("custId") +
     * " , custAddId = " + params.get("custAddId"));
     */
    EgovMap detailaddr = null;

    LOGGER.info("##### updateCustomerAddressInfoPop START #####");
    LOGGER.info("### 가져온 파라미터 확인 : " + params.get("editCustAddId"));

    params.put("getparam", params.get("editCustAddId"));

    detailaddr = customerService.selectCustomerAddrDetailViewPop(params);
    LOGGER.info("### DetailAddress 정보 확인  : " + detailaddr.toString());
    int billAddrExist = customerService.billAddrExist(params);
    int installAddrExist = customerService.installAddrExist(params);

    LOGGER.info("##### billAddrExist 확인 : " + billAddrExist);
    LOGGER.info("### installAddrExist 확인 : " + installAddrExist);
    model.addAttribute("detailaddr", detailaddr);
    model.addAttribute("billAddrExistCnt", billAddrExist);
    model.addAttribute("installAddrExistCnt", installAddrExist);

    return "sales/customer/customerAddressEditInfoPop";
  }

  /**
   *
   * Customer Contact Info Edit Set Main 연락처 정보 메인 설정
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.08.02
   */
  @RequestMapping(value = "updateCustomerContactSetMain.do")
  public ResponseEntity<ReturnMessage> updateCustomerContactSetMain(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    // service
    /* customerService.updateCustomerContactSetActive(params); */
    customerService.updateCustomerContactSetMain(params);
    // set message
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  /**
   *
   * Customer Contact Info Edit Pop up Window 주소 정보 수정창
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.08.03
   */
  @RequestMapping(value = "/updateCustomerContactInfoPop.do")
  public String updateCustomerContactInfoPop(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap detailcontact = null;
    LOGGER.info("##### updateCustomerContactInfoPop START #####");
    params.put("getparam", params.get("editCustCntcId"));
    detailcontact = customerService.selectCustomerContactDetailViewPop(params);
    model.addAttribute("detailcontact", detailcontact);

    return "sales/customer/customerContactEditInfoPop";
  }

  /**
   *
   * Customer Contact Info Edit After 연락처 정보 수정 DB Update
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.08.03
   */
  @RequestMapping(value = "/updateCustomerContactInfoAf.do")
  public ResponseEntity<ReturnMessage> updateCustomerContactInfoAf(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    // service
    customerService.updateCustomerContactInfoAf(params);
    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);

  }

  /**
   *
   * Customer Bank Account Info Edit Pop up Window Bank Account 정보 수정창
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.08.03
   */
  @RequestMapping(value = "/updateCustomerBankAccEditInfoPop.do")
  public String updateCustomerBankAccEditInfoPop(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap detailbank = null;
    params.put("getparam", params.get("editCustBankId"));
    detailbank = customerService.selectCustomerBankDetailViewPop(params);

    model.addAttribute("detailbank", detailbank);

    return "sales/customer/customerBankAccEditInfoPop";

  }

  /**
   *
   * Bank Account ComboBox List
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.08.04
   */
  @RequestMapping(value = "/selectAccBank.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectAccBank(@RequestParam Map<String, Object> params) throws Exception {

    LOGGER.debug("groupCode : {}", params.get("groupCode"));

    List<EgovMap> codeList = customerService.selectAccBank(params);
    return ResponseEntity.ok(codeList);
  }

  /**
   *
   * Deduction Channel List
   *
   * @param params
   * @param model
   * @return
   * @author ONGHC 2018.11.29
   */
  @RequestMapping(value = "/selectDdlChnl.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectDdlChnl(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> codeList = customerService.selectDdlChnl(params);
    return ResponseEntity.ok(codeList);
  }

  /**
   *
   * Credit Card ComboBox List
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.08.04
   */
  @RequestMapping(value = "/selectCrcBank.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCrcBank(@RequestParam Map<String, Object> params) throws Exception {

    LOGGER.debug("groupCode : {}", params.get("groupCode"));

    List<EgovMap> codeList = customerService.selectCrcBank(params);

    return ResponseEntity.ok(codeList);
  }

  /**
   *
   * Customer Credit Card 정보 수정 창
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.08.04
   */
  @RequestMapping(value = "/updateCustomerCreditCardInfoPop.do")
  public String updateCustomerCreditCardInfoPop(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap detailcard = null;
    params.put("getparam", params.get("editCustCardId"));
    detailcard = customerService.selectCustomerCreditCardDetailViewPop(params);

    model.addAttribute("detailcard", detailcard);
    model.addAttribute("custId", params.get("custId"));
    model.addAttribute("custNric", params.get("editCustNric"));
    model.addAttribute("pageAuth", params.get("pageAuth"));
    model.put("mcPaymentUrl", mcPaymentUrl);

    return "sales/customer/customerCreditCardEditInfoPop";

  }

  /**
   *
   * Customer Bank Account 정보 수정 창
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.08.04
   */
  @RequestMapping(value = "/updateCustomerBankInfoAf.do")
  public ResponseEntity<ReturnMessage> updateCustomerBankInfoAf(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    // service
    customerService.updateCustomerBankInfoAf(params);
    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  /**
   *
   * Customer Bank Account 정보 수정 창
   *
   * @param params
   * @param model
   * @return
   * @author 이석희 2017.08.04
   */
  @RequestMapping(value = "/updateCustomerCardInfoAf.do")
  public ResponseEntity<ReturnMessage> updateCustomerCardInfoAf(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

	  params.put("custOriCrcNo", params.get("oriCustCrcNo"));
	  params.put("cardExpr", params.get("crcExpDate"));

    // service
    customerService.updateCustomerCardInfoAf(params); //FRANGO CHECK 1CARD 1 CUST

    customerService.tokenCrcUpdate1(params);

    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/deleteCustomerAddress.do")
  public ResponseEntity<ReturnMessage> deleteCustomerAddress(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    // service
    customerService.deleteCustomerAddress(params);
    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/deleteCustomerContact.do")
  public ResponseEntity<ReturnMessage> deleteCustomerContact(@RequestParam Map<String, Object> params)
      throws Exception {

    // service
    customerService.deleteCustomerContact(params);
    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/deleteCustomerBank.do")
  public ResponseEntity<ReturnMessage> deleteCustomerBank(@RequestParam Map<String, Object> params) throws Exception {

    // service
    customerService.deleteCustomerBank(params);
    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/deleteCustomerCard.do")
  public ResponseEntity<ReturnMessage> deleteCustomerCard(@RequestParam Map<String, Object> params) throws Exception {

	//WAWA 11/4/2023 PASSING USER ID
	  SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	 params.put("userId", sessionVO.getUserId());
    // service
    customerService.deleteCustomerCard(params);
    // 결과 만들기 예.

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/updateCustomerAddressInfoAf.do")
  public ResponseEntity<ReturnMessage> updateCustomerAddressInfoAf(@RequestParam Map<String, Object> params)
      throws Exception {

    // service
    customerService.updateCustomerAddressInfoAf(params);
    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  /**
   * Magic Address
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/searchMagicAddressPop.do")
  public String searchMagicAddressPop(@RequestParam Map<String, Object> params, ModelMap model) {

    if (params.get("extype") != null && "INS".equals((String) params.get("extype"))) {
      model.addAttribute("searchStreet", params.get("isearchSt"));
    } else {
      model.addAttribute("searchStreet", params.get("searchSt"));
    }
    model.addAttribute("state", params.get("mState"));
    model.addAttribute("city", params.get("mCity"));
    model.addAttribute("postCode", params.get("mPostCd"));

    // 20191018 - Add KR-SH
    model.addAttribute("searchState", params.get("mState"));
    model.addAttribute("searchCity", params.get("mCity"));


    // 데이터 리턴.
    return "sales/customer/customerMagicAddrPop";
  }

  /**
   * Magic Address
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/searchMagicAddressPopJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> searchMagicAddressPopJsonList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    List<EgovMap> searchMagicAddrList = null;
    // searchStreet
    LOGGER.info("##### searchMagicAddrList START #####");
    searchMagicAddrList = customerService.searchMagicAddressPop(params);

    // 데이터 리턴.
    return ResponseEntity.ok(searchMagicAddrList);
  }

  /**
   * Add new Address(Edit)
   *
   * @param model
   * @param params
   * @return
   */
  @RequestMapping(value = "/updateCustomerNewAddressPop.do")
  public String updateCustomerNewAddressPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    model.addAttribute("insCustId", params.get("custId"));

    // Page Param
    model.addAttribute("callParam", params.get("callParam"));

    return "sales/customer/customerNewAddressPop";
  }

  /**
   * Add new Contact(Edit)
   *
   * @param model
   * @param params
   * @return
   */
  @RequestMapping(value = "/updateCustomerNewContactPop.do")
  public String updateCustomerNewContactPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    model.addAttribute("insCustId", params.get("custId"));

    // Page Param
    model.addAttribute("callParam", params.get("callParam"));

    return "sales/customer/customerNewContactPop";
  }

  /**
   * Add new Contact(Edit)
   *
   * @param model
   * @param params
   * @return
   */
  @RequestMapping(value = "/updateCustomerNewContactPopeSales.do")
  public String updateCustomerNewContactPopeSales(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    model.addAttribute("insCustId", params.get("custId"));

    // Page Param
    model.addAttribute("callParam", params.get("callParam"));

    return "sales/customer/customerNewContactPopeSales";
  }

  /**
   * Add new Contact(Edit)
   *
   * @param model
   * @param params
   * @return
   */
  @RequestMapping(value = "/updateCustomerNewAddContactPop.do")
  public String updateCustomerNewAddContactPop(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    model.addAttribute("insCustId", params.get("custId"));

    // Page Param
    model.addAttribute("callParam", params.get("callParam"));

    return "sales/customer/customerNewAddContactPop";
  }

  /**
   * Add new Bank Account(Edit)
   *
   * @param model
   * @param params
   * @return
   */
  @RequestMapping(value = "/updateCustomerNewBankPop.do")
  public String updateCustomerNewBankPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    model.addAttribute("insCustId", params.get("custId"));

    return "sales/customer/customerNewBankPop";
  }

  /**
   * Add new Card Account(Edit)
   *
   * @param model
   * @param params
   * @return
   */
  @RequestMapping(value = "/updateCustomerNewCardPop.do")
  public String updateCustomerNewCardPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    model.addAttribute("insCustId", params.get("custId"));

    if(params.containsKey("_custNric")) {
        model.addAttribute("insNric", params.get("_custNric"));
    } else {
        model.addAttribute("insNric", customerService.getCustNric(params));
    }

    model.put("mcPaymentUrl", mcPaymentUrl);
    return "sales/customer/customerNewCardPop";
  }

  /**
   * Add new Address(Edit) After
   *
   * @param params
   * @return
   */
  @RequestMapping(value = "/insertCustomerAddressInfoAf.do")
  public ResponseEntity<ReturnMessage> insertCustomerAddressInfoAf(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("custId", params.get("insCustId"));

    int custAddrExist = customerService.selectCustomerAddressJsonList(params).size();

    params.put("stusId", custAddrExist < 1 ? 9 : 1);
    int custAddId = customerService.insertCustomerAddressInfoAf(params);

    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setData(custAddId);

    return ResponseEntity.ok(message);
  }

  /**
   * Add new Contact(Edit) After
   *
   * @param params
   * @return
   */
  @RequestMapping(value = "/insertCustomerContactAddAf.do")
  public ResponseEntity<ReturnMessage> insertCustomerContactAddAf(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    int custCntcId = customerService.insertCustomerContactAddAf(params);

    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setData(custCntcId);

    return ResponseEntity.ok(message);
  }

  /**
   *
   * Basic Customer Info 등록
   *
   * @param params
   * @param model.
   * @return
   * @author
   */
  @RequestMapping(value = "/insertCareContactInfo.do")
  public ResponseEntity<ReturnMessage> insertCareContactInfo(@RequestParam Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {

    int custCareCntId = customerService.getCustCareCntIdSeq();

    params.put("getCustCareCntId", custCareCntId);
    params.put("getCustId", params.get("custId"));
    params.put("custInitial", params.get("cntcInitial"));
    params.put("asCustName", params.get("cntcName"));
    params.put("asTelM", params.get("cntcTelm"));
    params.put("asTelO", params.get("cntcTelo"));
    params.put("asTelR", params.get("cntcTelr"));
    params.put("asTelF", params.get("cntcTelf"));
    params.put("asExt", params.get("cntcExtNo"));
    params.put("asEmail", params.get("cntcEmail"));
    params.put("stusCodeId", SalesConstants.STATUS_ACTIVE);
    params.put("crtUserId", sessionVO.getUserId());
    params.put("updUserId", sessionVO.getUserId());

    customerService.insertCareContactInfo(params);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage("New contact successfully saved.");
    message.setData(custCareCntId);

    return ResponseEntity.ok(message);
  }

  /**
   * Add new Bank(Edit) After
   *
   * @param params
   * @return
   */
  @RequestMapping(value = "/insertCustomerBankAddAf.do")
  public ResponseEntity<ReturnMessage> insertCustomerBankAddAf(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    customerService.insertCustomerBankAddAf(params);

    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);

  }

  /**
   * Add new Credit Card(Edit) After
   *
   * @param params
   * @return
   */
  @RequestMapping(value = "/insertCustomerCardAddAf.do")
  public ResponseEntity<ReturnMessage> insertCustomerCardAddAf(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

      LOGGER.debug("insertCustomerCardAddAf.do");
      LOGGER.info("Params :: " + params.toString());

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    int custCrcId = customerService.getCustCrcId();
    params.put("custCrcId", custCrcId);

    customerService.insertCustomerCardAddAf(params); //FRANGO CHECk
	customerService.tokenCrcUpdate1(params);

    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/selectCustomerCopyAddressJson")
  public ResponseEntity<EgovMap> selectCustomerCopyAddressJson(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap addrMap = null;

    addrMap = customerService.selectCustomerAddrDetailViewPop(params);

    return ResponseEntity.ok(addrMap);
  }

  @RequestMapping(value = "/selectCustomerCopyContactJson")
  public ResponseEntity<EgovMap> selectCustomerCopyContactJson(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap contactMap = null;

    contactMap = customerService.selectCustomerContactDetailViewPop(params);

    return ResponseEntity.ok(contactMap);
  }

  @RequestMapping(value = "/selectCustomerMainAddr")
  public ResponseEntity<EgovMap> selectCustomerMainAddr(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap mainAddidMap = null;
    mainAddidMap = customerService.selectCustomerMainAddr(params);

    return ResponseEntity.ok(mainAddidMap);
  }

  @RequestMapping(value = "/selectCustomerMainContact")
  public ResponseEntity<EgovMap> selectCustomerMainContact(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap mainContactidMap = null;
    mainContactidMap = customerService.selectCustomerMainContact(params);

    return ResponseEntity.ok(mainContactidMap);
  }

  @RequestMapping(value = "/selectMagicAddressComboList")
  public ResponseEntity<List<EgovMap>> selectMagicAddressComboList(@RequestParam Map<String, Object> params)
      throws Exception {

    List<EgovMap> postList = null;

    postList = customerService.selectMagicAddressComboList(params);

    return ResponseEntity.ok(postList);

  }

  @RequestMapping(value = "/getAreaId.do")
  public ResponseEntity<EgovMap> getAreaId(@RequestParam Map<String, Object> params) throws Exception {

    EgovMap areaMap = null;

    areaMap = customerService.getAreaId(params);

    return ResponseEntity.ok(areaMap);
  }

  @RequestMapping(value = "/getNationList")
  public ResponseEntity<List<EgovMap>> getNationList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> nationList = null;

    nationList = customerService.getNationList(params);

    return ResponseEntity.ok(nationList);

  }

  @RequestMapping(value = "/updateLimitBasicInfo")
  public ResponseEntity<ReturnMessage> updateLimitBasicInfo(@RequestBody Map<String, Object> params) throws Exception {

    // Session
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());

    LOGGER.info("############################################################");
    LOGGER.info("########  Params : " + params.toString());
    LOGGER.info("############################################################");

    customerService.updateLimitBasicInfo(params);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/customerAddBankAccountMemPop.do")
  public String customerAddBankAccountMemPop(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> accBankList = customerService.selectAccBank(params);
    model.addAttribute("accBankList", accBankList);
    model.put("custId", params.get("custId"));

    return "sales/customer/customerBankAccountMemPop";
  }

  @RequestMapping(value = "/checkCrc.do", method = RequestMethod.GET)
  public ResponseEntity<Integer> checkCrc(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) throws Exception {

    LOGGER.debug("checkCrc.do :: start");
    LOGGER.debug("params :: " + params);

    int rtnCrc = 0;

    if ("NC".equals(params.get("src").toString())) {
      String cardExp = params.get("expDate").toString().substring(0, 2)
          + params.get("expDate").toString().substring(5, 7);
      params.put("expDate", cardExp);
    }

    /*
     * Step 1 - Check Credit Card number count If Credit Card count > 0, proceed
     * saving Else proceed step 2
     */
    LOGGER.info("checkCRC :: step 1");
    EgovMap step1 = (EgovMap) customerService.checkCRC1(params);
    LOGGER.info("checkCRC :: step 1 :: " + step1.get("cnt").toString());
    if (!"0".equals(step1.get("cnt").toString())) {

      /*
       * Step 2 - Check Credit Card number's cust_id's NRIC If Existing Credit
       * card belongs to > 1 cust nric, stop Else proceed step 3
       */

      LOGGER.info("checkCRC :: step 2");
      EgovMap step2 = (EgovMap) customerService.checkCRC2(params);
      LOGGER.info("checkCRC :: step 2 :: " + step2.get("cnt").toString());
      if ("1".equals(step2.get("cnt").toString())) {

        /*
         * Step 3 - Check Credit Card number's to PASSED IN nric If Existing
         * Credit card == PASSED IN nric procced save Else stop
         */

        params.put("step", "3");

        LOGGER.info("checkCRC :: step 3");
        EgovMap step3 = (EgovMap) customerService.checkCRC2(params);
        LOGGER.info("checkCRC :: step 3 :: " + step3.get("cnt").toString());
        if (!"1".equals(step3.get("cnt").toString())) {
          // 0 = NRIC does not match; 1 = NRIC match
          rtnCrc = 3;
        }
      } else {
        rtnCrc = 2;
      }
    }

    LOGGER.info("checkCRC :: rtnCrc :: " + rtnCrc);

    return ResponseEntity.ok(rtnCrc);
  }

  @RequestMapping(value = "/selectCustomerOrderList.do")
  public String selectCustomerOrderList(@ModelAttribute("customerVO") CustomerVO customerVO,
      @RequestParam Map<String, Object> params, ModelMap model) {

    return "sales/order/customerCheckingList";
  }

  @RequestMapping(value = "/selectCustomerCheckingList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCustomerCheckingList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    List<EgovMap> customerList = null;

    LOGGER.info("##### customerList START #####");
    customerList = customerService.selectCustomerCheckingList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(customerList);
  }

  @RequestMapping(value = "/selectCustomerOrderView.do")
  public String selectCustomerOrderView(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    EgovMap basicinfo = null;
    EgovMap agingmonth = null;
    // EgovMap icare = null;
    EgovMap rentInst = null;
    EgovMap pairOrdId = null;
    String valid = null;
    BigDecimal valiOutStanding;
    BigDecimal rentInstNo;
    int oldId;
    String icare;
    String instAdd = "";

    LOGGER.info("##### customeView START #####");
    basicinfo = customerService.selectCustomerCheckingListPop(params);
    agingmonth = customerService.selectCustomerAgingMonth(params);
    rentInst = customerService.selectCustomerRentInst(params);
    oldId = customerService.selectCustomerOldId(params);

    // String icare = (String)basicinfo.get("iCare");
    if (oldId > 0) {
      pairOrdId = customerService.selectPairOrdId(params);
      int salesOrdId = Integer.parseInt(String.valueOf(pairOrdId.get("salesOrdId")));
      String address = pairOrdId.get("instAdd").toString();
      EgovMap resultMap = this.selectSalesOrderM(salesOrdId, 0);
      String salesOrdNo = resultMap.get("salesOrdNo").toString();

      icare = "Yes (Order No: " + salesOrdNo + ")";
      //instAdd = address;
    } else {
      icare = "No";
      //instAdd = "";
    }
    String rentStatus = (String) basicinfo.get("rentStus");
    String stkCategory = (String) basicinfo.get("stkCategory");
    if (agingmonth != null) {
      valiOutStanding = (BigDecimal) agingmonth.get("agingMth");
      valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);
    } else {
      valiOutStanding = BigDecimal.ZERO;
    }
    if (rentInst != null) {
      rentInstNo = (BigDecimal) rentInst.get("rentInstNo");

    } else {
      rentInstNo = BigDecimal.ZERO;

    }

    int apptypeId = Integer.parseInt(String.valueOf(basicinfo.get("appTypeId")));
    int custtypeid = Integer.parseInt(String.valueOf(basicinfo.get("custTypeId")));
    String payMode = basicinfo.get("payModeCode").toString();

    if ("REG".equals(rentStatus) &&
        "No".equals(icare) &&
        "WP".equals(stkCategory) &&
        rentInstNo.compareTo(BigDecimal.valueOf(6)) == 1 &&
        apptypeId == 66 &&
        valiOutStanding.compareTo(BigDecimal.valueOf(2)) == -1 &&
        custtypeid == 964 &&
        !payMode.equals("REG")
        ) {
      valid = "Yes";
    } else {
      valid = "No";
    }

    // ajax param
    model.addAttribute("ordId", params.get("ordId"));

    // infomation param
    model.addAttribute("result", basicinfo);
    model.addAttribute("aging", agingmonth);
    model.addAttribute("verify", valid);
    model.addAttribute("icare", icare);
    //model.addAttribute("address", instAdd);

    return "sales/order/customerCheckingViewPop";
  }

  private EgovMap selectSalesOrderM(int ordId, int appTypeId) {
    Map<String, Object> params = new HashMap<String, Object>();

    params.put("salesOrdId", ordId);
    params.put("appTypeId", appTypeId);

    EgovMap result = orderRegisterMapper.selectSalesOrderM(params);

    return result;
  }

  @RequestMapping(value = "/existingHPCodyMobile", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> existingHPCodyMobile(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

	  EgovMap existingHP = customerService.existingHPCodyMobile(params);

    // 데이터 리턴.
    return ResponseEntity.ok(existingHP);
  }

  @RequestMapping(value="/tokenPubKey.do", method=RequestMethod.GET)
  public ResponseEntity<EgovMap> tokenPubKey(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

      EgovMap pKey = customerService.getPubKey();

      return ResponseEntity.ok(pKey);
  }

  @RequestMapping(value="/tokenLogging.do", method = RequestMethod.GET)
  public ResponseEntity<Map<String, Object>> tokenLogging(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {

      int tknId = 0;
      String refNo;
      Map<String, Object> result = new HashMap();

      LOGGER.debug("params :: " + params);

      String nric = params.get("nric").toString();

      if(!"".equals(nric)) {

          SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
          params.put("userId", sessionVO.getUserId());

          // Get token ID
          tknId = (Integer) customerService.getTokenID();
          result.put("tknId", tknId);

          // Construct RefNO for tokenization's reference
          /*
           * NN :: New Customer > New CRC :: NRIC
           * EN :: Edit Customer > New CRC :: NRIC + Cust ID
           * EE :: Edit Customer > Edit CRC :: NRIC + Cust ID + Cust CRC ID
           */

          String r1 = "";
          String r2 = "";
          String r3= "";

          if(nric.length() < 12) {
              r1 = StringUtils.leftPad(nric, 12, "0");
          } else {
              r1 = nric.substring(nric.length() - 12);
          }

          if("NN".equals(params.get("etyPoint").toString())) {
              r2 = StringUtils.leftPad("", 10, "0");
              r3 = StringUtils.leftPad("", 10, "0");

          } else if("EN".equals(params.get("etyPoint").toString()) || "EE".equals(params.get("etyPoint").toString())) {
              if(params.get("custId").toString().length() < 10) {
                  r2 = StringUtils.leftPad(params.get("custId").toString(), 10, "0");
                  r3 = StringUtils.leftPad("", 10, "0");
              } else {
                  r2 = params.get("custId").toString();
                  r3 = StringUtils.leftPad("", 10, "0");
              }

              if("EE".equals(params.get("etyPoint").toString())) {
                  if(params.get("custCrcId").toString().length() < 10) {
                      r3 = StringUtils.leftPad(params.get("custCrcId").toString(), 10, "0");
                  } else {
                      r3 = params.get("custCrcId").toString();
                  }
              }
          }

          refNo = r1 + r2 + r3;
          result.put("refNo", refNo);

          // Creating reference number
          EgovMap tokenSettings = customerService.getTokenSettings();
          String urlReq = tokenSettings.get("tknzUrl").toString();
          String merchantId = tokenSettings.get("tknzMerchantId").toString();
          String verfKey = tokenSettings.get("tknzVerfKey").toString();

          // Get Encrypted credit card information
          String ccNum = params.get("PAN").toString();
          String expYear = params.get("EXPYEAR").toString();
          String expMonth = params.get("EXPMONTH").toString();

          // Hashing SHA-256 - Start
          String signature = merchantId + refNo + ccNum + expMonth + expYear + "1" + verfKey;

          MessageDigest md = MessageDigest.getInstance("SHA-256");
          byte[] hashInBytes = md.digest(signature.getBytes(StandardCharsets.UTF_8));

          StringBuilder sb = new StringBuilder();
          for(byte b : hashInBytes) {
              sb.append(String.format("%02x", b));
          }

          signature = sb.toString();
          // Hashing SHA-256 - End

          params.put("tknId", tknId);
          params.put("refNo", refNo);
          params.put("signature", signature);

          // Insert Log
          customerService.insertTokenLogging(params);

          result.put("urlReq", urlReq);
          result.put("merchantId", merchantId);
          result.put("signature", signature);
      }

      return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/tokenizationProcess.do", method = RequestMethod.GET)
  public ResponseEntity <Map<String, Object>> tokenizationProcess(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{
      LOGGER.error("======================================= tokenizationProcess =======================================");
      LOGGER.error("params :: " + params);

      Map<String, Object> result = new HashMap();

      if(!"".equals(params.get("tknId").toString())) {
          LOGGER.error("tokenizationProcess :: 1");

          // Requesting tokenization from RazerPay
          //URL url = new URL(urlReq);
          TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
                public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                    return null;
                }

                public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType) {
                }

                public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType) {
                }
          } };
          SSLContext sslContext = SSLContext.getInstance("SSL");
          sslContext.init(null, trustAllCerts, null);

//          SSLContext sslContext = SSLContext.getInstance("TLSv1.2");
//          sslContext.init(null, null, new SecureRandom());

          URL url = new URL(null, params.get("urlReq").toString(), new sun.net.www.protocol.https.Handler());
          URLConnection con = url.openConnection();
          con.setRequestProperty("User-Agent", "Mozilla/5.0");
          HttpsURLConnection http = (HttpsURLConnection) con;
          http.setSSLSocketFactory(sslContext.getSocketFactory());
          http.setHostnameVerifier(new HostnameVerifier() {
              @Override
              public boolean verify(String s, SSLSession sslSession) {
                  return true;
              }
          } );
          http.setRequestMethod("POST");
          http.setDoOutput(true);

          Map<String, String> requestParam = new HashMap<>();
          requestParam.put("merchantID", params.get("merchantId").toString());
          requestParam.put("referenceNo", params.get("refNo").toString());
          requestParam.put("billingName", params.get("nameCard").toString());
          requestParam.put("billingEmail", params.get("refNo").toString().substring(12, 22)); // << Change
          requestParam.put("billingMobile", params.get("refNo").toString().substring(22)); // << Change
          requestParam.put("creditCardNo", params.get("PAN").toString());
          requestParam.put("expMonth", params.get("EXPMONTH").toString());
          requestParam.put("expYear", params.get("EXPYEAR").toString());
          requestParam.put("tokenType", "1");
          requestParam.put("signature", params.get("signature").toString());

          LOGGER.error(requestParam.toString());
          LOGGER.error("tokenizationProcess :: 2");

          StringJoiner sj = new StringJoiner("&");
          for(Map.Entry<String,String> entry : requestParam.entrySet())
              sj.add(URLEncoder.encode(entry.getKey(), "UTF-8") + "=" + URLEncoder.encode(entry.getValue(), "UTF-8"));
          byte[] out = sj.toString().getBytes(StandardCharsets.UTF_8);
          int length = out.length;

          LOGGER.error("tokenizationProcess :: 3");
          http.setFixedLengthStreamingMode(length);
          LOGGER.error("tokenizationProcess :: 3.1");
          http.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
          LOGGER.error("tokenizationProcess :: 3.2");
          http.connect();
          LOGGER.error("tokenizationProcess :: 3.3");
          try(OutputStream os = http.getOutputStream()) {
              os.write(out);
              LOGGER.error(os.toString());
              LOGGER.error("tokenizationProcess :: 3.3.1");
          }
          LOGGER.debug("tokenizationProcess :: 3.4");

          LOGGER.debug("tokenizationProcess :: 4");
          BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
          String inputLine = in.readLine();
          in.close();

          LOGGER.error("tokenizationProcess :: 5");

          Map<String, Object> retResult = new HashMap();

          retResult.put("tknId", params.get("tknId"));
          retResult.put("resText", inputLine);
          inputLine = inputLine.replaceAll("[\\{\"\\}]", "");

          String[] arr1 = inputLine.split(",");

          for(int i = 0; i < arr1.length; i++) {
              String[] arr2 = arr1[i].split(":");
              retResult.put(arr2[0], arr2[1]);
          }

          if(!retResult.containsKey("error_code")) {
              LOGGER.error("successful tokenization");
              retResult.put("stus", "1");

              customerService.updateTokenLogging(retResult);

              result.put("stus", "1");

              String crcNo = retResult.get("BIN").toString() + "******" + retResult.get("cclast4").toString();
              result.put("crcNo", crcNo);
              result.put("token", retResult.get("token").toString());

              Map<String, Object> crcParam = new HashMap<>();
              crcParam.put("cardNo", retResult.get("BIN").toString() + "%" + retResult.get("cclast4").toString());
              crcParam.put("nric", params.get("refNo").toString().substring(0, 12));
              crcParam.put("custId", params.get("refNo").toString().substring(12, 22).replaceFirst("^0+(?!$)", ""));
              crcParam.put("custCrcId", params.get("refNo").toString().substring(22).replaceFirst("^0+(?!$)", ""));
              crcParam.put("token", retResult.get("token"));

              // Check CRC's 1st 6 digits, last 4 digits
              // Pending to check if needed to add expiry date + name for checking
              int step1 = (Integer) customerService.tCheckCRC1(crcParam);
              if (step1 != 0) {
                  if(!"EE".equals(params.get("etyPoint"))) {
                      int step2 = (Integer) customerService.tCheckCRC2(crcParam);

                      if (step2 >= 1) {
                          crcParam.put("step", "3");
                          int step3 = (Integer) customerService.tCheckCRC2(crcParam);

                          if (step3 >= 1) {
                              result.put("crcCheck", "3");
                              result.put("errorDesc", "This Bank card number is used by another customer.</br>Please inform respective HP/Cody.");

                          } else {
                              result.put("crcCheck", "0");
                          }
                      } else {
                          result.put("crcCheck", "0");
                      }
                  } else {
                      result.put("crcCheck", "0");
                  }
              } else {
                  result.put("crcCheck", "0");
              }

          } else {
              LOGGER.error("failed tokenization");
              retResult.put("stus", "21");

              customerService.updateTokenLogging(retResult);
              customerService.insertTokenError(retResult);

              result.put("stus", "21");
              if("T9".equals(retResult.get("error_code"))) {
                  result.put("errorDesc", "Invalid credit card.");
              } else {
                  result.put("errorDesc", retResult.get("error_desc"));
              }
          }
      }

      return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/tokenCrcUpdate.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> tokenCrcUpdate(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) throws Exception{
      LOGGER.debug("params :: " + params);

      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
      params.put("userId", sessionVO.getUserId());

//      customerService.tokenCrcUpdate(params);

      ReturnMessage message = new ReturnMessage();
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

      return ResponseEntity.ok(message);
  }

  /**
   * tokenCustCrcTest
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/tokenCustCrcTest.do")
  public String tokenCustCrcTest(@RequestParam Map<String, Object> params, ModelMap model) {
      LOGGER.info("##### tokenCustCrcTest START #####");

      List<EgovMap> bankList = customerService.selectIssueBank(params);
      model.addAttribute("bankList", bankList);
      model.addAttribute("nric", params.get("nric"));
      model.put("mcPaymentUrl", mcPaymentUrl);

      return "sales/customer/tokenCustomerCreditCardTest";
    }

  @RequestMapping(value = "/getTknId.do", method = RequestMethod.GET)
  public ResponseEntity<Map<String, Object>> getTknId(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model)throws Exception {
      LOGGER.debug("/getTknId.do");
      LOGGER.debug("params :: " + params);

      int tknId = 0;
      Map<String, Object> result = new HashMap();

      tknId = (Integer) customerService.getTokenID();
      result.put("tknId", tknId);
      result.put("tknRef", params.get("refId") + StringUtils.leftPad(Integer.toString(tknId), 10, "0"));
      LOGGER.debug("getTknID.do :: TknRef");

      customerService.insertTokenLogging(result);

      return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/getTokenNumber.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> getTokenNumber(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model)throws Exception {
      LOGGER.debug("getTokenNumber.do");
      LOGGER.debug("params :: " + params);

      //Map<String, Object> result = new HashMap();
      Map<String, Object> result = customerService.getTokenNumber(params);

      if(result == null){
          customerService.updateTokenStagingF(params);
      }

      if(result != null && result.get("token") != null){
          boolean isCreditCardValid = customerService.checkCreditCardValidity(result.get("token").toString());
          if(isCreditCardValid == false) {
              customerService.updateTokenStagingF(params);

        	  ReturnMessage message = new ReturnMessage();
              message.setCode(AppConstants.FAIL);
              message.setData(result);
              message.setMessage( "This card has marked as \'Transaction Not Allowed\'  <span style='color:red'>(TNA)</span>. Kindly change a new card");

              return ResponseEntity.ok(message);
          }
      }

      ReturnMessage message = new ReturnMessage();
      message.setCode(AppConstants.SUCCESS);
      message.setData(result);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

      return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/customerEditDeactivatePop.do")
  public String customerEditDeactivatePop(@RequestParam Map<String, Object> params, Model model) {

    model.addAttribute("custInfo",params);

    return "sales/customer/customerEditDeactivatePop";
  }

  @RequestMapping(value = "/validCustStatus.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> validCustStatus(@RequestParam Map<String, Object> params)throws Exception {

      EgovMap result = customerService.validCustStatus(params);

      return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/updateCustStatus.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateCustStatus(@RequestBody Map<String, Object> params, SessionVO sessionVO)throws Exception {

    System.out.println(params);
    params.put("userId",sessionVO.getUserId());

    int record = customerService.updateCustStatus(params);

    ReturnMessage message = new ReturnMessage();
    if(record > 0){
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    }else{
      message.setCode(AppConstants.FAIL);
      message.setMessage("Fail to update due to record had been updated by other user.");
    }

    return ResponseEntity.ok(message);
  }

  //Jonathan Ting Credit Card Check Module start
	@RequestMapping(value = "/checkCreditCard.do")
	public String checkCreditCardOwner(@RequestParam Map<String, Object>params, ModelMap model) {
		model.put("mcPaymentUrl", mcPaymentUrl);
		return "/sales/customer/checkCreditCard";
	}

	@RequestMapping(value = "/searchCreditCard.do")
	public ResponseEntity<List<EgovMap>> searchCreditCard(@RequestParam Map<String, Object>params, ModelMap model) {
		List<EgovMap> result = null;
		params.put("tokenId", params.get("tokenID").toString());
		result = customerService.searchCreditCard(params);
		return ResponseEntity.ok(result);
	}
//Credit Card Check Module end

	@RequestMapping(value = "/checkActTokenByCustCrcId")
	public ResponseEntity<Boolean> isActTokenId(@RequestParam Map<String, Object> params) throws Exception {
		boolean result = false;

	    LOGGER.debug("checkActTokenByCustCrcId params : {}", params.toString());
	    result = customerService.getCountActTokenId(params);

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/checkDeleteAccess")
	public  ResponseEntity<Boolean>  checkDeleteAccess(@RequestParam Map<String, Object> params) throws Exception {
		boolean result = false;

		LOGGER.debug("getAutoDebitUserId params : {}", params.toString());
		result = customerService.getAutoDebitUserId(params);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/checkCreditCardNoExp.do")
	public String checkCreditCardOwnerNoExp(@RequestParam Map<String, Object>params, ModelMap model) {
		return "/sales/customer/checkCreditCardNoExp";
	}

	@RequestMapping(value = "/searchCreditCardNoExp.do")
	public ResponseEntity<List<EgovMap>> searchCreditCardNoExp(@RequestParam Map<String, Object>params, ModelMap model){
		return ResponseEntity.ok(customerService.searchCreditCardNoExp(params));
	}

	  @RequestMapping(value = "/selectCustomerStatusHistoryLogJsonList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectCustomerStatusHistoryLogJsonList(@RequestParam Map<String, Object> params,
	      HttpServletRequest request, ModelMap model) {
//#{custId}
	    List<EgovMap> custStusHistLog = null;

	    LOGGER.info("##### custStusHistLog START #####");
	    custStusHistLog = customerService.selectCustomerStatusHistoryLogList(params);

	    // 데이터 리턴.
	    return ResponseEntity.ok(custStusHistLog);
	  }

	  @RequestMapping(value = "/selectCustomerBasicInfoHistoryLogJsonList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectCustomerBasicInfoHistoryLogJsonList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		  List<EgovMap> custBasicInfoHistLog = null;

		  LOGGER.info("##### custBasicInfoHistLog START #####");
		  custBasicInfoHistLog = customerService.selectCustomerBasicInfoHistoryLogList(params);

		  // 데이터 리턴.
		  return ResponseEntity.ok(custBasicInfoHistLog);
	  }

		@RequestMapping(value = "/checkBlackArea")
		public ResponseEntity<Boolean> isBlackArea(@RequestParam Map<String, Object> params) throws Exception {
			boolean result = false;

		    LOGGER.debug("checkBlackArea params : {}", params.toString());
		    result = customerService.getBlackArea(params);

			return ResponseEntity.ok(result);
		}

		  @RequestMapping(value = "/blacklistedAreaWithProductCategory.do")
		  public String blacklistedAreaWithProductCategoryList(@RequestParam Map<String, Object> params) {
		    return "/sales/customer/blacklistedAreaWithProductCategory";
		  }

		  @RequestMapping(value = "/selectBlacklistedAreawithProductCategoryList.do")
		  public ResponseEntity<List<EgovMap>> selectTokenIdMaintain(@RequestParam Map<String, Object> params) {

		    List<EgovMap> resultList = customerService.selectBlacklistedAreawithProductCategoryList(params);
		    return ResponseEntity.ok(resultList);
		  }


}
