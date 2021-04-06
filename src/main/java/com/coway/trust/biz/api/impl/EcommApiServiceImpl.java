package com.coway.trust.biz.api.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2020/12/16           API for Common
 ***************************************/

import java.util.Map;
import java.util.Objects;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.EcommApiService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.vo.AccClaimAdtVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.EStatementReqVO;
import com.coway.trust.biz.sales.order.vo.InstallationVO;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.RentPaySetVO;
import com.coway.trust.biz.sales.order.vo.RentalSchemeVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderDVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.google.common.collect.Maps;
import com.coway.trust.AppConstants;
import com.coway.trust.api.project.eCommerce.EComApiDto;
import com.coway.trust.api.project.eCommerce.EComApiForm;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("eCommApiService")
public class EcommApiServiceImpl extends EgovAbstractServiceImpl implements EcommApiService {

  @Resource(name = "EcommApiMapper")
  private EcommApiMapper ecommApiMapper;

  @Resource(name = "CommonApiMapper")
  private CommonApiMapper commonApiMapper;

  @Resource(name = "commonApiService")
  private CommonApiService commonApiService;

  @Resource(name = "orderRegisterService")
  private OrderRegisterService orderRegisterService;

  @Override
  public EgovMap registerOrder(HttpServletRequest request, EComApiForm eComApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0", sysUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    EgovMap access = new EgovMap();
    Map<String, Object> reqPrm = Maps.filterValues(EComApiForm.createRegOrdMap(eComApiForm),Objects::nonNull);
    EgovMap custInfo = new EgovMap();

    //try{

      access = commonApiMapper.checkAccess(reqPrm);
      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
      else {
        apiUserId = access.get("apiUserId").toString();
        sysUserId = access.get("sysUserId").toString();
        reqPrm.put("apiUserId", apiUserId);

        int created = 0;
        String salesMenCode = CommonUtils.nvl(reqPrm.get("salesmanCode")) == "" ? "100334" : reqPrm.get("salesmanCode").toString();

        ecommApiMapper.registerOrd(reqPrm);
        ecommApiMapper.getCustomerInfo(reqPrm);

        custInfo = (EgovMap) ((ArrayList) reqPrm.get("p1")).get(0);

        SessionVO sessionVO = new SessionVO();
        sessionVO.setUserId(Integer.parseInt(sysUserId));

        OrderVO orderVO = new OrderVO();
        SalesOrderMVO salesOrderMVO = new SalesOrderMVO();
        SalesOrderDVO salesOrderDVO = new SalesOrderDVO();
        InstallationVO installationVO = new InstallationVO();
        RentPaySetVO rentPaySetVO = new RentPaySetVO();
        CustBillMasterVO custBillMasterVO = new CustBillMasterVO();
        AccClaimAdtVO accClaimAdtVO = new AccClaimAdtVO();
        EStatementReqVO eStatementReqVO = new EStatementReqVO();
        DocSubmissionVO docSubmissionVO = new DocSubmissionVO();
        GridDataSet<DocSubmissionVO> documentList = new GridDataSet<DocSubmissionVO>();
        List<DocSubmissionVO> docList = new ArrayList<DocSubmissionVO>();
        RentalSchemeVO rentalSchemeVO = new RentalSchemeVO();

        // Get Promotion Price Info
        Map<String, Object> ordInfo = new HashMap<String, Object>();
        ordInfo.put("appTypeId" , reqPrm.get("appType").toString());
        ordInfo.put("promoId"   , reqPrm.get("promo").toString());
        ordInfo.put("stkId"     , reqPrm.get("product").toString());
        ordInfo.put("srvPacId"  , reqPrm.get("srvPac").toString());

        Map<String, Object> memberCode = new HashMap<String, Object>();
        memberCode.put("memCode", salesMenCode);
        memberCode.put("stus", 1);
        memberCode.put("salesMen", 1);

        EgovMap productPrice = orderRegisterService.selectStockPrice(ordInfo);

        // Non Rental Order - SRV_PAC_ID = 0
        if(!ordInfo.get("appTypeId").toString().equals("66")){
          ordInfo.put("srvPacId",0);
        }

        EgovMap promoPrice = orderRegisterService.selectProductPromotionPriceByPromoStockID(ordInfo);
        EgovMap memInfo = orderRegisterService.selectMemberByMemberIDCode(memberCode);

        orderVO.setCustTypeId(964);
        orderVO.setRaceId( Integer.valueOf(reqPrm.get("race").toString()) );
        orderVO.setBillGrp("new");

        //SAL0001D
        salesOrderMVO.setEcommOrdId(Integer.valueOf(reqPrm.get("ecommOrdId").toString()));
        salesOrderMVO.setAdvBill(0);
        salesOrderMVO.setAppTypeId( Integer.valueOf(reqPrm.get("appType").toString()) );
        salesOrderMVO.setSrvPacId( Integer.valueOf(reqPrm.get("srvPac").toString()) );
        salesOrderMVO.setCustAddId(Integer.valueOf(custInfo.get("custaddid").toString()));
        salesOrderMVO.setCustCareCntId(Integer.valueOf(custInfo.get("custcarecntid").toString()));
        salesOrderMVO.setCustCntId(Integer.valueOf(custInfo.get("custcnctid").toString()));
        salesOrderMVO.setCustId(Integer.valueOf(custInfo.get("custid").toString()));
        salesOrderMVO.setInstPriod(0);
        salesOrderMVO.setPvMonth(0);
        salesOrderMVO.setPvYear(0);

        salesOrderMVO.setDefRentAmt( new BigDecimal(promoPrice.get("orderRentalFeesPromo").toString()));
        salesOrderMVO.setMthRentAmt( new BigDecimal(promoPrice.get("orderRentalFeesPromo").toString()) );
        salesOrderMVO.setPromoDiscPeriod(Integer.valueOf(promoPrice.get("promoDiscPeriod").toString()));
        salesOrderMVO.setPromoDiscPeriodTp(Integer.valueOf(promoPrice.get("promoDiscPeriodTp").toString()));
        salesOrderMVO.setTotPv(new BigDecimal(promoPrice.get("orderPVPromo").toString()));
        salesOrderMVO.setNorAmt(new BigDecimal(promoPrice.get("orderRentalFeesPromo").toString()));
        salesOrderMVO.setNorRntFee(new BigDecimal(promoPrice.get("orderRentalFeesPromo").toString()));
        salesOrderMVO.setDiscRntFee(new BigDecimal(promoPrice.get("orderRentalFeesPromo").toString()));

        salesOrderMVO.setPromoId( Integer.valueOf(reqPrm.get("promo").toString()) );
        salesOrderMVO.setRefNo(reqPrm.get("refNo").toString());
        salesOrderMVO.setRem("Ecommerce Order");
        salesOrderMVO.setBrnchId(42);

        salesOrderMVO.setMemId(Integer.valueOf(memInfo.get("memId").toString()));
        salesOrderMVO.setDeptCode(memInfo.get("deptCode").toString());
        salesOrderMVO.setGrpCode(memInfo.get("grpCode").toString());
        salesOrderMVO.setOrgCode(memInfo.get("orgCode").toString());
        salesOrderMVO.setSalesGmId(Integer.valueOf(memInfo.get("lvl1UpId").toString()));
        salesOrderMVO.setSalesSmId(Integer.valueOf(memInfo.get("lvl2UpId").toString()));
        salesOrderMVO.setSalesHmId(Integer.valueOf(memInfo.get("lvl3UpId").toString()));
        orderVO.setSalesOrderMVO(salesOrderMVO);

        // SAL0002D
        salesOrderDVO.setItmPrc(new BigDecimal(promoPrice.get("orderRentalFeesPromo").toString()));
        salesOrderDVO.setItmPrcId(Integer.valueOf(productPrice.get("priceId").toString()));
        salesOrderDVO.setItmPv(new BigDecimal(promoPrice.get("orderPVPromo").toString()));
        salesOrderDVO.setItmStkId(Integer.valueOf(reqPrm.get("product").toString()) );
        salesOrderDVO.setItmCompId(Integer.valueOf(reqPrm.get("cpntId").toString()) );
        orderVO.setSalesOrderDVO(salesOrderDVO);

        // SAL0045D
        installationVO.setAddId(Integer.valueOf(custInfo.get("custaddid").toString()));
        installationVO.setBrnchId(42);
        installationVO.setCntId(Integer.valueOf(custInfo.get("custcnctid").toString()));;
        installationVO.setInstct(null);
        installationVO.setPreDt("01/01/1900");
        installationVO.setPreTm("12:00");
        orderVO.setInstallationVO(installationVO);

        // SAL0074D
        rentPaySetVO.setBankId(Integer.valueOf(reqPrm.get("issueBank").toString()));
        rentPaySetVO.setCustAccId(0);
        rentPaySetVO.setCustCrcId(Integer.valueOf(custInfo.get("custcrcid").toString()));
        rentPaySetVO.setCustId(Integer.valueOf(custInfo.get("custid").toString()));
        //rentPaySetVO.setIs3rdParty(Integer.valueOf(reqPrm.get("thrdParty").toString()));
        rentPaySetVO.setModeId(131);
        rentPaySetVO.setIssuNric(null);
        rentPaySetVO.setNricOld(null);
        orderVO.setRentPaySetVO(rentPaySetVO);

        // SAL0024D
        custBillMasterVO.setCustBillAddId(Integer.valueOf(custInfo.get("custaddid").toString()));
        custBillMasterVO.setCustBillCntId(Integer.valueOf(custInfo.get("custcnctid").toString()));
        custBillMasterVO.setCustBillCustCareCntId(Integer.valueOf(custInfo.get("custcarecntid").toString()));
        custBillMasterVO.setCustBillCustId(Integer.valueOf(custInfo.get("custid").toString()));
        custBillMasterVO.setCustBillIsEstm(1);
        custBillMasterVO.setCustBillEmail(reqPrm.get("email1") != null ? reqPrm.get("email1").toString() : null);
        custBillMasterVO.setCustBillIsPost(0);
        custBillMasterVO.setCustBillIsSms(0);
        custBillMasterVO.setCustBillIsSms2(0);
        custBillMasterVO.setCustBillIsWebPortal(0);
        custBillMasterVO.setCustBillRem(null);
        custBillMasterVO.setCustBillWebPortalUrl(null);
        orderVO.setCustBillMasterVO(custBillMasterVO);

        // PAY0008M
        accClaimAdtVO.setAccClBillClmAmt(BigDecimal.valueOf(0));
        accClaimAdtVO.setAccClClmAmt(BigDecimal.valueOf(0));
        accClaimAdtVO.setAccClAccTName(reqPrm.get("cardName").toString());
        accClaimAdtVO.setAccClAccNric(reqPrm.get("nric").toString());
        accClaimAdtVO.setAccClPayMode("CRC");
        accClaimAdtVO.setAccClPayModeId(131);
        orderVO.setAccClaimAdtVO(accClaimAdtVO);

        eStatementReqVO.setEmail(reqPrm.get("email1") != null ? reqPrm.get("email1").toString() : null);
        orderVO.seteStatementReqVO(eStatementReqVO);

        // ORG0010D
        docSubmissionVO.setChkfield(1);
        docSubmissionVO.setDocTypeId(3198);
        docSubmissionVO.setTypeDesc("Sales Order Form");
        docList.add(0, docSubmissionVO);
        documentList.setUpdate((ArrayList<DocSubmissionVO>) docList);
        orderVO.setDocSubmissionVOList(documentList);
        orderVO.setRentalSchemeVO(rentalSchemeVO);


        orderRegisterService.registerOrder(orderVO, sessionVO);

        created = 1;


        if(created > 0){
          code = String.valueOf(AppConstants.RESPONSE_CODE_CREATED);
          message = AppConstants.RESPONSE_DESC_CREATED;
        }else{
          code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
          message = AppConstants.RESPONSE_DESC_INVALID;
        }
      }

    /*} catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }*/

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, null ,apiUserId);
  }

  @Override
  public EgovMap checkOrderStatus(HttpServletRequest request,EComApiForm eComApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    EgovMap data = new EgovMap(), access = new EgovMap();
    Map<String, Object> reqPrm = Maps.filterValues(EComApiForm.createMap(eComApiForm),Objects::nonNull);
    EComApiDto rtn = new EComApiDto();

    try{

      access = commonApiMapper.checkAccess(reqPrm);

      if(access != null) apiUserId = access.get("apiUserId").toString();

      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
      else if(CommonUtils.isEmpty(eComApiForm.getSofNo())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "Sales Order Form No. Not Found";
      }
      else {
        data = ecommApiMapper.checkOrderStatus(EComApiForm.createMap(eComApiForm));

        if(MapUtils.isNotEmpty(data)){
          code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
          message = AppConstants.RESPONSE_DESC_SUCCESS;

          rtn = EComApiDto.create(data);
        }else{
          code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
          message = "Sales Order Form No. Not Found";
        }
      }

    }catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, EComApiDto.createMap(rtn) ,apiUserId);
  }

  @Override
  public EgovMap cardDiffNRIC(HttpServletRequest request, EComApiForm eComApiForm) throws Exception {

    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    EgovMap data = new EgovMap(), params = new EgovMap(), access = new EgovMap();
    Map<String, Object> reqPrm = Maps.filterValues(EComApiForm.createMap(eComApiForm),Objects::nonNull);

    params.put("cardDiffNRIC", "F");

    try{

      access = commonApiMapper.checkAccess(reqPrm);

      if(access != null) apiUserId = access.get("apiUserId").toString();

      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
      else if(CommonUtils.isEmpty(eComApiForm.getNric())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "NRIC not found.";
      }
      else if(CommonUtils.isEmpty(eComApiForm.getCardTokenId())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "Card Token Id not found.";
      }
      else {
        data = ecommApiMapper.cardDiffNRIC(reqPrm);

        if(data != null){
          code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
          message = AppConstants.RESPONSE_DESC_SUCCESS;

          if(!(data.get("custCrcToken") == null) && data.get("nric") == null )
            params.put("cardDiffNRIC", "Y");
          else{
            params.put("cardDiffNRIC", "N");
          }
        }else{
          code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
          message = String.valueOf(AppConstants.RESPONSE_DESC_SUCCESS);
          params.put("cardDiffNRIC", "N");
        }

      }

    }catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, params ,apiUserId);
  }

  @Override
  public EgovMap insertNewAddr(HttpServletRequest request, EComApiForm eComApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    EgovMap access = new EgovMap(), params = new EgovMap();
    int created = 0;
    Map<String, Object> reqPrm = Maps.filterValues(EComApiForm.createAddrMap(eComApiForm),Objects::nonNull);

    try{

      access = commonApiMapper.checkAccess(reqPrm);
      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }else if(CommonUtils.isEmpty(eComApiForm.getCountry())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "Country not found.";
      }else if(CommonUtils.isEmpty(eComApiForm.getState())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "State not found.";
      }else if(CommonUtils.isEmpty(eComApiForm.getPostcode())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "Postcode not found.";
      }else if(CommonUtils.isEmpty(eComApiForm.getArea())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "Area not found.";
      }else if(CommonUtils.isEmpty(eComApiForm.getCity())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "City not found.";
      }
      else {
        apiUserId = access.get("apiUserId").toString();
        created = ecommApiMapper.insertNewAddr(reqPrm);

        params.put("areaId", reqPrm.get("areaId").toString());

        if(created > 0){
          code = String.valueOf(AppConstants.RESPONSE_CODE_CREATED);
          message = AppConstants.RESPONSE_DESC_CREATED;
        }else{
          code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
          message = "Failed to insert address";
        }
      }

    }catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, params ,apiUserId);
  }

  @Override
  public EgovMap cancelOrder(HttpServletRequest request, EComApiForm eComApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    EgovMap access = new EgovMap();
    Map<String, Object> reqPrm = Maps.filterValues(EComApiForm.createMap(eComApiForm),Objects::nonNull);
    Map<String, Object> cancelResult = new HashMap<String, Object>();

    try{

      access = commonApiMapper.checkAccess(reqPrm);
      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
      else if(CommonUtils.isEmpty(eComApiForm.getSofNo())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "Sales Order Form No. Not Found";
      }
      else {
        apiUserId = access.get("apiUserId").toString();
        reqPrm.put("apiUserId", apiUserId);

        ecommApiMapper.cancelOrd(reqPrm);
        if(reqPrm.get("p1").toString().equals("O.K")){
          code = String.valueOf(AppConstants.RESPONSE_CODE_CREATED);
          message = AppConstants.RESPONSE_DESC_CREATED;
        }else{
          code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
          message = reqPrm.get("p1").toString();
        }
      }

    }catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, null ,apiUserId);
  }
}
