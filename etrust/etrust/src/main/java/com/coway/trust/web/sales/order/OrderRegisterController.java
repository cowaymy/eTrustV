package com.coway.trust.web.sales.order;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.biz.sales.pst.PSTSalesDVO;
import com.coway.trust.biz.sales.pst.PSTSalesMVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.web.sales.pst.PSTRequestDOForm;
import com.coway.trust.web.sales.pst.PSTStockListGridForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderRegisterController {

	private static Logger logger = LoggerFactory.getLogger(OrderRegisterController.class);
	
	@Resource(name = "orderRegisterService")
	private OrderRegisterService orderRegisterService;
	
	@Resource(name = "customerService")
	private CustomerService customerService;
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@RequestMapping(value = "/orderRegisterPop.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
		
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
		
		return "sales/order/orderRegisterPop";
	}
	
	@RequestMapping(value = "/oldOrderPop.do")
	public String oldOrderPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/oldOrderPop";
	}
	
	@RequestMapping(value = "/cnfmOrderDetailPop.do")
	public String cnfmOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/cnfmOrderDetailPop";
	}
	
	@RequestMapping(value = "/orderSearchPop.do")
	public String orderSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("callPrgm", params.get("callPrgm"));
		model.put("indicator", params.get("indicator"));
		return "sales/order/orderSearchPop";
	}
	
    @RequestMapping(value = "/selectCustAddJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectCustAddInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
    
    	logger.debug("!@##############################################################################");
    	logger.debug("!@###### custAddId : "+params.get("custAddId"));
    	logger.debug("!@##############################################################################");
    	
    //	EgovMap custAddInfo = orderRegisterService.selectCustAddInfo(params);
    	EgovMap custAddInfo = customerService.selectCustomerViewMainAddress(params);
    
    	if(custAddInfo != null) {
    		if(CommonUtils.isNotEmpty(custAddInfo.get("postcode"))) {
    			params.put("postCode", custAddInfo.get("postcode"));
    			
    			EgovMap brnchInfo = commonService.selectBrnchIdByPostCode(params);
    			
    			custAddInfo.put("brnchId", brnchInfo.get("brnchId"));
    		}
    	}
    	
    	// 데이터 리턴.
    	return ResponseEntity.ok(custAddInfo);
    }
    
    @RequestMapping(value = "/checkOldOrderId.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectOldOrderId(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
    
    	EgovMap RESULT = orderRegisterService.checkOldOrderId(params);
    	
    	// 데이터 리턴.
    	return ResponseEntity.ok(RESULT);
    }
    
/*    @RequestMapping(value = "/selectOldOrderId.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectOldOrderId(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
    
    	EgovMap ordInfo = orderRegisterService.selectOldOrderId(params);
    	
    	// 데이터 리턴.
    	return ResponseEntity.ok(ordInfo);
    }
    
    @RequestMapping(value = "/selectSvcExpire.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectSvcExpire(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
    
    	EgovMap ordInfo = orderRegisterService.selectSvcExpire(params);
    	
    	// 데이터 리턴.
    	return ResponseEntity.ok(ordInfo);
    }
    
    @RequestMapping(value = "/selectVerifyOldSalesOrderNoValidity.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectVerifyOldSalesOrderNoValidity(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
    
    	EgovMap ordInfo = orderRegisterService.selectVerifyOldSalesOrderNoValidity(params);
    	
    	// 데이터 리턴.
    	return ResponseEntity.ok(ordInfo);
    }*/
    
    @RequestMapping(value = "/selectCustCntcJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectCustCntcInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
    
        logger.debug("!@##############################################################################");
        logger.debug("!@###### custAddId : "+params.get("custAddId"));
        logger.debug("!@##############################################################################");
        
        EgovMap custAddInfo = customerService.selectCustomerViewMainContact(params);
    
        // 데이터 리턴.
        return ResponseEntity.ok(custAddInfo);
    }

    @RequestMapping(value = "/selectSrvCntcJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectSrvCntcInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
    
        logger.debug("!@##############################################################################");
        logger.debug("!@###### /selectSrvCntcJsonInfo.do : custCareCntId : "+params.get("custCareCntId"));
        logger.debug("!@##############################################################################");
        
        EgovMap custAddInfo = orderRegisterService.selectSrvCntcInfo(params);
    
        // 데이터 리턴.
        return ResponseEntity.ok(custAddInfo);
    }
    
    @RequestMapping(value = "/selectStockPriceJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectStockPrice(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
    
        logger.debug("!@##############################################################################");
        logger.debug("!@###### /selectSrvCntcJsonInfo.do : custCareCntId : "+params.get("custCareCntId"));
        logger.debug("!@##############################################################################");
        
        EgovMap priceInfo = orderRegisterService.selectStockPrice(params);
    
        // 데이터 리턴.
        return ResponseEntity.ok(priceInfo);
    }
    	
    @RequestMapping(value = "/selectDocSubmissionList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectDocSubmissionList(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> codeList = orderRegisterService.selectDocSubmissionList(params);
    	return ResponseEntity.ok(codeList);
    }
    
    @RequestMapping(value = "/selectPromotionByAppTypeStock.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectPromotionByAppTypeStock(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> codeList = orderRegisterService.selectPromotionByAppTypeStock(params);
    	return ResponseEntity.ok(codeList);
    }
    
    @RequestMapping(value = "/selectProductPromotionPriceByPromoStockID.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectProductPromotionPriceByPromoStockID(@RequestParam Map<String, Object> params)
    {
    	EgovMap priceInfo = orderRegisterService.selectProductPromotionPriceByPromoStockID(params);
    	return ResponseEntity.ok(priceInfo);
    }
    
    @RequestMapping(value = "/selectTrialNo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectTrialNo(@RequestParam Map<String, Object> params)
    {
    	EgovMap result = orderRegisterService.selectTrialNo(params);
    	return ResponseEntity.ok(result);
    }
    
    @RequestMapping(value = "/selectMemberByMemberIDCode.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectMemberByMemberIDCode(@RequestParam Map<String, Object> params)
    {
    	EgovMap result = orderRegisterService.selectMemberByMemberIDCode(params);
    	return ResponseEntity.ok(result);
    }
    
    @RequestMapping(value = "/selectMemberList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectMemberList(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> codeList = orderRegisterService.selectMemberList(params);
    	return ResponseEntity.ok(codeList);
    }
    
	@RequestMapping(value = "/registerOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> registerOrder(@RequestBody OrderVO orderVO, HttpServletRequest request, Model model, SessionVO sessionVO) throws ParseException {

		orderRegisterService.registerOrder(orderVO, sessionVO);

		String msg = "", appTypeName = "";
		
		switch(orderVO.getSalesOrderMVO().getAppTypeId()) {
    		case SalesConstants.APP_TYPE_CODE_ID_RENTAL :
    			appTypeName = SalesConstants.APP_TYPE_CODE_RENTAL_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT :
    			appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHT_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT :
    			appTypeName = SalesConstants.APP_TYPE_CODE_INSTALLMENT_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_SPONSOR :
    			appTypeName = SalesConstants.APP_TYPE_CODE_SPONSOR_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_SERVICE :
    			appTypeName = SalesConstants.APP_TYPE_CODE_SERVICE_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_EDUCATION :
    			appTypeName = SalesConstants.APP_TYPE_CODE_EDUCATION_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_FREE_TRIAL :
    			appTypeName = SalesConstants.APP_TYPE_CODE_FREE_TRIAL_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS :
    			appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHTPLUS_FULL;
    			break;
    		default :
    			break;
		}
		
		
        msg += "Order successfully saved.<br />";
        msg += "Order Number : " + orderVO.getSalesOrderMVO().getSalesOrdNo() + "<br />";
        msg += "Application Type : " + appTypeName + "<br />";
		
		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}
}
