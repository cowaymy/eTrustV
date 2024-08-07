package com.coway.trust.biz.sales.customer.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.coway.trust.biz.sales.customer.CustomerBVO;
import com.coway.trust.biz.sales.customer.CustomerCVO;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.order.vo.CustAccVO;
import com.coway.trust.biz.sales.order.vo.CustCrcVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("customerService")
public class CustomerServiceImpl extends EgovAbstractServiceImpl implements CustomerService {

  private static final Logger LOGGER = LoggerFactory.getLogger(CustomerServiceImpl.class);

  @Resource(name = "customerMapper")
  private CustomerMapper customerMapper;

  @Autowired
  private MessageSourceAccessor messageSourceAccessor;

  /**
   * 글 목록을 조회한다.
   *
   * @param CustomerVO
   *          - 조회할 정보가 담긴 VO
   * @return 글 목록
   * @exception Exception
   */
  @Override
  public List<EgovMap> selectCustomerList(Map<String, Object> params) {

    return customerMapper.selectCustomerList(params);
  }

  @Override
  public List<EgovMap> selectCustomerStatusHistoryLogList(Map<String, Object> params) {

    return customerMapper.selectCustomerStatusHistoryLogList(params);
  }

  /**
   * 상세화면 조회한다.(Basic Info)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.20
   */
  @Override
  public EgovMap selectCustomerViewBasicInfo(Map<String, Object> params) {

    return customerMapper.selectCustomerViewBasicInfo(params);
  }

  //////////////////////////////////////////////////  CHECK_EXIST_NRIC  ///////////////////////////////////////////////////

  public EgovMap checkNricExist(Map<String, Object> params) throws Exception {

	    EgovMap outMap = customerMapper.selectNricExist(params);

	    return outMap;
	  }

  //////////////////////////////////////////////////  CHECK_EXIST_NRIC  ///////////////////////////////////////////////////

  /**
   * 상세화면 조회한다. (Main Address)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.20
   */
  @Override
  public EgovMap selectCustomerViewMainAddress(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerViewMainAddress(params);
  }

  /**
   * 상세화면 조회한다. (Main Contact)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.20
   */
  @Override
  public EgovMap selectCustomerViewMainContact(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerViewMainContact(params);
  }

  /**
   * 상세화면 조회한다. (Address List)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.20
   */
  @Override
  public List<EgovMap> selectCustomerAddressJsonList(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerAddressJsonList(params);
  }

  /**
   * 상세화면 조회한다. (Contact List)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.21
   */
  @Override
  public List<EgovMap> selectCustomerContactJsonList(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerContactJsonList(params);
  }

  /**
   * 상세화면 조회한다. (Contact List)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.21
   */
  @Override
  public List<EgovMap> selectCustCareContactList(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustCareContactList(params);
  }

  /**
   * 상세화면 조회한다. (Contact List)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.21
   */
  @Override
  public List<EgovMap> selectBillingGroupByKeywordCustIDList(Map<String, Object> params) throws Exception {

    List<EgovMap> result = customerMapper.selectBillingGroupByKeywordCustIDList(params);

    List<EgovMap> resultNew = new ArrayList<>();

    for (EgovMap eMap : result) {

      String billAddrFull = "";
      String billType = "";
      /*
       * if(CommonUtils.isNotEmpty(eMap.get("addrDtl"))) billAddrFull +=
       * eMap.get("addrDtl") + " ";
       * if(CommonUtils.isNotEmpty(eMap.get("street"))) billAddrFull +=
       * eMap.get("street") + " ";
       * if(CommonUtils.isNotEmpty(eMap.get("postcode"))) billAddrFull +=
       * eMap.get("postcode") + " ";
       * if(CommonUtils.isNotEmpty(eMap.get("locality"))) billAddrFull +=
       * eMap.get("locality") + " ";
       * if(CommonUtils.isNotEmpty(eMap.get("region2"))) billAddrFull +=
       * eMap.get("region2") + " ";
       * if(CommonUtils.isNotEmpty(eMap.get("region1"))) billAddrFull +=
       * eMap.get("region1") + " ";
       */
      if (CommonUtils.isNotEmpty(eMap.get("addrDtl")))
        billAddrFull += eMap.get("addrDtl") + " ";
      if (CommonUtils.isNotEmpty(eMap.get("street")))
        billAddrFull += eMap.get("street") + " ";
      if (CommonUtils.isNotEmpty(eMap.get("area")))
        billAddrFull += eMap.get("area") + " ";
      if (CommonUtils.isNotEmpty(eMap.get("postcode")))
        billAddrFull += eMap.get("postcode") + " ";
      if (CommonUtils.isNotEmpty(eMap.get("city")))
        billAddrFull += eMap.get("city") + " ";
      if (CommonUtils.isNotEmpty(eMap.get("state")))
        billAddrFull += eMap.get("state") + " ";
      if (CommonUtils.isNotEmpty(eMap.get("country")))
        billAddrFull += eMap.get("country") + " ";

      if (((BigDecimal) eMap.get("custBillIsPost")).compareTo(BigDecimal.ONE) == 0) {
        billType += "Post";
      }
      if (((BigDecimal) eMap.get("custBillIsSms")).compareTo(BigDecimal.ONE) == 0) {
        billType += CommonUtils.isNotEmpty(billType) ? ",SMS" : "SMS";
      }
      if (((BigDecimal) eMap.get("custBillIsEstm")).compareTo(BigDecimal.ONE) == 0) {
        billType += CommonUtils.isNotEmpty(billType) ? ",EStatement" : "EStatement";
      }

      eMap.put("billAddrFull", billAddrFull);
      eMap.put("billType", billType);

      resultNew.add(eMap);
    }

    return resultNew;
  }

  /**
   * 상세화면 조회한다. (Bank List)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.21
   */
  @Override
  public List<EgovMap> selectCustomerBankAccJsonList(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerBankAccJsonList(params);
  }

  /**
   * 상세화면 조회한다. (Card List)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.21
   */
  @Override
  public List<EgovMap> selectCustomerCreditCardJsonList(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerCreditCardJsonList(params);
  }

  /**
   * 상세화면 조회한다. (Own Order List)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.21
   */
  @Override
  public List<EgovMap> selectCustomerOwnOrderJsonList(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerOwnOrderJsonList(params);
  }

  /**
   * 상세화면 조회한다. (Third Party Order List)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.21
   */
  @Override
  public List<EgovMap> selectCustomerThirdPartyJsonList(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerThirdPartyJsonList(params);
  }

  /**
   * 상세화면 조회한다. (Coway Rewards List)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2022.11.29
   */
  @Override
  public List<EgovMap> selectCustomerCowayRewardsJsonList(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerCowayRewardsJsonList(params);
  }

  /**
   * 상세화면 조회한다. (Detail Address View)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.24
   */
  @Override
  public EgovMap selectCustomerAddrDetailViewPop(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerAddrDetailViewPop(params);
  }

  @Override
  public int getCustCareCntIdSeq() {

    int getCustCareCntId = customerMapper.getCustCareCntIdSeq();

    return getCustCareCntId;
  }

  /**
   * NRIC / Company No 중복체크
   *
   * @param
   * @return
   * @exception Exception
   * @author
   */
  public EgovMap nricDupChk(Map<String, Object> params) {
    return customerMapper.nricDupChk(params);
  }

  @Override
  public void insertCustomerInfo(Map<String, Object> params) {

    customerMapper.insertCustomerInfo(params);
  }

  @Override
  public void insertAddressInfo(Map<String, Object> params) {

    customerMapper.insertAddressInfo(params);
  }

  @Override
  public void insertContactInfo(Map<String, Object> params) {

    customerMapper.insertContactInfo(params);
  }

  @Override
  public void insertCareContactInfo(Map<String, Object> params) {
    customerMapper.insertCareContactInfo(params);
  }

  /**
   * 상세화면 조회한다. (Detail Contact View)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.25
   */
  @Override
  public EgovMap selectCustomerContactDetailViewPop(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerContactDetailViewPop(params);
  }

  /**
   * 상세화면 조회한다. (Detail Bank View)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.25
   */
  @Override
  public EgovMap selectCustomerBankDetailViewPop(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerBankDetailViewPop(params);
  }

  /**
   * 상세화면 조회한다. (Detail Card View)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.07.25
   */
  @Override
  public EgovMap selectCustomerCreditCardDetailViewPop(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerCreditCardDetailViewPop(params);
  }

  /**
   * 기본정보 업데이트
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.01
   */
  @Override
  public void updateCustomerBasicInfoAf(Map<String, Object> params) throws Exception {

	  // CELESTE 08-05-2024: INSERT NEW TIN ID AND INFO AND HISTORY [S]
	  if(params.containsKey("isEInvoiceNew") && params.get("isEInvoiceNew") != null && params.get("isEInvoiceNew").equals("1")){
		  params.put("isEInvoice", 1);
	  }
	  else {
		  params.put("isEInvoice", 0);
	  }

	  if((params.get("basicCustTin").toString() != null && params.get("basicCustTin").toString() != "") ||
		 (params.get("isEInvoice") != null && params.get("isEInvoice") != "") ) {
			  if((params.get("basicCustTinOld").toString() != null && !params.get("basicCustTin").toString().equals(params.get("basicCustTinOld").toString())) ||
				 (params.get("isEInvoice") != null && !params.get("isEInvoice").equals(params.get("isEInvoiceOld")))	 ){
				  int custTinId = customerMapper.getCustTinIdSeq();
				  params.put("custTinId", custTinId);
				  customerMapper.updateCustomerTinStatus(params);
				  customerMapper.insertCustomerTinId(params);
			  }
			  else if(params.get("basicCustTinOld").toString() == null) {
				  int custTinId = customerMapper.getCustTinIdSeq();
				  params.put("custTinId", custTinId);
				  customerMapper.insertCustomerTinId(params);
			  }
	  }

	  customerMapper.insertCustomerBasicInfoHist(params);

	  // CELESTE 08-05-2024:  INSERT NEW TIN ID AND INFO AND HISTORY [E]

	  LOGGER.debug("updateCustomerBasicInfoAf -- Params: " + params);
	  customerMapper.updateCustomerBasicInfoAf(params);
  }

  @Override
  public int getCustTinIdSeq() {

    int getCustTinIdSeq = customerMapper.getCustTinIdSeq();

    return getCustTinIdSeq;
  }

  @Override
  public List<EgovMap> selectCustomerBasicInfoHistoryLogList(Map<String, Object> params) {

    return customerMapper.selectCustomerBasicInfoHistoryLogList(params);
  }

  @Override
  public void insertCustomerTinId(Map<String, Object> params) {

    customerMapper.insertCustomerTinId(params);
  }

  /**
   * Main Address 업데이트 (Set Main)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.01
   */
  @Override
  @Transactional
  public void updateCustomerAddressSetMain(Map<String, Object> params) throws Exception {

    customerMapper.updateCustomerAddressSetActive(params);
    customerMapper.updateCustomerAddressSetMain(params);
  }

  /**
   * Main Contact 업데이트 (Set Main)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.03
   */
  @Override
  @Transactional
  public void updateCustomerContactSetMain(Map<String, Object> params) throws Exception {

    customerMapper.updateCustomerContactSetActive(params);
    // set STUS_CODE_ID == 9 <MAIN>
    customerMapper.updateCustomerContactSetMain(params);
  }

  /**
   * 연락처 업데이트
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.03
   */
  @Override
  public void updateCustomerContactInfoAf(Map<String, Object> params) throws Exception {

    customerMapper.updateCustomerContactInfoAf(params);

  }

  /**
   * Bank ComboBox List (Issue Bank)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.04
   */
  @Override
  public List<EgovMap> selectAccBank(Map<String, Object> params) {
    if (params.get("ddlChnl") != null) {
      if ((params.get("ddlChnl").toString()).equals("3182")) {
        return customerMapper.selectDdtChnlAccBank(params);
      } else {
        return customerMapper.selectAccBank(params);
      }
    } else {
      return customerMapper.selectAccBank(params);
    }
  }

  /**
   * Deduction Channel List
   *
   * @param
   * @return
   * @exception Exception
   * @author ONGHC 2018.11.29
   */
  @Override
  public List<EgovMap> selectDdlChnl(Map<String, Object> params) {

    return customerMapper.selectDdlChnl(params);
  }

  /**
   * Card ComboBox List (Issue Bank)
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.04
   */
  @Override
  public List<EgovMap> selectCrcBank(Map<String, Object> params) throws Exception {

    return customerMapper.selectCrcBank(params);
  }

  /**
   * 은행 Account 업데이트
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.03
   */
  @Override
  public void updateCustomerBankInfoAf(Map<String, Object> params) throws Exception {
    customerMapper.updateCustomerBankInfoAf(params);

  }

  /**
   * 카드 Account 업데이트
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.03
   */
  @Override
  public void updateCustomerCardInfoAf(Map<String, Object> params) throws Exception {
    customerMapper.updateCustomerCardInfoAf(params);
  }

  /**
   * Address Delete
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.03
   */
  @Override
  public void deleteCustomerAddress(Map<String, Object> params) throws Exception {
    customerMapper.deleteCustomerAddress(params);
  }

  /**
   * Contact Delete
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.03
   */
  @Override
  public void deleteCustomerContact(Map<String, Object> params) throws Exception {
    customerMapper.deleteCustomerContact(params);
  }

  /**
   * Bank Delete
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.07
   */
  @Override
  public void deleteCustomerBank(Map<String, Object> params) throws Exception {
    customerMapper.deleteCustomerBank(params);

  }

  /**
   * Card Delete
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.07
   */
  @Override
  public void deleteCustomerCard(Map<String, Object> params) throws Exception {
    customerMapper.deleteCustomerCard(params);
  }

  /**
   * Address Update
   *
   * @param
   * @return
   * @exception Exception
   * @author 이석희 2017.08.07
   */
  @Override
  public void updateCustomerAddressInfoAf(Map<String, Object> params) throws Exception {
    customerMapper.updateCustomerAddressInfoAf(params);
  }

  /**
   * Credit Card Issue Bank
   */
  @Override
  public List<EgovMap> selectIssueBank(Map<String, Object> params) {
    return customerMapper.selectIssueBank(params);
  }

  @Override
  public void insertCreditCardInfo(List<CustomerCVO> customerCardVOList) {

    for (CustomerCVO customerCVO : customerCardVOList) {
      LOGGER.debug("##### Impl >> getCreditCardNo :" + customerCVO.getCreditCardNo());
      customerMapper.insertCreditCardInfo(customerCVO);

      customerMapper.tokenCrcUpdate(customerCVO);
    }

  }

  @Override
  public void insertBankAccountInfo(List<CustomerBVO> customerBankVOList) {

    for (CustomerBVO customerBVO : customerBankVOList) {

      customerMapper.insertBankAccountInfo(customerBVO);
    }

  }

  @Override
  public int insertBankAccountInfo2(Map<String, Object> params, SessionVO sessionVO) {

    CustAccVO custAccVO = new CustAccVO();

    custAccVO.setCustId(Integer.parseInt((String) params.get("custId")));
    custAccVO.setCustAccNo((String) params.get("accNo"));
    //custAccVO.setCustEncryptAccNo(null);
    custAccVO.setCustEncryptAccNo((String) params.get("accNo"));
    custAccVO.setCustAccOwner((String) params.get("accName"));
    custAccVO.setCustAccTypeId(Integer.parseInt((String) params.get("bankType")));
    custAccVO.setCustAccBankId(Integer.parseInt((String) params.get("accBank")));
    custAccVO.setDdtChnl(Integer.parseInt((String) params.get("ddlChnl")));
    custAccVO.setCustAccBankBrnch((String) params.get("accBankBranch"));
    custAccVO.setCustAccRem((String) params.get("accRemark"));
    custAccVO.setCustAccStusId(1);
    custAccVO.setCustAccUpdUserId(sessionVO.getUserId());
    custAccVO.setCustAccNric("");
    custAccVO.setCustAccIdOld(0);
    custAccVO.setSoId(0);
    custAccVO.setCustAccIdcm(0);
    custAccVO.setCustHlbbId(0);
    custAccVO.setCustAccCrtUserId(sessionVO.getUserId());

    customerMapper.insertBankAccountInfo2(custAccVO);

    return custAccVO.getCustAccId();
  }

  @Override
  public int insertCreditCardInfo2(Map<String, Object> params, SessionVO sessionVO) {

    /*
    String expDate = (String) params.get("expDate");

    expDate = expDate.substring(0, 2) + expDate.substring(5, 7);
    */

    CustCrcVO custCrcVO = new CustCrcVO();

    custCrcVO.setCustId(Integer.parseInt((String) params.get("custId")));
    custCrcVO.setCustCrcNo((String) params.get("cardNo")); // EncryptionProvider.Encrypt(txtCRCNo.Text.Trim());
    custCrcVO.setCustOriCrcNo((String) params.get("cardNo"));
    custCrcVO.setCustEncryptCrcNo((String) params.get("oriCustCrcNo")); // CommonFunction.GetBytesFromString(txtCRCNo.Text.Trim());
    custCrcVO.setCustCrcOwner((String) params.get("nameOnCard"));
    custCrcVO.setCustCrcTypeId(Integer.parseInt((String) params.get("creditCardType")));
    custCrcVO.setCustCrcBankId(Integer.parseInt((String) params.get("issBank")));
    custCrcVO.setCustCrcStusId(1);
    custCrcVO.setCustCrcRem((String) params.get("cardRem"));
    custCrcVO.setCustCrcUpdUserId(sessionVO.getUserId());
    custCrcVO.setCustCrcExpr((String) params.get("cardExpr"));
    custCrcVO.setCrcToken((String) params.get("tknId"));
    ;
    custCrcVO.setCustCrcIdOld(0);
    custCrcVO.setSoId(0);
    custCrcVO.setCustCrcIdcm(0);
    custCrcVO.setCustCrcCrtUserId(sessionVO.getUserId());
    custCrcVO.setCardTypeId(Integer.parseInt((String) params.get("cardType")));

    customerMapper.insertCreditCardInfo2(custCrcVO);

    return custCrcVO.getCustCrcId();
  }

  /**
   * Customer Magic Address
   *
   * @param
   * @return Customer Magic Address
   * @exception Exception
   */
  @Override
  public List<EgovMap> searchMagicAddressPop(Map<String, Object> params) {

    return customerMapper.searchMagicAddressPop(params);
  }

  /**
   * Customer Add New Address (Af)
   *
   * @param
   * @return void
   * @exception Exception
   */
  @Override
  public int insertCustomerAddressInfoAf(Map<String, Object> params) throws Exception {
    customerMapper.insertCustomerAddressInfoAf(params);
    return (int) params.get("custAddId");
  }

  /**
   * Customer Add New Contact (Af)
   *
   * @param
   * @return void
   * @exception Exception
   */
  @Override
  public int insertCustomerContactAddAf(Map<String, Object> params) throws Exception {
    customerMapper.insertCustomerContactAddAf(params);
    return (int) params.get("custCntcId");
  }

  /**
   * Customer Add New Bank Account (Af)
   *
   * @param
   * @return void
   * @exception Exception
   */
  @Override
  public void insertCustomerBankAddAf(Map<String, Object> params) throws Exception {

    customerMapper.insertCustomerBankAddAf(params);

  }

  /**
   * Customer Add New Card Account (Af)
   *
   * @param
   * @return void
   * @exception Exception
   */
  @Override
  public void insertCustomerCardAddAf(Map<String, Object> params) throws Exception {

    customerMapper.insertCustomerCardAddAf(params);
  }

  public int getCustCrcId() {
      return customerMapper.getCustCrcId();
  };

  /**
   * Get Customer Detail Main Address
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  @Override
  public EgovMap selectCustomerMainAddr(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerMainAddr(params);
  }

  /**
   * Get Customer Detail Main Contact
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  @Override
  public EgovMap selectCustomerMainContact(Map<String, Object> params) throws Exception {

    return customerMapper.selectCustomerMainContact(params);
  }

  /**
   * selectMagicAddressComboList (Magic Address)
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */

  @Override
  public List<EgovMap> selectMagicAddressComboList(Map<String, Object> params) throws Exception {

    // State
    if (params.get("state") == null && params.get("city") == null && params.get("postcode") == null) {
      params.put("colState", "1");
    }
    // City
    if (params.get("state") != null && params.get("city") == null && params.get("postcode") == null) {
      params.put("colCity", "1");
    }
    // Post Code
    if (params.get("state") != null && params.get("city") != null && params.get("postcode") == null) {
      params.put("colPostCode", "1");
    }
    // Area
    if (params.get("state") != null && params.get("city") != null && params.get("postcode") != null) {
      params.put("colArea", "1");
    }

    return customerMapper.selectMagicAddressComboList(params);
  }

  /**
   * Get Area Id (Magic Address)
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  @Override
  public EgovMap getAreaId(Map<String, Object> params) throws Exception {

    return customerMapper.getAreaId(params);
  }

  /**
   * Nation List
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  @Override
  public List<EgovMap> getNationList(Map<String, Object> params) throws Exception {

    return customerMapper.getNationList(params);
  }

  @Override
  public void updateLimitBasicInfo(Map<String, Object> params) throws Exception {

    customerMapper.updateLimitBasicInfo(params);

  }

  @Override
  public int getCustIdSeq() throws Exception {

    return customerMapper.getCustIdSeq();
  }

  @Override
  public int billAddrExist(Map<String, Object> params) {

    return customerMapper.billAddrExist(params);
  }

  @Override
  public int installAddrExist(Map<String, Object> params) {

    return customerMapper.installAddrExist(params);
  }

  @Override
  public EgovMap checkCRC1(Map<String, Object> params) {
    return customerMapper.checkCRC1(params);
  }

  @Override
  public EgovMap checkCRC2(Map<String, Object> params) {
    return customerMapper.checkCRC2(params);
  }

  @Override
  public int tCheckCRC1(Map<String, Object> params) {
    return customerMapper.tCheckCRC1(params);
  }

  @Override
  public int tCheckCRC2(Map<String, Object> params) {
    return customerMapper.tCheckCRC2(params);
  }

  @Override
  public List<EgovMap> selectCustomerCheckingList(Map<String, Object> params) {

    return customerMapper.selectCustomerCheckingList(params);
  }

  @Override
  public EgovMap selectCustomerCheckingListPop(Map<String, Object> params) {

    return customerMapper.selectCustomerCheckingListPop(params);
  }

  @Override
  public EgovMap selectCustomerAgingMonth(Map<String, Object> params) {

    return customerMapper.selectCustomerAgingMonth(params);
  }

  @Override
  public EgovMap selectCustomerRentInst(Map<String, Object> params) {

    return customerMapper.selectCustomerRentInst(params);
  }

  @Override
  public int selectCustomerOldId(Map<String, Object> params) {

    return customerMapper.selectCustomerOldId(params);
  }

  @Override
  public EgovMap selectPairOrdId(Map<String, Object> params) {

    return customerMapper.selectPairOrdId(params);
  }

  @Override
  public EgovMap existingHPCodyMobile(Map<String, Object> params) {

    return customerMapper.existingHPCodyMobile(params);
  }

  @Override
  public int getTokenID() {
      return customerMapper.getTokenID();
  }

  @Override
  public void insertTokenLogging(Map<String, Object> params) {
      customerMapper.insertTokenLogging(params);
  }

  @Override
  public void insertMCPLogging(Map<String, Object> params) {
      customerMapper.insertMCPLogging(params);
  }

  @Override
  public EgovMap getTokenSettings() {
      return customerMapper.getTokenSettings();
  }

  @Override
  public void updateTokenLogging(Map<String, Object> params) {
      customerMapper.updateTokenLogging(params);
  }

  @Override
  public void insertTokenError(Map<String, Object> params) {
      customerMapper.insertTokenError(params);
  }

  @Override
  public EgovMap getPubKey() {
      return customerMapper.getPubKey();
  }

  @Override
  public void tokenCrcUpdate1(Map<String, Object> params) {
      customerMapper.tokenCrcUpdate1(params);
  }

  public String getCustNric(Map<String, Object> params) {
      return customerMapper.getCustNric(params);
  }

  @Override
  public EgovMap getTokenNumber(Map<String, Object> params) {
      return customerMapper.getTokenNumber(params);
  }

  @Override
  public void updateTokenStagingF(Map<String, Object> params) {
      customerMapper.updateTokenStagingF(params);
  }

  @Override
  public EgovMap validCustStatus(Map<String, Object> params) {
    return customerMapper.getCustStatus(params);
  }

  @Override
  public int updateCustStatus(Map<String, Object> params) {

    int count = customerMapper.selCustRcdTms(params);

    if(count > 0){
      customerMapper.updateCustomerStatus(params);

      if(params.get("action").equals("DEACTIVE"))
        customerMapper.deactivateCustomerCreditCard(params);
    }

    return count;
  }

  @Override
  public boolean checkCreditCardValidity(String tokenId) {
    int result = customerMapper.checkCreditCardValidity(tokenId);

    if(result > 0){
    	return false;
    }
    return true;
  }

  public boolean getCountActTokenId(Map<String, Object> params)throws Exception {

	int count = 0;

	LOGGER.info("######################################### custCrcId : " + params);

    count = customerMapper.getCountActTokenId(params);

	if(count > 0){
		return true;
	}else{
		return false;
	}
  }


  public List<EgovMap> searchCreditCard(Map<String, Object> params) {
    return customerMapper.getCreditCardDetails(params);
  }

  public boolean getAutoDebitUserId(Map<String, Object> params)throws Exception{

	  int count = 0;
	  LOGGER.info("######################################### userId : " + params);

	   count = customerMapper.getAutoDebitUserId(params);

		if(count > 0){
			return true;
		}else{
			return false;
		}

  }

  @Override
  public void updatePreccpData(Map<String, Object> params) {
	  customerMapper.updatePreccpData(params);
  }

  @Override
  public List<EgovMap> searchCreditCardNoExp(Map<String, Object> params){
	  return customerMapper.searchCreditCardNoExp(params);
  }

}
