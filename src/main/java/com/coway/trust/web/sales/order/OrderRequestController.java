/**
 * 
 */
package com.coway.trust.web.sales.order;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderLedgerService;
import com.coway.trust.biz.sales.order.OrderRequestService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/order")
public class OrderRequestController {

	private static Logger logger = LoggerFactory.getLogger(OrderRequestController.class);
	
	@Resource(name = "orderRequestService")
	private OrderRequestService orderRequestService;
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "orderLedgerService")
	private OrderLedgerService orderLedgerService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@RequestMapping(value = "/orderRequestPop.do")
	public String orderRequestPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {
		
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);//APP_TYPE_ID CUST_ID

		model.put("orderDetail", orderDetail);
		model.put("ordReqType",  params.get("ordReqType"));
		model.put("toDay", 		 CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		
		model.put("toDay", toDay);
		
		return "sales/order/orderRequestPop";
	}

    @RequestMapping(value = "/selectResnCodeList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectResnCodeList(@RequestParam Map<String, Object> params)    {
    	List<EgovMap> rsltList = orderRequestService.selectResnCodeList(params);
    	return ResponseEntity.ok(rsltList);
    }

    @RequestMapping(value = "/selectOrderLastRentalBillLedger1.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectOrderLastRentalBillLedger1(@RequestParam Map<String, Object> params)    {
    	EgovMap rslt = orderRequestService.selectOrderLastRentalBillLedger1(params);
    	return ResponseEntity.ok(rslt);
    }
    
	@RequestMapping(value = "/requestCancelOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> requestCancelOrder(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		
		ReturnMessage message = orderRequestService.requestCancelOrder(params, sessionVO);

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/requestProdExch.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> requestProdExch(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		
		ReturnMessage message = orderRequestService.requestProductExchange(params, sessionVO);

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/requestSchmConv.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> requestSchmConv(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		
		ReturnMessage message = orderRequestService.requestSchmConv(params, sessionVO);

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/requestAppExch.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> requestAppExch(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		
		ReturnMessage message = orderRequestService.requestApplicationExchange(params, sessionVO);

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/requestOwnershipTransfer.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> requestOwnershipTransfer(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		
		ReturnMessage message = orderRequestService.requestOwnershipTransfer(params, sessionVO);

		return ResponseEntity.ok(message);
	}
	
    @RequestMapping(value = "/selectCompleteASIDByOrderIDSolutionReason.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectCompleteASIDByOrderIDSolutionReason(@RequestParam Map<String, Object> params)    {
    	EgovMap rslt = orderRequestService.selectCompleteASIDByOrderIDSolutionReason(params);
    	return ResponseEntity.ok(rslt);
    }
    
	@RequestMapping(value = "/loginUserId.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> loginUserId(SessionVO sessionVO) throws Exception {

		EgovMap map = new EgovMap();
		
		map.put("userId", sessionVO.getUserId());
		
		return ResponseEntity.ok(map);
	}
	
    @RequestMapping(value = "/selectSalesOrderSchemeList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectSalesOrderSchemeList(@RequestParam Map<String, Object> params)    {
    	List<EgovMap> rsltList = orderRequestService.selectSalesOrderSchemeList(params);
    	return ResponseEntity.ok(rsltList);
    }

    @RequestMapping(value = "/selectSchemePriceSettingByPromoCode.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectSchemePriceSettingByPromoCode(@RequestParam Map<String, Object> params)    {
    	EgovMap rslt = orderRequestService.selectSchemePriceSettingByPromoCode(params);
    	return ResponseEntity.ok(rslt);
    }

    @RequestMapping(value = "/selectSchemePartSettingBySchemeIDList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectSchemePartSettingBySchemeIDList(@RequestParam Map<String, Object> params)    {
    	List<EgovMap> rsltList = orderRequestService.selectSchemePartSettingBySchemeIDList(params);
    	return ResponseEntity.ok(rsltList);
    }
    
	@RequestMapping(value = "/schemConvPop.do")
	public String schemConvPop() {
		return "sales/order/schemConvPop";
	}
	
    @RequestMapping(value = "/selectValidateInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectValidateInfo(@RequestParam Map<String, Object> params)    {
    	EgovMap rslt = orderRequestService.selectValidateInfo(params);
    	return ResponseEntity.ok(rslt);
    }
	
    @RequestMapping(value = "/selectValidateInfoSimul.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectValidateInfoSimul(@RequestParam Map<String, Object> params)    {
    	EgovMap rslt = orderRequestService.selectValidateInfoSimul(params);
    	return ResponseEntity.ok(rslt);
    }
	
    @RequestMapping(value = "/selectOrderSimulatorViewByOrderNo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectOrderSimulatorViewByOrderNo(@RequestParam Map<String, Object> params)    {
    	EgovMap rslt = orderRequestService.selectOrderSimulatorViewByOrderNo(params);
    	return ResponseEntity.ok(rslt);
    }
	
    @RequestMapping(value = "/selectOderOutsInfo.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectOderOutsInfo(@RequestParam Map<String, Object> params)    {
    	List<EgovMap> ordOutInfoList = orderLedgerService.getOderOutsInfo(params);
    	return ResponseEntity.ok(ordOutInfoList);
    }
}
