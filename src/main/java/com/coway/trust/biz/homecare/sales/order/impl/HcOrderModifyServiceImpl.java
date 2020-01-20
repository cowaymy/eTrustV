package com.coway.trust.biz.homecare.sales.order.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.sales.order.HcOrderModifyService;
import com.coway.trust.biz.sales.order.OrderModifyService;
import com.coway.trust.biz.sales.order.impl.OrderDetailMapper;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderModifyServiceImpl.java
 * @Description : Homecare Order Modify ServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2020. 1. 9.   KR-SH        First creation
 * </pre>
 */
@Service("hcOrderModifyService")
public class HcOrderModifyServiceImpl extends EgovAbstractServiceImpl implements HcOrderModifyService {

	@Resource(name = "orderModifyService")
	private OrderModifyService orderModifyService;

	@Resource(name = "orderDetailMapper")
	private OrderDetailMapper orderDetailMapper;

	@Resource(name = "hcOrderListService")
	private HcOrderListService hcOrderListService;

	@Resource(name = "hcOrderModifyMapper")
	private HcOrderModifyMapper hcOrderModifyMapper;

	/**
	 * Homecare Order Modify - Install Info
	 * @Author KR-SH
	 * @Date 2020. 1. 9.
	 * @param params
	 * @return
	 * @throws Exception
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderModifyService#updateHcInstallInfo(java.util.Map)
	 */
	@Override
	public ReturnMessage updateHcInstallInfo(Map<String, Object> params, SessionVO sessionVO) throws Exception {
		String rtnMsg = "Order Number : " + CommonUtils.nvl(params.get("salesOrdNo"));

		// update - Mattress Install Info
		orderModifyService.updateInstallInfo(params, sessionVO);

		params.put("srvOrdId", CommonUtils.nvl(params.get("salesOrdId")));  // set - Mattress Order Id

		EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);
		String fraOrdId = CommonUtils.nvl(hcOrder.get("anoOrdId"));  // get - Frame Order Id

		// has Frame Order
		if(!"".equals(fraOrdId)) {
			params.put("salesOrderId", fraOrdId);  // set - Frame Order Id
			params.put("salesOrdId", fraOrdId);  // set - Frame Order Id
		    EgovMap instMap = orderDetailMapper.selectOrderInstallationInfoByOrderID(params);

		    params.put("installId", CommonUtils.nvl(instMap.get("installId"))); // set - Frame Install Id

		    // update - Frame Install Info
			orderModifyService.updateInstallInfo(params, sessionVO);
			rtnMsg += ", " + CommonUtils.nvl(hcOrder.get("fraOrdNo"));
		}

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(rtnMsg + "</br>Information successfully updated.");

		return message;
	}

	/**
	 * Homecare Order Modify - Promotion
	 * @Author KR-SH
	 * @Date 2020. 1. 15.
	 * @param salesOrderMVO
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderModifyService#updateHcPromoPriceInfo(com.coway.trust.biz.sales.order.vo.SalesOrderMVO, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public ReturnMessage updateHcPromoPriceInfo(SalesOrderMVO salesOrderMVO, SessionVO sessionVO) throws Exception {
		int rtnCnt = 0;
		int salesOrdId = CommonUtils.intNvl(salesOrderMVO.getSalesOrdId());  // Mattress Order ID
		if(salesOrdId <= 0) {
			throw new ApplicationException(AppConstants.FAIL, "Order Modify Failed. - Null Order ID");
		}

		Map<String, Object> params = new HashMap<String, Object>();
		String rtnMsg = "Order Number : " + CommonUtils.nvl(salesOrderMVO.getSalesOrdNo());

		salesOrderMVO.setUpdUserId(sessionVO.getUserId());

		params.put("srvOrdId", salesOrdId);  // set - Mattress Order Id
		// Homecare Order Info
		EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);
		int fraOrdId = CommonUtils.intNvl(hcOrder.get("anoOrdId"));  // get - Frame Order Id

		if(fraOrdId > 0) {
			/*- 메인오더 : mth_rent_amt, def_rent_amt 에  + aux오더의 disc_rnt_fee
			 - aux오더 : mth_rent_amt, def_rent_amt = 0 으로 변경*/
			Map<String, Object> order2params = new HashMap<String, Object>();
			order2params.put("salesOrdId", fraOrdId);

			EgovMap salesOrder2 = this.select_SAL0001D(order2params);
			BigDecimal discRntFee = new BigDecimal(CommonUtils.nvl(salesOrder2.get("discRntFee")));  // frame rental fee

			// mattress order (mth_rent_amt, def_rent_amt) + frame order(disc_rnt_fee)
			salesOrderMVO.setMthRentAmt(salesOrderMVO.getMthRentAmt().add(discRntFee));
			salesOrderMVO.setDefRentAmt(salesOrderMVO.getDefRentAmt().add(discRntFee));

			BigDecimal norAmt = new BigDecimal(CommonUtils.nvl(salesOrder2.get("norAmt")));  // frame NOR_AMT
			// mattress order NOR_AMT + frame order NOR_AMT
			salesOrderMVO.setNorAmt(salesOrderMVO.getNorAmt().add(norAmt));

			SalesOrderMVO salesOrderMVO2 = new SalesOrderMVO();

			salesOrderMVO2.setPromoId(salesOrderMVO.getPromoId());
			salesOrderMVO2.setTotAmt(new BigDecimal(CommonUtils.nvl(salesOrder2.get("totAmt"))));
			salesOrderMVO2.setTotPv(new BigDecimal(CommonUtils.nvl(salesOrder2.get("totPv"))));
			salesOrderMVO2.setUpdUserId(sessionVO.getUserId());
			salesOrderMVO2.setPromoDiscPeriodTp(CommonUtils.intNvl(salesOrder2.get("promoDiscPeriodTp")));
			salesOrderMVO2.setPromoDiscPeriod(CommonUtils.intNvl(salesOrder2.get("promoDiscPeriod")));
			salesOrderMVO2.setDiscRntFee(discRntFee);
			salesOrderMVO2.setSalesOrdId(fraOrdId);
			// frame order (mth_rent_amt, def_rent_amt) = 0
			salesOrderMVO2.setMthRentAmt(BigDecimal.ZERO);
			salesOrderMVO2.setDefRentAmt(BigDecimal.ZERO);
			// frame order NOR_AMT = 0
    		salesOrderMVO2.setNorAmt(BigDecimal.ZERO);

			// update - Frame Promotion
			rtnCnt = hcOrderModifyMapper.updateHcPromoPriceInfo(salesOrderMVO2);
			if(rtnCnt <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Promotion(Frame) updated Failed.");
			}
		    rtnMsg += ", " + CommonUtils.nvl(hcOrder.get("fraOrdNo"));
		}

		// update - Mattress Promotion
		rtnCnt = hcOrderModifyMapper.updateHcPromoPriceInfo(salesOrderMVO);
		if(rtnCnt <= 0) {
			throw new ApplicationException(AppConstants.FAIL, "Promotion(Mattress) updated Failed.");
		}

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(rtnMsg + "</br>Promotion successfully updated.");

		return message;
	}

	/**
	 * select Order Marster (SAL0001D)
	 * @Author KR-SH
	 * @Date 2020. 1. 15.
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap select_SAL0001D(Map<String, Object> params) {
		return hcOrderModifyMapper.select_SAL0001D(params);
	}

}
