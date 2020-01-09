package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.sales.order.HcOrderModifyService;
import com.coway.trust.biz.sales.order.OrderModifyService;
import com.coway.trust.biz.sales.order.impl.OrderDetailMapper;
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

}
