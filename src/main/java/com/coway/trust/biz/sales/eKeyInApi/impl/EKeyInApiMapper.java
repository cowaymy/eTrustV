package com.coway.trust.biz.sales.eKeyInApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : EKeyInApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 *          Date Author Description
 *          ------------- ----------- -------------
 *          2019. 12. 09. KR-JAEMJAEM:) First creation
 *          2020. 03. 31. MY-ONGHC Add selectExistAddress and selectExistAddress
 *          2020. 04. 08. MY-ONGHC Add selectCpntLst to Retrieve Component List
 *          Add selectPromoByCpntId
 *          2023. 06. 27. MY-ONGHC Add checkTNA for Validate Card Validity bt crcID
 *          </pre>
 */
@Mapper("EKeyInApiMapper")
public interface EKeyInApiMapper {

  List<EgovMap> selecteKeyInList(Map<String, Object> param);

  List<EgovMap> selectCodeList();

  EgovMap selecteKeyInDetail(Map<String, Object> param);

  List<EgovMap> selecteKeyInDetailOrderHomecare(Map<String, Object> param);

  EgovMap selecteKeyInDetailOrder(Map<String, Object> param);

  List<EgovMap> selecteKeyInDetailAttachment(Map<String, Object> param);

  List<EgovMap> selecteOrderPackType1();

  List<EgovMap> selecteOrderPackType2(Map<String, Object> param);

  List<EgovMap> selecteOrderProduct1(Map<String, Object> param);

  List<EgovMap> selecteOrderProduct2(Map<String, Object> param);

  List<EgovMap> selectPromotionByAppTypeStockESales(Map<String, Object> param);

  List<EgovMap> selectPromotionByAppTypeStock(Map<String, Object> param);

  List<EgovMap> selectBankList();

  List<EgovMap> selectAnotherContact(Map<String, Object> param);

  int selectExistContact(Map<String, Object> param);

  int insertAddNewContact(Map<String, Object> param);

  EgovMap selectItmStkPrice(Map<String, Object> param);

  EgovMap selectSsPvInfo(Map<String, Object> param);

  EgovMap selectItmStkPrice2(Map<String, Object> param);

  EgovMap selectPromoDesc(int promoId);

  EgovMap selectSrvType(Map<String, Object> param);

  EgovMap selectProductPromotionPriceByPromoStockIDNewCorp(Map<String, Object> param);

  EgovMap selectProductPromotionPriceByPromoStockIDNew(Map<String, Object> param);

  EgovMap selectProductPromotionPriceByPromoStockID(Map<String, Object> param);

  List<EgovMap> selectAnotherAddress(Map<String, Object> param);

  int selectExistAddress(Map<String, Object> param);

  int insertAddNewAddress(Map<String, Object> param);

  List<EgovMap> selectAnotherCard(Map<String, Object> param);

  EgovMap selectParamVal();

  int selectTokenID();

  EgovMap selectTokenSettings();

  int insertSAL0257D(Map<String, Object> param);

  int updateSAL0257D(Map<String, Object> param);

  int selectCheckCRC1(Map<String, Object> param);

  int selectCheckCRC2(Map<String, Object> param);

  int insertSAL0258D(Map<String, Object> param);

  int insertSAL0028D(Map<String, Object> param);

  int updateCustCrcIdSAL0257D(Map<String, Object> param);

  int selectCreditCardIsExisting(Map<String, Object> param);

  EgovMap selectCheckRc(Map<String, Object> param);

  int selectExistSofNo(Map<String, Object> param);

  EgovMap selectCustomerInfo(Map<String, Object> param);

  int selectFileGroupKey();

  int insertSYS0071D(Map<String, Object> param);

  int updateSYS0071D(Map<String, Object> param);

  int updateSYS0070M(Map<String, Object> param);

  int deleteSYS0071D(Map<String, Object> param);

  int deleteSYS0070M(Map<String, Object> param);

  int insertSYS0070M(Map<String, Object> param);

  int insertSAL0213M(Map<String, Object> param);

  int insertHMC0011D(Map<String, Object> param);

  int updateBndlIdSAL0213M(Map<String, Object> param);

  int updateSAL0213M(Map<String, Object> param);

  int updateHMC0011D(Map<String, Object> param);

  int cancelSAL0213M(Map<String, Object> param);

  int cancelHMC0011D(Map<String, Object> param);

  EgovMap selectAttachmentImgFile(Map<String, Object> param);

  List<EgovMap> selectCpntLst(Map<String, Object> param);

  List<EgovMap> selectPromoByCpntId(Map<String, Object> param);

  EgovMap getTokenInfo(Map<String, Object> param);

  int updateStagingF(Map<String, Object> param);

  int checkCreditCardValidity(String token);

  EgovMap checkTNA(String param);

  List<EgovMap> selectVoucherPlatformCodeList();

  int isVoucherValidToApply(Map<String, Object> param);

  int isVoucherValidToApplyIneKeyIn(Map<String, Object> param);

  List<EgovMap> getVoucherUsagePromotionId(Map<String, Object> param);

  List<EgovMap> selectCwStoreIDInfo();
}
