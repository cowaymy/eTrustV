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
		
		EgovMap getUserInfo = salesCommonService.getUserInfo(params);
		if(getUserInfo != null){
			if("1".equals(getUserInfo.get("memType")) || "2".equals(getUserInfo.get("memType"))){
				model.put("memType", getUserInfo.get("memType"));
				model.put("orgCode", getUserInfo.get("lastOrgCode"));
				model.put("grpCode", getUserInfo.get("lastGrpCode"));
				model.put("deptCode", getUserInfo.get("lastDeptCode"));
			}
		}
		
		return "sales/order/orderColorGridList";
	}
	
	@RequestMapping(value = "/orderColorGridJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderColorGridJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		logger.info("##################### params #####" +params.toString());
		logger.info("##################### cmbCondition #####" +params.get("cmbCondition"));
		
		String[] cmbAppTypeList = request.getParameterValues("cmbAppType");
		params.put("cmbAppTypeList", cmbAppTypeList);
		
		List<EgovMap> colorGridList = orderColorGridService.colorGridList(params);
		
		return ResponseEntity.ok(colorGridList);
	}
}
