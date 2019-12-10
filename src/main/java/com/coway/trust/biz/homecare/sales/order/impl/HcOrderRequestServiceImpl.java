package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcOrderRequestService;
import com.coway.trust.biz.sales.order.OrderRequestService;
import com.coway.trust.biz.sales.order.impl.OrderRequestMapper;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @ClassName : HcOrderRequestServiceImpl.java
 * @Description : Homecare Order Request ServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 28.   KR-SH        First creation
 * </pre>
 */
@Service("hcOrderRequestService")
public class HcOrderRequestServiceImpl extends EgovAbstractServiceImpl implements HcOrderRequestService {

	@Resource(name = "orderRequestService")
	private OrderRequestService orderRequestService;

	@Resource(name = "orderRequestMapper")
	private OrderRequestMapper orderRequestMapper;


	/**
	 * Request Cancel Order
	 * @Author KR-SH
	 * @Date 2019. 10. 28.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderRequestService#hcRequestCancelOrder(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public ReturnMessage hcRequestCancelOrder(Map<String, Object> params, SessionVO sessionVO) throws Exception {
		// 대상주문을 취소요청 한다.
		ReturnMessage rtnMsg = orderRequestService.requestCancelOrder(params, sessionVO);

		// 같이 주문된 주문 건이 있는경우 취소한다.
		String salesAnoOrdId = CommonUtils.nvl(params.get("salesAnoOrdId"));
		String salesOrdCtgryCd = CommonUtils.nvl(params.get("salesOrdCtgryCd"));

		// Mattress 주문이면서 같이 주문된 주문이 있는 경우.
		if("MAT".equals(salesOrdCtgryCd) && CommonUtils.isNotEmpty(salesAnoOrdId)) {
			// 유효성 체크
			params.put("salesOrdId", salesAnoOrdId);
			ReturnMessage rtnVaild = validOCRStus(params);

			if(rtnVaild.equals(AppConstants.SUCCESS)) {
				String rtnMessage = CommonUtils.nvl(rtnMsg.getMessage());
				// 같이 주문된 주문 취소요청한다.
				orderRequestService.requestCancelOrder(params, sessionVO);

				rtnMessage = rtnMessage.replaceFirst("<br/>", ", "+ CommonUtils.nvl(params.get("rtnOrderNo") +"<br/>"));
				rtnMessage = CommonUtils.replaceLast(rtnMessage, "<br/>", ", "+ CommonUtils.nvl(params.get("rtnReqNo") +"<br/>"));
				rtnMsg.setMessage(rtnMessage);
			}
		}

		return rtnMsg;
	}


	/**
	 * Request Check Validation
	 * @Author KR-SH
	 * @Date 2019. 12. 4.
	 * @param params
	 * @return
	 * @throws Exception
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderRequestService#validOCRStus(java.util.Map)
	 */
	@Override
	public ReturnMessage validOCRStus(Map<String, Object> params) throws Exception {
		ReturnMessage message = new ReturnMessage();
		int callLogResult = 0;
		String strMsg = "This order [$3] is<br />under progress [$1].<br />OCR is not allowed due to $2 Status still [ACTIVE].<br/>";
		String salesOrdNo = CommonUtils.nvl(params.get("salesOrdNo"));

	    callLogResult = orderRequestMapper.validOCRStus(params);
	    if (callLogResult > 0) {
	    	message.setCode(AppConstants.FAIL);
	      	message.setMessage(strMsg.replace("$1", "Call for Install").replace("$2", "Installation").replace("$3", salesOrdNo));

	      	return message;
	    }

	    callLogResult = orderRequestMapper.validOCRStus2(params);
	    if (callLogResult > 0) {
	    	message.setCode(AppConstants.FAIL);
	    	message.setMessage(strMsg.replace("$1", "Call for Install").replace("$2", "Order").replace("$3", salesOrdNo));

	    	return message;
	    }

	    callLogResult = orderRequestMapper.validOCRStus3(params);
	    if (callLogResult > 0) {
	    	message.setCode(AppConstants.FAIL);
	    	message.setMessage(strMsg.replace("$1", "Call for Cancel").replace("$2", "Cancellation").replace("$3", salesOrdNo));

	    	return message;
	    }

	    callLogResult = orderRequestMapper.validOCRStus4(params);
	    if (callLogResult > 0) {
	    	message.setCode(AppConstants.FAIL);
	    	message.setMessage(strMsg.replace("$1", "Confirm To Cancel").replace("$2", "Cancellation").replace("$3", salesOrdNo));

	    	return message;
	    }

	    message.setCode(AppConstants.SUCCESS);
		return message;
	}

}
