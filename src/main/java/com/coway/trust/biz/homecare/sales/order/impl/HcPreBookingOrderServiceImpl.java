package com.coway.trust.biz.homecare.sales.order.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcPreBookingOrderService;
import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.coway.trust.biz.misc.voucher.impl.VoucherMapper;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.biz.sales.order.impl.PreBookingOrderMapper;
import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants.HC_PRE_ORDER;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcPreOrderServiceImpl.java
 * @Description : Homecare Pre Order ServiceImpl
 */

@Service("hcPreBookingOrderService")
public class HcPreBookingOrderServiceImpl extends EgovAbstractServiceImpl implements HcPreBookingOrderService {

  /*
    @Resource(name = "hcPreBookingOrderMapper")
  	 private HcPreOrderMapper hcPreBookingOrderMapper;

  	@Resource(name = "preBookingOrderMapper")
    private PreBookingOrderMapper preBookingOrderMapper;

  	@Resource(name = "hcOrderRegisterMapper")
  	private HcOrderRegisterMapper hcOrderRegisterMapper;

  	@Resource(name = "orderRegisterMapper")
	   private OrderRegisterMapper orderRegisterMapper;

  	@Resource(name = "voucherMapper")
	   private VoucherMapper voucherMapper;


	 // Search Homecare Pre OrderList
	@Override
	public List<EgovMap> selectHcPreBookingOrderList(Map<String, Object> params) {
		return hcPreBookingOrderMapper.selectHcPreOrderList(params);
	}

	 // Homecare Register Pre Order
	@Override
	public void registerHcPreBookingOrder(PreBookingOrderVO preBookingOrderVO, SessionVO sessionVO) throws ParseException {
		try {
			int matStkId = CommonUtils.intNvl(preBookingOrderVO.getItmStkId1());
			int fraStkId = CommonUtils.intNvl(preBookingOrderVO.getItmStkId2());
			int matPreOrdId = 0;
			int fraPreOrdId = 0;
			int custId = CommonUtils.intNvl(preBookingOrderVO.getCustId());     // Cust Id

			if(custId <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Order Register Failed. - Null Customer ID");
			}

			if(matStkId+fraStkId <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Pre Order Register Failed. - Null Product ID");
			}


			 // Check if the voucher has been used before on sales order
			 // Also check if the voucher has been use before on other e-keyin sales
			if(preBookingOrderVO.getVoucherCode().isEmpty() == false){
				this.checkVoucherValideKeyIn(preBookingOrderVO.getVoucherCode());
			}

			if(matStkId > 0 && fraStkId > 0) {
				BigDecimal discRntFee2 = preBookingOrderVO.getDiscRntFee2();

				// frame rental fee
				// mattress order (mth_rent_amt) + frame order(disc_rnt_fee)
				preBookingOrderVO.setMthRentAmt1(preBookingOrderVO.getMthRentAmt1().add(discRntFee2));
				// frame order (mth_rent_amt) = 0
				preBookingOrderVO.setMthRentAmt2(BigDecimal.ZERO);

				BigDecimal norAmt1 = preBookingOrderVO.getNorAmt1();
				// mattress NOR_AMT
    		norAmt1 = norAmt1 == null ? BigDecimal.ZERO : norAmt1;

				BigDecimal norAmt2 = preBookingOrderVO.getNorAmt2();
				// frame NOR_AMT
				norAmt2 = norAmt2 == null ? BigDecimal.ZERO : norAmt2;

				// mattress order NOR_AMT + frame order NOR_AMT
				preBookingOrderVO.setNorAmt1(norAmt1.add(norAmt2));
				// frame order NOR_AMT = 0
				preBookingOrderVO.setNorAmt2(BigDecimal.ZERO);
			}

			int ordSeqNo = hcOrderRegisterMapper.getOrdSeqNo();

			preBookingOrderVO.setStusId(SalesConstants.STATUS_ACTIVE);
			preBookingOrderVO.setChnnl(SalesConstants.PRE_ORDER_CHANNEL_WEB);
			preBookingOrderVO.setPreTm(CommonUtils.convert24Tm(preBookingOrderVO.getPreTm()));
			preBookingOrderVO.setCrtUserId(sessionVO.getUserId());
			preBookingOrderVO.setUpdUserId(sessionVO.getUserId());
			preBookingOrderVO.setBndlId(ordSeqNo);

			// Mattress register
			if(matStkId > 0) {
    		// Mattress register
			  preBookingOrderVO.setItmStkId(preBookingOrderVO.getItmStkId1());
			  preBookingOrderVO.setItmCompId(preBookingOrderVO.getItmCompId1());
			  preBookingOrderVO.setPromoId(preBookingOrderVO.getPromoId1());
			  preBookingOrderVO.setMthRentAmt(preBookingOrderVO.getMthRentAmt1());
			  preBookingOrderVO.setTotAmt(preBookingOrderVO.getTotAmt1());
			  preBookingOrderVO.setNorAmt(preBookingOrderVO.getNorAmt1());
			  preBookingOrderVO.setDiscRntFee(preBookingOrderVO.getDiscRntFee1());
    		preBookingOrderVO.setTotPv(preBookingOrderVO.getTotPv1());
    		preBookingOrderVO.setTotPvGst(preBookingOrderVO.getTotPvGst1());
    		preBookingOrderVO.setPrcId(preBookingOrderVO.getPrcId1());

    			// 주문등록
    		preBookingOrderMapper.insertPreBookingOrder(preBookingOrderVO);
    			matPreOrdId = preBookingOrderVO.getPreOrdId();
			}

			// Frame register
			if(fraStkId > 0) {
    			// Frame register
			    preBookingOrderVO.setAppTypeId(SalesConstants.APP_TYPE_CODE_ID_AUX);
			    preBookingOrderVO.setItmStkId(preBookingOrderVO.getItmStkId2());
			    preBookingOrderVO.setItmCompId(preBookingOrderVO.getItmCompId2());
			    preBookingOrderVO.setPromoId(preBookingOrderVO.getPromoId2());
			    preBookingOrderVO.setMthRentAmt(preBookingOrderVO.getMthRentAmt2());
			    preBookingOrderVO.setTotAmt(preBookingOrderVO.getTotAmt2());
			    preBookingOrderVO.setNorAmt(preBookingOrderVO.getNorAmt2());
			    preBookingOrderVO.setDiscRntFee(preBookingOrderVO.getDiscRntFee2());
			    preBookingOrderVO.setTotPv(preBookingOrderVO.getTotPv2());
			    preBookingOrderVO.setTotPvGst(preBookingOrderVO.getTotPvGst2());
			    preBookingOrderVO.setPrcId(preBookingOrderVO.getPrcId2());

    			// 주문등록
			    preBookingOrderMapper.insertPreBookingOrder(preBookingOrderVO);
    			fraPreOrdId = preBookingOrderVO.getPreOrdId();
			}

			// HMC0011D
			HcOrderVO hcOrderVO = new HcOrderVO();
			String bndlNo = hcOrderRegisterMapper.getBndlNo(ordSeqNo);

			hcOrderVO.setOrdSeqNo(ordSeqNo);
			hcOrderVO.setCustId(custId);                     // 고객번호
			hcOrderVO.setMatPreOrdId(CommonUtils.intNvl(matPreOrdId));        // Mattress Order No
			hcOrderVO.setFraPreOrdId(CommonUtils.intNvl(fraPreOrdId));           // Frame Order No
			hcOrderVO.setCrtUserId(sessionVO.getUserId());        // session Id Setting
			hcOrderVO.setUpdUserId(sessionVO.getUserId());      // session Id Setting
			hcOrderVO.setStusId(HC_PRE_ORDER.STATUS_ACT);  // Homecare Pre Order Status - Active
			hcOrderVO.setBndlNo(bndlNo);

			int rtnCnt = hcOrderRegisterMapper.insertHcRegisterOrder(hcOrderVO);
			if(rtnCnt <= 0) { // not insert
				throw new ApplicationException(AppConstants.FAIL, "Order Register Failed.");
			}
			preBookingOrderVO.setHcOrderVO(hcOrderVO);

			//Update customer marketing message status(universal between HC/HA)
      Map<String, Object> params1 = new HashMap();
      params1.put("custId",preBookingOrderVO.getCustId());
      params1.put("updUserId", sessionVO.getUserId());
      params1.put("receivingMarketingMsgStatus", preBookingOrderVO.getReceivingMarketingMsgStatus());
      orderRegisterMapper.updateMarketingMessageStatus(params1);

		} catch (Exception e) {
			throw new ApplicationException(AppConstants.FAIL, "Order Register Failed.");
		}
	}

	 // Search Homacare Pre OrderInfo
	@Override
	public EgovMap selectHcPreBookingOrderInfo(Map<String, Object> params) {
		return hcPreBookingOrderMapper.selectHcPreOrderInfo(params);
	}

	 // Homecare Pre Order update
	@Override
	public int updateHcPreBookingOrder(PreBookingOrderVO preBookingOrderVO, SessionVO sessionVO) throws ParseException {
		int rtnCnt = 0;
		Map<String, Object> params = new HashMap<String, Object>();

		try {
			int matStkId = CommonUtils.intNvl(preBookingOrderVO.getItmStkId1());
			int fraStkId = CommonUtils.intNvl(preBookingOrderVO.getItmStkId2());
			int custId = CommonUtils.intNvl(preBookingOrderVO.getCustId());     // Cust Id

			if(custId <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Order Update Failed. - Null Customer ID");
			}

			if(matStkId+fraStkId <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Pre Order Update Failed. - Null Product ID");
			}

			if(preBookingOrderVO.getPreOrdId1() > 0){
			  PreBookingOrderVO newPreOrderVOForVoucher = new PreBookingOrderVO();
				newPreOrderVOForVoucher.setPreOrdId(preBookingOrderVO.getPreOrdId1());
				String existingVoucherCode = preBookingOrderMapper.selectExistingSalesVoucherCode(newPreOrderVOForVoucher);
				String currentVoucherCode = preBookingOrderVO.getVoucherCode();

				 // Check if the voucher has been used before on sales order
				 // Also check if the voucher has been use before on other e-keyin sales
				if(currentVoucherCode.isEmpty() == false){
					if(existingVoucherCode.isEmpty()){
						this.checkVoucherValideKeyIn(currentVoucherCode);
					}
					else{
						if(existingVoucherCode.equals(currentVoucherCode) == false){
							this.checkVoucherValideKeyIn(currentVoucherCode);
						}
					}
				}
			}

			if(matStkId > 0 && fraStkId > 0) {
    			BigDecimal discRntFee2 = preBookingOrderVO.getDiscRntFee2();

    			// frame rental fee
    			// mattress order (mth_rent_amt) + frame order(disc_rnt_fee)
    			preBookingOrderVO.setMthRentAmt1(preBookingOrderVO.getMthRentAmt1().add(discRntFee2));
    			// frame order (mth_rent_amt) = 0
    			preBookingOrderVO.setMthRentAmt2(BigDecimal.ZERO);

    			BigDecimal norAmt1 = preBookingOrderVO.getNorAmt1();
    			// mattress NOR_AMT
    			norAmt1 = norAmt1 == null ? BigDecimal.ZERO : norAmt1;

    			BigDecimal norAmt2 = preBookingOrderVO.getNorAmt2();
    			// frame NOR_AMT
    			norAmt2 = norAmt2 == null ? BigDecimal.ZERO : norAmt2;

    			// mattress order NOR_AMT + frame order NOR_AMT
    			preBookingOrderVO.setNorAmt1(norAmt1.add(norAmt2));
    			// frame order NOR_AMT = 0
    			preBookingOrderVO.setNorAmt2(BigDecimal.ZERO);
    		}

    		preBookingOrderVO.setPreTm(CommonUtils.convert24Tm(preBookingOrderVO.getPreTm()));
    		preBookingOrderVO.setCrtUserId(sessionVO.getUserId());
    		preBookingOrderVO.setUpdUserId(sessionVO.getUserId());

			// Mattress update
			if(matStkId > 0) {
				params.put("preOrdId", preBookingOrderVO.getPreOrdId1());
				params.put("rcdTms", preBookingOrderVO.getRcdTms1());

				rtnCnt = preBookingOrderMapper.selRcdTms(params);
				if(rtnCnt <= 0) {
				  // null to update target
					throw new ApplicationException(AppConstants.FAIL, "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
				}

    			// Mattress update
				  preBookingOrderVO.setPreOrdId(preBookingOrderVO.getPreOrdId1());
				  preBookingOrderVO.setItmStkId(preBookingOrderVO.getItmStkId1());
    			preBookingOrderVO.setItmCompId(preBookingOrderVO.getItmCompId1());
    			preBookingOrderVO.setPromoId(preBookingOrderVO.getPromoId1());
    			preBookingOrderVO.setMthRentAmt(preBookingOrderVO.getMthRentAmt1());
    			preBookingOrderVO.setTotAmt(preBookingOrderVO.getTotAmt1());
    			preBookingOrderVO.setNorAmt(preBookingOrderVO.getNorAmt1());
    			preBookingOrderVO.setDiscRntFee(preBookingOrderVO.getDiscRntFee1());
    			preBookingOrderVO.setTotPv(preBookingOrderVO.getTotPv1());
    			preBookingOrderVO.setTotPvGst(preBookingOrderVO.getTotPvGst1());
    			preBookingOrderVO.setPrcId(preBookingOrderVO.getPrcId1());

    			preBookingOrderMapper.updatePreBookingOrder(preBookingOrderVO);
			}

			// Frame update
			if(fraStkId > 0) {
				int preOrdId2 = CommonUtils.intNvl(preBookingOrderVO.getPreOrdId2());

				if(preOrdId2 > 0) {
				  // has Frame Order - update Frame Order
					params.put("preOrdId", preBookingOrderVO.getPreOrdId2());
					params.put("rcdTms", preBookingOrderVO.getRcdTms2());

					rtnCnt = preBookingOrderMapper.selRcdTms(params);
					if(rtnCnt <= 0) {
					  // null to update target
						throw new ApplicationException(AppConstants.FAIL, "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
					}

	    			// Frame update
					  preBookingOrderVO.setPreOrdId(preBookingOrderVO.getPreOrdId2());
					  preBookingOrderVO.setItmStkId(preBookingOrderVO.getItmStkId2());
					  preBookingOrderVO.setItmCompId(preBookingOrderVO.getItmCompId2());
					  preBookingOrderVO.setPromoId(preBookingOrderVO.getPromoId2());
					  preBookingOrderVO.setMthRentAmt(preBookingOrderVO.getMthRentAmt2());
					  preBookingOrderVO.setTotAmt(preBookingOrderVO.getTotAmt2());
					  preBookingOrderVO.setNorAmt(preBookingOrderVO.getNorAmt2());
					  preBookingOrderVO.setDiscRntFee(preBookingOrderVO.getDiscRntFee2());
					  preBookingOrderVO.setTotPv(preBookingOrderVO.getTotPv2());
					  preBookingOrderVO.setTotPvGst(preBookingOrderVO.getTotPvGst2());
					  preBookingOrderVO.setPrcId(preBookingOrderVO.getPrcId2());

					  preBookingOrderMapper.updatePreBookingOrder(preBookingOrderVO);
				}
			}

			// insert - HMC0011D
			HcOrderVO hcOrderVO = new HcOrderVO();
			hcOrderVO.setCustId(custId);                     // 고객번호
			hcOrderVO.setOrdSeqNo(preBookingOrderVO.getOrdSeqNo());
			hcOrderVO.setMatPreOrdId(CommonUtils.intNvl(preBookingOrderVO.getPreOrdId1()));          // Mattress Order No
			hcOrderVO.setFraPreOrdId(CommonUtils.intNvl(preBookingOrderVO.getPreOrdId2()));           // Frame Order No
			hcOrderVO.setUpdUserId(sessionVO.getUserId());  // session Id Setting

			// Homecare Mapping Table Update
			rtnCnt = hcOrderRegisterMapper.updateHcPreOrder(hcOrderVO);
			if(rtnCnt <= 0) { // not insert
				throw new ApplicationException(AppConstants.FAIL, "Order Update Failed.");
			}
			preBookingOrderVO.setHcOrderVO(hcOrderVO);

	    // Update customer marketing message status(universal between HC/HA)
      Map<String, Object> params1 = new HashMap();
      params1.put("custId",preBookingOrderVO.getCustId());
      params1.put("updUserId", sessionVO.getUserId());
      params1.put("receivingMarketingMsgStatus", preBookingOrderVO.getReceivingMarketingMsgStatus());
      orderRegisterMapper.updateMarketingMessageStatus(params1);

		} catch (Exception e) {
			throw new ApplicationException(AppConstants.FAIL, "Order Update Failed.");
		}

		return rtnCnt;
	}

	 // Homecare Pre Order Status Update
		@Override
	public int updateHcPreBookingOrderStatus(Map<String, Object> params, SessionVO sessionVO) throws ParseException {
		int rtnCnt = 0;
		// HMC0011D
		EgovMap hcPreOrdInfo = selectHcPreBookingOrderInfo(params);
		int anoPreOrdId = CommonUtils.intNvl(hcPreOrdInfo.get("anoPreOrdId"));

		try {
			params.put("updUserId", sessionVO.getUserId());
			params.put("crtUserId", sessionVO.getUserId()); //added by keyi 202206 Multiple remarks

			rtnCnt = hcPreBookingOrderMapper.updateHcPreOrderFailStatus(params);

			if(rtnCnt <= 0) { // not insert
				throw new ApplicationException(AppConstants.FAIL, "Order Status updated Failed.");
			}

			preBookingOrderMapper.InsertPreBookingOrderFailStatus(params);
			// Multiple remarks
			// HMC0011D
			if(anoPreOrdId > 0) {
				params.put("preOrdId", anoPreOrdId);

				rtnCnt = hcPreBookingOrderMapper.updateHcPreOrderFailStatus(params);

				preBookingOrderMapper.InsertPreBookingOrderFailStatus(params); //added by keyi 202206 Multiple remarks

				if(rtnCnt <= 0) { // not insert
					throw new ApplicationException(AppConstants.FAIL, "Order Status updated Failed.");
				}
			}
			// HMC0011D
			HcOrderVO hcOrderVO = new HcOrderVO();
			hcOrderVO.setOrdSeqNo(CommonUtils.intNvl(hcPreOrdInfo.get("ordSeqNo")));
			hcOrderVO.setStusId(CommonUtils.intNvl(params.get("stusId")));
			hcOrderVO.setUpdUserId(sessionVO.getUserId());  // session Id Setting

			// Homecare Mapping Table Update
			rtnCnt = hcOrderRegisterMapper.updateHcPreOrder(hcOrderVO);
			if(rtnCnt <= 0) { // not insert
				throw new ApplicationException(AppConstants.FAIL, "Order Status updated Failed.");
			}

		} catch (Exception e) {
			throw new ApplicationException(AppConstants.FAIL, "Order Status updated Failed.");
		}
		return rtnCnt;
	}

	private void checkVoucherValideKeyIn(String voucherCode)
	{
        Map<String, Object> voucherParams = new HashMap();
        voucherParams.put("voucherCode", voucherCode);
    		int valid = voucherMapper.isVoucherValidToApply(voucherParams);

    		if(valid == 0){
    			throw new ApplicationException(AppConstants.FAIL, "Voucher applied is not a valid voucher");
    		}

    		int eKeyInValid = voucherMapper.isVoucherValidToApplyIneKeyIn(voucherParams);

    		if(eKeyInValid == 0){
    			throw new ApplicationException(AppConstants.FAIL, "Voucher is applied on other e-KeyIn orders");
    		}
	}
	*/
}
