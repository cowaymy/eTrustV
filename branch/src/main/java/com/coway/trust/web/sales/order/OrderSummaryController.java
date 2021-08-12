package com.coway.trust.web.sales.order;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderSummaryService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : OrderSummaryController.java
 * @Description : Order Summary Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 02.   KR-OHK        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/sales/order")
public class OrderSummaryController {

	private static final Logger logger = LoggerFactory.getLogger(OrderSummaryController.class);

	@Autowired
	private OrderSummaryService orderSummaryService;

	@Autowired
	private SalesCommonService salesCommonService;

	@RequestMapping(value = "/orderSummary.do")
	public String orderSummary(@RequestParam Map<String, Object>params, ModelMap model,	SessionVO sessionVO) throws Exception {

		params.put("userId", sessionVO.getUserId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memType", getUserInfo.get("memType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));
		}

		return "sales/order/orderSummary";
	}

	@RequestMapping(value = "/selectOrderSummary", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderSummary(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		String[] cmbAppTypeList = request.getParameterValues("cmbAppType");
		if(cmbAppTypeList    != null && !CommonUtils.containsEmpty(cmbAppTypeList))    params.put("cmbAppTypeList", cmbAppTypeList);

		List<EgovMap> requestList = orderSummaryService.selectOrderSummary(params);

		return ResponseEntity.ok(requestList);
	}
}
