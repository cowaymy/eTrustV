/**
 * 
 */
package com.coway.trust.web.sales.order;

import java.text.ParseException;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
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
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderModifyService;
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
public class OrderModifyController {

	private static Logger logger = LoggerFactory.getLogger(OrderModifyController.class);
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	@Resource(name = "orderModifyService")
	private OrderModifyService orderModifyService;
	
	@Resource(name = "customerService")
	private CustomerService customerService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@RequestMapping(value = "/orderModifyPop.do")
	public String orderModifyPop(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
		
		//[Tap]Basic Info
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params);//APP_TYPE_ID CUST_ID
		EgovMap basicInfo = (EgovMap) orderDetail.get("basicInfo");

		model.put("orderDetail",  orderDetail);
		model.put("salesOrderId", params.get("salesOrderId"));
		model.put("ordEditType",  params.get("ordEditType"));
		model.put("custId",       basicInfo.get("custId"));
		model.put("appTypeId",    basicInfo.get("appTypeId"));
		model.put("appTypeDesc",  basicInfo.get("appTypeDesc"));
		model.put("salesOrderNo", basicInfo.get("ordNo"));
		model.put("custNric",     basicInfo.get("custNric"));
		model.put("toDay", 		  CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
		 
		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+model.get("salesOrderId"));
		logger.debug("!@###### ordEditType  : "+model.get("ordEditType"));
		logger.debug("!@###### custId       : "+model.get("custId"));
		logger.debug("!@###### appTypeId    : "+model.get("appTypeId"));
		logger.debug("!@###### appTypeDesc  : "+model.get("appTypeDesc"));
		logger.debug("!@###### salesOrderNo : "+model.get("salesOrderNo"));
		logger.debug("!@###### custNric     : "+model.get("custNric"));
		logger.debug("!@##############################################################################");
		
		return "sales/order/orderModifyPop";
	}

	@RequestMapping(value = "/updateOrderBasinInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateOrderBasinInfo(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		orderModifyService.updateOrderBasinInfo(params, sessionVO);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage("Order Number : " + params.get("salesOrdNo") + "</br>Information successfully updated.");

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateMailingAddress.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateMailingAddress(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws ParseException {
		
		orderModifyService.updateOrderMailingAddress(params, sessionVO);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage("Mailing address has been updated.");

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updateCntcPerson.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCntcPerson(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws ParseException {
		
		orderModifyService.updateCntcPerson(params, sessionVO);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage("Mailing address has been updated.");

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updateNric.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateNric(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws ParseException {
		
		orderModifyService.updateNric(params, sessionVO);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage("NRIC has been successfully updated.");

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePaymentChannel.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePaymentChannel(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		
		orderModifyService.updatePaymentChannel(params, sessionVO);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage("Order Number : " + params.get("salesOrdNo") + "</br>Information successfully updated.");

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectBillGrpMailingAddrJson.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectBillGrpMailingAddrJson(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		EgovMap resultMap = orderModifyService.selectBillGrpMailingAddr(params);

		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}
	
	@RequestMapping(value = "/selectBillGrpCntcPersonJson.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectBillGrpCntcPerson(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		EgovMap resultMap = orderModifyService.selectBillGrpCntcPerson(params);

		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}
	
	@RequestMapping(value = "/checkNricEdit.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> checkNricEdit(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		EgovMap resultMap = orderModifyService.checkNricEdit(params);

		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}
	
	@RequestMapping(value = "/checkNricExist.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> checkNricExist(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		EgovMap resultMap = orderModifyService.checkNricExist(params);
		
		logger.info("resultMap:"+resultMap);

		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}
	
	@RequestMapping(value = "/selectCustomerInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectCustomerInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		EgovMap resultMap = orderModifyService.selectCustomerInfo(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}
	
	@RequestMapping(value = "/selectInstallInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectInstallInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		EgovMap resultMap = orderModifyService.selectInstallInfo(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}

	@RequestMapping(value = "/selectInstallAddrInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectInstallAddrInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		EgovMap resultMap = orderModifyService.selectInstallAddrInfo(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}

	@RequestMapping(value = "/selectInstallCntcInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectInstallCntcInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		EgovMap resultMap = orderModifyService.selectInstallCntcInfo(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}

	@RequestMapping(value = "/selectInstRsltCount.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectInstRsltCount(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		EgovMap resultMap = orderModifyService.selectInstRsltCount(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}

	@RequestMapping(value = "/selectGSTZRLocationCount.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectGSTZRLocationCount(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		EgovMap resultMap = orderModifyService.selectGSTZRLocationCount(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}

	@RequestMapping(value = "/selectGSTZRLocationByAddrIdCount.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectGSTZRLocationByAddrIdCount(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		EgovMap resultMap = orderModifyService.selectGSTZRLocationByAddrIdCount(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}

	@RequestMapping(value = "/updateInstallInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateInstallInfo(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws ParseException {
		
		orderModifyService.updateInstallInfo(params, sessionVO);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage("Order Number : " + params.get("salesOrdNo") + "<br />Information successfully updated.");

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectRentPaySetInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectRentPaySetInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		EgovMap resultMap = orderModifyService.selectRentPaySetInfo(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}

	@RequestMapping(value = "/selectCustomerBankDetailView.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectCustomerBankDetailView(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		EgovMap resultMap = customerService.selectCustomerBankDetailViewPop(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}

	@RequestMapping(value = "/selectCustomerCreditCardDetailView.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectCustomerCreditCardDetailView(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		EgovMap resultMap = customerService.selectCustomerCreditCardDetailViewPop(params);
		
		resultMap.put("decryptCRCNoShow", CommonUtils.getMaskCreditCardNo(StringUtils.trim((String)resultMap.get("custOriCrcNo")), "*", 4));
		
		// 데이터 리턴.
		return ResponseEntity.ok(resultMap);
	}


}
