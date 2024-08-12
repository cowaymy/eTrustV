package com.coway.trust.biz.sales.eKeyInApi;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiForm;
import com.coway.trust.biz.common.FileVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : EKeyInApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 *          Date Author Description
 *          ------------- ----------- -------------
 *          2019. 12. 09. KR-JAEMJAEM:) First creation
 *          2020. 04. 08. MY-ONGHC Add selectCpntLst to Retrieve Component List
 *          Add selectPromoByCpntId
 *          2023. 06. 27. MY-ONGHC Add checkTNA for Validate Card Validity bt crcID
 *          </pre>
 */
public interface EKeyInApiService {

  List<EgovMap> selecteKeyInList(EKeyInApiForm param) throws Exception;

  EKeyInApiDto selectCodeList() throws Exception;

  EKeyInApiDto selecteKeyInDetail(EKeyInApiForm param) throws Exception;

  List<EgovMap> selecteOrderPackType1() throws Exception;

  List<EgovMap> selecteOrderPackType2(EKeyInApiForm param) throws Exception;

  List<EgovMap> selecteOrderProduct1(EKeyInApiForm param) throws Exception;

  List<EgovMap> selecteOrderProduct2(EKeyInApiForm param) throws Exception;

  List<EgovMap> selectPromotionByAppTypeStockESales(EKeyInApiForm param) throws Exception;

  List<EgovMap> selectPromotionByAppTypeStock(EKeyInApiForm param) throws Exception;

  List<EgovMap> selectBankList() throws Exception;

  List<EgovMap> selectAnotherContact(EKeyInApiForm param) throws Exception;

  EKeyInApiDto saveAddNewContact(EKeyInApiDto param) throws Exception;

  EKeyInApiDto selecteOrderProductHomecare(EKeyInApiForm param) throws Exception;

  EKeyInApiDto selectItmStkChangeInfo(EKeyInApiForm param) throws Exception;

  EKeyInApiDto selectPromoChange(EKeyInApiForm param) throws Exception;

  EKeyInApiDto selectSrvType(EKeyInApiForm param) throws Exception;

  List<EgovMap> selectAnotherAddress(EKeyInApiForm param) throws Exception;

  EKeyInApiDto saveAddNewAddress(EKeyInApiDto param) throws Exception;

  List<EKeyInApiDto> selectAnotherCard(EKeyInApiForm param) throws Exception;

  EKeyInApiDto selectNewCardInfo() throws Exception;

  EKeyInApiDto saveTokenLogging(EKeyInApiDto param) throws Exception;

  EKeyInApiDto saveTokenizationProcess(EKeyInApiDto param) throws Exception;

  EKeyInApiDto selectCheckRc(EKeyInApiForm param) throws Exception;

  EKeyInApiDto selectExistSofNo(EKeyInApiForm param) throws Exception;

  int insertUploadFileSal0500(List<FileVO> list, EKeyInApiDto param);

  int updateUploadFileSal0500(List<FileVO> list, EKeyInApiDto param);

  EKeyInApiDto insertEkeyIn(EKeyInApiDto param) throws Exception;

  EKeyInApiDto updateEkeyIn(EKeyInApiDto param) throws Exception;

  EKeyInApiDto cancelEkeyIn(EKeyInApiDto param) throws Exception;

  EKeyInApiDto selectAttachmentImgFile(Map<String, Object> param) throws Exception;

  EKeyInApiDto selectCpntLst(EKeyInApiForm param) throws Exception;

  EKeyInApiDto selectPromoByCpntId(EKeyInApiForm param) throws Exception;

  EKeyInApiDto getTokenId(EKeyInApiDto param) throws Exception;

  EKeyInApiDto saveTokenNumber(EKeyInApiDto param) throws Exception;

  EKeyInApiDto checkIfIsAcInstallationProductCategoryCode(EKeyInApiForm param);

  EgovMap checkTNA(String param) throws Exception;

EKeyInApiDto isVoucherValidToApply(EKeyInApiForm param) throws Exception;

List<EgovMap> selectVoucherPlatformCodeList() throws Exception;

EKeyInApiDto getVoucherUsagePromotionId(EKeyInApiForm param) throws Exception;
}
