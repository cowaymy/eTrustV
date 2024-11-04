package com.coway.trust.biz.api.impl;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.EcommApiService;
import com.coway.trust.biz.application.impl.FileApplicationImpl;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.homecare.sales.order.HcOrderRegisterService;
import com.coway.trust.biz.homecare.sales.order.impl.HcOrderRegisterMapper;
import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.coway.trust.biz.sales.customer.CustomerService;
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
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.Maps;
import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.customerApi.CustomerTierPointApiDto;
import com.coway.trust.api.project.eCommerce.EComApiCustCatForm;
import com.coway.trust.api.project.eCommerce.EComApiCustCatto;
import com.coway.trust.api.project.eCommerce.EComApiDto;
import com.coway.trust.api.project.eCommerce.EComApiForm;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("eCommApiService")
public class EcommApiServiceImpl extends EgovAbstractServiceImpl implements EcommApiService {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);

  @Resource(name = "EcommApiMapper")
  private EcommApiMapper ecommApiMapper;

  @Resource(name = "CommonApiMapper")
  private CommonApiMapper commonApiMapper;

  @Resource(name = "commonApiService")
  private CommonApiService commonApiService;

  @Resource(name = "orderRegisterService")
  private OrderRegisterService orderRegisterService;

  @Resource(name = "customerService")
  private CustomerService customerService;

  @Resource(name = "hcOrderRegisterService")
	private HcOrderRegisterService hcOrderRegisterService;

  @Resource(name = "hcOrderRegisterMapper")
	private HcOrderRegisterMapper hcOrderRegisterMapper;

  @Resource(name = "commonService")
  private CommonService commonService;

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

        LOGGER.debug("reqPrm=======================>" + reqPrm);
        // To check duplicate order coming in from Ascentis
        int duplicateOrdCount = ecommApiMapper.checkDuplicateOrder(reqPrm);
        if(duplicateOrdCount >= 1)
        {
        	code = String.valueOf(AppConstants.RESPONSE_CODE_FORBIDDEN);
            message = AppConstants.RESPONSE_DESC_DUP;
        }
        else
        {
        	//Check for black area product blocking
        	int isBlackAreaFound = ecommApiMapper.isProductUnderBlackArea(reqPrm);
        	if(isBlackAreaFound > 0){
                code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
                message = AppConstants.RESPONSE_DESC_NOT_COVERED;

                return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, null ,apiUserId);
        	}

        	ecommApiMapper.registerOrd(reqPrm);
            ecommApiMapper.getCustomerInfo(reqPrm);

            custInfo = (EgovMap) ((ArrayList) reqPrm.get("p1")).get(0);

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

            Date date = new Date();
            SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault(Locale.Category.FORMAT));
            String nowDate = df.format(date);

            // Get Promotion Price Info
            Map<String, Object> ordInfo = new HashMap<String, Object>();
            ordInfo.put("appTypeId" , reqPrm.get("appType").toString());
            ordInfo.put("promoId"   , reqPrm.get("promo").toString());
            ordInfo.put("stkId"     , reqPrm.get("product").toString());
            ordInfo.put("srvPacId"  , reqPrm.get("srvPac").toString());
            ordInfo.put("bndlId"  , reqPrm.get("bndlId").toString());

            Map<String, Object> memberCode = new HashMap<String, Object>();
            memberCode.put("memCode", salesMenCode);
            memberCode.put("stus", 1);
            memberCode.put("salesMen", 1);

            Map<String, Object> custAdd = new HashMap<String, Object>();
            custAdd.put("custAddId", Integer.valueOf(custInfo.get("custaddid").toString()));

            EgovMap productPrice = orderRegisterService.selectStockPrice(ordInfo);
            // Retrieve back the main product's appTyeId for Frame

            if(ordInfo.get("appTypeId").toString().equals("5764"))
            {
            	String selectAppTypeId = orderRegisterService.selectPrevMatOrderAppTypeId(ordInfo);

            	if(!selectAppTypeId.equals("66"))
                {
                	ordInfo.put("srvPacId",0);
                }
                else
                {
                	ordInfo.put("srvPacId", reqPrm.get("srvPac").toString());
                }
            }
            else if(!ordInfo.get("appTypeId").toString().equals("66"))
            {
            	ordInfo.put("srvPacId",0);
            }

            /*// Non Rental Order - SRV_PAC_ID = 0
            if(!ordInfo.get("appTypeId").toString().equals("66")){
              ordInfo.put("srvPacId",0);
            }*/

            //20230105: Celeste comment to use stockID to find product category
            /*String prdCat = reqPrm.get("prodCat").toString();
            if((prdCat != null && (prdCat.equals("Mattress"))) || prdCat.equals("Frame"))
            {
            	custAdd.put("isHomecare", "Y");
            }*/

            String prodId = reqPrm.get("product").toString();
            String hcFlag = null;
            List<EgovMap> hcProdList = ecommApiMapper.selectHCProdId(ordInfo);
            List<String> hcProdId = new ArrayList<String>();

            Map hm = null;

			for(int i=0; i<hcProdList.size(); i++)
			{
				Map<String, Object> hcProdMap = (Map<String, Object>) hcProdList.get(i);
				hcProdId.add(hcProdMap.get("stkId").toString());
			}

			 LOGGER.debug("hcProdList =====================================>>  " + hcProdList);
			 LOGGER.debug("hcProdId =====================================>>  " + hcProdId);

//            for(Object map : hcProdId)
//            {
//            	hm = (HashMap<String, Object>) map;
//            	hcProdId.add(hm.get("stkId").toString());
//            }

            if(hcProdId.contains(prodId))
            {
            	custAdd.put("isHomecare", "Y");
            	hcFlag = "Y";
            }

            EgovMap promoPrice = orderRegisterService.selectProductPromotionPriceByPromoStockID(ordInfo);
            EgovMap memInfo = orderRegisterService.selectMemberByMemberIDCode(memberCode);
            EgovMap custAddInfo = customerService.selectCustomerViewMainAddress(custAdd);
            EgovMap custStusInfo = ecommApiMapper.getCustStatusId(custInfo);

            SessionVO sessionVO = new SessionVO();
            sessionVO.setUserId(Integer.parseInt(sysUserId));
            sessionVO.setUserBranchId(42);

            orderVO.setCustTypeId(964);
            orderVO.setRaceId( Integer.valueOf(reqPrm.get("race").toString()) );
            orderVO.setBillGrp("new");

            //SAL0001D
            salesOrderMVO.setEcommOrdId(Integer.valueOf(reqPrm.get("ecommOrdId").toString()));
            salesOrderMVO.setAdvBill(0);
            salesOrderMVO.setAppTypeId( Integer.valueOf(reqPrm.get("appType").toString()) );
            salesOrderMVO.setSrvPacId( Integer.valueOf(reqPrm.get("srvPac").toString()) );
            salesOrderMVO.setCustAddId(Integer.valueOf(custInfo.get("custaddid").toString()));
            //salesOrderMVO.setCustCareCntId(Integer.valueOf(custInfo.get("custcarecntid").toString()));
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

            if(CommonUtils.nvl(custStusInfo.get("isExstCust")).equals("") == false){
                salesOrderDVO.setIsExstCust(Integer.valueOf(custStusInfo.get("isExstCust").toString()));
            }
            orderVO.setSalesOrderDVO(salesOrderDVO);

            // SAL0045D
            installationVO.setAddId(Integer.valueOf(custInfo.get("custaddid").toString()));
            installationVO.setBrnchId(CommonUtils.nvl(Integer.valueOf(custAddInfo.get("brnchId").toString()),42));
            installationVO.setCntId(Integer.valueOf(custInfo.get("custcnctid").toString()));;
            installationVO.setInstct(null);
            installationVO.setPreDt(nowDate);
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
            custBillMasterVO.setCustBillCntId(Integer.valueOf(custInfo.get("custcarecntid").toString()));
            //custBillMasterVO.setCustBillCustCareCntId(Integer.valueOf(custInfo.get("custcarecntid").toString()));
            custBillMasterVO.setCustBillCustId(Integer.valueOf(custInfo.get("custid").toString()));
            custBillMasterVO.setCustBillIsEstm(0);
            custBillMasterVO.setCustBillEmail(reqPrm.get("email1") != null ? reqPrm.get("email1").toString() : null);
            custBillMasterVO.setCustBillIsPost(0);
            custBillMasterVO.setCustBillIsSms(1);
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


            // Celeste: when product category is 5706/5707, insert into HMC0110D and setBundleID in SAL0001D with HMC0110D ord_seq_no
            String stkCat = hcOrderRegisterMapper.getProductCategory(reqPrm.get("product").toString());

            String ecommBndlId = reqPrm.get("bndlId").toString();
			int ecommOrdId = salesOrderMVO.getEcommOrdId();
            int cntExisted = hcOrderRegisterMapper.getCountExistBndlId(ecommBndlId);

            if(hcFlag != null && hcFlag.equals("Y"))
    		{
                HcOrderVO hcOrderVO = orderVO.getHcOrderVO();
                //salesOrderMVO.setBndlId(Integer.valueOf(hcOrderVO.getBndlNo().toString()));
                SalesOrderMVO salesOrderMVO1 = new SalesOrderMVO();
                SalesOrderMVO salesOrderMVO2 = new SalesOrderMVO();
                SalesOrderDVO salesOrderDVO1 = new SalesOrderDVO(); //MATTRESS
                SalesOrderDVO salesOrderDVO2 = new SalesOrderDVO(); //FRAME
                AccClaimAdtVO accClaimAdtVO1 = new AccClaimAdtVO(); //MATTRESS
                AccClaimAdtVO accClaimAdtVO2 = new AccClaimAdtVO(); //FRAME
//                if(stkCat.equals("5706")) // MATTRESS  // 20230103: Celeste : not to check solely 5706 but the appTypeId instead
            	if(!ordInfo.get("appTypeId").toString().equals("5764")) // NON-AUX
                {
                	salesOrderDVO1 = orderVO.getSalesOrderDVO();
                	accClaimAdtVO1 = orderVO.getAccClaimAdtVO();
                }
            	else // AUX
                {
                	salesOrderDVO2 = orderVO.getSalesOrderDVO();
                	accClaimAdtVO2 = orderVO.getAccClaimAdtVO();
                }
                salesOrderMVO.seteCommBndlId(reqPrm.get("bndlId").toString());
                orderVO.setSalesOrderMVO(salesOrderMVO);
            	orderVO.setSalesOrderDVO1(salesOrderDVO1);
                orderVO.setSalesOrderDVO2(salesOrderDVO2);
                salesOrderMVO1 = orderVO.getSalesOrderMVO();
                salesOrderMVO2 = orderVO.getSalesOrderMVO();
                orderVO.setSalesOrderMVO1(salesOrderMVO1);
                orderVO.setSalesOrderMVO2(salesOrderMVO2);
                orderVO.setAccClaimAdtVO1(accClaimAdtVO1);
                orderVO.setAccClaimAdtVO2(accClaimAdtVO2);

                if(cntExisted > 1)
                {
                	Map<String, Object> HCObj = new HashMap<String, Object>();
                    HCObj.put("ecommBndlId", ecommBndlId);
    				HCObj.put("ecommOrdId", ecommOrdId);
    				int prevHCOrderId =  hcOrderRegisterMapper.getPrevOrdId(HCObj);
    				String bndlId = ecommBndlId;
    				int prevOrdSeqNo = hcOrderRegisterMapper.getPrevOrdSeq(bndlId);
    				orderVO.setOrdSeqNo(prevOrdSeqNo);
    				salesOrderMVO.setBndlId(prevHCOrderId);
    				orderVO.setSalesOrderMVO(salesOrderMVO);
                }

                hcOrderRegisterService.hcRegisterOrder(orderVO, sessionVO);
    		}else{
    			//check if bundleId in API0005D existed before

    			if(cntExisted > 1)
    			{
    				Map<String, Object> HAObj = new HashMap<String, Object>();
    				HAObj.put("ecommBndlId", ecommBndlId);
    				HAObj.put("ecommOrdId", ecommOrdId);
    				int prevHAOrderId =  hcOrderRegisterMapper.getPrevOrdId(HAObj);
    				salesOrderMVO.setComboOrdBind(prevHAOrderId);
    				orderVO.setSalesOrderMVO(salesOrderMVO);
    			}

    			orderRegisterService.registerOrder(orderVO, sessionVO);
    		}
            created = 1;


            if(created > 0){
              code = String.valueOf(AppConstants.RESPONSE_CODE_CREATED);
              message = AppConstants.RESPONSE_DESC_CREATED;
            }else{
              code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
              message = AppConstants.RESPONSE_DESC_INVALID;
            }
        }
      }

    /*} catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);

      System.out.println();
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

  @Override
  public Map<String, Object> getCustomerCategory(HttpServletRequest request, EComApiCustCatForm eComApiForm) throws Exception {
	  String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

	  StopWatch stopWatch = new StopWatch();
	  stopWatch.reset();
	  stopWatch.start();

	  Map<String, Object> resultValue = new HashMap<String, Object>();
	  Map<String, Object> respParam = new HashMap<String, Object>();
	  EgovMap access = new EgovMap();
	  Map<String, Object> reqPrm = new HashMap<String, Object>();//Maps.filterValues(EComApiCustCatForm.createMap(eComApiForm),Objects::nonNull);

	  Map<String, Object> cnvCustCat = new HashMap<String, Object>();
	  try{

		  Map<String, Object> keyPrm = new HashMap<>();
		  String key = request.getHeader("key");
		  keyPrm.put("key", key);

		  access = commonApiMapper.checkAccess(keyPrm);
		  if(access == null){
			  respParam.put("success", false);
			  respParam.put("statusCode", String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED));
			  respParam.put("message", AppConstants.RESPONSE_DESC_UNAUTHORIZED);
		  }
	      else if(CommonUtils.isEmpty(eComApiForm.getCustNric())){
	    	  respParam.put("success", false);
	    	  respParam.put("statusCode", String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
	    	  respParam.put("message", "NRIC not found.");
	      }
		  else {
			  apiUserId = access.get("apiUserId").toString();
			  reqPrm.put("apiUserId", apiUserId);
			  reqPrm.put("custNric", eComApiForm.getCustNric());

			  List<EgovMap> custCat = ecommApiMapper.getCustomerCat(reqPrm);

			  if(custCat.isEmpty()){
				  Map<String, Object> codeParams = new HashMap<>();
				  codeParams.put("groupCode", 566);
				  codeParams.put("likeValue", "NEW");
				  List<EgovMap> newStatusList = commonService.selectCodeList(codeParams);

				  respParam.put("success", true);
				  respParam.put("statusCode", (int)AppConstants.RESPONSE_CODE_SUCCESS);
				  respParam.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
				  respParam.put("custCatCode", newStatusList.get(0).get("code").toString());
				  respParam.put("custCatNm", newStatusList.get(0).get("codeName").toString());
			  }else{
				  if(custCat.size() > 1){
					  respParam.put("success", false);
					  respParam.put("statusCode", (int)AppConstants.RESPONSE_CODE_INVALID);
					  respParam.put("message", AppConstants.RESPONSE_DESC_DUP + ". Please contact admin or agent.");
				  }else{
					  respParam.put("success", true);
					  respParam.put("statusCode", (int)AppConstants.RESPONSE_CODE_SUCCESS);
					  respParam.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
					  respParam.put("custCatCode", custCat.get(0).get("custCatCode").toString());
					  respParam.put("custCatNm", custCat.get(0).get("custCatNm").toString());
				  }
			  }
//			  EComApiCustCatto custTierDto = EComApiCustCatto.create(respParam);
//
//			  ObjectMapper oMapper = new ObjectMapper();
//			  respParam = oMapper.convertValue(custTierDto, Map.class);

		  }

		  resultValue.put("respParam", respParam);

	  }catch(Exception e){
		  respParam.put("success", false);
		  respParam.put("statusCode", String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
		  respParam.put("message", StringUtils.substring(e.getMessage(), 0, 4000));

		  resultValue.put("respParam", respParam);
	  } finally{
		  stopWatch.stop();
		  respTm = stopWatch.toString();

		  resultValue.put("reqParam", CommonUtils.nvl(reqPrm));
		  resultValue.put("ipAddr", CommonUtils.getClientIp(request));
		  resultValue.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
		  resultValue.put("respTm", CommonUtils.nvl(respTm));
		  resultValue.put("apiUserId", CommonUtils.nvl(apiUserId));
		  rtnRespMsg(resultValue);
	  }


	  return respParam;
  }

	private void rtnRespMsg(Map<String, Object> param) {
		Map<String, Object> params = new HashMap<>();

		params.put("respCde", param.get("statusCode"));
		params.put("errMsg", param.get("message"));
		params.put("reqParam", param.get("reqParam").toString());
		params.put("ipAddr", param.get("ipAddr"));
		params.put("prgPath", param.get("prgPath"));
		params.put("respTm", param.get("respTm"));
		params.put("respParam", param.containsKey("respParam") ? param.get("respParam").toString().length() >= 4000 ? param.get("respParam").toString().substring(0,4000) : param.get("respParam").toString() : "");
    	params.put("apiUserId", param.get("apiUserId") );

    	commonApiMapper.insertApiAccessLog(params);
	}
}
