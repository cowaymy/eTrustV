package com.coway.trust.biz.sales.customer.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.customer.CustomerBVO;
import com.coway.trust.biz.sales.customer.CustomerCVO;
import com.coway.trust.biz.sales.order.vo.CustAccVO;
import com.coway.trust.biz.sales.order.vo.CustCrcVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("customerMapper")
public interface CustomerMapper {

	  //////////////////////////////////////////////////  CHECK_EXIST_NRIC  ///////////////////////////////////////////////////

	EgovMap selectNricExist(Map<String, Object> params);

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
   * Customer View Basic Info mapper
   *
   * @param params
   * @return EgovMap
   * @exception Exception
   * @author 이석희
   */
  EgovMap selectCustomerViewBasicInfo(Map<String, Object> params);

  /**
   * Customer View Main Address mapper
   *
   * @param params
   * @return EgovMap
   * @exception Exception
   * @author 이석희
   */
  EgovMap selectCustomerViewMainAddress(Map<String, Object> params) throws Exception;

  /**
   * Customer View Main Contact mapper
   *
   * @param params
   * @return EgovMap
   * @exception Exception
   * @author 이석희
   */
  EgovMap selectCustomerViewMainContact(Map<String, Object> params) throws Exception;

  /**
   * Customer View Address List mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author 이석희
   */
  List<EgovMap> selectCustomerAddressJsonList(Map<String, Object> params) throws Exception;

  /**
   * Customer View Contact List mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author 이석희
   */
  List<EgovMap> selectCustomerContactJsonList(Map<String, Object> params) throws Exception;

  /**
   * Customer Care Contact List mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author Yunseok Jang
   */
  List<EgovMap> selectCustCareContactList(Map<String, Object> params) throws Exception;

  /**
   * Billing Group List mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author Yunseok Jang
   */
  List<EgovMap> selectBillingGroupByKeywordCustIDList(Map<String, Object> params) throws Exception;

  /**
   * Customer View Bank List mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author 이석희
   */
  List<EgovMap> selectCustomerBankAccJsonList(Map<String, Object> params) throws Exception;

  /**
   * Customer View Card List mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author 이석희
   */
  List<EgovMap> selectCustomerCreditCardJsonList(Map<String, Object> params) throws Exception;

  /**
   * Customer Own Order List mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author 이석희
   */
  List<EgovMap> selectCustomerOwnOrderJsonList(Map<String, Object> params) throws Exception;

  /**
   * Customer Third Party Order List mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author 이석희
   */
  List<EgovMap> selectCustomerThirdPartyJsonList(Map<String, Object> params) throws Exception;

  /**
   * Customer Coway Rewards List mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author 이석희
   */
  List<EgovMap> selectCustomerCowayRewardsJsonList(Map<String, Object> params) throws Exception;

  /**
   * Customer Address Detail View mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author 이석희
   */
  EgovMap selectCustomerAddrDetailViewPop(Map<String, Object> params) throws Exception;

  /**
   * get customer Id
   *
   * @param Map
   * @return
   * @exception Exception
   */
  int getCustIdSeq();

  /**
   * get customer Address
   *
   * @param Map
   * @return
   * @exception Exception
   */
  int getCustAddrIdSeq();

  /**
   * get customer Contact
   *
   * @param Map
   * @return
   * @exception Exception
   */
  int getCustCntcIdSeq();

  /**
   * get customer Care Contact
   *
   * @param Map
   * @return
   * @exception Exception
   */
  int getCustCareCntIdSeq();

  /**
   * insert customer Info Data
   *
   * @param Map
   * @return
   * @exception Exception
   */
  int insertCustomerInfo(Map<String, Object> params);

  /**
   * NRIC/Customer No Data Duplication Check
   *
   * @param Map
   * @return
   * @exception Exception
   */
  EgovMap nricDupChk(Map<String, Object> params);

  /**
   * update customer Info Data
   *
   * @param Map
   * @return
   * @exception Exception
   */
  int updateCustomerInfo(Map<String, Object> params);

  /**
   * insert address Info Data
   *
   * @param Map
   * @return
   * @exception Exception
   */
  int insertAddressInfo(Map<String, Object> params);

  /**
   * insert contact Info Data
   *
   * @param Map
   * @return
   * @exception Exception
   */
  int insertContactInfo(Map<String, Object> params);

  /**
   * insert care contact Info Data
   *
   * @param Map
   * @return
   * @exception Exception
   */
  int insertCareContactInfo(Map<String, Object> params);

  /**
   * Customer Contact Detail View mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author 이석희
   */
  EgovMap selectCustomerContactDetailViewPop(Map<String, Object> params) throws Exception;

  /**
   * Customer Bank Detail View mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author 이석희
   */
  EgovMap selectCustomerBankDetailViewPop(Map<String, Object> params) throws Exception;

  /**
   * Customer Card Detail View mapper
   *
   * @param params
   * @return List<EgovMap>
   * @exception Exception
   * @author 이석희
   */
  EgovMap selectCustomerCreditCardDetailViewPop(Map<String, Object> params) throws Exception;

  /**
   * Credit Card Issue Bank
   */
  List<EgovMap> selectIssueBank(Map<String, Object> params);

  /**
   * insert Credit Card Info Data
   *
   * @param Map
   * @return
   * @exception Exception
   */
  int insertCreditCardInfo(CustomerCVO customerCVO);

  int insertCreditCardInfo2(CustCrcVO custCrcVO);

  /**
   * get Customer Id Max Seq 필요없음.
   *
   * @param Map
   * @return
   * @exception Exception
   */
  int getCustIdMaxSeq();

  /**
   * insert Bank Account Info Data
   *
   * @param Map
   * @return
   * @exception Exception
   */
  int insertBankAccountInfo(CustomerBVO customerBVO);

  int insertBankAccountInfo2(CustAccVO custAccVO);

  /**
   * Customer Basic Update mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void updateCustomerBasicInfoAf(Map<String, Object> params) throws Exception;

  /**
   * Customer Address to Set Active mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void updateCustomerAddressSetActive(Map<String, Object> params) throws Exception;

  /**
   * Customer Address to Set Main mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void updateCustomerAddressSetMain(Map<String, Object> params) throws Exception;

  /**
   * Customer Contact to Set Active mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void updateCustomerContactSetActive(Map<String, Object> params) throws Exception;

  /**
   * Customer Contact to Set Main mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void updateCustomerContactSetMain(Map<String, Object> params) throws Exception;

  /**
   * Customer Contact update mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void updateCustomerContactInfoAf(Map<String, Object> params) throws Exception;

  /**
   * Bank ComboBox List (Issue Bank) mapper
   *
   * @param params
   * @return
   * @exception Exception
   * @author 이석희
   */
  List<EgovMap> selectAccBank(Map<String, Object> params);

  /**
   * Deduction Channel Bank ComboBox List mapper
   *
   * @param params
   * @return
   * @exception Exception
   * @author ONGHC
   */
  List<EgovMap> selectDdtChnlAccBank(Map<String, Object> params);

  /**
   * Deduction Channel List mapper
   *
   * @param params
   * @return
   * @exception Exception
   * @author ONGHC
   */
  List<EgovMap> selectDdlChnl(Map<String, Object> params);

  /**
   * Card ComboBox List (Issue Bank) mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  List<EgovMap> selectCrcBank(Map<String, Object> params) throws Exception;

  /**
   * Customer Bank update mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void updateCustomerBankInfoAf(Map<String, Object> params) throws Exception;

  /**
   * Customer Card update mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void updateCustomerCardInfoAf(Map<String, Object> params) throws Exception;

  /**
   * Customer Address Delete mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void deleteCustomerAddress(Map<String, Object> params) throws Exception;

  /**
   * Customer Contact Delete mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void deleteCustomerContact(Map<String, Object> params) throws Exception;

  /**
   * Customer Bank Delete mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void deleteCustomerBank(Map<String, Object> params) throws Exception;

  /**
   * Customer Card Delete mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void deleteCustomerCard(Map<String, Object> params) throws Exception;

  /**
   * Customer Address Update mapper
   *
   * @param params
   * @return Boolean
   * @exception Exception
   * @author 이석희
   */
  void updateCustomerAddressInfoAf(Map<String, Object> params) throws Exception;

  /**
   * Customer Magic Address
   *
   * @param params
   * @return EgovMap
   * @exception Exception
   * @author
   */
  List<EgovMap> searchMagicAddressPop(Map<String, Object> params);

  /**
   * Customer Add new Address
   *
   * @param params
   * @return EgovMap
   * @exception Exception
   * @author
   */
  int insertCustomerAddressInfoAf(Map<String, Object> params) throws Exception;

  /**
   * Customer Add new Contact Account
   *
   * @param params
   * @exception Exception
   * @author
   */
  int insertCustomerContactAddAf(Map<String, Object> params) throws Exception;

  /**
   * Customer Add new Bank Account
   *
   * @param params
   * @exception Exception
   * @author
   */
  void insertCustomerBankAddAf(Map<String, Object> params) throws Exception;

  /**
   * Customer Add new Card Account
   *
   * @param params
   * @exception Exception
   * @author
   */
  void insertCustomerCardAddAf(Map<String, Object> params) throws Exception;

  int getCustCrcId();

  /**
   * Get Customer Detail Main Address
   *
   * @param params
   * @exception Exception
   * @author
   */
  EgovMap selectCustomerMainAddr(Map<String, Object> params) throws Exception;

  /**
   * Get Customer Detail Main Contact
   *
   * @param params
   * @exception Exception
   * @author
   */
  EgovMap selectCustomerMainContact(Map<String, Object> params) throws Exception;

  /* #### Magic Address Start ##### */
  /**
   * Get State List (Magic Address)
   *
   * @param params
   * @exception Exception
   * @author
   */
  List<EgovMap> selectMagicAddressComboList(Map<String, Object> params) throws Exception;

  /**
   * Get Area Id (Magic Address)
   *
   * @param params
   * @exception Exception
   * @author
   */
  EgovMap getAreaId(Map<String, Object> params) throws Exception;
  /* #### Magic Address End ##### */

  /**
   * Nation List
   *
   * @param params
   * @exception Exception
   * @author
   */
  List<EgovMap> getNationList(Map<String, Object> params) throws Exception;

  void updateLimitBasicInfo(Map<String, Object> params) throws Exception;

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

  void tokenCrcUpdate(CustomerCVO customerCVOMap);

  void tokenCrcUpdate1(Map<String, Object> params);

  String getCustNric(Map<String, Object> params);

  EgovMap getTokenNumber(Map<String, Object> params);

  void updateTokenStagingF(Map<String, Object> params);

  EgovMap getCustStatus(Map<String, Object> params);

  int selCustRcdTms(Map<String, Object> params);

  void updateCustomerStatus(Map<String, Object> params);
  void deactivateCustomerCreditCard(Map<String, Object> params);

  int checkCreditCardValidity(String tokenId);

  List<EgovMap> getCreditCardDetails(Map<String, Object> params);

  int getCountActTokenId(Map<String, Object> params);

  int getAutoDebitUserId(Map<String, Object> params);

  void updatePreccpData(Map<String, Object> params);

  List<EgovMap> searchCreditCardNoExp(Map<String, Object> params);

  List<EgovMap> selectCustomerStatusHistoryLogList(Map<String, Object> params);

  int getCustTinIdSeq();

  void insertCustomerTinId(Map<String, Object> params);

  void insertCustomerBasicInfoHist(Map<String, Object> params);

  void updateCustomerTinStatus(Map<String, Object> params);

  List<EgovMap> selectCustomerBasicInfoHistoryLogList(Map<String, Object> params);

  int getBlackArea(Map<String, Object> params);

  List<EgovMap> selectBlacklistedAreawithProductCategoryList(Map<String, Object> params);
}
