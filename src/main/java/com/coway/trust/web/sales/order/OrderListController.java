/**
 * 
 */
package com.coway.trust.web.sales.order;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/order")
public class OrderListController {

	private static Logger logger = LoggerFactory.getLogger(OrderListController.class);
	
	@Resource(name = "orderListService")
	private OrderListService orderListService;
	
	@RequestMapping(value = "/orderList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		
		model.put("bfDay", bfDay);
		model.put("toDay", toDay);
		
		return "sales/order/orderList";
	}
	
	@RequestMapping(value = "/selectOrderJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		String[] arrAppType   = request.getParameterValues("appType"); //Application Type
		String[] arrOrdStusId = request.getParameterValues("ordStusId"); //Order Status 
		String[] arrKeyinBrnchId = request.getParameterValues("keyinBrnchId"); //Key-In Branch
		String[] arrDscBrnchId = request.getParameterValues("dscBrnchId"); //DSC Branch 
		String[] arrRentStus = request.getParameterValues("rentStus"); //Rent Status

		if(StringUtils.isEmpty(params.get("ordStartDt"))) params.put("ordStartDt", "01/01/1900");
    	if(StringUtils.isEmpty(params.get("ordEndDt")))   params.put("ordEndDt",   "31/12/9999");
    	
    	params.put("ordStartDt", CommonUtils.changeFormat(String.valueOf(params.get("ordStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    	params.put("ordEndDt", CommonUtils.changeFormat(String.valueOf(params.get("ordEndDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
		
		if(arrAppType      != null && !CommonUtils.containsEmpty(arrAppType))      params.put("arrAppType", arrAppType);
		if(arrOrdStusId    != null && !CommonUtils.containsEmpty(arrOrdStusId))    params.put("arrOrdStusId", arrOrdStusId);
		if(arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrDscBrnchId   != null && !CommonUtils.containsEmpty(arrDscBrnchId))   params.put("arrDscBrnchId", arrDscBrnchId);
		if(arrRentStus     != null && !CommonUtils.containsEmpty(arrRentStus))     params.put("arrRentStus", arrRentStus);
		
		if(params.get("custIc") == null) {logger.debug("!@###### custIc is null");}
		if("".equals(params.get("custIc"))) {logger.debug("!@###### custIc ''");}
		
		logger.debug("!@##############################################################################");
		logger.debug("!@###### ordNo : "+params.get("ordNo"));
		logger.debug("!@###### ordStartDt : "+params.get("ordStartDt"));
		logger.debug("!@###### ordEndDt : "+params.get("ordEndDt"));
		logger.debug("!@###### ordDt : "+params.get("ordDt"));
		logger.debug("!@###### custIc : "+params.get("custIc"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> orderList = orderListService.selectOrderList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orderList);
	}
	
	@RequestMapping(value = "/orderRentToOutrSimulPop.do")
	public String orderRentToOutrSimulPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		model.put("ordNo", params.get("ordNo"));
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT3));
		
		return "sales/order/orderRentToOutrSimulPop";
	}
	
	@RequestMapping(value="/orderRentalPaySettingUpdateListPop.do")
	public String orderRentalPaySettingUpdateListPop(){
		
		return "sales/order/orderRentalPaySettingUpdateListPop";
	}
	
	@RequestMapping(value="/orderSOFListPop.do")
	public String orderSOFListPop(){
		
		return "sales/order/orderSOFListPop";
	}
	
	@RequestMapping(value="/getApplicationTypeList")
	public ResponseEntity<List<EgovMap>> getApplicationTypeList(@RequestParam Map<String, Object> params) throws Exception{
	
		List<EgovMap> applicationTypeList = null;
		applicationTypeList = orderListService.getApplicationTypeList(params);
	
		return ResponseEntity.ok(applicationTypeList);	
	}
	
	@RequestMapping(value="/getUserCodeList")
	public ResponseEntity<List<EgovMap>> getUserCodeList() throws Exception{
	
		List<EgovMap> userCodeList = null;
		userCodeList = orderListService.getUserCodeList();
		
		return ResponseEntity.ok(userCodeList);
	}
	
	@RequestMapping(value="/orderDDCRCListPop.do")
	public String orderDDCRCListPop(){
		
		return "sales/order/orderDDCRCListPop";
	}
	
	@RequestMapping(value="/orderASOSalesReportPop.do")
	public String orderASOSalesReportPop(){
		
		return "sales/order/orderASOSalesReportPop";
	}
	
	@RequestMapping(value="/orderSalesYSListingPop.do")
	public String orderSalesYSListingPop(){
		
		return "sales/order/orderSalesYSListingPop";
	}
	
	@RequestMapping(value="/getOrgCodeList")
	public ResponseEntity<List<EgovMap>> getOrgCodeList(@RequestParam Map<String, Object> params) throws Exception{
	
		List<EgovMap> orgCodeList = null;
		orgCodeList = orderListService.getOrgCodeList(params);
		
		return ResponseEntity.ok(orgCodeList);
	}
	
	@RequestMapping(value="/getGrpCodeList")
	public ResponseEntity<List<EgovMap>> getGrpCodeList(@RequestParam Map<String, Object> params) throws Exception{
	
		List<EgovMap> grpCodeList = null;
		grpCodeList = orderListService.getGrpCodeList(params);
		
		return ResponseEntity.ok(grpCodeList);
	}
}
