package com.coway.trust.biz.homecare.sales.order.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcTrialRentalListService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.biz.sales.order.impl.OrderRequestMapper;
import com.coway.trust.biz.sales.order.impl.OrderRequestServiceImpl;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderContractVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderDVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : OrderListServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 18.   KR-SH        First creation
 * 2020. 05. 20.   KR-ONGHC  Add selectProductCodeList
 *          </pre>
 */
@Service("hcTrialRentalListService")
public class HcTrialRentalServiceImpl extends EgovAbstractServiceImpl implements HcTrialRentalListService {

  @Resource(name = "hcTrialRentalListMapper")
  private HcTrialRentalListMapper hcTrialRentalListMapper;

  @Resource(name = "orderRequestMapper")
  private OrderRequestMapper orderRequestMapper;

  @Resource(name = "orderRegisterMapper")
  private OrderRegisterMapper orderRegisterMapper;

  @Resource(name = "orderRegisterService")
  private OrderRegisterService orderRegisterService;

  private static Logger logger = LoggerFactory.getLogger(OrderRequestServiceImpl.class);

  /**
   * Search Homacare OrderList
   *
   * @Author KR-SH
   * @Date 2019. 10. 24.
   * @param params
   * @return
   * @see com.coway.trust.biz.homecare.sales.order.HcOrderListService#selectHcOrderList(java.util.Map)
   */
  @Override
  public List<EgovMap> selectHcTrialRentalList(Map<String, Object> params) {
    return hcTrialRentalListMapper.selectHcTrialRentalList(params);
  }

  /**
   * Search Homacare OrderInfo
   *
   * @Author KR-SH
   * @Date 2019. 10. 25.
   * @param params
   * @return
   * @see com.coway.trust.biz.homecare.sales.order.HcOrderListService#selectHcOrderInfo(java.util.Map)
   */
  @Override
  public EgovMap selectHcTrialRentalInfo(Map<String, Object> params) {
    return hcTrialRentalListMapper.selectHcTrialRentalInfo(params);
  }

  /**
   * select Product Info
   *
   * @Author KR-SH
   * @Date 2020. 1. 14.
   * @param salesOrdId
   * @return
   * @see com.coway.trust.biz.homecare.sales.order.HcOrderListService#selectProductInfo(java.lang.String)
   */
  @Override
  public EgovMap selectProductInfo(String salesOrdId) {
    return hcTrialRentalListMapper.selectProductInfo(salesOrdId);
  }

  @Override
  public List<EgovMap> selectProductCodeList() {
    return hcTrialRentalListMapper.selectProductCodeList();
  }

  @Override
  public int getMemberID(Map<String, Object> params) {
      return hcTrialRentalListMapper.getMemberID(params);
  }

  @Override
  public EgovMap getOrgDtls(Map<String, Object> params) {
      return hcTrialRentalListMapper.getOrgDtls(params);
  }

  @Override
  public EgovMap selectOrderSimulatorViewByOrderNo(Map<String, Object> params) {

	  EgovMap view = hcTrialRentalListMapper.hcSelectOrderSimulatorViewByOrderNo(params);

	    int CurrentBillMth = 0;
	    int CurrentBillMthFrame = 0;
	    int LastBillMth = 0;
	    int LastBillMthFrame = 0;
	    String installDate = SalesConstants.DEFAULT_DATE3;
	    BigDecimal TotalOutstanding = BigDecimal.ZERO;
	    BigDecimal TotalOutstandingFrame = BigDecimal.ZERO;
	    BigDecimal OutrightPrice = BigDecimal.ZERO;
	    BigDecimal TotalBillAmt = BigDecimal.ZERO;
	    BigDecimal TotalBillAmtFrame = BigDecimal.ZERO;
	    BigDecimal TotalBillRPF = BigDecimal.ZERO;
	    BigDecimal TotalBillRPFFrame = BigDecimal.ZERO;
	    BigDecimal TotalDNBill = BigDecimal.ZERO;
	    BigDecimal TotalDNBillFrame = BigDecimal.ZERO;
	    BigDecimal TotalCNBill = BigDecimal.ZERO;
	    BigDecimal TotalCNBillFrame = BigDecimal.ZERO;
	    BigDecimal TotalDNRPF = BigDecimal.ZERO;
	    BigDecimal TotalDNRPFFrame = BigDecimal.ZERO;
	    BigDecimal TotalCNRPF = BigDecimal.ZERO;
	    BigDecimal TotalCNRPFFrame = BigDecimal.ZERO;
	    int fraSalesOrdId = 0;

	    if (view != null) {
	      int salesOrdId = Integer.parseInt(String.valueOf(view.get("salesOrdId")));
	      int appTypeId = Integer.parseInt(String.valueOf(view.get("appTypeId")));
	      int orderStatusID = Integer.parseInt(String.valueOf(view.get("stusCodeId")));
	      String rentalStatus = String.valueOf(view.get("stusCodeId1"));
	      int bndlId = Integer.parseInt(String.valueOf(view.get("bndlId")));
	      int pacId = 3;

	      params.put("salesOrdId", salesOrdId);

	      if(CommonUtils.nvl(view.get("fraOrdId").toString()) != "" && CommonUtils.nvl(view.get("fraOrdId").toString())!= null){
	    	  fraSalesOrdId =  Integer.parseInt(String.valueOf(view.get("fraOrdId")));
	    	  params.put("fraSalesOrdId", fraSalesOrdId);
	      }

	      if (appTypeId == SalesConstants.APP_TYPE_CODE_ID_RENTAL && orderStatusID == SalesConstants.STATUS_COMPLETED) {

	        // Get first install date
	        EgovMap irMap = orderRequestMapper.selectInstallResult(params);

	        if (irMap != null)
	          installDate = (String) irMap.get("installDt");

	        // Get outright price
	        int tracePromoID = 600;

	        if (CommonUtils.intNvl(view.get("ordDt")) > 20140701) {
	          switch(bndlId){
	            case 1 :
	              pacId = 25;
	              break;
	            case 2 :
	              pacId = 24;
	              break;
	            case 3 : // Frame Only orders
	              pacId = 28;
	              break;
	          }

	          // To get no promotion applied
	          Map<String, Object> noPromo = new HashMap<>();
	          noPromo.put("promoTypeId", "2282");
	          noPromo.put("promoAppTypeId", "2285");
	          noPromo.put("promoSrvMemPacId", pacId);
	          noPromo.put("promoPrcPrcnt", "0");
	          noPromo.put("promoRpfDiscAmt", "0");
	          noPromo.put("promoAddDiscPrc", "0");
	          if(pacId != 28)
	          noPromo.put("dateBetween", "1");
	          // Solve bug - Added Stock ID to retrieve promo ID precisely. Hui Ding, 13-04-2021
	          if(view.get("itmStkId") != null)
	          noPromo.put("promoItmStkId", view.get("itmStkId"));

	          EgovMap promoId = orderRequestMapper.selectPromoD(noPromo);
	          tracePromoID = ((BigDecimal) promoId.get("promoId")).intValue();
	          // tracePromoID = 577;
	        }

	        params.put("promoId", tracePromoID);
	        params.put("promoItmStkId", view.get("itmStkId"));

	        EgovMap opMap = orderRequestMapper.selectPromoD(params);

	        EgovMap opMap_anoStkId =null;
	        String anoStkId = orderRequestMapper.selectAnoStkIDWithBundleID(params);


	        if(anoStkId !=null){
	        	 params.put("promoItmAnoStkId", anoStkId);
	        	 opMap_anoStkId = orderRequestMapper.selectAnoStkPromoD(params);
	        }


	        logger.debug("opMap_anoStkId:" +opMap_anoStkId);

	        if (opMap != null &&opMap_anoStkId!=null) {
	        	BigDecimal b1, b2;
	        	 b1 =(BigDecimal) opMap.get("promoItmPrc") ;
	             b2 = (BigDecimal) opMap_anoStkId.get("promoAmt") ;
	             int SumPrice = b1.intValue()+b2.intValue();
	            OutrightPrice = BigDecimal.valueOf(SumPrice);
	        }
	        else{
	        	 OutrightPrice = (BigDecimal) opMap.get("promoItmPrc");
	        }

	        // Get Order Ledger Record
	        EgovMap rlMap = orderRequestMapper.selectAccRentLedger(params);

	        if (CommonUtils.intNvl(rlMap.get("cnt")) > 0) {
	          // Get Order Total Bill (Except RPF)
	          /*EgovMap tbMap = orderRequestMapper.selectAccRentLedger2(params);

	          if (CommonUtils.intNvl(tbMap.get("cnt")) > 0) {
	            TotalBillAmt = (BigDecimal) tbMap.get("rentAmt");
	          }

	          // Get Order Tota DN Bill (Except RPF)
	          EgovMap dnMap = orderRequestMapper.selectTotalDNBill(params);

	          if (CommonUtils.intNvl(dnMap.get("cnt")) > 0) {
	            TotalDNBill = (BigDecimal) dnMap.get("rentAmt");
	          }

	          // Get Order Total CN Bill (Except RPF)
	          EgovMap cnMap = orderRequestMapper.selectTotalCNBill(params);

	          if (CommonUtils.intNvl(cnMap.get("cnt")) > 0) {
	            TotalCNBill = (BigDecimal) cnMap.get("cnAmount");
	          }

	          // Get Order Total Bill RPF
	          EgovMap tbMap2 = orderRequestMapper.selectAccRentLedger3(params);

	          if (CommonUtils.intNvl(tbMap2.get("cnt")) > 0) {
	            TotalBillRPF = (BigDecimal) tbMap2.get("rentAmt");
	          }

	          // Get Order Tota DN RPF
	          EgovMap dnMap2 = orderRequestMapper.selectTotalDNBill2(params);

	          if (CommonUtils.intNvl(dnMap2.get("cnt")) > 0) {
	            TotalDNRPF = (BigDecimal) dnMap.get("rentAmt");
	          }

	          // Get Order Total CN RPF
	          EgovMap cnMap2 = orderRequestMapper.selectTotalCNBill2(params);

	          if (CommonUtils.intNvl(cnMap2.get("cnt")) > 0) {
	            TotalCNRPF = (BigDecimal) cnMap2.get("cnAmount");
	          }*/

	          // Get Order Total Outstanding
	          TotalOutstanding = (BigDecimal) rlMap.get("rentAmt");
	        }

	        // Get Last Bill Month
	        if (CommonUtils.intNvl(rlMap.get("cnt")) > 0) {
	            EgovMap lbMap = orderRequestMapper.selectLastBill(params);

		        if (lbMap != null) {
		          LastBillMth = CommonUtils.intNvl(lbMap.get("rentInstNo"));
		        }
	        }

	        // Get Current Bill Month
	        EgovMap qryMaxBillMonth = orderRequestMapper.selectRentalInst(params);

	        if (qryMaxBillMonth != null) {
	          if (Integer.parseInt(((String) qryMaxBillMonth.get("rentInstDt")).substring(0, 6) + "01") <= CommonUtils
	              .intNvl(CommonUtils.getNowDate())) {
	            CurrentBillMth = CommonUtils.intNvl(qryMaxBillMonth.get("rentInstNo"));
	          } else {
	            EgovMap qryCurrentBillMonth = orderRequestMapper.selectRentalInst2(params);

	            if (qryCurrentBillMonth != null) {

	              CurrentBillMth = CommonUtils.intNvl(qryCurrentBillMonth.get("rentInstNo")) == 0 ? 1 : CommonUtils.intNvl(qryCurrentBillMonth.get("rentInstNo"));
	            }
	          }

	          TotalBillAmt = ((BigDecimal) view.get("mthRentAmt")).multiply(BigDecimal.valueOf(CurrentBillMth));
	        }

	        logger.debug("fraSOID111===" + view.toString());
	        logger.debug("fraSOID111===" + fraSalesOrdId);
	    	logger.debug("fraSOID111===" + params.get("fraSalesOrdId").toString());

	        //FRAME
		    if(CommonUtils.intNvl(fraSalesOrdId) > 0){
		     	//GET Frame
		        EgovMap frameRlMap = orderRequestMapper.selectAccRentLedgerFrame3(params);

		        if (CommonUtils.intNvl(frameRlMap.get("cnt")) > 0) {

		          EgovMap frameTbMap = orderRequestMapper.selectAccRentLedgerFrame(params);

		          if (CommonUtils.intNvl(frameTbMap.get("cnt")) > 0) {
		            TotalBillAmtFrame = (BigDecimal) frameTbMap.get("rentAmt");
		          }

		          EgovMap frameDnMap = orderRequestMapper.selectTotalDNBillFrame(params);

		          if (CommonUtils.intNvl(frameDnMap.get("cnt")) > 0) {
		            TotalDNBillFrame = (BigDecimal) frameDnMap.get("rentAmt");
		          }

		          EgovMap frameCnMap = orderRequestMapper.selectTotalCNBillFrame(params);

		          if (CommonUtils.intNvl(frameCnMap.get("cnt")) > 0) {
		            TotalCNBillFrame = (BigDecimal) frameCnMap.get("cnAmount");
		          }

		          EgovMap frameTbMap2 = orderRequestMapper.selectAccRentLedgerFrame2(params);

		          if (CommonUtils.intNvl(frameTbMap2.get("cnt")) > 0) {
		            TotalBillRPFFrame = (BigDecimal) frameTbMap2.get("rentAmt");
		          }

		          EgovMap frameDnMap2 = orderRequestMapper.selectTotalDNBillFrame2(params);

		          if (CommonUtils.intNvl(frameDnMap2.get("cnt")) > 0) {
		            TotalDNRPFFrame = (BigDecimal) frameDnMap2.get("rentAmt");
		          }

		          EgovMap FrameCnMap2 = orderRequestMapper.selectTotalCNBillFrame2(params);

		          if (CommonUtils.intNvl(FrameCnMap2.get("cnt")) > 0) {
		            TotalCNRPFFrame = (BigDecimal) FrameCnMap2.get("cnAmount");
		          }

		          TotalOutstandingFrame = (BigDecimal) frameRlMap.get("rentAmt");
		        }

		        // Get Last Bill Month
		        if (CommonUtils.intNvl(rlMap.get("cnt")) > 0) {

		        	EgovMap frameLbMap = orderRequestMapper.selectLastBillFrame(params);

		        	if (frameLbMap != null) {
		        		LastBillMthFrame = CommonUtils.intNvl(frameLbMap.get("rentInstNo"));
		        	}
		        }

		        EgovMap qryMaxBillMonthFrame = orderRequestMapper.selectRentalInstFrame(params);

		        if (qryMaxBillMonthFrame != null) {
		          if (Integer.parseInt(((String) qryMaxBillMonthFrame.get("rentInstDt")).substring(0, 6) + "01") <= CommonUtils
		              .intNvl(CommonUtils.getNowDate())) {
		            CurrentBillMthFrame = CommonUtils.intNvl(qryMaxBillMonthFrame.get("rentInstNo"));
		          } else {
		            EgovMap qryCurrentBillMonthFrame = orderRequestMapper.selectRentalInstFrame2(params);

		            if (qryCurrentBillMonthFrame != null) {
		            	CurrentBillMthFrame = CommonUtils.intNvl(qryCurrentBillMonthFrame.get("rentInstNo"));
		            }
		          }
		        }
		    }
	      }
	    }

	    view.put("currentbillmth", CurrentBillMth);
	    view.put("lastbillmth", LastBillMth);
	    view.put("installdate", installDate);
	    view.put("totaloutstanding", TotalOutstanding);
	    view.put("outrightprice", OutrightPrice);
	    view.put("totalbillamt", TotalBillAmt);
	    view.put("totalbillrpf", TotalBillRPF);
	    view.put("totaldnbill", TotalDNBill);
	    view.put("totalcnbill", TotalCNBill);
	    view.put("totaldnrpf", TotalDNRPF);
	    view.put("totalcnrpf", TotalCNRPF);
	    view.put("currentbillmthFrame", CurrentBillMthFrame);
	    view.put("lastbillmthFrame", LastBillMthFrame);
	    view.put("totaloutstandingFrame", TotalOutstandingFrame);
	    view.put("totalbillamtFrame", TotalBillAmtFrame);
	    view.put("totalbillrpfFrame", TotalBillRPFFrame);
	    view.put("totaldnbillFrame", TotalDNBillFrame);
	    view.put("totalcnbillFrame", TotalCNBillFrame);
	    view.put("totaldnrpfFrame", TotalDNRPFFrame);
	    view.put("totalcnrpfFrame", TotalCNRPFFrame);

	    System.out.println(view.toString());
        logger.debug("fraSOID111===" + view.toString());

	    return view;
  }

  @Override
  public List<EgovMap> selectTrialRentalConvertServicePackageList(Map<String, Object> params) {
    return hcTrialRentalListMapper.selectTrialRentalConvertServicePackageList(params);
  }

  @Override
  public EgovMap getTrialRentalBasicInfo(Map<String, Object> params) {
      return hcTrialRentalListMapper.getTrialRentalBasicInfo(params);
  }

  @Override
  @Transactional
  public int convertTrialRental(OrderVO orderVO, SessionVO sessionVO) {
	  SalesOrderMVO salesOrderMVO = orderVO.getSalesOrderMVO1();
	  SalesOrderDVO salesOrderDVO = orderVO.getSalesOrderDVO1();

	  salesOrderMVO.setSalesOrdId(orderVO.getSalesOrdId());
	  salesOrderDVO.setSalesOrdId(orderVO.getSalesOrdId());
	  salesOrderMVO.setUpdUserId(sessionVO.getUserId());
	  salesOrderDVO.setUpdUserId(sessionVO.getUserId());

	  int salesOrdId = orderVO.getSalesOrdId();

	  Map<String, Object> params = new HashMap<>();
	  params.put("ordId", salesOrdId);

	  int trialRentalConvertHistorySeq = hcTrialRentalListMapper.getTrialRentalConvertHistorySeq();
	  Map<String, Object> inTrialRentalConvertHistory = new HashMap<>();

	  try {
		  EgovMap trialRentalInfo = hcTrialRentalListMapper.getTrialRentalBasicInfo(params);

		  if(trialRentalInfo != null && trialRentalInfo.size() > 0){
			  int orderNumber = Integer.parseInt(orderVO.getSalesOrdNoFirst());

			  int promoId = CommonUtils.intNvl(salesOrderMVO.getPromoId());
			  int srvPacId = CommonUtils.intNvl(salesOrderMVO.getSrvPacId());
			  int appTypeId = CommonUtils.intNvl(salesOrderMVO.getAppTypeId());

		      inTrialRentalConvertHistory.clear();
		      inTrialRentalConvertHistory.put("convertId", trialRentalConvertHistorySeq);
		      inTrialRentalConvertHistory.put("salesOrdId", salesOrdId);
		      inTrialRentalConvertHistory.put("convertStusId", 1);

		      inTrialRentalConvertHistory.put("oldStusId", trialRentalInfo.get("ordStusId"));
		      inTrialRentalConvertHistory.put("oldAppTypeId", trialRentalInfo.get("appTypeId"));
		      inTrialRentalConvertHistory.put("oldSvcPacId", trialRentalInfo.get("srvPacId"));
		      inTrialRentalConvertHistory.put("oldPromoId", trialRentalInfo.get("ordPromoId"));

		      inTrialRentalConvertHistory.put("newStusId", trialRentalInfo.get("ordStusId"));
		      inTrialRentalConvertHistory.put("newAppTypeId", appTypeId);
		      inTrialRentalConvertHistory.put("newSvcPacId", srvPacId);
		      inTrialRentalConvertHistory.put("newPromoId", promoId);

		      inTrialRentalConvertHistory.put("userId", sessionVO.getUserId());

			  int check = hcTrialRentalListMapper.checkActiveTrialRentalConvertHistory(inTrialRentalConvertHistory);
			  if(check == 0){
			      hcTrialRentalListMapper.insertTrialRentalConvertHistory(inTrialRentalConvertHistory);
			  }else{
			      inTrialRentalConvertHistory.put("convertStusId", 21);
				  hcTrialRentalListMapper.updateOldTrialRentalConvertHistory(inTrialRentalConvertHistory);
				  return 0;
			  }

		      EgovMap iMap2 = new EgovMap();

		      iMap2.put("srvCntrctPacId", srvPacId);

		      EgovMap oMap2 = orderRegisterMapper.selectServiceContractPackage(iMap2);

		      SalesOrderContractVO salesOrderContractVO = new SalesOrderContractVO();
		      salesOrderContractVO.setCntrctSalesOrdId(salesOrdId);
		      salesOrderContractVO.setCntrctRentalPriod(CommonUtils.intNvl(oMap2.get("srvCntrctPacDur")));
		      salesOrderContractVO.setCntrctObligtPriod(CommonUtils.intNvl(oMap2.get("obligtPriod")));
		      salesOrderContractVO.setCntrctRcoPriod(CommonUtils.intNvl(oMap2.get("rcoPriod")));
		      salesOrderContractVO.setCntrctUpdUserId(sessionVO.getUserId());

		      hcTrialRentalListMapper.updateSAL0001D(salesOrderMVO);
		      hcTrialRentalListMapper.updateSAL0225D(salesOrderMVO);
		      hcTrialRentalListMapper.updateSAL0002D(salesOrderDVO);
		      hcTrialRentalListMapper.updateSAL0003D(salesOrderContractVO);

		      Map<String, Object> inSal0095d = new HashMap<>();
		      inSal0095d.put("salesOrdId", salesOrdId);
		      inSal0095d.put("srvPacId", srvPacId);
		      inSal0095d.put("custCntId", salesOrderMVO.getCustCntId());
		      inSal0095d.put("userId", sessionVO.getUserId());
		      hcTrialRentalListMapper.insertSAL0095D(inSal0095d);

		      Map<String, Object> inSal0088d = new HashMap<>();
		      inSal0088d.put("salesOrdId", salesOrdId);
		      inSal0088d.put("userId", sessionVO.getUserId());
		      hcTrialRentalListMapper.insertSAL0088D(inSal0088d);

		      Map<String, Object> inSal0070d = new HashMap<>();
		      inSal0070d.put("salesOrdId", salesOrdId);
		      inSal0070d.put("userId", sessionVO.getUserId());
		      hcTrialRentalListMapper.insertSAL0070D(inSal0070d);

		      inTrialRentalConvertHistory.clear();
		      inTrialRentalConvertHistory.put("convertId", trialRentalConvertHistorySeq);
		      inTrialRentalConvertHistory.put("convertStusId", 4);
		      inTrialRentalConvertHistory.put("userId", sessionVO.getUserId());

		      hcTrialRentalListMapper.updateTrialRentalConvertHistory(inTrialRentalConvertHistory);

		      return orderNumber;
		  }
		  else{
			  inTrialRentalConvertHistory.clear();
			  inTrialRentalConvertHistory.put("convertId", trialRentalConvertHistorySeq);
		      inTrialRentalConvertHistory.put("convertStusId", 21);
		      inTrialRentalConvertHistory.put("userId", sessionVO.getUserId());

		      hcTrialRentalListMapper.updateTrialRentalConvertHistory(inTrialRentalConvertHistory);

			  return 0;
		  }
	  }
	  catch(Exception ex){
		  logger.debug("convertTrialRental: " + ex.getMessage());
		  throw new ApplicationException(AppConstants.FAIL, "Failed to convert order.");
	  }
  }
}
