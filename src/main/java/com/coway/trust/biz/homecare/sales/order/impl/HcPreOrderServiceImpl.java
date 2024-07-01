package com.coway.trust.biz.homecare.sales.order.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcPreOrderService;
import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.coway.trust.biz.misc.voucher.impl.VoucherMapper;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.biz.sales.order.impl.PreOrderMapper;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
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
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 18.   KR-SH        First creation
 * </pre>
 */
@Service("hcPreOrderService")
public class HcPreOrderServiceImpl extends EgovAbstractServiceImpl implements HcPreOrderService {

  	@Resource(name = "hcPreOrderMapper")
  	private HcPreOrderMapper hcPreOrderMapper;

  	@Resource(name = "preOrderMapper")
  	private PreOrderMapper preOrderMapper;

  	@Resource(name = "hcOrderRegisterMapper")
  	private HcOrderRegisterMapper hcOrderRegisterMapper;

  	@Resource(name = "orderRegisterMapper")
	private OrderRegisterMapper orderRegisterMapper;

  	@Resource(name = "voucherMapper")
	private VoucherMapper voucherMapper;

	/**
	 * Search Homecare Pre OrderList
	 * @Author KR-SH
	 * @Date 2019. 11. 5.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderListService#selectPreHcOrderList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectHcPreOrderList(Map<String, Object> params) {
		return hcPreOrderMapper.selectHcPreOrderList(params);
	}


	/**
	 * Homecare Register Pre Order
	 * @Author KR-SH
	 * @Date 2019. 11. 5.
	 * @param preOrderVO
	 * @param sessionVO
	 * @throws ParseException
	 * @see com.coway.trust.biz.homecare.sales.order.HcPreOrderService#registerHcPreOrder(com.coway.trust.biz.sales.order.vo.PreOrderVO, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public void registerHcPreOrder(PreOrderVO preOrderVO, SessionVO sessionVO) throws ParseException {
		try {
			int matStkId = CommonUtils.intNvl(preOrderVO.getItmStkId1());
			int fraStkId = CommonUtils.intNvl(preOrderVO.getItmStkId2());
			int matPreOrdId = 0;
			int fraPreOrdId = 0;
			int custId = CommonUtils.intNvl(preOrderVO.getCustId());     // Cust Id

			if(custId <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Order Register Failed. - Null Customer ID");
			}
			// 제품이 둘다 없는 경우.
			if(matStkId+fraStkId <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Pre Order Register Failed. - Null Product ID");
			}

			/*
			 * Check if the voucher has been used before on sales order
			 * Also check if the voucher has been use before on other e-keyin sales
			 */
		    if (CommonUtils.isEmpty(preOrderVO.getVoucherCode()) == false) {
				this.checkVoucherValideKeyIn(preOrderVO.getVoucherCode());
			}

			// 제품이 둘다 있는 경우.
			if(matStkId > 0 && fraStkId > 0) {
				BigDecimal discRntFee2 = preOrderVO.getDiscRntFee2(); // frame rental fee

				// mattress order (mth_rent_amt) + frame order(disc_rnt_fee)
				preOrderVO.setMthRentAmt1(preOrderVO.getMthRentAmt1().add(discRntFee2));
				// frame order (mth_rent_amt) = 0
				preOrderVO.setMthRentAmt2(BigDecimal.ZERO);

				BigDecimal norAmt1 = preOrderVO.getNorAmt1(); // mattress NOR_AMT
    			norAmt1 = norAmt1 == null ? BigDecimal.ZERO : norAmt1;

				BigDecimal norAmt2 = preOrderVO.getNorAmt2(); // frame NOR_AMT
				norAmt2 = norAmt2 == null ? BigDecimal.ZERO : norAmt2;

				// mattress order NOR_AMT + frame order NOR_AMT
				preOrderVO.setNorAmt1(norAmt1.add(norAmt2));
				// frame order NOR_AMT = 0
				preOrderVO.setNorAmt2(BigDecimal.ZERO);
			}

			int ordSeqNo = hcOrderRegisterMapper.getOrdSeqNo();

			preOrderVO.setStusId(SalesConstants.STATUS_ACTIVE);
			preOrderVO.setChnnl(preOrderVO.getChnnl()==2 ? preOrderVO.getChnnl(): SalesConstants.PRE_ORDER_CHANNEL_WEB);
			preOrderVO.setPreTm(CommonUtils.convert24Tm(preOrderVO.getPreTm()));
			preOrderVO.setCrtUserId(sessionVO.getUserId());
			preOrderVO.setUpdUserId(sessionVO.getUserId());
			preOrderVO.setBndlId(ordSeqNo);

			// Mattress register
			if(matStkId > 0) {
    			// Mattress register
    			preOrderVO.setItmStkId(preOrderVO.getItmStkId1());
    			preOrderVO.setItmCompId(preOrderVO.getItmCompId1());
    			preOrderVO.setPromoId(preOrderVO.getPromoId1());
    			preOrderVO.setMthRentAmt(preOrderVO.getMthRentAmt1());
    			preOrderVO.setTotAmt(preOrderVO.getTotAmt1());
    			preOrderVO.setNorAmt(preOrderVO.getNorAmt1());
    			preOrderVO.setDiscRntFee(preOrderVO.getDiscRntFee1());
    			preOrderVO.setTotPv(preOrderVO.getTotPv1());
    			preOrderVO.setTotPvGst(preOrderVO.getTotPvGst1());
    			preOrderVO.setPrcId(preOrderVO.getPrcId1());

    			// 주문등록
    			preOrderMapper.insertPreOrder(preOrderVO);
    			matPreOrdId = preOrderVO.getPreOrdId();
			}

			// Frame register
			if(fraStkId > 0) {
    			// Frame register
				preOrderVO.setAppTypeId(SalesConstants.APP_TYPE_CODE_ID_AUX);
    			preOrderVO.setItmStkId(preOrderVO.getItmStkId2());
    			preOrderVO.setItmCompId(preOrderVO.getItmCompId2());
    			preOrderVO.setPromoId(preOrderVO.getPromoId2());
    			preOrderVO.setMthRentAmt(preOrderVO.getMthRentAmt2());
    			preOrderVO.setTotAmt(preOrderVO.getTotAmt2());
    			preOrderVO.setNorAmt(preOrderVO.getNorAmt2());
    			preOrderVO.setDiscRntFee(preOrderVO.getDiscRntFee2());
    			preOrderVO.setTotPv(preOrderVO.getTotPv2());
    			preOrderVO.setTotPvGst(preOrderVO.getTotPvGst2());
    			preOrderVO.setPrcId(preOrderVO.getPrcId2());

    			// 주문등록
    			preOrderMapper.insertPreOrder(preOrderVO);
    			fraPreOrdId = preOrderVO.getPreOrdId();
			}

			// 홈케어 주문관리 테이블 insert - HMC0011D
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
			preOrderVO.setHcOrderVO(hcOrderVO);

			//Update customer marketing message status(universal between HC/HA)
	        Map<String, Object> params1 = new HashMap();
	        params1.put("custId",preOrderVO.getCustId());
	        params1.put("updUserId", sessionVO.getUserId());
	        params1.put("receivingMarketingMsgStatus", preOrderVO.getReceivingMarketingMsgStatus());
	        orderRegisterMapper.updateMarketingMessageStatus(params1);

		} catch (Exception e) {
			throw new ApplicationException(AppConstants.FAIL, "Order Register Failed.");
		}
	}

	/**
	 * Search Homacare Pre OrderInfo
	 * @Author KR-SH
	 * @Date 2019. 10. 24.
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectHcPreOrderInfo(Map<String, Object> params) {
		return hcPreOrderMapper.selectHcPreOrderInfo(params);
	}


	/**
	 * Homecare Pre Order update
	 * @Author KR-SH
	 * @Date 2019. 11. 7.
	 * @param preOrderVO
	 * @param sessionVO
	 * @return
	 * @throws ParseException
	 * @see com.coway.trust.biz.homecare.sales.order.HcPreOrderService#registerHcPreOrder(com.coway.trust.biz.sales.order.vo.PreOrderVO, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public int updateHcPreOrder(PreOrderVO preOrderVO, SessionVO sessionVO) throws ParseException {
		int rtnCnt = 0;
		Map<String, Object> params = new HashMap<String, Object>();
		try {
			int matStkId = CommonUtils.intNvl(preOrderVO.getItmStkId1());
			int fraStkId = CommonUtils.intNvl(preOrderVO.getItmStkId2());
			int custId = CommonUtils.intNvl(preOrderVO.getCustId());     // Cust Id

			if(custId <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Order Update Failed. - Null Customer ID");
			}
			// 제품이 둘다 없는 경우.
			if(matStkId+fraStkId <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Pre Order Update Failed. - Null Product ID");
			}

			if(preOrderVO.getPreOrdId1() > 0){
				PreOrderVO newPreOrderVOForVoucher = new PreOrderVO();
				newPreOrderVOForVoucher.setPreOrdId(preOrderVO.getPreOrdId1());
				String existingVoucherCode = CommonUtils.nvl(preOrderMapper.selectExistingSalesVoucherCode(newPreOrderVOForVoucher));
				String currentVoucherCode = CommonUtils.nvl(preOrderVO.getVoucherCode());
				/*
				 * Check if the voucher has been used before on sales order
				 * Also check if the voucher has been use before on other e-keyin sales
				 */

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

			// 제품이 둘다 있는 경우.
    		if(matStkId > 0 && fraStkId > 0) {
    			BigDecimal discRntFee2 = preOrderVO.getDiscRntFee2(); // frame rental fee

    			// mattress order (mth_rent_amt) + frame order(disc_rnt_fee)
    			preOrderVO.setMthRentAmt1(preOrderVO.getMthRentAmt1().add(discRntFee2));
    			// frame order (mth_rent_amt) = 0
    			preOrderVO.setMthRentAmt2(BigDecimal.ZERO);

    			BigDecimal norAmt1 = preOrderVO.getNorAmt1(); // mattress NOR_AMT
    			norAmt1 = norAmt1 == null ? BigDecimal.ZERO : norAmt1;

    			BigDecimal norAmt2 = preOrderVO.getNorAmt2(); // frame NOR_AMT
    			norAmt2 = norAmt2 == null ? BigDecimal.ZERO : norAmt2;

    			// mattress order NOR_AMT + frame order NOR_AMT
    			preOrderVO.setNorAmt1(norAmt1.add(norAmt2));
    			// frame order NOR_AMT = 0
    			preOrderVO.setNorAmt2(BigDecimal.ZERO);
    		}

			//preOrderVO.setStusId(SalesConstants.STATUS_ACTIVE);
			//preOrderVO.setChnnl(SalesConstants.PRE_ORDER_CHANNEL_WEB);
			preOrderVO.setPreTm(CommonUtils.convert24Tm(preOrderVO.getPreTm()));
			preOrderVO.setCrtUserId(sessionVO.getUserId());
			preOrderVO.setUpdUserId(sessionVO.getUserId());

			// Mattress update
			if(matStkId > 0) {
				params.put("preOrdId", preOrderVO.getPreOrdId1());
				params.put("rcdTms", preOrderVO.getRcdTms1());

				rtnCnt = preOrderMapper.selRcdTms(params);
				if(rtnCnt <= 0) { // null to update target
					throw new ApplicationException(AppConstants.FAIL, "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
				}

    			// Mattress update
				preOrderVO.setPreOrdId(preOrderVO.getPreOrdId1());
    			preOrderVO.setItmStkId(preOrderVO.getItmStkId1());
    			preOrderVO.setItmCompId(preOrderVO.getItmCompId1());
    			preOrderVO.setPromoId(preOrderVO.getPromoId1());
    			preOrderVO.setMthRentAmt(preOrderVO.getMthRentAmt1());
    			preOrderVO.setTotAmt(preOrderVO.getTotAmt1());
    			preOrderVO.setNorAmt(preOrderVO.getNorAmt1());
    			preOrderVO.setDiscRntFee(preOrderVO.getDiscRntFee1());
    			preOrderVO.setTotPv(preOrderVO.getTotPv1());
    			preOrderVO.setTotPvGst(preOrderVO.getTotPvGst1());
    			preOrderVO.setPrcId(preOrderVO.getPrcId1());

    			// 주문수정
    			preOrderMapper.updatePreOrder(preOrderVO);
			}

			// Frame update
			if(fraStkId > 0) {
				int preOrdId2 = CommonUtils.intNvl(preOrderVO.getPreOrdId2());

				if(preOrdId2 > 0) {  // has Frame Order - update Frame Order
					params.put("preOrdId", preOrderVO.getPreOrdId2());
					params.put("rcdTms", preOrderVO.getRcdTms2());

					rtnCnt = preOrderMapper.selRcdTms(params);
					if(rtnCnt <= 0) { // null to update target
						throw new ApplicationException(AppConstants.FAIL, "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
					}

	    			// Frame update
					preOrderVO.setPreOrdId(preOrderVO.getPreOrdId2());
	    			preOrderVO.setItmStkId(preOrderVO.getItmStkId2());
	    			preOrderVO.setItmCompId(preOrderVO.getItmCompId2());
	    			preOrderVO.setPromoId(preOrderVO.getPromoId2());
	    			preOrderVO.setMthRentAmt(preOrderVO.getMthRentAmt2());
	    			preOrderVO.setTotAmt(preOrderVO.getTotAmt2());
	    			preOrderVO.setNorAmt(preOrderVO.getNorAmt2());
	    			preOrderVO.setDiscRntFee(preOrderVO.getDiscRntFee2());
	    			preOrderVO.setTotPv(preOrderVO.getTotPv2());
	    			preOrderVO.setTotPvGst(preOrderVO.getTotPvGst2());
	    			preOrderVO.setPrcId(preOrderVO.getPrcId2());

	    			// 주문수정
	    			preOrderMapper.updatePreOrder(preOrderVO);
				}
			}

			// 홈케어 주문관리 테이블 insert - HMC0011D
			HcOrderVO hcOrderVO = new HcOrderVO();
			hcOrderVO.setCustId(custId);                     // 고객번호
			hcOrderVO.setOrdSeqNo(preOrderVO.getOrdSeqNo());
			hcOrderVO.setMatPreOrdId(CommonUtils.intNvl(preOrderVO.getPreOrdId1()));          // Mattress Order No
			hcOrderVO.setFraPreOrdId(CommonUtils.intNvl(preOrderVO.getPreOrdId2()));           // Frame Order No
			hcOrderVO.setUpdUserId(sessionVO.getUserId());  // session Id Setting

			// Homecare Mapping Table Update
			rtnCnt = hcOrderRegisterMapper.updateHcPreOrder(hcOrderVO);
			if(rtnCnt <= 0) { // not insert
				throw new ApplicationException(AppConstants.FAIL, "Order Update Failed.");
			}
			preOrderVO.setHcOrderVO(hcOrderVO);

			//Update customer marketing message status(universal between HC/HA)
	        Map<String, Object> params1 = new HashMap();
	        params1.put("custId",preOrderVO.getCustId());
	        params1.put("updUserId", sessionVO.getUserId());
	        params1.put("receivingMarketingMsgStatus", preOrderVO.getReceivingMarketingMsgStatus());
	        orderRegisterMapper.updateMarketingMessageStatus(params1);

		} catch (Exception e) {
			throw new ApplicationException(AppConstants.FAIL, "Order Update Failed.");
		}

		return rtnCnt;
	}


	/**
	 * Homecare Pre Order Status Update
	 * @Author KR-SH
	 * @Date 2019. 11. 11.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws ParseException
	 * @see com.coway.trust.biz.homecare.sales.order.HcPreOrderService#updateHcPreOrderStatus(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public int updateHcPreOrderStatus(Map<String, Object> params, SessionVO sessionVO) throws ParseException {
		int rtnCnt = 0;
		// 매핑테이블 조회. - HMC0011D
		EgovMap hcPreOrdInfo = selectHcPreOrderInfo(params);
		int anoPreOrdId = CommonUtils.intNvl(hcPreOrdInfo.get("anoPreOrdId"));

		try {
			params.put("updUserId", sessionVO.getUserId());
			params.put("crtUserId", sessionVO.getUserId()); //added by keyi 202206 Multiple remarks

			rtnCnt = hcPreOrderMapper.updateHcPreOrderFailStatus(params);

			if(rtnCnt <= 0) { // not insert
				throw new ApplicationException(AppConstants.FAIL, "Order Status updated Failed.");
			}

			preOrderMapper.InsertPreOrderFailStatus(params); //added by keyi 202206 Multiple remarks

			// HMC0011D에 다른 주문이 있는 경우.
			if(anoPreOrdId > 0) {
				params.put("preOrdId", anoPreOrdId);

				rtnCnt = hcPreOrderMapper.updateHcPreOrderFailStatus(params);

				preOrderMapper.InsertPreOrderFailStatus(params); //added by keyi 202206 Multiple remarks

				if(rtnCnt <= 0) { // not insert
					throw new ApplicationException(AppConstants.FAIL, "Order Status updated Failed.");
				}
			}
			// 홈케어 주문관리 테이블 insert - HMC0011D
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
}
