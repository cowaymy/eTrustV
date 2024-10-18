package com.coway.trust.biz.homecare.sales.order.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcOrderRegisterService;
import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.coway.trust.biz.misc.voucher.impl.VoucherMapper;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.biz.sales.order.impl.OrderRegisterServiceImpl;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.sales.order.HcOrderRegisterController;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : OrderRegisterServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 18.   KR-SH        First creation
 * </pre>
 */
@Service("hcOrderRegisterService")
public class HcOrderRegisterServiceImpl extends EgovAbstractServiceImpl implements HcOrderRegisterService {
    private static Logger logger = LoggerFactory.getLogger(HcOrderRegisterServiceImpl.class);

  	@Resource(name = "hcOrderRegisterMapper")
  	private HcOrderRegisterMapper hcOrderRegisterMapper;

  	@Resource(name = "orderRegisterService")
  	private OrderRegisterService orderRegisterService;

  	@Resource(name = "voucherMapper")
  	private VoucherMapper voucherMapper;

  	/**
  	 * Select Homacare Product List
  	 *
  	 * @Author KR-SH
  	 * @Date 2019. 10. 18.
  	 * @param params
  	 * @return list
  	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderRegisterService#selectHcProductCodeList(java.util.Map)
  	 */
    @Override
    public List<EgovMap> selectHcProductCodeList(Map<String, Object> params) {
    	return hcOrderRegisterMapper.selectHcProductCodeList(params);
    }

    /**
     * Homecare Register Order
     *
     * @Author KR-SH
     * @Date 2019. 10. 23.
     * @param orderVO
     * @param sessionVO
     * @throws ParseException
     * @see com.coway.trust.biz.homecare.sales.order.HcOrderRegisterService#hcRegisterOrder(com.coway.trust.biz.sales.order.vo.OrderVO, com.coway.trust.cmmn.model.SessionVO)
     */
	@Override
	public void hcRegisterOrder(OrderVO orderVO, SessionVO sessionVO) throws ParseException {
		String matOrdNo = "";     // Mattress Order No
		String fraOrdNo = "";       // Frame Order No.
		int matOrdId = 0;
		int rtnCnt = 0;
		SalesOrderMVO salesOrderMVO1 = orderVO.getSalesOrderMVO1();
		SalesOrderMVO salesOrderMVO2 = null;
		String hcSetOrdYn = "N";

		int custId = CommonUtils.intNvl(salesOrderMVO1.getCustId());     // Cust Id
		int matStkId = CommonUtils.intNvl(orderVO.getSalesOrderDVO1().getItmStkId());
		int fraStkId = CommonUtils.intNvl(orderVO.getSalesOrderDVO2().getItmStkId());
		String ordChgYn = CommonUtils.nvl(orderVO.getCopyOrderChgYn());

		if(custId <= 0) {
			throw new ApplicationException(AppConstants.FAIL, "Order Register Failed. - Null Customer ID");
		}
		// 제품이 둘다 없는 경우.
		if(matStkId+fraStkId <= 0) {
			throw new ApplicationException(AppConstants.FAIL, "Order Register Failed. - Null Product ID");
		}

		/*
	     * Voucher checking before creating order as HC PRE-ORDER does not consume voucher usage
	     */
	    if(CommonUtils.isEmpty(salesOrderMVO1.getVoucherCode()) == false){
	        Map<String, Object> voucherInfo = new HashMap<String, Object>();
	        voucherInfo.put("voucherCode", salesOrderMVO1.getVoucherCode());
	        int validVoucher = voucherMapper.isVoucherValidToApply(voucherInfo);

	        if(validVoucher == 0)
	        {
	        	throw new ApplicationException(AppConstants.FAIL,
						"Voucher applied is either used or not a valid voucher : " + salesOrderMVO1.getVoucherCode() + ". Please recheck.");
	        }
	    }

		// has order frame
		if(matStkId > 0 && fraStkId > 0) {
			hcSetOrdYn = "Y";
			salesOrderMVO2 = orderVO.getSalesOrderMVO2();
			salesOrderMVO2.setAppTypeId(SalesConstants.APP_TYPE_CODE_ID_AUX);
			BigDecimal discRntFee2 = salesOrderMVO2.getDiscRntFee();  // frame rental fee

			// mattress order (mth_rent_amt, def_rent_amt) + frame order(disc_rnt_fee)
			salesOrderMVO1.setMthRentAmt(salesOrderMVO1.getMthRentAmt().add(discRntFee2));
			salesOrderMVO1.setDefRentAmt(salesOrderMVO1.getDefRentAmt().add(discRntFee2));

			// frame order (mth_rent_amt, def_rent_amt) = 0
			salesOrderMVO2.setMthRentAmt(BigDecimal.ZERO);
			salesOrderMVO2.setDefRentAmt(BigDecimal.ZERO);
			salesOrderMVO2.setTotAmt(BigDecimal.ZERO);
			salesOrderMVO2.setTotPv(BigDecimal.ZERO);

			BigDecimal norAmt1 = salesOrderMVO1.getNorAmt(); // mattress NOR_AMT
			norAmt1 = norAmt1 == null ? BigDecimal.ZERO : norAmt1;

			BigDecimal norAmt2 = salesOrderMVO2.getNorAmt(); // frame NOR_AMT
			norAmt2 = norAmt2 == null ? BigDecimal.ZERO : norAmt2;

			// mattress order NOR_AMT + frame order NOR_AMT
			salesOrderMVO1.setNorAmt(norAmt1.add(norAmt2));
			// frame order NOR_AMT = 0
			salesOrderMVO2.setNorAmt(BigDecimal.ZERO);
		}else if(matStkId <= 0 && fraStkId > 0){
		  salesOrderMVO2 = orderVO.getSalesOrderMVO2();
		}

		// Order Copy(Change) -> ordSeqNo = 0
		int ordSeqNo = ("Y".equals(ordChgYn) && matStkId > 0) ? 0 : CommonUtils.intNvl(orderVO.getOrdSeqNo());
		if(ordSeqNo <= 0) {
			ordSeqNo = hcOrderRegisterMapper.getOrdSeqNo();
		}

		// set OrderVO
		orderVO.setBndlId(ordSeqNo);
		orderVO.setHcSetOrdYn(hcSetOrdYn);

		// Mattress register
		if(matStkId > 0) {
			// Mattress register - set OrderVO
			orderVO.setSalesOrderMVO(salesOrderMVO1);
			orderVO.setSalesOrderDVO(orderVO.getSalesOrderDVO1());
			orderVO.setAccClaimAdtVO(orderVO.getAccClaimAdtVO1());
			orderVO.setPreOrdId(orderVO.getMatPreOrdId());
			orderVO.setMatAppTyId(orderVO.getSalesOrderMVO().getAppTypeId());

			orderRegisterService.registerOrder(orderVO, sessionVO);
			matOrdNo = orderVO.getSalesOrderMVO().getSalesOrdNo();
			matOrdId =  CommonUtils.intNvl(orderVO.getSalesOrderMVO().getSalesOrdId());
			if("".equals(matOrdNo)) { // not insert - Mattress order
				throw new ApplicationException(AppConstants.FAIL, "Order Register Failed. - Mattress");
			}

			/*
			 * If got voucher, updated voucher to use state
			 */
			if(CommonUtils.isEmpty(salesOrderMVO1.getVoucherCode()) == false){
				Map<String,Object> voucherParam = new HashMap();
				voucherParam.put("voucherCode", salesOrderMVO1.getVoucherCode());
				voucherParam.put("salesOrdNo", matOrdNo);
				voucherParam.put("updBy", salesOrderMVO1.getUpdUserId());
				voucherParam.put("isUsed", 1);
				voucherMapper.updateVoucherCodeUseStatus(voucherParam);
			}
		}

		// Frame register
		if(fraStkId > 0) {
			// Frame register - set OrderVO
			orderVO.setSalesOrderMVO(salesOrderMVO2);
			orderVO.setSalesOrderDVO(orderVO.getSalesOrderDVO2());
			orderVO.setAccClaimAdtVO(orderVO.getAccClaimAdtVO2());
			orderVO.setPreOrdId(orderVO.getFraPreOrdId());

			orderRegisterService.registerOrder(orderVO, sessionVO);
			fraOrdNo = orderVO.getSalesOrderMVO().getSalesOrdNo();
			if("".equals(fraOrdNo)) { // not insert - frame order
				throw new ApplicationException(AppConstants.FAIL, "Order Register Failed. - Frame");
			}
		}

		// 홈케어 주문관리 테이블 insert - HMC0011D
		HcOrderVO hcOrderVO = new HcOrderVO();

		//String ecommBndlId = null;
		String ecommBndlId = orderVO.getSalesOrderMVO().geteCommBndlId() != null ? orderVO.getSalesOrderMVO().geteCommBndlId().toString() : null;

		int cntHcOrder = hcOrderRegisterMapper.getCountHcPreOrder(ordSeqNo);
		int cntHcExisted = hcOrderRegisterMapper.getCountExistBndlId(ecommBndlId);
		String bndlNo = hcOrderRegisterMapper.getBndlNo(ordSeqNo);

		hcOrderVO.setCustId(custId);                     // 고객번호
		hcOrderVO.setMatOrdNo(matOrdNo);        // Mattress Order No
		hcOrderVO.setFraOrdNo(fraOrdNo);           // Frame Order No
		hcOrderVO.setCrtUserId(sessionVO.getUserId());    // session Id Setting
		hcOrderVO.setUpdUserId(sessionVO.getUserId());  // session Id Setting
		hcOrderVO.setOrdSeqNo(ordSeqNo);
		hcOrderVO.setBndlNo(bndlNo);
		hcOrderVO.setSrvOrdId(matOrdId);
		if(cntHcExisted > 0)
		{
			hcOrderVO.setOrdSeqNo(ordSeqNo);
		}

		// Pre Order 인 경우.
		if(cntHcOrder > 0) {
			rtnCnt = hcOrderRegisterMapper.updateHcPreOrder(hcOrderVO);
		}else if(cntHcExisted > 1)
		{
			int eCommOrdSeq = hcOrderRegisterMapper.getPrevOrdSeq(ecommBndlId);
			hcOrderVO.setOrdSeqNo(eCommOrdSeq);
			rtnCnt = hcOrderRegisterMapper.updateHcPreOrder(hcOrderVO);
		}
		else {
			rtnCnt = hcOrderRegisterMapper.insertHcRegisterOrder(hcOrderVO);
		}

		if(rtnCnt <= 0) { // not insert
			throw new ApplicationException(AppConstants.FAIL, "Order Register Failed.");
		}
		orderVO.setHcOrderVO(hcOrderVO);
	}

	@Override
	public boolean checkProductSize(Map<String, Object> params) {
		String productSize1 = hcOrderRegisterMapper.getProductSize(CommonUtils.nvl(params.get("product1")));
		String productSize2 = hcOrderRegisterMapper.getProductSize(CommonUtils.nvl(params.get("product2")));

		if(CommonUtils.nvl(productSize1).equals(CommonUtils.nvl(productSize2))) {
			return true;
		}

		return false;
	}

	/**
	 * Select Promotion By Frame
	 * @Author KR-SH
	 * @Date 2019. 12. 24.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderRegisterService#selectPromotionByFrame(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectPromotionByFrame(Map<String, Object> params) {
		return hcOrderRegisterMapper.selectPromotionByFrame(params);
	}

	@Override
  public int chkPromoCboMst(Map<String, Object> params) {
    /* CODE              DESCRIPTION
     * ----------------------------------------
     * 1                 IS NORMAL PROMOTION NO RELATED TO COMBO SET
     * 2                 IS MASTER COMBO PACKAGE
     * 3                 HAVE MASTER COMBO ORDER TO MAP
     * 4                 PLEASE CREATE A MASTER COMBP TO MAP
     * 99                SELECTED PROMOTION CODE ARE NOT FOR NEW SALES (FOR CANCELLATION)
     */

    // CHECK SELECTED PROMO. ARE USED FOR CANCELLATION

    int canCnt = hcOrderRegisterMapper.chkPromoCboCan(params);

    if (canCnt == 0) {
        int mstCnt = hcOrderRegisterMapper.chkPromoCboMst(params);

        int subCnt;
        int canMapCnt;
        int qtyHcAcCmbByGrpCnt; // check the homecare aic-con combo by group category
        int cmbGrpMaxQty; // check maximum quantity
        if (mstCnt > 0) {
                // IS MASTER COMBO SELECTION
               // PASS
              return 2;
        } else {
              // MAYBE IS SUB COMBO OR NOT COMBO PACKAGE
              subCnt = hcOrderRegisterMapper.chkPromoCboSub(params);

              if (subCnt > 0) {
                    // IS SUB COMBO
                    // CHECK CUSTOMER HAVE ANY MASTER COMBO

                    canMapCnt = hcOrderRegisterMapper.chkCanMapCnt(params);

                    if (canMapCnt > 0) {
                         // PASS
                          return 3;
                    } else {
                      // FAIL
                      return 4;
                    }
              } else { // IS NORMAL PROMOTION
                // PASS
                return 1;
              }
        }
    } else {
         return 99;
    }
  }

  @Override
  public List<EgovMap> selectHcAcComboOrderJsonList(Map<String, Object> params) {
    List<EgovMap> lst = hcOrderRegisterMapper.selectHcAcComboOrderJsonList(params);
    return lst;
  }

  @Override
  public List<EgovMap> selectHcAcComboOrderJsonList_2(Map<String, Object> params) {
    List<EgovMap> lst = hcOrderRegisterMapper.selectHcAcComboOrderJsonList_2(params);
    return lst;
  }

  @Override
  public int chkQtyCmbOrd(Map<String, Object> params) {
       int qtyHcAcCmbByGrpCnt; // check the homecare aic-con combo by group category
       int cmbGrpMaxQty; // check maximum quantity

      logger.info("[HcOrderRegisterServiceImpl - chkQtyCmbOrd] params :: {} " + params);
      int qtyCmbOrd = hcOrderRegisterMapper.chkQtyCmbOrd(params);
      logger.info("[HcOrderRegisterServiceImpl - chkQtyCmbOrd] qtyCmbOrd :: " + qtyCmbOrd);

      qtyHcAcCmbByGrpCnt = hcOrderRegisterMapper.chkQtyHcAcCmbByGroup(params);
      cmbGrpMaxQty = hcOrderRegisterMapper.chkCmbGrpMaxQty(params);
      logger.info("[HcOrderRegisterServiceImpl - chkQtyCmbOrd] qtyHcAcCmbByGrpCnt :: " + qtyHcAcCmbByGrpCnt);
      logger.info("[HcOrderRegisterServiceImpl - chkQtyCmbOrd] cmbGrpMaxQty :: " + cmbGrpMaxQty);

      if(qtyCmbOrd >= 5){
        return 99;
      }else if(qtyHcAcCmbByGrpCnt == cmbGrpMaxQty){
            logger.info("[HcOrderRegisterServiceImpl - chkQtyCmbOrd] qtyHcAcCmbByGrpCnt == cmbGrpMaxQty!! " );
           return 99;
      }
      return 0;
   }

  @Override
   public List<EgovMap> selectHcAcCmbOrderDtlList(Map<String, Object> params) {
    List<EgovMap> lst = hcOrderRegisterMapper.selectHcAcCmbOrderDtlList(params);
    return lst;
  }

  @Override
  public List<EgovMap> selectPwpOrderNoList(Map<String, Object> params) {
    // TODO ProductCodeList 호출시 error남
    return hcOrderRegisterMapper.selectPwpOrderNoList(params);
  }

  @Override
  public EgovMap checkPwpOrderId(Map<String, Object> params) throws ParseException {

    String msg = "" , mainOrdId = "";
    boolean isPass = false;

    logger.info("!@#### custId:" + (String) params.get("custId"));
    logger.info("!@#### salesOrdNo:" + (String) params.get("salesOrdNo"));

    EgovMap RESULT = new EgovMap();
    EgovMap ordInfo = hcOrderRegisterMapper.selectPwpOrderNoList(params).get(0);

    if (ordInfo != null) {
      if(ordInfo.get("appTypeId").toString().equals("144") || // EDUCATION
    		  ordInfo.get("appTypeId").toString().equals("145") || // FREE TRIAL
    		  ordInfo.get("appTypeId").toString().equals("5764")){ // AUXILIARY
    	  isPass = false;
          msg = "* Education, Free trial and auxiliary are disallowed to register for PWP!";

      }else{
          if(ordInfo.get("stusCodeId").toString().equals("1") || ordInfo.get("stusCodeId").toString().equals("4")){
        	  isPass = true;
        	  mainOrdId = ordInfo.get("salesOrdId").toString();

        	  if(ordInfo.get("stusCodeId").toString().equals("4")){
        		Date now = new Date();

        		if(ordInfo.containsKey("srvExprDt")){
        			Date expDt= new SimpleDateFormat("dd/MM/yyyy").parse(ordInfo.get("srvExprDt").toString());

        			if(now.after(expDt)){
        				isPass = false;
            	        msg = "* Expired or without membership is disallowed to register for PWP!";
        			}

        		} else{
        			isPass = false;
        	        msg = "* Expired or without membership is disallowed to register for PWP!";
        		}
        	  }

          } else{
        	  isPass = false;
              msg = "* Order status not under ACT and COM is disallowed to register for PWP!";
          }
      }
    }else{
    	isPass = false;
    	msg = "* Order Number not found!";
    }

    RESULT.put("Main_Order_Id", mainOrdId);
    RESULT.put("IsPass", isPass);
    RESULT.put("MSG", msg);

    return RESULT;
  }

  @Override
  public List<EgovMap> selectSeda4PromoList(Map<String, Object> params) {
    List<EgovMap> lst = hcOrderRegisterMapper.selectSeda4PromoList(params);
    return lst;
  }

  @Override
  public String selectLastHcAcCmbOrderInfo(Map<String, Object> params){
    String lastCmbOrdId = hcOrderRegisterMapper.getLastHcAcComboOrdId(params);
    params.put("subOrdId", lastCmbOrdId);

    List<EgovMap> lstCmbOrdOriNormalRntFeeList = hcOrderRegisterMapper.selectHcAcCmbOrderDtlList(params);

    String lstOrdOriRntFee = "";
    if(lstCmbOrdOriNormalRntFeeList != null && lstCmbOrdOriNormalRntFeeList.size() > 0){
        for(EgovMap lastOrderOriNorRntFee : lstCmbOrdOriNormalRntFeeList){
          lstOrdOriRntFee = lastOrderOriNorRntFee.get("originalNorRntFee").toString();
        }
    }
    return lstOrdOriRntFee;
  }

  @Override
  public int chkHcAcCmbOrdStus(Map<String, Object> params) {
      int cmbOrdStus = hcOrderRegisterMapper.chkHcAcCmbOrdStus(params);
      return cmbOrdStus;
   }

  @Override
  public int chkSeqGrpAcCmbPromoPerOrd(Map<String, Object> params) {
	 logger.info("[HcOrderRegisterServiceImpl - chkSeqGrpAcCmbPromoPerOrd] params :: {} " + params);

     int chkNextHcAcCmbByPromo;
     int chkSelectedPromotionPerProdCmbGrp;

      // check the current homecare aic-con combo group by promotion
      chkNextHcAcCmbByPromo = hcOrderRegisterMapper.chkNextHcAcComboOrdGrp(params);
      
      // check selected promotion per product combo group
      chkSelectedPromotionPerProdCmbGrp = hcOrderRegisterMapper.chkCmbGrpByPromoIdProd(params);
      
      if(chkSelectedPromotionPerProdCmbGrp > chkNextHcAcCmbByPromo){
    	return 99;
      }
      return 0;
   }

}
