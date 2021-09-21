package com.coway.trust.web.sales.order;

import java.util.Arrays;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderColorGridService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderColorGridController {

	private static final Logger logger = LoggerFactory.getLogger(OrderColorGridController.class);

	@Resource(name = "orderColorGridService")
	private OrderColorGridService orderColorGridService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Autowired
	private SessionHandler sessionHandler;

	/**
	 * 화면 호출. order Color Grid
	 */
	@RequestMapping(value = "/orderColorGridList.do")
	public String orderColorGridList(@RequestParam Map<String, Object>params, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memType", getUserInfo.get("memType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));

			logger.info("memType ##### " + getUserInfo.get("memType"));
		}

		return "sales/order/orderColorGridList";
	}

	@RequestMapping(value = "/orderColorGridJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderColorGridJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		logger.info("##################### params #####" +params.toString());
		logger.info("##################### cmbCondition #####" +params.get("cmbCondition"));

		String[] cmbAppTypeList = request.getParameterValues("cmbAppType");
		String[] cmbCustomerType = request.getParameterValues("cmbCustomerType"); // Customer Type
		String[] cmbCorpTypeId = request.getParameterValues("cmbCorpTypeId"); // Company Type
		String[] cmbSalesType = request.getParameterValues("cmbSalesType");
		String[] cmbProductCtgry = request.getParameterValues("cmbProductCtgry");

		String[] cmbProduct = request.getParameterValues("cmbProduct");
		String[] cmbCondition = request.getParameterValues("cmbCondition");


		logger.info("Customer type:: " + Arrays.toString(cmbCustomerType));
		logger.info("Company type:: " + Arrays.toString(cmbCorpTypeId));

		if (cmbCustomerType != null) {
			for (int i = 0; i < cmbCustomerType.length; i++) {
				int tmp = Integer.parseInt(cmbCustomerType[i].toString());

				if (tmp == 964) {
					params.put("Individual", "individual");
				}
			}
			params.put("cmbCustomerType", cmbCustomerType);
		} else {
			params.put("cmbCustomerType", "");
		}

		if (params.get("mem_code") != null) {
			String memID = orderColorGridService.getMemID(params.get("mem_code").toString());
			params.put("mem_id", memID);
		}
		else {
			params.put("mem_id", "");
		}

		params.put("cmbAppTypeList", cmbAppTypeList);
		params.put("cmbCorpTypeId", cmbCorpTypeId);
		params.put("cmbSalesType", cmbSalesType);
		params.put("cmbProduct", cmbProduct);
		params.put("cmbCondition", cmbCondition);
		params.put("cmbProductCtgry",cmbProductCtgry);

		List<EgovMap> colorGridList = orderColorGridService.colorGridList(params);

		return ResponseEntity.ok(colorGridList);
	}

	@RequestMapping(value = "/colorGridProductList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> colorGridCmbProduct(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> colorGridProductList = orderColorGridService.colorGridCmbProduct();

		return ResponseEntity.ok(colorGridProductList);
	}
}
