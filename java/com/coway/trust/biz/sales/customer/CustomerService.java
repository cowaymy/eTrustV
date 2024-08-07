package com.coway.trust.biz.sales.customer;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CustomerService {

	  //////////////////////////////////////////////////  CHECK_EXIST_NRIC  ///////////////////////////////////////////////////

	EgovMap checkNricExist(Map<String, Object> params) throws Exception;

	  //////////////////////////////////////////////////  CHECK_EXIST_NRIC  ///////////////////////////////////////////////////
  /**
   * 글 목록을 조회한다.
   *
   * @param searchVO
   *          - 조회할 정보가 담긴 VO
   * @return 글 목록
   * @exception Exception
   */
  List<EgovMap> selectCustomerList(Map<String, Object> params);

  /**
   * 상세화면 조회. basic info
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.20
   */
  EgovMap selectCustomerViewBasicInfo(Map<String, Object> params);

  /**
   * 상세화면 조회. main address
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.20
   */
  EgovMap selectCustomerViewMainAddress(Map<String, Object> params) throws Exception;

  /**
   * 상세화면 조회. main contact
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.20
   */
  EgovMap selectCustomerViewMainContact(Map<String, Object> params) throws Exception;

  /**
   * 상세화면 조회. customer address list
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.20
   */
  List<EgovMap> selectCustomerAddressJsonList(Map<String, Object> params) throws Exception;

  /**
   * 상세화면 조회. customer Contact list
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.21
   */
  List<EgovMap> selectCustomerContactJsonList(Map<String, Object> params) throws Exception;

  /**
   * 상세화면 조회. customer Bank list
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.21
   */
  List<EgovMap> selectCustomerBankAccJsonList(Map<String, Object> params) throws Exception;

  /**
   * 상세화면 조회. customer Card list
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.21
   */
  List<EgovMap> selectCustomerCreditCardJsonList(Map<String, Object> params) throws Exception;

  /**
   * 상세화면 조회. own order list
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.21
   */
  List<EgovMap> selectCustomerOwnOrderJsonList(Map<String, Object> params) throws Exception;

  /**
   * 상세화면 조회. coway rewards list
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2022.11.29
   */
  List<EgovMap> selectCustomerCowayRewardsJsonList(Map<String, Object> params) throws Exception;

  /**
   * 상세화면 조회. third party list
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.21
   */
  List<EgovMap> selectCustomerThirdPartyJsonList(Map<String, Object> params) throws Exception;

  /**
   * 상세화면 조회. detail address view
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.24
   */
  EgovMap selectCustomerAddrDetailViewPop(Map<String, Object> params) throws Exception;

  /**
   * get Customer Care Contact Id Seq
   *
   * @param
   * @return
   * @exception Exception
   * @author
   */
  int getCustCareCntIdSeq();

  /**
   * insert Customer Basic Info
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  void insertCustomerInfo(Map<String, Object> params);

  /**
   * insert install address
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  void insertAddressInfo(Map<String, Object> params);

  /**
   * insert additional service contact
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  void insertContactInfo(Map<String, Object> params);

  /**
   * insert additional service contact (care contact)
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  void insertCareContactInfo(Map<String, Object> params);

  /**
   * 상세화면 조회. detail contact view
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.25
   */
  EgovMap selectCustomerContactDetailViewPop(Map<String, Object> params) throws Exception;

  /**
   * 상세화면 조회. detail bank view
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.25
   */
  EgovMap selectCustomerBankDetailViewPop(Map<String, Object> params) throws Exception;

  /**
   * 상세화면 조회. detail credit card view
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.07.25
   */
  EgovMap selectCustomerCreditCardDetailViewPop(Map<String, Object> params) throws Exception;

  /**
   * customer 기본정보 업데이트
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.01
   */
  void updateCustomerBasicInfoAf(Map<String, Object> params) throws Exception;

  /**
   * customer main Address 업데이트(Set Active)
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.02
   */
  /*
   * void updateCustomerAddressSetActive(Map<String, Object> params) throws
   * Exception;
   */

  /**
   * customer main Address 업데이트(Set Main)
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.02
   */
  void updateCustomerAddressSetMain(Map<String, Object> params) throws Exception;

  /**
   * customer main Address 업데이트(Set Active)
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.02
   */
  /*
   * void updateCustomerContactSetActive(Map<String, Object> params) throws
   * Exception;
   */

  /**
   * customer main Contact 업데이트(Set Main)
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.03
   */
  void updateCustomerContactSetMain(Map<String, Object> params) throws Exception;

  /**
   * customer 연락처 업데이트
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.03
   */
  void updateCustomerContactInfoAf(Map<String, Object> params) throws Exception;

  /**
   * Bank ComboBox List (Issue Bank)
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.04
   */
  List<EgovMap> selectAccBank(Map<String, Object> params);

  /**
   * Card ComboBox List (Issue Bank)
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.04
   */
  List<EgovMap> selectCrcBank(Map<String, Object> params) throws Exception;

  /**
   * customer 은행 Account 업데이트
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.04
   */
  void updateCustomerBankInfoAf(Map<String, Object> params) throws Exception;

  /**
   * Deduction Channel List
   *
   * @param params
   * @return
   * @exception Exception
   * @author ONGHC 2018.11.29
   */
  List<EgovMap> selectDdlChnl(Map<String, Object> params);

  /**
   * customer 카드 Account 업데이트
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.04
   */
  void updateCustomerCardInfoAf(Map<String, Object> params) throws Exception;

  /**
   * customer Address Delete
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.04
   */
  void deleteCustomerAddress(Map<String, Object> params) throws Exception;

  /**
   * customer Contact Delete
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.04
   */
  void deleteCustomerContact(Map<String, Object> params) throws Exception;

  /**
   * customer Bank Delete
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.07
   */
  void deleteCustomerBank(Map<String, Object> params) throws Exception;

  /**
   * customer Card Delete
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.07
   */
  void deleteCustomerCard(Map<String, Object> params) throws Exception;

  /**
   * customer Address Update
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희 2017.08.07
   */
  void updateCustomerAddressInfoAf(Map<String, Object> params) throws Exception;

  /**
   * Credit Card Issue Bank - select box
   */
  List<EgovMap> selectIssueBank(Map<String, Object> params);

  /**
   * insert Customer Credit Card Info
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  void insertCreditCardInfo(List<CustomerCVO> customerCardVOList);

  /**
   * insert Customer Bank Account Info
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  void insertBankAccountInfo(List<CustomerBVO> customerBankVOList);

  /**
   * NRIC / Company No 중복체크
   *
   * @param
   * @return
   * @exception Exception
   * @author
   */
  EgovMap nricDupChk(Map<String, Object> params) throws Exception;

  /**
   * CustCareContact
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  List<EgovMap> selectCustCareContactList(Map<String, Object> params) throws Exception;

  /**
   * BillingGroupByKeyword
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  List<EgovMap> selectBillingGroupByKeywordCustIDList(Map<String, Object> params) throws Exception;

  /**
   * Customer Magic Address
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  List<EgovMap> searchMagicAddressPop(Map<String, Object> params);

  /**
   * Customer Add New Address (After)
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  int insertCustomerAddressInfoAf(Map<String, Object> params) throws Exception;

  /**
   * Customer Add New Contact (After)
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  int insertCustomerContactAddAf(Map<String, Object> params) throws Exception;

  /**
   * Customer Add New Bank Account (After)
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  void insertCustomerBankAddAf(Map<String, Object> params) throws Exception;

  /**
   * Customer Add New Card Account (After)
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  void insertCustomerCardAddAf(Map<String, Object> params) throws Exception;

  int getCustCrcId();

  /**
   * Get Customer Detail Main Address
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  EgovMap selectCustomerMainAddr(Map<String, Object> params) throws Exception;

  /**
   * Get Customer Detail Main Contact
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  EgovMap selectCustomerMainContact(Map<String, Object> params) throws Exception;

  /**
   * Get State List (Magic Address)
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  List<EgovMap> selectMagicAddressComboList(Map<String, Object> params) throws Exception;

  /**
   * Get Area Id (Magic Address)
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  EgovMap getAreaId(Map<String, Object> params) throws Exception;

  /**
   * Nation List
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  List<EgovMap> getNationList(Map<String, Object> params) throws Exception;

  int insertBankAccountInfo2(Map<String, Object> params, SessionVO sessionVO);

  int insertCreditCardInfo2(Map<String, Object> params, SessionVO sessionVO);

  void updateLimitBasicInfo(Map<String, Object> params) throws Exception;

  int getCustIdSeq() throws Exception;

  int billAddrExist(Map<String, Object> params);

  int installAddrExist(Map<String, Object> params);

  EgovMap checkCRC1(Map<String, Object> params);

  EgovMap checkCRC2(Map<String, Object> params);

  int tCheckCRC1(Map<String, Object> params);

  int tCheckCRC2(Map<String, Object> params);

  List<EgovMap> selectCustomerCheckingList(Map<String, Object> params);

  EgovMap selectCustomerCheckingListPop(Map<String, Object> params);

  EgovMap selectCustomerAgingMonth(Map<String, Object> params);

  EgovMap selectCustomerRentInst(Map<String, Object> params);

  int selectCustomerOldId(Map<String, Object> params);

  EgovMap selectPairOrdId(Map<String, Object> params);

  EgovMap existingHPCodyMobile(Map<String, Object> params);

  int getTokenID();

  void insertTokenLogging(Map<String, Object> params);

  void insertMCPLogging(Map<String, Object> params); // To remove/append changes to insertTokenLogging

  EgovMap getTokenSettings();

  void updateTokenLogging(Map<String, Object> params);

  void insertTokenError(Map<String, Object> params);

  EgovMap getPubKey();

  void tokenCrcUpdate1(Map<String, Object> params);

  String getCustNric(Map<String, Object> params);

  EgovMap getTokenNumber(Map<String, Object> params);

  void updateTokenStagingF(Map<String, Object> params);

  EgovMap validCustStatus(Map<String, Object> params);

  int updateCustStatus(Map<String, Object> params);

  List<EgovMap> searchCreditCard(Map<String, Object> params);

  boolean checkCreditCardValidity(String tokenId);

  boolean getCountActTokenId(Map<String, Object> params)throws Exception;

  boolean getAutoDebitUserId(Map<String, Object> params)throws Exception;

  void updatePreccpData(Map<String, Object> params);

  List<EgovMap> searchCreditCardNoExp(Map<String, Object> params);

  List<EgovMap> selectCustomerStatusHistoryLogList(Map<String, Object> params);

  int getCustTinIdSeq();

  List<EgovMap> selectCustomerBasicInfoHistoryLogList(Map<String, Object> params);

  void insertCustomerTinId(Map<String, Object> params);

}
