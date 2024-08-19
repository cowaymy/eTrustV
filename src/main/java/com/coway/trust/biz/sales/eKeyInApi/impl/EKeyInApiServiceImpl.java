package com.coway.trust.biz.sales.eKeyInApi.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.util.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.customerApi.CustomerApiForm;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiForm;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.HomecareCmMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.misc.voucher.impl.VoucherMapper;
import com.coway.trust.biz.sales.eKeyInApi.EKeyInApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : EKeyInApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 *
 * @History
 *
 *          <pre>
 *          Date Author Description
 *          ------------- ----------- -------------
 *          2019. 12. 09. KR-JAEMJAEM:) First creation
 *          2020. 03. 23 MY-ONGHC Amend saveTokenizationProcess
 *          2020. 03. 26 MY-ONGHC Amend selectOrderInfo's Promotion Listing
 *          Restructure Messy Code
 *          2020. 03. 27 MY-ONGHC Amend saveAddNewAddress to add userNm param
 *          2020. 03. 30 MY-ONGHC Amend selectExistSofNo and insertEkeyIn to remove SOF checking
 *          2020. 03. 31 MY-ONGHC Amend saveAddNewAddress and saveAddNewContact to check existing MAIN record exist before.
 *          2020. 04. 01 MY-ONGHC Amend selectOrderInfo to solve promotion issue
 *          2020. 04. 03 MY-ONGHC Amend selectItmStkChangeInfo
 *          2020. 04. 08. MY-ONGHC Add selectCpntLst to Retrieve Component List
 *          Add selectPromoByCpntId
 *          2020. 04. 10 MY-ONGHC Revert selectExistSofNo and insertEkeyIn to remove SOF checking
 *          2020. 08. 19 MY-ONGHC Amend insertEkeyIn to Support Multiple Payment Method
 *          2023. 06. 27 MY-ONGHC Add checkTNA for Validate Card Validity bt crcID
 *          </pre>
 */
@Service("EKeyInApiService")
public class EKeyInApiServiceImpl extends EgovAbstractServiceImpl implements EKeyInApiService {

  private static final Logger logger = LoggerFactory.getLogger(EKeyInApiServiceImpl.class);

  @Resource(name = "EKeyInApiMapper")
  private EKeyInApiMapper eKeyInApiMapper;

  @Resource(name = "homecareCmMapper")
  private HomecareCmMapper homecareCmMapper;

  @Resource(name = "voucherMapper")
  private VoucherMapper voucherMapper;

  @Autowired
  private LoginMapper loginMapper;

  @Override
  public List<EgovMap> selecteKeyInList(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getReqstDtFrom()) || CommonUtils.isEmpty(param.getReqstDtTo())) {
      throw new ApplicationException(AppConstants.FAIL, " Request Date  does not exist.");
    }
    if (CommonUtils.isEmpty(param.getSelectType())) {
      throw new ApplicationException(AppConstants.FAIL, "Select Type value does not exist.");
    } else {
      if (("2").equals(param.getSelectType()) && param.getSelectKeyword().length() < 5) {
        throw new ApplicationException(AppConstants.FAIL, "Please enter at least 5 characters.");
      }
    }
    if (CommonUtils.isEmpty(param.getRegId())) {
      throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
    }
    return eKeyInApiMapper.selecteKeyInList(EKeyInApiForm.createMap(param));
  }

  @Override
  public EKeyInApiDto selectCodeList() throws Exception {
    EKeyInApiDto rtn = new EKeyInApiDto();
    List<EgovMap> selectCodeList = eKeyInApiMapper.selectCodeList();
    List<EKeyInApiDto> codeList = selectCodeList.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
    rtn.setCodeList(codeList);
    return rtn;
  }

  @Override
  public EKeyInApiDto selecteKeyInDetail(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getPreOrdId()) || param.getPreOrdId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, " Pre Order ID value does not exist.");
    }
    EKeyInApiDto selecteKeyInDetail = EKeyInApiDto.create(eKeyInApiMapper.selecteKeyInDetail(EKeyInApiForm.createMap(param)));

    selecteKeyInDetail.setCustOriCrcNo(CommonUtils.getMaskCreditCardNo(StringUtils.trim(selecteKeyInDetail.getCustOriCrcNo()), "*", 4));
    List<EgovMap> selectBankList = selectBankList();
    List<EKeyInApiDto> bankList = selectBankList.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
    selecteKeyInDetail.setBankList(bankList);

    EKeyInApiDto selectOrderInfo = selectOrderInfo(selecteKeyInDetail);
    selecteKeyInDetail.setPackTypeList(selectOrderInfo.getPackTypeList());
    selecteKeyInDetail.setProductList(selectOrderInfo.getProductList());
    selecteKeyInDetail.setPromotionList(selectOrderInfo.getPromotionList());

    if(selecteKeyInDetail.getVoucherCode() != null
    		&& selecteKeyInDetail.getVoucherCode().length() > 0){
        Map<String,Object> voucherParam = new HashMap();
        voucherParam.put("voucherCode", selecteKeyInDetail.getVoucherCode());
        EgovMap voucherInfo = voucherMapper.getVoucherInfo(voucherParam);

        if(voucherInfo != null){
        	selecteKeyInDetail.setVoucherEmail(voucherInfo.get("custEmail").toString());
        	selecteKeyInDetail.setVoucherType(Integer.parseInt(voucherInfo.get("platformId").toString()));
        }
    }

    if (CommonUtils.isNotEmpty(selecteKeyInDetail.getHcGu()) && selecteKeyInDetail.getHcGu().equals("HC")) {
      List<EgovMap> selecteKeyInDetailOrderHomecare = eKeyInApiMapper.selecteKeyInDetailOrderHomecare(EKeyInApiForm.createMap(param));
      List<EKeyInApiDto> homecareList = selecteKeyInDetailOrderHomecare.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
      if (homecareList.size() != 1) {
        throw new ApplicationException(AppConstants.FAIL, " HomeCare information is missing.");
      }

      int mattressItmStkId = 0;
      int frameItmStkId = 0;
      int masterAppTyp = 0;
      for (EKeyInApiDto listData : homecareList) {
        if (CommonUtils.isNotEmpty(listData.getMatPreOrdId())) {
          param.setPreOrdId(listData.getMatPreOrdId());
          EgovMap selecteKeyInDetailOrder = eKeyInApiMapper.selecteKeyInDetailOrder(EKeyInApiForm.createMap(param));
          if (MapUtils.isNotEmpty(selecteKeyInDetailOrder)) {
            EKeyInApiDto mattress = EKeyInApiDto.create(selecteKeyInDetailOrder);

            mattress.setStkCtgryId(5706);
            EKeyInApiDto selectOrderInfoMattress = selectOrderInfo(mattress);

            mattress.setPackTypeList(selectOrderInfoMattress.getPackTypeList());
            mattress.setProductList(selectOrderInfoMattress.getProductList());
            mattress.setPromotionList(selectOrderInfoMattress.getPromotionList());
            mattress.setMatPreOrdId(mattress.getPreOrdId());

            selecteKeyInDetail.setMattress(mattress);

            mattressItmStkId = mattress.getItmStkId();

            masterAppTyp = mattress.getAppTypeId();
          }
        }

        if (CommonUtils.isNotEmpty(listData.getFraPreOrdId()) && 0 < listData.getFraPreOrdId()) {
          param.setPreOrdId(listData.getFraPreOrdId());
          EgovMap selecteKeyInDetailOrder = eKeyInApiMapper.selecteKeyInDetailOrder(EKeyInApiForm.createMap(param));
          if (MapUtils.isNotEmpty(selecteKeyInDetailOrder)) {
            EKeyInApiDto frame = EKeyInApiDto.create(selecteKeyInDetailOrder);

            frameItmStkId = frame.getItmStkId();
            frame.setStkCtgryId(5707);
            frame.setItmStkId(mattressItmStkId); // mattress itmStkId -> frame
                                                 // itmStkId select

            if (masterAppTyp != 0) {
              frame.setAppTypeId(masterAppTyp);
            }

            EKeyInApiDto selectOrderInfoFrame = selectOrderInfo(frame);
            frame.setPackTypeList(selectOrderInfoFrame.getPackTypeList());
            frame.setProductList(selectOrderInfoFrame.getProductList());
            frame.setPromotionList(selectOrderInfoFrame.getPromotionList());

            frame.setItmStkId(frameItmStkId); // frame itmStkId set
            frame.setFraPreOrdId(frame.getPreOrdId());
            selecteKeyInDetail.setFrame(frame);
          }

        }
      }
    }

    if (CommonUtils.isNotEmpty(selecteKeyInDetail.getAtchFileGrpId()) && selecteKeyInDetail.getAtchFileGrpId() > 0) {
      param.setAtchFileGrpId(selecteKeyInDetail.getAtchFileGrpId());
      List<EgovMap> selecteKeyInDetailAttachment = eKeyInApiMapper.selecteKeyInDetailAttachment(EKeyInApiForm.createMap(param));
      List<EKeyInApiDto> attachment = selecteKeyInDetailAttachment.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
      selecteKeyInDetail.setAttachment(attachment);
    }
    return selecteKeyInDetail;
  }

  public EKeyInApiDto selectOrderInfo(EKeyInApiDto selectData) throws Exception {
    EKeyInApiForm param = new EKeyInApiForm();
    if (selectData.getAppTypeId() == 66) {
      List<EgovMap> selecteOrderPackType1 = selecteOrderPackType1();
      List<EKeyInApiDto> packTypeList = selecteOrderPackType1.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
      selectData.setPackTypeList(packTypeList);

      param.setSrvCntrctPacId(selectData.getSrvPacId());
      if (selectData.getStkCtgryId() == 5706 || selectData.getStkCtgryId() == 5707) {
        param.setStkCtgryId(selectData.getStkCtgryId());
      }

      if (selectData.getStkCtgryId() == 5707) { // mattress product select
        param.setGu("MATTRESS");
        param.setItmStkId(selectData.getItmStkId());
      }
      List<EgovMap> selecteOrderProduct1 = selecteOrderProduct1(param);
      List<EKeyInApiDto> productList = selecteOrderProduct1.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
      selectData.setProductList(productList);
    } else {
      param.setAppTypeId(selectData.getAppTypeId());
      List<EgovMap> selecteOrderPackType2 = selecteOrderPackType2(param);
      List<EKeyInApiDto> packTypeList = selecteOrderPackType2.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
      selectData.setPackTypeList(packTypeList);

      param.setSrvCntrctPacId(selectData.getSrvPacId());
      if (selectData.getStkCtgryId() == 5706 || selectData.getStkCtgryId() == 5707) {
        param.setStkCtgryId(selectData.getStkCtgryId());
      }
      List<EgovMap> selecteOrderProduct2 = selecteOrderProduct2(param);
      List<EKeyInApiDto> productList = selecteOrderProduct2.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
      selectData.setProductList(productList);
    }

    int yyyy = Integer.parseInt(selectData.getYyyy());
    int mm = Integer.parseInt(selectData.getMm());
    param.setAppTypeId(selectData.getAppTypeId());
    param.setSrvPacId(selectData.getSrvPacId());
    param.setEmpChk(selectData.getEmpChk());
    param.setExTrade(selectData.getExTrade());
    param.setTypeId(selectData.getTypeId());
    param.setPromoId(selectData.getPromoId());
    param.setItmStkId(selectData.getItmStkId());
    param.setPromoDt(selectData.getReqstDt());
    param.setCustomerStatusCode(selectData.getCustomerStatusCode());
    if ((yyyy == 2019 && mm >= 7) || (yyyy >= 2020)) {
      List<EgovMap> selectPromotionByAppTypeStockESales = selectPromotionByAppTypeStockESales(param);
      List<EKeyInApiDto> promotionList = selectPromotionByAppTypeStockESales.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
      selectData.setPromotionList(promotionList);
    } else {
      List<EgovMap> selectPromotionByAppTypeStock = selectPromotionByAppTypeStock(param);
      List<EKeyInApiDto> promotionList = selectPromotionByAppTypeStock.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
      selectData.setPromotionList(promotionList);
    }

    // COMPONENT LISTING
    List<EgovMap> selectCpntList = eKeyInApiMapper.selectCpntLst(EKeyInApiForm.createMap(param));
    selectData.setCpntList(selectCpntList);

    return selectData;
  }

  @Override
  public List<EgovMap> selecteOrderPackType1() throws Exception {
    return eKeyInApiMapper.selecteOrderPackType1();
  }

  @Override
  public List<EgovMap> selecteOrderPackType2(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (param.getAppTypeId() == 67) {
      param.setCodeMasterId(368);

    } else if (param.getAppTypeId() == 68) {
      param.setCodeMasterId(369);

    } else if (param.getAppTypeId() == 1412) {
      param.setCodeMasterId(370);

    } else if (param.getAppTypeId() == 142) {
      param.setCodeMasterId(371);

    } else if (param.getAppTypeId() == 143) {
      param.setCodeMasterId(372);

    } else if (param.getAppTypeId() == 144) {
      param.setCodeMasterId(373);

    } else if (param.getAppTypeId() == 145) {
      param.setCodeMasterId(374);

    } else {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");

    }
    return eKeyInApiMapper.selecteOrderPackType2(EKeyInApiForm.createMap(param));
  }

  @Override
  public List<EgovMap> selecteOrderProduct1(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getSrvCntrctPacId()) || param.getSrvCntrctPacId() < 0) {
      throw new ApplicationException(AppConstants.FAIL, "SrvMemPacID value does not exist.");
    }
    return eKeyInApiMapper.selecteOrderProduct1(EKeyInApiForm.createMap(param));
  }

  @Override
  public List<EgovMap> selecteOrderProduct2(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getSrvCntrctPacId()) || param.getSrvCntrctPacId() < 0) {
      throw new ApplicationException(AppConstants.FAIL, "SrvMemPacID value does not exist.");
    }
    return eKeyInApiMapper.selecteOrderProduct2(EKeyInApiForm.createMap(param));
  }

  @Override
  public List<EgovMap> selectPromotionByAppTypeStockESales(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getAppTypeId())) {
      throw new ApplicationException(AppConstants.FAIL, "App Type ID value does not exist.");
    } else {
      param.setAppTypeId(CommonUtils.changePromoAppTypeId(param.getAppTypeId()));
    }
    if (CommonUtils.isEmpty(param.getTypeId())) {
      throw new ApplicationException(AppConstants.FAIL, "Type ID value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getEmpChk())) {
      throw new ApplicationException(AppConstants.FAIL, "EmpChk value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getExTrade())) {
      throw new ApplicationException(AppConstants.FAIL, " EX Trade value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getSrvPacId())) {
      throw new ApplicationException(AppConstants.FAIL, " Srv Pac ID value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getItmStkId())) {
      throw new ApplicationException(AppConstants.FAIL, " Item Stock ID  value does not exist.");
    }
    /*if (CommonUtils.isEmpty(param.getCustomerStatusCode())) {
        throw new ApplicationException(AppConstants.FAIL, " Customer Status ID  value does not exist.");
      }*/
    return eKeyInApiMapper.selectPromotionByAppTypeStockESales(EKeyInApiForm.createMap(param));
  }

  @Override
  public List<EgovMap> selectPromotionByAppTypeStock(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getAppTypeId())) {
      throw new ApplicationException(AppConstants.FAIL, "App Type ID value does not exist.");
    } else {
      param.setAppTypeId(CommonUtils.changePromoAppTypeId(param.getAppTypeId()));
    }
    if (CommonUtils.isEmpty(param.getTypeId())) {
      throw new ApplicationException(AppConstants.FAIL, "Type ID value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getEmpChk())) {
      throw new ApplicationException(AppConstants.FAIL, "EmpChk value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getExTrade())) {
      throw new ApplicationException(AppConstants.FAIL, " EX Trade value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getSrvPacId())) {
      throw new ApplicationException(AppConstants.FAIL, " Srv Pac ID value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getPromoId())) {
      throw new ApplicationException(AppConstants.FAIL, " Prome ID value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getItmStkId())) {
      throw new ApplicationException(AppConstants.FAIL, " Item Stock ID  value does not exist.");
    }
    return eKeyInApiMapper.selectPromotionByAppTypeStock(EKeyInApiForm.createMap(param));
  }

  @Override
  public List<EgovMap> selectBankList() throws Exception {
    return eKeyInApiMapper.selectBankList();
  }

  @Override
  public List<EgovMap> selectAnotherContact(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustId())) {
      throw new ApplicationException(AppConstants.FAIL, "Cust ID value does not exist.");
    }
    return eKeyInApiMapper.selectAnotherContact(EKeyInApiForm.createMap(param));
  }

  @Override
  public EKeyInApiDto saveAddNewContact(EKeyInApiDto param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }

    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", param.getRegId());
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "UserID is null.");
    }

    if (CommonUtils.isEmpty(param.getCustId()) || param.getCustId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Cust ID value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustInitial()) || param.getCustInitial() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Initials value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getName())) {
      throw new ApplicationException(AppConstants.FAIL, "Name value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getGender())) {
      throw new ApplicationException(AppConstants.FAIL, "Gender value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getRaceId()) || param.getRaceId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Race value does not exist.");
    }

    Map<String, Object> sal0027d = new HashMap<String, Object>();
    sal0027d.put("custId", param.getCustId());
    sal0027d.put("custInitial", param.getCustInitial());
    sal0027d.put("name", param.getName());
    sal0027d.put("gender", param.getGender());
    sal0027d.put("raceId", param.getRaceId());
    sal0027d.put("telM1", param.getTelM1());
    sal0027d.put("telR", param.getTelR());
    sal0027d.put("telO", param.getTelO());
    sal0027d.put("telf", param.getTelf());
    sal0027d.put("email", param.getEmail());
    sal0027d.put("ext", param.getExt());
    sal0027d.put("crtUserId", loginVO.getUserId());
    sal0027d.put("updUserId", loginVO.getUserId());

    // CHECK ANY MAIN CONTACT EXIST BEFORE
    int existCnt = eKeyInApiMapper.selectExistContact(sal0027d);
    if (existCnt == 0) {
      sal0027d.put("stat", '9');
    } else {
      sal0027d.put("stat", '1');
    }

    int saveCnt = eKeyInApiMapper.insertAddNewContact(sal0027d);
    if (saveCnt != 1) {
      throw new ApplicationException(AppConstants.FAIL, "Contact Exception.");
    }
    if (CommonUtils.isEmpty(sal0027d.get("custCntcId"))) {
      throw new ApplicationException(AppConstants.FAIL, "Cust Contact ID value does not exist.");
    }

    List<EgovMap> selectAnotherContact = eKeyInApiMapper.selectAnotherContact(sal0027d);
    if (selectAnotherContact.size() != 1) {
      throw new ApplicationException(AppConstants.FAIL, "Error");
    }

    return EKeyInApiDto.create(selectAnotherContact.get(0));
  }

  @Override
  public EKeyInApiDto selecteOrderProductHomecare(EKeyInApiForm param) throws Exception {
    EKeyInApiDto rtn = new EKeyInApiDto();

    List<EgovMap> selectMattressProductList = null;
    List<EgovMap> selectFrameProductList = null;

    if (param.getAppTypeId() == 66) { // FOR RENTAL
      param.setStkCtgryId(5706);
      selectMattressProductList = selecteOrderProduct1(param);

      param.setStkCtgryId(5707);
      selectFrameProductList = selecteOrderProduct1(param);
    } else { // FOR OUTRIGHT AND INSTALLMENT
      param.setStkCtgryId(5706);
      selectMattressProductList = selecteOrderProduct2(param);

      param.setStkCtgryId(5707);
      selectFrameProductList = selecteOrderProduct2(param);
    }
    List<EKeyInApiDto> mattressProductList = selectMattressProductList.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
    rtn.setMattressProductList(mattressProductList);

    List<EKeyInApiDto> frameProductList = selectFrameProductList.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
    rtn.setFrameProductList(frameProductList);
    return rtn;
  }

  public EKeyInApiDto selectItmStkPrice(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getAppTypeId())) {
      throw new ApplicationException(AppConstants.FAIL, "appTypeId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getItmStkId())) {
      throw new ApplicationException(AppConstants.FAIL, "itmStkId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getSrvPacId())) {
      throw new ApplicationException(AppConstants.FAIL, "srvPacId value does not exist.");
    }

    // EgovMap selectItmStkPrice = eKeyInApiMapper.selectItmStkPrice(EKeyInApiForm.createMap(param));
    EgovMap selectItmStkPrice = null;

    if ("66".equals(CommonUtils.nvl(param.getAppTypeId()))) { // FOR RENTAL
      selectItmStkPrice = eKeyInApiMapper.selectItmStkPrice(EKeyInApiForm.createMap(param));
    } else { // FOR OUTRIGHT AND INSTALLMENT
      selectItmStkPrice = eKeyInApiMapper.selectItmStkPrice2(EKeyInApiForm.createMap(param));
    }
    if (MapUtils.isEmpty(selectItmStkPrice)) {
      throw new ApplicationException(AppConstants.FAIL, "No price information.");
    }
    if (SalesConstants.APP_TYPE_CODE_ID_RENTAL == param.getAppTypeId()) {
      selectItmStkPrice.put("totAmt", selectItmStkPrice.get("prcRpf"));
      selectItmStkPrice.put("mthRentAmt", selectItmStkPrice.get("monthlyRental"));
    } else {
      selectItmStkPrice.put("totAmt", selectItmStkPrice.get("amt"));
      selectItmStkPrice.put("mthRentAmt", BigDecimal.ZERO);
    }
    return EKeyInApiDto.create(selectItmStkPrice);
  }

  @Override
  public EKeyInApiDto selectItmStkChangeInfo(EKeyInApiForm param) throws Exception {
    EKeyInApiDto selectItmStkPrice = selectItmStkPrice(param);

    // List<EgovMap> promotionList = selectPromotionByAppTypeStock(param);
    List<EgovMap> promotionList = selectPromotionByAppTypeStockESales(param);
    List<EKeyInApiDto> promotionListDto = promotionList.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
    selectItmStkPrice.setPromotionList(promotionListDto);

    if (CommonUtils.isNotEmpty(param.getGu()) && param.getGu().equals("MATTRESS")) {
      param.setStkCtgryId(5707);

      // check aircon type category
      /*
       * int result = homecareCmMapper.checkIfIsAcInstallationProductCategoryCode(String.valueOf(param.getItmStkId()));
       * if(result == 1){
       * param.setGu("");
       * }
       * else{
       * param.setGu("MATTRESS");
       * }
       */
      param.setSrvCntrctPacId(param.getSrvPacId());
      List<EgovMap> selecteOrderProduct1 = null;

      if ("66".equals(CommonUtils.nvl(param.getAppTypeId())) || "2284".equals(CommonUtils.nvl(param.getAppTypeId()))) {
        selecteOrderProduct1 = selecteOrderProduct1(param);
      } else {
        selecteOrderProduct1 = selecteOrderProduct2(param);
      }

      if (selecteOrderProduct1.size() != 0) {
        List<EKeyInApiDto> selectFrameProductList = selecteOrderProduct1.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
        selectItmStkPrice.setFrameProductList(selectFrameProductList);
      }
    }
    return selectItmStkPrice;
  }

  @Override
  public EKeyInApiDto selectPromoChange(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getSrvPacId())) {
      throw new ApplicationException(AppConstants.FAIL, "srvPacId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getItmStkId())) {
      throw new ApplicationException(AppConstants.FAIL, "itmStkId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getPromoId())) {
      throw new ApplicationException(AppConstants.FAIL, "promoId value does not exist.");
    }

    EgovMap selectPromoDesc = eKeyInApiMapper.selectPromoDesc(param.getPromoId());
    int isNew = CommonUtils.intNvl(selectPromoDesc.get("isNew"));

    BigDecimal orderPricePromo = BigDecimal.ZERO;
    BigDecimal orderPVPromo = BigDecimal.ZERO;
    BigDecimal orderPVPromoGST = BigDecimal.ZERO;
    BigDecimal orderRentalFeesPromo = BigDecimal.ZERO;
    // BigDecimal normalRentalFees = BigDecimal.ZERO;
    BigDecimal quotaStus = BigDecimal.ZERO;

    Map<String, Object> createParam = EKeyInApiForm.createMap(param);

    EgovMap priceInfo = null;
    if (isNew == 1) {
      if (param.getSrvPacId() == 4) {
        priceInfo = eKeyInApiMapper.selectProductPromotionPriceByPromoStockIDNewCorp(createParam);
      } else {
        priceInfo = eKeyInApiMapper.selectProductPromotionPriceByPromoStockIDNew(createParam);
      }

      if (null != priceInfo) {
        if (SalesConstants.PROMO_APP_TYPE_CODE_ID_REN == Integer.parseInt(String.valueOf((BigDecimal) priceInfo.get("promoAppTypeId")))) { // Rental
          orderPricePromo = (BigDecimal) priceInfo.get("promoPrcRpf");
          orderRentalFeesPromo = (BigDecimal) priceInfo.get("promoAmt");
          orderPVPromo = (BigDecimal) priceInfo.get("promoItmPv");
          orderPVPromoGST = (BigDecimal) priceInfo.get("promoItmPvGst");
          // normalRentalFees = (BigDecimal) priceInfo.get("amt");
          quotaStus = (BigDecimal) priceInfo.get("quotaStus");

        } else {
          if (param.getPromoId() == 31834 && param.getPromoId() == 892 && param.getPromoId() == 0) {
            orderPricePromo = BigDecimal.valueOf(3540);
          } else {
            orderPricePromo = (BigDecimal) priceInfo.get("promoAmt");
          }
          orderRentalFeesPromo = BigDecimal.ZERO;
          orderPVPromo = (BigDecimal) priceInfo.get("promoItmPv");
          orderPVPromoGST = (BigDecimal) priceInfo.get("promoItmPvGst");
          // normalRentalFees = BigDecimal.ZERO;
          quotaStus = (BigDecimal) priceInfo.get("quotaStus");
        }

        priceInfo.put("totAmt", orderPricePromo);
        priceInfo.put("mthRentAmt", orderRentalFeesPromo);
        priceInfo.put("totPv", orderPVPromo);
        priceInfo.put("totPvGst", orderPVPromoGST);
        priceInfo.put("quotaStus", quotaStus);

        // priceInfo.put("promoDiscPeriodTp",
        // selectPromoDesc.get("promoDiscPeriodTp"));
        // priceInfo.put("promoDiscPeriod",
        // selectPromoDesc.get("promoDiscPeriod"));
        // priceInfo.put("normalRentalFees", normalRentalFees);
      }
    } else {
      priceInfo = eKeyInApiMapper.selectProductPromotionPriceByPromoStockID(createParam);

      if (null != priceInfo) {
        orderPricePromo = (BigDecimal) priceInfo.get("promoItmPrc");
        orderPVPromo = (BigDecimal) priceInfo.get("promoItmPv");
        orderRentalFeesPromo = ((BigDecimal) priceInfo.get("promoItmRental")).compareTo(BigDecimal.ZERO) > 0 ? (BigDecimal) priceInfo.get("promoItmRental") : BigDecimal.ZERO;
        quotaStus = (BigDecimal) priceInfo.get("quotaStus");

        priceInfo.put("totAmt", orderPricePromo);
        priceInfo.put("mthRentAmt", orderRentalFeesPromo);
        priceInfo.put("totPv", orderPVPromo);
        priceInfo.put("totPvGst", BigDecimal.ZERO);
        priceInfo.put("quotaStus", quotaStus);

        // priceInfo.put("promoDiscPeriodTp",
        // selectPromoDesc.get("promoDiscPeriodTp"));
        // priceInfo.put("promoDiscPeriod",
        // selectPromoDesc.get("promoDiscPeriod"));
        // priceInfo.put("normalPricePromo", normalRentalFees);
      }
    }

    EKeyInApiDto rtn = new EKeyInApiDto();
    if (MapUtils.isNotEmpty(priceInfo)) {
      rtn = EKeyInApiDto.create(priceInfo);
    }
    return rtn;
  }

  @Override
  public EgovMap selectSrvType(EKeyInApiForm param) throws Exception {

	  if (null == param) {
	      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
	    }
	  if ( CommonUtils.isEmpty( String.valueOf( param.getItmStkId()) ) ) {
	      throw new ApplicationException( AppConstants.FAIL, "Item ID value does not exist." );
	    }
	    if ( CommonUtils.isEmpty( String.valueOf( param.getPromoId()) ) )  {
	      throw new ApplicationException( AppConstants.FAIL, "Promo ID value does not exist." );
	    }

	    return eKeyInApiMapper.selectSrvType(EKeyInApiForm.createMap( param ));


  }

  @Override
  public List<EgovMap> selectAnotherAddress(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustId())) {
      throw new ApplicationException(AppConstants.FAIL, "Cust ID value does not exist.");
    }
    return eKeyInApiMapper.selectAnotherAddress(EKeyInApiForm.createMap(param));
  }

  @Override
  public EKeyInApiDto saveAddNewAddress(EKeyInApiDto param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }

    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", param.getRegId());
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "UserID is null.");
    }

    if (CommonUtils.isEmpty(param.getCustId()) || param.getCustId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Cust ID value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getAreaId())) {
      throw new ApplicationException(AppConstants.FAIL, "Area ID value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getAddrDtl())) {
      throw new ApplicationException(AppConstants.FAIL, "Address Detail value does not exist.");
    }
    if (CommonUtils.isNotEmpty(param.getRem()) && StringUtil.getEncodedSize(String.valueOf(param.getRem())) > 80) {
      throw new ApplicationException(AppConstants.FAIL, "Remark is too long.");
    }

    Map<String, Object> sal0023d = new HashMap<String, Object>();
    sal0023d.put("custId", param.getCustId());
    sal0023d.put("rem", param.getRem());
    sal0023d.put("updUserId", loginVO.getUserId());
    sal0023d.put("crtUserId", loginVO.getUserId());
    sal0023d.put("areaId", param.getAreaId());
    sal0023d.put("addrDtl", param.getAddrDtl());
    sal0023d.put("street", param.getStreet());
    sal0023d.put("userNm", param.getRegId());

    // CHECK ANY MAIN ADDRESS EXIST BEFORE
    int existCnt = eKeyInApiMapper.selectExistAddress(sal0023d);
    if (existCnt == 0) {
      sal0023d.put("stat", '9');
    } else {
      sal0023d.put("stat", '1');
    }

    int saveCnt = eKeyInApiMapper.insertAddNewAddress(sal0023d);
    if (saveCnt != 1) {
      throw new ApplicationException(AppConstants.FAIL, "Address Exception.");
    }
    if (CommonUtils.isEmpty(sal0023d.get("custAddId"))) {
      throw new ApplicationException(AppConstants.FAIL, "Cust Contact ID value does not exist.");
    }

    List<EgovMap> selectAnotherAddress = eKeyInApiMapper.selectAnotherAddress(sal0023d);
    if (selectAnotherAddress.size() != 1) {
      throw new ApplicationException(AppConstants.FAIL, "Error");
    }

    return EKeyInApiDto.create(selectAnotherAddress.get(0));
  }

  @Override
  public List<EKeyInApiDto> selectAnotherCard(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustId())) {
      throw new ApplicationException(AppConstants.FAIL, "Cust ID value does not exist.");
    }
    List<EgovMap> selectAnotherCard = eKeyInApiMapper.selectAnotherCard(EKeyInApiForm.createMap(param));
    List<EKeyInApiDto> selectAnotherCardList = selectAnotherCard.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
    for (EKeyInApiDto data : selectAnotherCardList) {
      data.setCustOriCrcNo(CommonUtils.getMaskCreditCardNo(StringUtils.trim(data.getCustOriCrcNo()), "*", 4));
    }
    return selectAnotherCardList;
  }

  @Override
  public EKeyInApiDto selectNewCardInfo() throws Exception {
    /*
     * EKeyInApiDto selectNewCardInfo = EKeyInApiDto.create(eKeyInApiMapper.selectParamVal());
     * if (CommonUtils.isEmpty(selectNewCardInfo.getParamVal())) {
     * throw new ApplicationException(AppConstants.FAIL, "paramVal value does not exist.");
     * }
     * selectNewCardInfo
     * .setParamVal("-----BEGIN PUBLIC KEY-----" + selectNewCardInfo.getParamVal() + "-----END PUBLIC KEY-----");
     */

    EKeyInApiDto selectNewCardInfo = new EKeyInApiDto();
    List<EgovMap> selectBankList = eKeyInApiMapper.selectBankList();
    selectNewCardInfo.setBankList(selectBankList.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
    return selectNewCardInfo;
  }

  @Override
  public EKeyInApiDto saveTokenLogging(EKeyInApiDto param) throws Exception {
    if (logger.isDebugEnabled()) {
      logger.debug("::::::::::::::::::::::::::::::::::::::::::::::::::::::");
      logger.debug("[START]saveTokenLogging");
      logger.debug("::::::::::::::::::::::::::::::::::::::::::::::::::::::");
    }
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getNric())) {
      throw new ApplicationException(AppConstants.FAIL, "Nric value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustId())) {
      throw new ApplicationException(AppConstants.FAIL, "Cust ID value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getEtyPoint())) {
      throw new ApplicationException(AppConstants.FAIL, "etyPoint value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getPan())) {
      throw new ApplicationException(AppConstants.FAIL, "PAN value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getExpyear())) {
      throw new ApplicationException(AppConstants.FAIL, "EXPYEAR value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getExpmonth())) {
      throw new ApplicationException(AppConstants.FAIL, "EXPMONTH value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustCrcExprYYYY())) {
      throw new ApplicationException(AppConstants.FAIL, "YYYY value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustCrcExprMM())) {
      throw new ApplicationException(AppConstants.FAIL, "MM value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustCrcOwner())) {
      throw new ApplicationException(AppConstants.FAIL, "CustCrcOwner value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getRegId())) {
      throw new ApplicationException(AppConstants.FAIL, "regId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustOriCrcNo())) {
      throw new ApplicationException(AppConstants.FAIL, "custOriCrcNo value does not exist.");
    }

    EKeyInApiForm selectParam = new EKeyInApiForm();
    selectParam.setCustId(param.getCustId());
    selectParam.setCustOriCrcNo(param.getCustOriCrcNo());
    int existing = eKeyInApiMapper.selectCreditCardIsExisting(EKeyInApiForm.createMap(selectParam));
    if (existing != 0) {
      throw new ApplicationException(AppConstants.FAIL, "Credit card is existing.");
    }

    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", param.getRegId());
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "UserID is null.");
    }

    // Get token ID
    int tknId = eKeyInApiMapper.selectTokenID();
    if (CommonUtils.isEmpty(tknId) || tknId <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "TokenID is null.");
    }

    /*
     * Construct RefNO for tokenization's reference NN :: New Customer > New CRC
     * :: NRIC EN :: Edit Customer > New CRC :: NRIC + Cust ID EE :: Edit
     * Customer > Edit CRC :: NRIC + Cust ID + Cust CRC ID
     */
    String r1 = "";
    String r2 = "";
    String r3 = "";
    if (param.getNric().length() < 12) {
      r1 = StringUtils.leftPad(param.getNric(), 12, "0");
    } else {
      r1 = param.getNric().substring(param.getNric().length() - 12);
    }
    if ("NN".equals(param.getEtyPoint())) {
      r2 = StringUtils.leftPad("", 10, "0");
      r3 = StringUtils.leftPad("", 10, "0");
    } else if ("EN".equals(param.getEtyPoint()) || "EE".equals(param.getEtyPoint())) {
      if (Integer.toString(param.getCustId()).length() < 10) {
        r2 = StringUtils.leftPad(Integer.toString(param.getCustId()), 10, "0");
        r3 = StringUtils.leftPad("", 10, "0");
      } else {
        r2 = Integer.toString(param.getCustId());
        r3 = StringUtils.leftPad("", 10, "0");
      }
      if ("EE".equals(param.getEtyPoint())) {
        if (CommonUtils.isEmpty(param.getCustCrcId()) || param.getCustCrcId() <= 0) {
          throw new ApplicationException(AppConstants.FAIL, "CustCrcId is null.");
        }
        if (Integer.toString(param.getCustCrcId()).length() < 10) {
          r3 = StringUtils.leftPad(Integer.toString(param.getCustCrcId()), 10, "0");
        } else {
          r3 = Integer.toString(param.getCustCrcId()).toString();
        }
      }
    }
    String refNo = r1 + r2 + r3;

    // Creating reference number
    EKeyInApiDto selectTokenSettings = EKeyInApiDto.create(eKeyInApiMapper.selectTokenSettings());
    String urlReq = selectTokenSettings.getTknzUrl();
    String merchantId = selectTokenSettings.getTknzMerchantId();
    String verfKey = selectTokenSettings.getTknzVerfKey();
    if (CommonUtils.isEmpty(selectTokenSettings.getTknzUrl()) || CommonUtils.isEmpty(selectTokenSettings.getTknzMerchantId()) || CommonUtils.isEmpty(selectTokenSettings.getTknzVerfKey())) {
      throw new ApplicationException(AppConstants.FAIL, "selectTokenSettings value does not exist.");
    }

    // Get Encrypted credit card information
    String ccNum = param.getPan();
    String expYear = param.getExpyear();
    String expMonth = param.getExpmonth();

    // Hashing SHA-256
    String signature = merchantId + refNo + ccNum + expMonth + expYear + "1" + verfKey;
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    byte[] hashInBytes = md.digest(signature.getBytes(StandardCharsets.UTF_8));
    StringBuilder sb = new StringBuilder();
    for (byte b : hashInBytes) {
      sb.append(String.format("%02x", b));
    }
    signature = sb.toString();

    param.setUrlReq(urlReq);
    param.setMerchantId(merchantId);
    param.setSignature(signature);

    Map<String, Object> sal0257D = new HashMap<String, Object>();
    sal0257D.put("tknId", tknId);
    sal0257D.put("refNo", refNo);
    if ("EE".equals(param.getEtyPoint())) {
      sal0257D.put("custCrcId", param.getCustCrcId());
    }
    sal0257D.put("billNm", param.getCustCrcOwner());
    sal0257D.put("expMonth", param.getCustCrcExprMM());
    sal0257D.put("expYear", param.getCustCrcExprYYYY());
    sal0257D.put("signatureReq", signature);
    sal0257D.put("crtUserId", loginVO.getUserId());
    sal0257D.put("updUserId", loginVO.getUserId());
    int saveCnt = eKeyInApiMapper.insertSAL0257D(sal0257D);
    if (saveCnt != 1) {
      throw new ApplicationException(AppConstants.FAIL, "Card Exception.");
    }

    EKeyInApiDto rtn = new EKeyInApiDto();
    rtn.setTknId(tknId);
    rtn.setRefNo(refNo);
    rtn.setUrlReq(urlReq);
    rtn.setMerchantId(merchantId);
    rtn.setSignature(signature);
    if (logger.isDebugEnabled()) {
      logger.debug("::::::::::::::::::::::::::::::::::::::::::::::::::::::");
      logger.debug("[END]saveTokenLogging");
      logger.debug("::::::::::::::::::::::::::::::::::::::::::::::::::::::");
    }
    return rtn;
  }

  @Override
  public EKeyInApiDto saveTokenizationProcess(EKeyInApiDto param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }

    if (CommonUtils.isEmpty(param.getTknId())) {
      throw new ApplicationException(AppConstants.FAIL, "tknId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getUrlReq())) {
      throw new ApplicationException(AppConstants.FAIL, "urlReq value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getMerchantId())) {
      throw new ApplicationException(AppConstants.FAIL, "merchantId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getRefNo())) {
      throw new ApplicationException(AppConstants.FAIL, "refNo value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustCrcOwner())) {
      throw new ApplicationException(AppConstants.FAIL, "custCrcOwner value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getPan())) {
      throw new ApplicationException(AppConstants.FAIL, "pan value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getExpyear())) {
      throw new ApplicationException(AppConstants.FAIL, "expyear value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getExpmonth())) {
      throw new ApplicationException(AppConstants.FAIL, "expmonth value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getSignature())) {
      throw new ApplicationException(AppConstants.FAIL, "signature value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getEtyPoint())) {
      throw new ApplicationException(AppConstants.FAIL, "etyPoint value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustCrcExprMM())) {
      throw new ApplicationException(AppConstants.FAIL, "custCrcExprMM value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustCrcExprYYYY())) {
      throw new ApplicationException(AppConstants.FAIL, "custCrcExprYYYY value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustId())) {
      throw new ApplicationException(AppConstants.FAIL, "custId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustCrcTypeId())) {
      throw new ApplicationException(AppConstants.FAIL, "custCrcTypeId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustCrcBankId())) {
      throw new ApplicationException(AppConstants.FAIL, "custCrcBankId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCardTypeId())) {
      throw new ApplicationException(AppConstants.FAIL, "cardTypeId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getCustOriCrcNo())) {
      throw new ApplicationException(AppConstants.FAIL, "custOriCrcNo value does not exist.");
    }

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
    @SuppressWarnings("restriction")
    URL url = new URL(null, param.getUrlReq(), new sun.net.www.protocol.https.Handler());
    URLConnection con = url.openConnection();
    con.setRequestProperty("User-Agent", "Mozilla/5.0");
    HttpsURLConnection http = (HttpsURLConnection) con;
    http.setSSLSocketFactory(sslContext.getSocketFactory());
    http.setHostnameVerifier(new HostnameVerifier() {
      @Override
      public boolean verify(String s, SSLSession sslSession) {
        return true;
      }
    });
    http.setRequestMethod("POST");
    http.setDoOutput(true);

    Map<String, String> requestParam = new HashMap<>();
    requestParam.put("merchantID", param.getMerchantId());
    requestParam.put("referenceNo", param.getRefNo());
    requestParam.put("billingName", param.getCustCrcOwner());
    requestParam.put("billingEmail", param.getRefNo().substring(12, 22));
    requestParam.put("billingMobile", param.getRefNo().substring(22));
    requestParam.put("creditCardNo", param.getPan());
    requestParam.put("expMonth", param.getExpmonth());
    requestParam.put("expYear", param.getExpyear());
    requestParam.put("tokenType", "1");
    requestParam.put("signature", param.getSignature());

    StringJoiner sj = new StringJoiner("&");
    for (Map.Entry<String, String> entry : requestParam.entrySet()) {
      sj.add(URLEncoder.encode(entry.getKey(), "UTF-8") + "=" + URLEncoder.encode(entry.getValue(), "UTF-8"));
    }
    byte[] out = sj.toString().getBytes(StandardCharsets.UTF_8);
    int length = out.length;
    http.setFixedLengthStreamingMode(length);
    http.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
    http.connect();
    try (OutputStream os = http.getOutputStream()) {
      os.write(out);
    }
    BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
    String inputLine = in.readLine();
    in.close();

    Map<String, Object> retResult = new HashMap<String, Object>();

    retResult.put("tknId", param.getTknId());
    retResult.put("resText", inputLine);
    inputLine = inputLine.replaceAll("[\\{\"\\}]", "");
    String[] arr1 = inputLine.split(",");

    for (int i = 0; i < arr1.length; i++) {
      String[] arr2 = arr1[i].split(":");
      retResult.put(arr2[0], arr2[1]);
    }

    EKeyInApiDto rtnDto = new EKeyInApiDto();
    String crcCheck = "";
    String stus = "";
    String errorDesc = "";
    if (!retResult.containsKey("error_code")) {
      Map<String, Object> loginInfoMap = new HashMap<String, Object>();
      loginInfoMap.put("_USER_ID", param.getRegId());
      LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
      if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
        throw new ApplicationException(AppConstants.FAIL, "UserID is null.");
      }
      retResult.put("crtUserId", loginVO.getUserId());
      retResult.put("updUserId", loginVO.getUserId());
      retResult.put("stus", "1");

      int saveCnt = eKeyInApiMapper.updateSAL0257D(retResult);
      if (saveCnt != 1) {
        throw new ApplicationException(AppConstants.FAIL, "Card Exception.");
      }

      Map<String, Object> crcParam = new HashMap<>();
      crcParam.put("cardNo", retResult.get("BIN").toString() + "%" + retResult.get("cclast4").toString());
      crcParam.put("nric", param.getRefNo().substring(0, 12));
      crcParam.put("custId", param.getRefNo().substring(12, 22).replaceFirst("^0+(?!$)", ""));
      crcParam.put("custCrcId", param.getRefNo().replaceFirst("^0+(?!$)", ""));
      crcParam.put("token", retResult.get("token"));

      // Check CRC's 1st 6 digits, last 4 digits
      // Pending to check if needed to add expiry date + name for checking
      int step1 = (Integer) eKeyInApiMapper.selectCheckCRC1(crcParam);
      if (step1 != 0) {
        if (!"EE".equals(param.getEtyPoint())) {
          int step2 = (Integer) eKeyInApiMapper.selectCheckCRC1(crcParam);

          if (step2 >= 1) {
            crcParam.put("step", "3");
            int step3 = (Integer) eKeyInApiMapper.selectCheckCRC2(crcParam);
            if (step3 >= 1) {
              crcCheck = "3";
              errorDesc = "This Bank card number is used by another customer.</br>Please inform respective HP/Cody.";
            } else {
              crcCheck = "0";
            }
          } else {
            crcCheck = "0";
          }
        } else {
          crcCheck = "0";
        }
      } else {
        crcCheck = "0";
      }
      String crcNo = retResult.get("BIN").toString() + "******" + retResult.get("cclast4").toString();
      stus = "1";

      if (crcCheck.equals("0")) {
        // String custCrcExpr = Integer.toString(param.getCustCrcExprMM()) +
        // Integer.toString(param.getCustCrcExprYYYY()).substring(2);
        String custCrcExpr = param.getCustCrcExprMM() + param.getCustCrcExprYYYY().substring(2); // ONGHC
                                                                                                 // -
                                                                                                 // 20200323
        Map<String, Object> sal0028D = new HashMap<String, Object>();
        // sal0028D.put("custCrcId", );
        sal0028D.put("custId", param.getCustId());
        sal0028D.put("custCrcNo", param.getCustOriCrcNo());
        sal0028D.put("custOriCrcNo", param.getCustOriCrcNo());
        sal0028D.put("custEncryptCrcNo", param.getCustOriCrcNo());
        sal0028D.put("custCrcOwner", param.getCustCrcOwner());
        sal0028D.put("custCrcTypeId", param.getCustCrcTypeId());
        sal0028D.put("custCrcBankId", param.getCustCrcBankId());
        sal0028D.put("custCrcStusId", 1);
        sal0028D.put("custCrcRem", param.getCustCrcRem());
        sal0028D.put("custCrcUpdUserId", loginVO.getUserId());
        // sal0028D.put("custCrcUpdDt", );
        sal0028D.put("custCrcExpr", custCrcExpr);
        sal0028D.put("custCrcIdOld", 0);
        sal0028D.put("soId", 0);
        sal0028D.put("custCrcIdcm", 0);
        sal0028D.put("custCrcCrtUserId", loginVO.getUserId());
        // sal0028D.put("custCrcCrtDt", );
        sal0028D.put("cardTypeId", param.getCardTypeId());
        sal0028D.put("custCrcToken", "");
        saveCnt = eKeyInApiMapper.insertSAL0028D(sal0028D);
        if (saveCnt != 1) {
          throw new ApplicationException(AppConstants.FAIL, "Card Exception.");
        }
        if (CommonUtils.isEmpty(sal0028D.get("custCrcId"))) {
          throw new ApplicationException(AppConstants.FAIL, "custCrcId value does not exist.");
        }
        retResult.put("custCrcId", sal0028D.get("custCrcId"));
        saveCnt = eKeyInApiMapper.updateCustCrcIdSAL0257D(retResult);
        if (saveCnt != 1) {
          throw new ApplicationException(AppConstants.FAIL, "Card Exception.");
        }

        EKeyInApiForm selectParam = new EKeyInApiForm();
        selectParam.setCustId(param.getCustId());
        selectParam.setCustCrcId(Integer.parseInt(sal0028D.get("custCrcId").toString()));
        List<EgovMap> selectAnotherCard = eKeyInApiMapper.selectAnotherCard(EKeyInApiForm.createMap(selectParam));
        List<EKeyInApiDto> selectAnotherCardList = selectAnotherCard.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
        if (selectAnotherCardList.size() != 1) {
          throw new ApplicationException(AppConstants.FAIL, "Error");
        }
        for (EKeyInApiDto data : selectAnotherCardList) {
          data.setCustOriCrcNo(CommonUtils.getMaskCreditCardNo(StringUtils.trim(data.getCustOriCrcNo()), "*", 4));
        }
        rtnDto = selectAnotherCardList.get(0);
      }
    } else {
      retResult.put("stus", "21");

      int saveCnt = eKeyInApiMapper.updateSAL0257D(retResult);
      if (saveCnt != 1) {
        throw new ApplicationException(AppConstants.FAIL, "Card Exception.");
      }
      saveCnt = eKeyInApiMapper.insertSAL0258D(retResult);
      if (saveCnt != 1) {
        throw new ApplicationException(AppConstants.FAIL, "Card Exception.");
      }
      param.setStus("21");
      if ("T9".equals(retResult.get("error_code"))) {
        errorDesc = "Invalid credit card.";
      } else {
        errorDesc = retResult.get("error_desc").toString();
      }
    }
    rtnDto.setStus(stus);
    rtnDto.setCrcCheck(crcCheck);
    rtnDto.setErrorDesc(errorDesc);
    return rtnDto;
  }

  @Override
  public EKeyInApiDto selectCheckRc(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getRegId())) {
      throw new ApplicationException(AppConstants.FAIL, "regId value does not exist.");
    }
    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", param.getRegId());
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "UserID is null.");
    }
    Map<String, Object> params = new HashMap<String, Object>();
    params.put("userId", loginVO.getUserId());
    if (!CommonUtils.isEmpty(param.getNric())) {
      params.put("nric", param.getNric());
    }

    EgovMap selectCheckRc = eKeyInApiMapper.selectCheckRc(params);

    EKeyInApiDto rtn = new EKeyInApiDto();
    if (MapUtils.isNotEmpty(selectCheckRc)) {
      rtn = EKeyInApiDto.create(selectCheckRc);
    }
    return rtn;
  }

  @Override
  public EKeyInApiDto selectExistSofNo(EKeyInApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Error Encounter. Please Contact System Administrator [selectExistSofNo : Param Missing]. ");
    }
    if (CommonUtils.isEmpty(param.getTypeId())) {
      throw new ApplicationException(AppConstants.FAIL, "Error Encounter. Please Contact System Administrator [selectExistSofNo : Type ID Missing]. ");
    }
    if (CommonUtils.isEmpty(param.getNric())) {
      throw new ApplicationException(AppConstants.FAIL, "Error Encounter. Please Contact System Administrator [selectExistSofNo : NRIC Missing]. ");
    }
    if (CommonUtils.isEmpty(param.getSofNo())) {
      throw new ApplicationException(AppConstants.FAIL, "Error Encounter. Please Contact System Administrator [selectExistSofNo : SOF Missing]. ");
    }
    if (CommonUtils.isEmpty(param.getUserNm())) {
      throw new ApplicationException(AppConstants.FAIL, "Error Encounter. Please Contact System Administrator [selectExistSofNo : User Name Missing]. ");
    }

    EKeyInApiDto rtn = new EKeyInApiDto();

    int selectExistSofNo = eKeyInApiMapper.selectExistSofNo(EKeyInApiForm.createMap(param));
    // int selectExistSofNo = 0;
    rtn.setCnt(selectExistSofNo);

    if (selectExistSofNo == 0) {
      EgovMap selectCustomerInfo = eKeyInApiMapper.selectCustomerInfo(EKeyInApiForm.createMap(param));
      if (MapUtils.isNotEmpty(selectCustomerInfo)) {
        rtn = EKeyInApiDto.create(selectCustomerInfo);

        param.setCustId(rtn.getCustId());
        param.setStusCodeId(9);
        List<EgovMap> selectAnotherContact = eKeyInApiMapper.selectAnotherContact(EKeyInApiForm.createMap(param));
        if (selectAnotherContact.size() > 1) {
          throw new ApplicationException(AppConstants.FAIL, "Please Check on Customer's Contact Detail. MAIN Record found " + selectAnotherContact.size() + "");
        }
        if (selectAnotherContact.size() == 1) {
          rtn.setSelectAnotherContactMain(EKeyInApiDto.create(selectAnotherContact.get(0)));
        }

        List<EgovMap> selectAnotherAddress = eKeyInApiMapper.selectAnotherAddress(EKeyInApiForm.createMap(param));
        if (selectAnotherAddress.size() == 0) {
          throw new ApplicationException(AppConstants.FAIL, "Please Check on Customer's Address Detail. MAIN Record found " + selectAnotherAddress.size() + "");
        }
        // if( selectAnotherAddress.size() == 1 ){
        rtn.setSelectAnotherAddressMain(EKeyInApiDto.create(selectAnotherAddress.get(0)));
        // }
      }

      List<EgovMap> selectBankList = eKeyInApiMapper.selectBankList();
      rtn.setBankList(selectBankList.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
    }
    return rtn;
  }

  @Override
  public int insertUploadFileSal0500(List<FileVO> list, EKeyInApiDto param) {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "userId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getFileKeySeq())) {
      throw new ApplicationException(AppConstants.FAIL, "fileKeySeq value does not exist.");
    }

    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", param.getUserId());
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "UserID is null.");
    }

    int fileGroupKey = 0;
    if (CommonUtils.isEmpty(param.getAtchFileGrpId()) || param.getAtchFileGrpId() == 0) {
      fileGroupKey = eKeyInApiMapper.selectFileGroupKey();
    } else {
      fileGroupKey = param.getAtchFileGrpId();
    }

    for (FileVO data : list) {
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      // sys0070M.put("atchFileId", );
      sys0071D.put("atchFileName", data.getAtchFileName());
      sys0071D.put("fileSubPath", data.getFileSubPath());
      sys0071D.put("physiclFileName", data.getPhysiclFileName());
      sys0071D.put("fileExtsn", data.getFileExtsn());
      sys0071D.put("fileSize", data.getFileSize());
      sys0071D.put("filePassword", null);
      sys0071D.put("fileUnqKey", null);
      sys0071D.put("fileKeySeq", param.getFileKeySeq());
      int saveCnt = eKeyInApiMapper.insertSYS0071D(sys0071D);
      if (saveCnt == 0) {
        throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
      }
      if (CommonUtils.isEmpty(sys0071D.get("atchFileId"))) {
        throw new ApplicationException(AppConstants.FAIL, "atchFileId value does not exist.");
      }

      Map<String, Object> sys0070M = new HashMap<String, Object>();
      sys0070M.put("atchFileGrpId", fileGroupKey);
      sys0070M.put("atchFileId", sys0071D.get("atchFileId"));
      sys0070M.put("chenalType", FileType.MOBILE.getCode());
      sys0070M.put("crtUserId", loginVO.getUserId());
      // sys0070M.put("crtDt", );
      sys0070M.put("updUserId", loginVO.getUserId());
      // sys0070M.put("updDt", );
      saveCnt = eKeyInApiMapper.insertSYS0070M(sys0070M);
      if (saveCnt == 0) {
        throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
      }
    }
    return fileGroupKey;
  }

  @Override
  public int updateUploadFileSal0500(List<FileVO> list, EKeyInApiDto param) {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "userId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getAtchFileGrpId())) {
      throw new ApplicationException(AppConstants.FAIL, "atchFileGrpId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getFileKeySeq())) {
      throw new ApplicationException(AppConstants.FAIL, "fileKeySeq value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getSaveFlag())) {
      throw new ApplicationException(AppConstants.FAIL, "saveFlag value does not exist.");
    }

    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", param.getUserId());
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "UserID is null.");
    }

    for (FileVO data : list) {
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      Map<String, Object> sys0070M = new HashMap<String, Object>();

      if (param.getSaveFlag().equals("I")) {
        // sys0070M.put("atchFileId", );
        sys0071D.put("atchFileName", data.getAtchFileName());
        sys0071D.put("fileSubPath", data.getFileSubPath());
        sys0071D.put("physiclFileName", data.getPhysiclFileName());
        sys0071D.put("fileExtsn", data.getFileExtsn());
        sys0071D.put("fileSize", data.getFileSize());
        sys0071D.put("filePassword", null);
        sys0071D.put("fileUnqKey", null);
        sys0071D.put("fileKeySeq", param.getFileKeySeq());
        int saveCnt = eKeyInApiMapper.insertSYS0071D(sys0071D);
        if (saveCnt == 0) {
          throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
        }
        if (CommonUtils.isEmpty(sys0071D.get("atchFileId"))) {
          throw new ApplicationException(AppConstants.FAIL, "atchFileId value does not exist.");
        }
        sys0070M.put("atchFileGrpId", param.getAtchFileGrpId());
        sys0070M.put("atchFileId", sys0071D.get("atchFileId"));
        sys0070M.put("chenalType", FileType.MOBILE.getCode());
        sys0070M.put("crtUserId", loginVO.getUserId());
        // sys0070M.put("crtDt", );
        sys0070M.put("updUserId", loginVO.getUserId());
        // sys0070M.put("updDt", );
        saveCnt = eKeyInApiMapper.insertSYS0070M(sys0070M);
        if (saveCnt == 0) {
          throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
        }
      } else if (param.getSaveFlag().equals("U")) {
        sys0071D.put("atchFileId", param.getAtchFileId());
        sys0071D.put("atchFileName", data.getAtchFileName());
        sys0071D.put("fileSubPath", data.getFileSubPath());
        sys0071D.put("physiclFileName", data.getPhysiclFileName());
        sys0071D.put("fileExtsn", data.getFileExtsn());
        sys0071D.put("fileSize", data.getFileSize());
        int saveCnt = eKeyInApiMapper.updateSYS0071D(sys0071D);
        if (saveCnt == 0) {
          throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
        }

        sys0070M.put("atchFileGrpId", param.getAtchFileGrpId());
        sys0070M.put("atchFileId", param.getAtchFileId());
        sys0070M.put("updUserId", loginVO.getUserId());
        // sys0070M.put("updDt", );
        saveCnt = eKeyInApiMapper.updateSYS0070M(sys0070M);
        if (saveCnt == 0) {
          throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
        }
      } else if (param.getSaveFlag().equals("D")) {
        throw new ApplicationException(AppConstants.FAIL, "saveFlag value does not exist.");
      } else {
        throw new ApplicationException(AppConstants.FAIL, "saveFlag value does not exist.");
      }
    }
    return param.getAtchFileGrpId();
  }

  @Override
  public EKeyInApiDto insertEkeyIn(EKeyInApiDto param) throws Exception {
    if (null == param.getSaveData()) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter set are empty.");
    }

    param = param.getSaveData();

    if (CommonUtils.isEmpty(param.getRegId())) {
      throw new ApplicationException(AppConstants.FAIL, "Register ID are empty.");
    }

    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", param.getRegId());
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);

    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "User ID are empty.");
    }

    EKeyInApiForm selectParam = new EKeyInApiForm();
    if (CommonUtils.isEmpty(param.getOrderType())) { // HOME APPLIANCE
      if (CommonUtils.isEmpty(param.getBasic())) { // CHECK BASIC ORDER DETAILS
        throw new ApplicationException(AppConstants.FAIL, "Basic order record are empty.");
      }

      if (CommonUtils.isEmpty(param.getBasic().getSofNo())) { // CHECK SOF NO VALUE
        throw new ApplicationException(AppConstants.FAIL, "SOF no. does not exist.");
      }

      selectParam.setSofNo(param.getBasic().getSofNo());

      // VALIDATE SOF ALREADY USED BEFORE
      int selectExistSofNo = eKeyInApiMapper.selectExistSofNo(EKeyInApiForm.createMap(selectParam));
      // int selectExistSofNo = 0;
      if (selectExistSofNo != 0) {
        throw new ApplicationException(AppConstants.FAIL, "Entered SOF No. had been used, please try other SOF No.");
      }

      param.getBasic().setCrtUserId(loginVO.getUserId());
      param.getBasic().setUpdUserId(loginVO.getUserId());
      param.getBasic().setRegId(param.getRegId());

      // INSERT SAL0213M
      this.insertEkeyInSal0213M(param.getBasic());

    } else { // HOMECARE
      if (CommonUtils.isEmpty(param.getMattress())) {
        throw new ApplicationException(AppConstants.FAIL, "Basic order record are empty.");
      }

      if (CommonUtils.isEmpty(param.getMattress().getSofNo())) {
        throw new ApplicationException(AppConstants.FAIL, "SOF no. does not exist.");
      }

      selectParam.setSofNo(param.getMattress().getSofNo());

      int selectExistSofNo = eKeyInApiMapper.selectExistSofNo(EKeyInApiForm.createMap(selectParam));
      // int selectExistSofNo = 0;
      if (selectExistSofNo != 0) {
        throw new ApplicationException(AppConstants.FAIL, "Entered SOF No. had been used, please try other SOF No.");
      }

      param.getMattress().setCrtUserId(loginVO.getUserId());
      param.getMattress().setUpdUserId(loginVO.getUserId());
      param.getMattress().setRegId(param.getRegId());

      // INSERT SAL0213M
      int mattressPreOrdId = insertEkeyInSal0213M(param.getMattress());
      int framePreOrdId = 0;

      if (CommonUtils.isNotEmpty(param.getFrame())) { // FRAME
        param.getFrame().setAppTypeId(5764); // SYS0013M : 5764(Auxiliary)
        param.getFrame().setCrtUserId(loginVO.getUserId());
        param.getFrame().setUpdUserId(loginVO.getUserId());
        param.getFrame().setRegId(param.getRegId());
        // INSERT SAL0213D FOR FRAME
        framePreOrdId = insertEkeyInSal0213M(param.getFrame());
      }

      Map<String, Object> hmc0011D = new HashMap<String, Object>();
      // hmc0011D.put("ordSeqNo", );
      hmc0011D.put("custId", param.getMattress().getCustId());
      // hmc0011D.put("salesDt", );
      // hmc0011D.put("matOrdNo", );
      // hmc0011D.put("fraOrdNo", );
      // hmc0011D.put("crtDt", );
      hmc0011D.put("crtUserId", loginVO.getUserId());
      // hmc0011D.put("updDt", );
      hmc0011D.put("updUserId", loginVO.getUserId());
      hmc0011D.put("matPreOrdId", mattressPreOrdId);
      hmc0011D.put("fraPreOrdId", framePreOrdId == 0 ? null : framePreOrdId);
      hmc0011D.put("stusId", 1);
      // hmc0011D.put("bndlNo", );
      // hmc0011D.put("srvOrdId", );

      // INSERT HMC0011D
      int saveCnt = eKeyInApiMapper.insertHMC0011D(hmc0011D);
      if (saveCnt == 0) {
        throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
      }

      if (CommonUtils.isEmpty(hmc0011D.get("ordSeqNo"))) {
        throw new ApplicationException(AppConstants.FAIL, "ordSeqNo value does not exist.");
      }

      // UPDATE BNDL_ID FOR MATTRESS
      Map<String, Object> updateBndl = new HashMap<String, Object>();
      updateBndl.put("preOrdId", mattressPreOrdId);
      updateBndl.put("bndlId", hmc0011D.get("ordSeqNo"));
      // UPDATE SAL0213M
      saveCnt = eKeyInApiMapper.updateBndlIdSAL0213M(updateBndl);

      if (saveCnt == 0) {
        throw new ApplicationException(AppConstants.FAIL, "Update Exception.");
      }

      // UPDATE BNDL_ID FOR FRAME
      if (CommonUtils.isNotEmpty(framePreOrdId) && framePreOrdId != 0) {
        updateBndl = new HashMap<String, Object>();
        updateBndl.put("preOrdId", framePreOrdId);
        updateBndl.put("bndlId", hmc0011D.get("ordSeqNo"));
        // UPDATE SAL0213M
        saveCnt = eKeyInApiMapper.updateBndlIdSAL0213M(updateBndl);

        if (saveCnt == 0) {
          throw new ApplicationException(AppConstants.FAIL, "Update Exception.");
        }
      }
    }
    return param;
  };

  public int insertEkeyInSal0213M(EKeyInApiDto param) {
    logger.debug("====================================================");
    logger.debug("= PARAM = " + param.toString());
    logger.debug("====================================================");

    if (CommonUtils.isEmpty(param.getRegId())) {
      throw new ApplicationException(AppConstants.FAIL, "Register ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getSofNo())) {
      throw new ApplicationException(AppConstants.FAIL, "SOF No. does not exist.");
    }

    if (CommonUtils.isEmpty(param.getAppTypeId()) || param.getAppTypeId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Application Type does not exist.");
    }

    if (CommonUtils.isEmpty(param.getSrvPacId()) || param.getSrvPacId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Service Package does not exist.");
    }

    // if( CommonUtils.isEmpty(param.getInstct()) ){
    // throw new ApplicationException(AppConstants.FAIL, "instct value does not
    // exist.");
    // }

    if (CommonUtils.isEmpty(param.getCustId()) || param.getCustId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Customer ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getCustCntcId()) || param.getCustCntcId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Customer Contact ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getKeyinBrnchId()) || param.getKeyinBrnchId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Key-in Branch does not exist.");
    }

    if (CommonUtils.isEmpty(param.getInstAddId()) || param.getInstAddId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Installation Address does not exist.");
    }

    if (CommonUtils.isEmpty(param.getDscBrnchId()) || param.getDscBrnchId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "DSC Branch does not exist.");
    }

    // OUTRIGHT, INSTALLMENT & AUXILIARY SKIP PAYMENT
    if (!"67".equals(CommonUtils.nvl(param.getAppTypeId())) && !"68".equals(CommonUtils.nvl(param.getAppTypeId())) && !"5764".equals(CommonUtils.nvl(param.getAppTypeId()))) {
      if (CommonUtils.isEmpty(param.getRentPayModeId()) || param.getRentPayModeId() <= 0) {
        throw new ApplicationException(AppConstants.FAIL, "Payment Mode does not exist.");
      }

      if ("131".equals(CommonUtils.isEmpty(param.getRentPayModeId()))) { // ONLY CREDIT CARD
        if (CommonUtils.isEmpty(param.getCustCrcId()) || param.getCustCrcId() <= 0) {
          throw new ApplicationException(AppConstants.FAIL, "Customer Credit Card ID does not exist.");
        }
        if (CommonUtils.isEmpty(param.getBankId()) || param.getBankId() <= 0) {
          throw new ApplicationException(AppConstants.FAIL, "Credit Card Bank ID does not exist.");
        }
      }
    }

    if ("68".equals(CommonUtils.nvl(param.getAppTypeId()))) {
      if (CommonUtils.isEmpty(param.getInstPriod())) {
        throw new ApplicationException(AppConstants.FAIL, "Installment Duration does not exist.");
      }
    }

    if (CommonUtils.isEmpty(param.getRentPayCustId()) || param.getRentPayCustId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Rental Payment Customer ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getCustBillCustId()) || param.getCustBillCustId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Customer Bill ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getCustBillCntId()) || param.getCustBillCntId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Customer Bill Contact ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getCustBillAddId()) || param.getCustBillAddId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Customer Bill Addess ID does not exist.");
    }

    if (param.getTypeId() == 965 && CommonUtils.isEmpty(param.getCustBillEmail())) {
      throw new ApplicationException(AppConstants.FAIL, "Customer Bill Email does not exist.");
    }

    if (CommonUtils.isEmpty(param.getItmStkId()) || param.getItmStkId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Stock ID does not exist.");
    }
    if (CommonUtils.isEmpty(param.getPromoId()) || param.getPromoId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Promotion ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getMthRentAmt())) {
      throw new ApplicationException(AppConstants.FAIL, "Monthly Rental Amount does not exist.");
    }

    if (CommonUtils.isEmpty(param.getTotAmt())) {
      throw new ApplicationException(AppConstants.FAIL, "Total Amount does not exist.");
    }
    if (CommonUtils.isEmpty(param.getNorAmt())) {
      throw new ApplicationException(AppConstants.FAIL, "Nor. Amount does not exist.");
    }

    if (CommonUtils.isEmpty(param.getDiscRntFee())) {
      throw new ApplicationException(AppConstants.FAIL, "Discount Rental Fee value does not exist.");
    }

    if (CommonUtils.isEmpty(param.getTotPv())) {
      throw new ApplicationException(AppConstants.FAIL, "Total PV does not exist.");
    }

    if (CommonUtils.isEmpty(param.getTotPvGst())) {
      throw new ApplicationException(AppConstants.FAIL, "Total PV GST does not exist.");
    }

    if (CommonUtils.isEmpty(param.getPrcId()) || param.getPrcId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Price ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getAtchFileGrpId()) || param.getAtchFileGrpId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Attachment does not exist.");
    }

    if (CommonUtils.isEmpty(param.getVoucherCode()) == false) {
      Map<String, Object> voucherParam = new HashMap<String, Object>();
      voucherParam.put("voucherCode", param.getVoucherCode());
  	  int validVoucherResult = eKeyInApiMapper.isVoucherValidToApply(voucherParam);
  	  int ekeyInValidResult = eKeyInApiMapper.isVoucherValidToApplyIneKeyIn(voucherParam);

	  if(validVoucherResult == 0 || ekeyInValidResult == 0){
		  if(validVoucherResult == 0){
		      throw new ApplicationException(AppConstants.FAIL, "Voucher applied is not a valid voucher.");
		  }
		  if(ekeyInValidResult == 0){
		      throw new ApplicationException(AppConstants.FAIL, "Voucher is applied on other e-KeyIn orders.");
		  }
	  }
    }

    Map<String, Object> sal0213M = new HashMap<String, Object>();
    // sal0213M.put("preOrdId", );
    // sal0213M.put("reqstDt, );
    sal0213M.put("chnnl", SalesConstants.PRE_ORDER_CHANNEL_MOB);
    sal0213M.put("stusId", SalesConstants.STATUS_ACTIVE);
    sal0213M.put("sofNo", param.getSofNo());
    sal0213M.put("custPoNo", null);
    sal0213M.put("appTypeId", param.getAppTypeId());
    sal0213M.put("srvPacId", param.getSrvPacId());
    sal0213M.put("instPriod", CommonUtils.intNvl(param.getInstPriod()));
    sal0213M.put("custId", param.getCustId());
    sal0213M.put("empChk", 0);
    sal0213M.put("gstChk", 0);
    sal0213M.put("eurcCustRgsNo", null);
    sal0213M.put("atchFileGrpId", param.getAtchFileGrpId());
    sal0213M.put("custCntcId", param.getCustCntcId());
    sal0213M.put("keyinBrnchId", param.getKeyinBrnchId());
    sal0213M.put("instAddId", param.getInstAddId());
    sal0213M.put("dscBrnchId", param.getDscBrnchId());
    // sal0213M.put("preDt", );
    sal0213M.put("preTm", "11:00:00");
    sal0213M.put("instct", param.getInstct());
    sal0213M.put("exTrade", 0);
    sal0213M.put("itmStkId", param.getItmStkId());
    sal0213M.put("promoId", param.getPromoId());
    sal0213M.put("mthRentAmt", param.getMthRentAmt());
    sal0213M.put("promoDiscPeriodTp", 0);
    sal0213M.put("promoDiscPeriod", null);
    sal0213M.put("totAmt", param.getTotAmt());
    sal0213M.put("norAmt", param.getNorAmt());
    sal0213M.put("norRntFee", null);
    sal0213M.put("discRntFee", param.getDiscRntFee());
    sal0213M.put("totPv", param.getTotPv());
    sal0213M.put("totPvGst", param.getTotPvGst());
    sal0213M.put("prcId", param.getPrcId());
    sal0213M.put("memCode", param.getRegId());
    sal0213M.put("advBill", 0);
    sal0213M.put("custCrcId", param.getCustCrcId());
    sal0213M.put("bankId", param.getBankId());
    sal0213M.put("custAccId", 0);
    sal0213M.put("is3rdParty", param.getIs3rdParty());
    sal0213M.put("rentPayCustId", param.getRentPayCustId());
    sal0213M.put("rentPayModeId", param.getRentPayModeId());
    sal0213M.put("custBillId", 0);
    sal0213M.put("custBillCustId", param.getCustBillCustId());
    sal0213M.put("custBillCntId", param.getCustBillCntId());
    sal0213M.put("custBillAddId", param.getCustBillAddId());
    sal0213M.put("custBillRem", null);
    sal0213M.put("custBillEmail", param.getCustBillEmail());
    sal0213M.put("custBillIsSms", 1);
    sal0213M.put("custBillIsPost", 0);
    sal0213M.put("custBillEmailAdd", null);
    sal0213M.put("custBillIsWebPortal", 0);
    sal0213M.put("custBillWebPortalUrl", null);
    sal0213M.put("custBillIsSms2", 0);
    sal0213M.put("custBillCustCareCntId", 0);
    sal0213M.put("rem1", null);
    sal0213M.put("rem2", null);
    sal0213M.put("crtUserId", param.getCrtUserId());
    // sal0213M.put("crtDt", );
    sal0213M.put("updUserId", param.getUpdUserId());
    // sal0213M.put("updDt", );
    sal0213M.put("salesOrdId", null);
    sal0213M.put("onHold", 0);
    sal0213M.put("cpntId", param.getCpntCode());
    sal0213M.put("corpCustType", 0);
    sal0213M.put("agreementType", 0);
    sal0213M.put("bndlId", null);
    sal0213M.put("voucherCode", param.getVoucherCode());
    sal0213M.put("srvType", param.getSrvType());

    logger.debug("====================================================");
    logger.debug("= PARAM FOR SAL0213M = " + sal0213M.toString());
    logger.debug("====================================================");

    int saveCnt = eKeyInApiMapper.insertSAL0213M(sal0213M);
    if (saveCnt == 0) {
      throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
    }
    if (CommonUtils.isEmpty(sal0213M.get("preOrdId"))) {
      throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
    }
    return Integer.parseInt(sal0213M.get("preOrdId").toString());
  }

  @Override
  public EKeyInApiDto updateEkeyIn(EKeyInApiDto param) throws Exception {
    if (null == param.getSaveData()) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter set are empty.");
    }
    param = param.getSaveData();

    if (CommonUtils.isEmpty(param.getRegId())) {
      throw new ApplicationException(AppConstants.FAIL, "Register ID are empty.");
    }

    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", param.getRegId());
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "User ID are empty.");
    }

    if (CommonUtils.isEmpty(param.getOrderType())) { // HOME APPLIANCE
      if (CommonUtils.isEmpty(param.getBasic())) { // CHECK BASIC ORDER DETAILS
        throw new ApplicationException(AppConstants.FAIL, "Basic order record are empty.");
      }
      if (CommonUtils.isEmpty(param.getBasic().getSofNo())) { // CHECK SOF NO VALUE
        throw new ApplicationException(AppConstants.FAIL, "SOF no. does not exist.");
      }

      param.getBasic().setCrtUserId(loginVO.getUserId());
      param.getBasic().setUpdUserId(loginVO.getUserId());
      param.getBasic().setRegId(param.getRegId());

      // INSERT SAL0213M
      updateEkeyInSal0213M(param.getBasic());
    } else { // HOMECARE
      if (CommonUtils.isEmpty(param.getMattress())) {
        throw new ApplicationException(AppConstants.FAIL, "Basic order record are empty.");
      }
      if (CommonUtils.isEmpty(param.getMattress().getPreOrdId())) {
        throw new ApplicationException(AppConstants.FAIL, "Pre order ID record are empty.");
      }

      Map<String, Object> selectHomecareParam = new HashMap<String, Object>();
      selectHomecareParam.put("preOrdId", param.getMattress().getPreOrdId());

      List<EgovMap> selecteKeyInDetailOrderHomecare = eKeyInApiMapper.selecteKeyInDetailOrderHomecare(selectHomecareParam);
      List<EKeyInApiDto> homecareList = selecteKeyInDetailOrderHomecare.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());

      if (homecareList.size() != 1) {
        throw new ApplicationException(AppConstants.FAIL, " Homecare Order Detail are missing.");
      }

      Map<String, Object> hmc0011D = new HashMap<String, Object>();
      hmc0011D.put("ordSeqNo", homecareList.get(0).getOrdSeqNo());
      hmc0011D.put("stusId", SalesConstants.STATUS_ACTIVE);
      hmc0011D.put("updUserId", loginVO.getUserId());

      // UPDATE HMC0011D
      int saveCnt = eKeyInApiMapper.updateHMC0011D(hmc0011D);
      if (saveCnt != 1) {
        throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
      }

      if (CommonUtils.isEmpty(homecareList.get(0).getMatPreOrdId())) {
        throw new ApplicationException(AppConstants.FAIL, "Mattress Pre Order ID are empty");
      }
      param.getMattress().setPreOrdId(homecareList.get(0).getMatPreOrdId());
      param.getMattress().setUpdUserId(loginVO.getUserId());
      param.getMattress().setRegId(param.getRegId());

      // UPDATE SAL0213M
      updateEkeyInSal0213M(param.getMattress());

      if (CommonUtils.isNotEmpty(homecareList.get(0).getFraPreOrdId()) && homecareList.get(0).getFraPreOrdId() > 0) {
        if (CommonUtils.isEmpty(param.getFrame())) {
          throw new ApplicationException(AppConstants.FAIL, "Homecare Frame Detail are missing");
        }
        param.getFrame().setPreOrdId(homecareList.get(0).getFraPreOrdId());
        param.getFrame().setUpdUserId(loginVO.getUserId());
        param.getFrame().setRegId(param.getRegId());

        // UPDATE SAL0213M
        updateEkeyInSal0213M(param.getFrame());
      }
    }

    if (CommonUtils.isNotEmpty(param.getAtchFileIdSales()) && param.getAtchFileIdSales() > 0) {
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put("atchFileId", param.getAtchFileIdSales());
      int saveCnt = eKeyInApiMapper.deleteSYS0071D(sys0071D);

      if (saveCnt != 1) {
        throw new ApplicationException(AppConstants.FAIL, "Delete Exception.");
      }
    }

    if (CommonUtils.isNotEmpty(param.getAtchFileIdNric()) && param.getAtchFileIdNric() > 0) {
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put("atchFileId", param.getAtchFileIdNric());
      int saveCnt = eKeyInApiMapper.deleteSYS0071D(sys0071D);

      if (saveCnt != 1) {
        throw new ApplicationException(AppConstants.FAIL, "Delete Exception.");
      }
    }

    if (CommonUtils.isNotEmpty(param.getAtchFileIdPayment()) && param.getAtchFileIdPayment() > 0) {
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put("atchFileId", param.getAtchFileIdPayment());
      int saveCnt = eKeyInApiMapper.deleteSYS0071D(sys0071D);

      if (saveCnt != 1) {
        throw new ApplicationException(AppConstants.FAIL, "Delete Exception.");
      }
    }

    if (CommonUtils.isNotEmpty(param.getAtchFileIdTemporary()) && param.getAtchFileIdTemporary() > 0) {
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put("atchFileId", param.getAtchFileIdTemporary());
      int saveCnt = eKeyInApiMapper.deleteSYS0071D(sys0071D);

      if (saveCnt != 1) {
        throw new ApplicationException(AppConstants.FAIL, "Delete Exception.");
      }
    }

    if (CommonUtils.isNotEmpty(param.getAtchFileIdoOthersform()) && param.getAtchFileIdoOthersform() > 0) {
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put("atchFileId", param.getAtchFileIdoOthersform());
      int saveCnt = eKeyInApiMapper.deleteSYS0071D(sys0071D);

      if (saveCnt != 1) {
        throw new ApplicationException(AppConstants.FAIL, "Delete Exception.");
      }
    }

    if (CommonUtils.isNotEmpty(param.getAtchFileIdoOthersform2()) && param.getAtchFileIdoOthersform2() > 0) {
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put("atchFileId", param.getAtchFileIdoOthersform2());
      int saveCnt = eKeyInApiMapper.deleteSYS0071D(sys0071D);

      if (saveCnt != 1) {
        throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
      }
    }
    return param;
  };

  public int updateEkeyInSal0213M(EKeyInApiDto param) {
    logger.debug("====================================================");
    logger.debug("= PARAM = " + param.getAppTypeId());
    logger.debug("====================================================");

    if (CommonUtils.isEmpty(param.getPreOrdId())) {
      throw new ApplicationException(AppConstants.FAIL, "Pre Order ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getRegId())) {
      throw new ApplicationException(AppConstants.FAIL, "Register ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getSofNo())) {
      throw new ApplicationException(AppConstants.FAIL, "SOF No. does not exist.");
    }

    // if (CommonUtils.isEmpty(param.getAppTypeId()) || param.getAppTypeId() <=
    // 0) {
    // throw new ApplicationException(AppConstants.FAIL, "appTypeId value does
    // not exist.");
    // }

    if (CommonUtils.isEmpty(param.getSrvPacId()) || param.getSrvPacId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Service Package does not exist.");
    }

    // if( CommonUtils.isEmpty(param.getInstct()) ){
    // throw new ApplicationException(AppConstants.FAIL, "instct value does not
    // exist.");
    // }

    if (CommonUtils.isEmpty(param.getCustId()) || param.getCustId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Customer ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getCustCntcId()) || param.getCustCntcId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Customer Contact ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getKeyinBrnchId()) || param.getKeyinBrnchId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Key-in Branch does not exist.");
    }

    if (CommonUtils.isEmpty(param.getInstAddId()) || param.getInstAddId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Installation Address does not exist.");
    }

    if (CommonUtils.isEmpty(param.getDscBrnchId()) || param.getDscBrnchId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "DSC Branch does not exist.");
    }

    if (!"67".equals(CommonUtils.nvl(param.getAppTypeId())) && !"68".equals(CommonUtils.nvl(param.getAppTypeId())) && !"5764".equals(CommonUtils.nvl(param.getAppTypeId()))) {
      if (CommonUtils.isEmpty(param.getRentPayModeId()) || param.getRentPayModeId() <= 0) {
        throw new ApplicationException(AppConstants.FAIL, "Payment Mode does not exist.");
      }

      if ("131".equals(CommonUtils.isEmpty(param.getRentPayModeId()))) { // ONLY CREDIT CARD
        if (CommonUtils.isEmpty(param.getCustCrcId()) || param.getCustCrcId() <= 0) {
          throw new ApplicationException(AppConstants.FAIL, "Customer Credit Card ID does not exist.");
        }

        if (CommonUtils.isEmpty(param.getBankId()) || param.getBankId() <= 0) {
          throw new ApplicationException(AppConstants.FAIL, "Credit Card Bank ID does not exist.");
        }
      }
    }

    /*
     * if ("68".equals(CommonUtils.nvl(param.getAppTypeId()))) {
     * if (CommonUtils.isEmpty(param.getInstPriod())) {
     * throw new ApplicationException(AppConstants.FAIL, "Installment Period does not exist.");
     * }
     * }
     */

    // if (CommonUtils.isEmpty(param.getRentPayCustId()) ||
    // param.getRentPayCustId() <= 0) {
    // throw new ApplicationException(AppConstants.FAIL, "rentPayCustId value
    // does not exist.");
    // }

    // if (CommonUtils.isEmpty(param.getCustBillCustId()) ||
    // param.getCustBillCustId() <= 0) {
    // throw new ApplicationException(AppConstants.FAIL, "custBillCustId value
    // does not exist.");
    // }
    if (CommonUtils.isEmpty(param.getCustBillCntId()) || param.getCustBillCntId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Customer Bill Contact ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getCustBillAddId()) || param.getCustBillAddId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Customer Bill Addess ID does not exist.");
    }

    if (param.getTypeId() == 965 && CommonUtils.isEmpty(param.getCustBillEmail())) {
      throw new ApplicationException(AppConstants.FAIL, "Customer Bill Email does not exist.");
    }

    if (CommonUtils.isEmpty(param.getItmStkId()) || param.getItmStkId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Stock ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getPromoId()) || param.getPromoId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Promotion ID does not exist.");
    }

    if (CommonUtils.isEmpty(param.getMthRentAmt())) {
      throw new ApplicationException(AppConstants.FAIL, "Monthly Rental Amount does not exist.");
    }

    if (CommonUtils.isEmpty(param.getTotAmt())) {
      throw new ApplicationException(AppConstants.FAIL, "Total Amount does not exist.");
    }

    if (CommonUtils.isEmpty(param.getNorAmt())) {
      throw new ApplicationException(AppConstants.FAIL, "Nor. Amount does not exist.");
    }

    if (CommonUtils.isEmpty(param.getDiscRntFee())) {
      throw new ApplicationException(AppConstants.FAIL, "Discount Rental Fee value does not exist.");
    }

    if (CommonUtils.isEmpty(param.getTotPv())) {
      throw new ApplicationException(AppConstants.FAIL, "Total PV does not exist.");
    }

    if (CommonUtils.isEmpty(param.getTotPvGst())) {
      throw new ApplicationException(AppConstants.FAIL, "Total PV GST does not exist.");
    }

    if (CommonUtils.isEmpty(param.getPrcId()) || param.getPrcId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "Price ID does not exist.");
    }

    // if (CommonUtils.isEmpty(param.getAtchFileGrpId()) ||
    // param.getAtchFileGrpId() <= 0) {
    // throw new ApplicationException(AppConstants.FAIL, "atchFileGrpId value
    // does not exist.");
    // }

    if (logger.isDebugEnabled()) {
      logger.debug("####################################################");
      logger.debug("####################################################");
      logger.debug("####################################################");
      logger.debug("getPreOrdId : " + param.getPreOrdId());
      logger.debug("getMthRentAmt : " + param.getMthRentAmt());
      logger.debug("getTotAmt : " + param.getTotAmt());
      logger.debug("getNorAmt : " + param.getNorAmt());
      logger.debug("getDiscRntFee : " + param.getDiscRntFee());
      logger.debug("getTotPv : " + param.getTotPv());
      logger.debug("getTotPvGst : " + param.getTotPvGst());
      logger.debug("####################################################");
      logger.debug("####################################################");
      logger.debug("####################################################");
    }

    Map<String, Object> sal0213M = new HashMap<String, Object>();
    sal0213M.put("preOrdId", param.getPreOrdId());
    // sal0213M.put("reqstDt, );
    // sal0213M.put("chnnl", SalesConstants.PRE_ORDER_CHANNEL_MOB);
    sal0213M.put("stusId", SalesConstants.STATUS_ACTIVE);
    // sal0213M.put("sofNo", param.getSofNo());
    // sal0213M.put("custPoNo", null);
    // sal0213M.put("appTypeId", param.getAppTypeId());
    sal0213M.put("srvPacId", param.getSrvPacId());
    // sal0213M.put("instPriod", CommonUtils.intNvl(param.getInstPriod()));
    // sal0213M.put("custId", param.getCustId());
    // sal0213M.put("empChk", 0);
    // sal0213M.put("gstChk", 0);
    // sal0213M.put("eurcCustRgsNo", null);
    // sal0213M.put("atchFileGrpId", param.getAtchFileGrpId());
    sal0213M.put("custCntcId", param.getCustCntcId());
    sal0213M.put("keyinBrnchId", param.getKeyinBrnchId());
    sal0213M.put("instAddId", param.getInstAddId());
    sal0213M.put("dscBrnchId", param.getDscBrnchId());
    // sal0213M.put("preDt", );
    // sal0213M.put("preTm", "11:00:00");
    sal0213M.put("instct", param.getInstct());
    // sal0213M.put("exTrade", 0);
    sal0213M.put("itmStkId", param.getItmStkId());
    sal0213M.put("promoId", param.getPromoId());
    sal0213M.put("mthRentAmt", param.getMthRentAmt());
    // sal0213M.put("promoDiscPeriodTp", 0);
    // sal0213M.put("promoDiscPeriod", null);
    sal0213M.put("totAmt", param.getTotAmt());
    sal0213M.put("norAmt", param.getNorAmt());
    // sal0213M.put("norRntFee", null);
    sal0213M.put("discRntFee", param.getDiscRntFee());
    sal0213M.put("totPv", param.getTotPv());
    sal0213M.put("totPvGst", param.getTotPvGst());
    sal0213M.put("prcId", param.getPrcId());
    sal0213M.put("memCode", param.getRegId());
    // sal0213M.put("advBill", 0);
    sal0213M.put("custCrcId", param.getCustCrcId());
    sal0213M.put("bankId", param.getBankId());
    // sal0213M.put("custAccId", 0);
    sal0213M.put("is3rdParty", param.getIs3rdParty());
    // sal0213M.put("rentPayCustId", param.getRentPayCustId());
    sal0213M.put("rentPayModeId", param.getRentPayModeId());
    // sal0213M.put("custBillId", 0);
    // sal0213M.put("custBillCustId", param.getCustBillCustId());
    sal0213M.put("custBillCntId", param.getCustBillCntId());
    sal0213M.put("custBillAddId", param.getCustBillAddId());
    // sal0213M.put("custBillRem", null);
    sal0213M.put("custBillEmail", param.getCustBillEmail());
    // sal0213M.put("custBillIsSms", 1);
    // sal0213M.put("custBillIsPost", 0);
    // sal0213M.put("custBillEmailAdd", null);
    // sal0213M.put("custBillIsWebPortal", 0);
    // sal0213M.put("custBillWebPortalUrl", null);
    // sal0213M.put("custBillIsSms2", 0);
    // sal0213M.put("custBillCustCareCntId", 0);
    // sal0213M.put("rem1", null);
    // sal0213M.put("rem2", null);
    // sal0213M.put("crtUserId", param.getCrtUserId());
    // sal0213M.put("crtDt", );
    sal0213M.put("updUserId", param.getUpdUserId());
    // sal0213M.put("updDt", );
    // sal0213M.put("salesOrdId", null);
    // sal0213M.put("onHold", 0);
    sal0213M.put("cpntId", param.getCpntCode());
    // sal0213M.put("corpCustType", 0);
    // sal0213M.put("agreementType", 0);
    // sal0213M.put("bndlId", null);
    sal0213M.put("voucherCode", param.getVoucherCode());

    // UPDATE SAL0213M
    int saveCnt = eKeyInApiMapper.updateSAL0213M(sal0213M);

    if (saveCnt == 0) {
      throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
    }
    return saveCnt;
  }

  @Override
  public EKeyInApiDto cancelEkeyIn(EKeyInApiDto param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getPreOrdId()) || param.getPreOrdId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "preOrdId value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getRegId())) {
      throw new ApplicationException(AppConstants.FAIL, "regId value does not exist.");
    }
    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", param.getRegId());
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "UserID is null.");
    }

    Map<String, Object> sal0213M = new HashMap<String, Object>();
    int saveCnt = 0;
    if (CommonUtils.isEmpty(param.getOrderType())) { // Basic
      sal0213M = new HashMap<String, Object>();
      sal0213M.put("preOrdId", param.getPreOrdId());
      sal0213M.put("updUserId", loginVO.getUserId());
      saveCnt = eKeyInApiMapper.cancelSAL0213M(sal0213M);
      if (saveCnt == 0) {
        throw new ApplicationException(AppConstants.FAIL, "Update Exception.");
      }

    } else {
      Map<String, Object> selectParam = new HashMap<String, Object>();
      selectParam.put("preOrdId", param.getPreOrdId());
      List<EgovMap> selecteKeyInDetailOrderHomecare = eKeyInApiMapper.selecteKeyInDetailOrderHomecare(selectParam);
      List<EKeyInApiDto> homecareList = selecteKeyInDetailOrderHomecare.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
      if (homecareList.size() != 1) {
        throw new ApplicationException(AppConstants.FAIL, " HomeCare information is missing.");
      }
      if (CommonUtils.isEmpty(homecareList.get(0).getOrdSeqNo())) {
        throw new ApplicationException(AppConstants.FAIL, " HC ORD Sequence value does not exist.");
      }
      sal0213M = new HashMap<String, Object>();
      sal0213M.put("preOrdId", homecareList.get(0).getMatPreOrdId());
      sal0213M.put("updUserId", loginVO.getUserId());
      saveCnt = eKeyInApiMapper.cancelSAL0213M(sal0213M);
      if (saveCnt == 0) {
        throw new ApplicationException(AppConstants.FAIL, "Update Exception.");
      }

      if (CommonUtils.isNotEmpty(homecareList.get(0).getFraPreOrdId()) && 0 < homecareList.get(0).getFraPreOrdId()) {
        sal0213M = new HashMap<String, Object>();
        sal0213M.put("preOrdId", homecareList.get(0).getFraPreOrdId());
        sal0213M.put("updUserId", loginVO.getUserId());
        saveCnt = eKeyInApiMapper.cancelSAL0213M(sal0213M);
        if (saveCnt == 0) {
          throw new ApplicationException(AppConstants.FAIL, "Update Exception.");
        }
      }

      Map<String, Object> hmc0011D = new HashMap<String, Object>();
      hmc0011D.put("ordSeqNo", homecareList.get(0).getOrdSeqNo());
      hmc0011D.put("updUserId", loginVO.getUserId());
      saveCnt = eKeyInApiMapper.cancelHMC0011D(hmc0011D);
      if (saveCnt == 0) {
        throw new ApplicationException(AppConstants.FAIL, "Update Exception.");
      }
    }
    return param;
  }

  @Override
  public EKeyInApiDto selectAttachmentImgFile(Map<String, Object> param) throws Exception {
    if (MapUtils.isEmpty(param)) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.get("atchFileId")) || Integer.parseInt(param.get("atchFileId").toString()) <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "atchFileId value does not exist.");
    }

    EgovMap selectAttachmentImgFile = eKeyInApiMapper.selectAttachmentImgFile(param);
    if (MapUtils.isEmpty(selectAttachmentImgFile)) {
      throw new ApplicationException(AppConstants.FAIL, "Picture information is missing.");
    }
    return EKeyInApiDto.create(selectAttachmentImgFile);
  }

  @Override
  public EKeyInApiDto selectCpntLst(EKeyInApiForm param) throws Exception {
    EKeyInApiDto rtn = new EKeyInApiDto();
    List<EgovMap> selectCpntList = eKeyInApiMapper.selectCpntLst(EKeyInApiForm.createMap(param));
    rtn.setCpntList(selectCpntList);
    return rtn;
  }

  @Override
  public EKeyInApiDto selectPromoByCpntId(EKeyInApiForm param) throws Exception {
    EKeyInApiDto rtn = new EKeyInApiDto();
    List<EgovMap> selectPromoByCpntId = eKeyInApiMapper.selectPromoByCpntId(EKeyInApiForm.createMap(param));
    rtn.setPromoByCpntIdList(selectPromoByCpntId);
    return rtn;
  }

  @Override
  public EKeyInApiDto getTokenId(EKeyInApiDto param) throws Exception {
    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", param.getRegId());
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "UserID is null.");
    }

    int tknId = eKeyInApiMapper.selectTokenID();
    if (CommonUtils.isEmpty(tknId) || tknId <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "TokenID is null.");
    }

    String r1 = "";
    String r2 = "";
    String r3 = "";
    if (param.getNric().length() < 12) {
      r1 = StringUtils.leftPad(param.getNric(), 12, "0");
    } else {
      r1 = param.getNric().substring(param.getNric().length() - 12);
    }

    if (Integer.toString(param.getCustId()).length() < 10) {
      r2 = StringUtils.leftPad(Integer.toString(param.getCustId()), 12, "0");
      r3 = StringUtils.leftPad("", 12, "0");
    }

    String refNo = r1 + r2 + r3 + tknId;

    Map<String, Object> sal0257D = new HashMap<String, Object>();
    sal0257D.put("tknId", tknId);
    sal0257D.put("refNo", refNo);
    sal0257D.put("crtUserId", loginVO.getUserId());
    sal0257D.put("updUserId", loginVO.getUserId());
    int saveCnt = eKeyInApiMapper.insertSAL0257D(sal0257D);
    if (saveCnt != 1) {
      throw new ApplicationException(AppConstants.FAIL, "Card Exception.");
    }

    EKeyInApiDto rtn = new EKeyInApiDto();
    rtn.setTknId(tknId);
    rtn.setRefNo(refNo);

    return rtn;
  }

  @Override
  public EKeyInApiDto saveTokenNumber(EKeyInApiDto param) throws Exception {
    int saveCnt = 0;
    String crcCheck = "";
    // String stus = "1";
    String errorDesc = "";

    EKeyInApiDto rtnDto = new EKeyInApiDto();

    Map<String, Object> params = new HashMap<String, Object>();
    params.put("refNo", param.getRefNo());

    EKeyInApiDto sal0257Dtoken = EKeyInApiDto.create(eKeyInApiMapper.getTokenInfo(params));

    // Check token availability in SAL0257D
    if (CommonUtils.isEmpty(sal0257Dtoken)) {
      // Token does not exist
      logger.debug("sal0257Dtoken is null");
      // stus = "21";
      saveCnt = eKeyInApiMapper.updateStagingF(params);
      if (saveCnt != 1) {
        throw new ApplicationException(AppConstants.FAIL, " Update Card Info Exception");
      }
      throw new ApplicationException(AppConstants.FAIL, "tokenInfo value does not exist.");
    } else {
      // Token Exist
      Map<String, Object> loginInfoMap = new HashMap<String, Object>();
      loginInfoMap.put("_USER_ID", param.getRegId());
      LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
      if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
        throw new ApplicationException(AppConstants.FAIL, "UserID is null.");
      }

      String maskPan = sal0257Dtoken.getCustOriCrcNo();
      String custCrcTypeId = "0";
      String custCrcTypeName = "";
      if (maskPan.startsWith("4")) {
        custCrcTypeId = "112";
        custCrcTypeName = "Visa Card";
      } else if (maskPan.startsWith("5")) {
        custCrcTypeId = "111";
        custCrcTypeName = "Master Card";
      }

      // Park duplicate card checking 1-1 relation
      Map<String, Object> checkCrc = new HashMap<>();
      checkCrc.put("token", sal0257Dtoken.getToken());

      // Count if token exist
      int step1 = (Integer) eKeyInApiMapper.selectCheckCRC1(checkCrc);
      logger.debug("step1 :: " + Integer.toString(step1));
      if (step1 > 0) {
        // Count distinct NRIC
        int step2 = (Integer) eKeyInApiMapper.selectCheckCRC2(checkCrc);
        logger.debug("step2 :: " + Integer.toString(step2));
        if (step2 >= 1) {
          crcCheck = "2";
          checkCrc.put("step", "3");
          checkCrc.put("nric", param.getNric());
          // Count distinct NRIC by registered CID's NRIC
          int step3 = (Integer) eKeyInApiMapper.selectCheckCRC2(checkCrc);
          logger.debug("step3 :: " + Integer.toString(step3));
          if (step3 == 1) {
            errorDesc = "This bank card has been registered under current customer.</br>Please select registered card.";
            // stus = "0";
          } else {
            errorDesc = "This bank card is used by another customer.";
            // stus = "0";
          }
        }
      } else {
        crcCheck = "0";
      }

      // check if credit card is being blocked
      int checkCreditCardValid = eKeyInApiMapper.checkCreditCardValidity(sal0257Dtoken.getToken());
      if (checkCreditCardValid > 0) {
        crcCheck = "2";
        errorDesc = "This card has marked as \"Transaction Not Allowed\". Kindly change a new card";
      }

      logger.debug("crcCheck :: " + crcCheck);
      // If card/token not duplicated
      if (crcCheck == "0") {
        Map<String, Object> sal0028D = new HashMap<String, Object>();
        sal0028D.put("custId", param.getCustId());
        sal0028D.put("custCrcNo", sal0257Dtoken.getCustOriCrcNo());
        sal0028D.put("custOriCrcNo", sal0257Dtoken.getCustOriCrcNo());
        sal0028D.put("custEncryptCrcNo", "");
        sal0028D.put("custCrcOwner", param.getCustCrcOwner());
        sal0028D.put("custCrcTypeId", custCrcTypeId);
        sal0028D.put("custCrcBankId", param.getCustCrcBankId());
        sal0028D.put("custCrcStusId", 1);
        sal0028D.put("custCrcRem", param.getCustCrcRem());
        sal0028D.put("custCrcExpr", sal0257Dtoken.getCustCrcExpr());
        sal0028D.put("custCrcIdOld", 0);
        sal0028D.put("soId", 0);
        sal0028D.put("custCrcIdcm", 0);
        sal0028D.put("custCrcUpdUserId", loginVO.getUserId());
        sal0028D.put("custCrcCrtUserId", loginVO.getUserId());
        sal0028D.put("cardTypeId", param.getCardTypeId());
        sal0028D.put("custCrcToken", sal0257Dtoken.getToken());

        saveCnt = eKeyInApiMapper.insertSAL0028D(sal0028D);
        if (saveCnt != 1) {
          logger.error("===== insertSAL0028D :: fail =====");
          throw new ApplicationException(AppConstants.FAIL, "Card Exception.");
        }

        if (CommonUtils.isEmpty(sal0028D.get("custCrcId"))) {
          logger.error("===== custCrcId value does not exist. =====");
          throw new ApplicationException(AppConstants.FAIL, "custCrcId value does not exist.");
        }

        params.put("updUserId", loginVO.getUserId());
        params.put("custCrcId", sal0028D.get("custCrcId"));
        saveCnt = eKeyInApiMapper.updateCustCrcIdSAL0257D(params);
        if (saveCnt != 1) {
          logger.error("updateCustCrcIdSAL0257D :: failed");
          throw new ApplicationException(AppConstants.FAIL, "Card Exception.");
        }

        rtnDto.setCustOriCrcNo(sal0257Dtoken.getCustOriCrcNo());
        rtnDto.setCustCrcTypeId(Integer.parseInt(custCrcTypeId));
        rtnDto.setCustCrcOwner(param.getCustCrcOwner());
        rtnDto.setCustCrcExpr(sal0257Dtoken.getCustCrcExpr());
        rtnDto.setCustCrcBankId(param.getCustCrcBankId());
        rtnDto.setCardTypeId(param.getCardTypeId());
        rtnDto.setCardTypeIdName(custCrcTypeName);
        rtnDto.setCustCrcId(Integer.parseInt(sal0028D.get("custCrcId").toString()));
      }
    }

    // rtnDto.setStus(stus);
    rtnDto.setCrcCheck(crcCheck);
    rtnDto.setErrorDesc(errorDesc);

    return rtnDto;
  }

  @Override
  public EKeyInApiDto checkIfIsAcInstallationProductCategoryCode(EKeyInApiForm param) {
    // TODO Auto-generated method stub
    EKeyInApiDto rtnDto = new EKeyInApiDto();
    int result = homecareCmMapper.checkIfIsAcInstallationProductCategoryCode(String.valueOf(param.getItmStkId()));
    rtnDto.setIsHcAcInstallationFlag(result);
    return rtnDto;
  }

  @Override
  public EgovMap checkTNA(String param) {
    return eKeyInApiMapper.checkTNA(param);
  }

  @Override
  public List<EgovMap> selectVoucherPlatformCodeList() throws Exception {
    return eKeyInApiMapper.selectVoucherPlatformCodeList();
  }

  @Override
  public EKeyInApiDto isVoucherValidToApply(EKeyInApiForm param) throws Exception {
	    EKeyInApiDto rtnDto = new EKeyInApiDto();
	  Map<String, Object> params = new HashMap<String, Object>();
	  params.put("voucherType", param.getVoucherType());
	  params.put("voucherCode", param.getVoucherCode());
	  params.put("voucherEmail", param.getVoucherEmail());
	  if(param.getPreOrdId() > 0){
		  params.put("preOrdId", param.getPreOrdId());
	  }
	  int valid = 1;
	  int validVoucherResult = eKeyInApiMapper.isVoucherValidToApply(params);
	  int ekeyInValidResult = eKeyInApiMapper.isVoucherValidToApplyIneKeyIn(params);

	  if(validVoucherResult == 0 || ekeyInValidResult == 0){
		  valid = 0;
	  }

	  rtnDto.setVoucherValid(valid);
	  return rtnDto;
  }

  @Override
  public EKeyInApiDto getVoucherUsagePromotionId(EKeyInApiForm param) throws Exception {
    EKeyInApiDto rtn = new EKeyInApiDto();
    List<EgovMap> selectCodeList = eKeyInApiMapper.getVoucherUsagePromotionId(EKeyInApiForm.createMap(param));
    List<EKeyInApiDto> codeList = selectCodeList.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList());
    rtn.setCodeList(codeList);
    return rtn;
  }
}
