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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.biz.sales.order.PreOrderService;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
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
public class PreOrderController {

	private static Logger logger = LoggerFactory.getLogger(PreOrderController.class);
	
	@Resource(name = "preOrderService")
	private PreOrderService preOrderService;
	
	@RequestMapping(value = "/preOrderList.do")
	public String preOrderList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("toDay", toDay);
		model.put("isAdmin", "true");
		
		return "sales/order/preOrderList";
	}
	
	@RequestMapping(value = "/selectPreOrderList.do")
	public ResponseEntity<List<EgovMap>> selectPreOrderList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		
		String[] arrAppType      = request.getParameterValues("_appTypeId"); //Application Type
		String[] arrPreOrdStusId = request.getParameterValues("_stusId");    //Pre-Order Status 
		String[] arrKeyinBrnchId = request.getParameterValues("_brnchId");   //Key-In Branch
		String[] arrCustType     = request.getParameterValues("_typeId");    //Customer Type

		if(arrAppType      != null && !CommonUtils.containsEmpty(arrAppType))      params.put("arrAppType", arrAppType);
		if(arrPreOrdStusId != null && !CommonUtils.containsEmpty(arrPreOrdStusId)) params.put("arrPreOrdStusId", arrPreOrdStusId);
		if(arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrCustType     != null && !CommonUtils.containsEmpty(arrCustType))     params.put("arrCustType", arrCustType);

		List<EgovMap> result = preOrderService.selectPreOrderList(params);
		
		return ResponseEntity.ok(result);
	}
	
	@RequestMapping(value = "/selectExistSofNo.do")
	public ResponseEntity<EgovMap> selectExistSofNo(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		int cnt = preOrderService.selectExistSofNo(params);
		
		EgovMap result = new EgovMap();
		
		result.put("IS_EXIST", cnt > 0 ? "true" : "false");
		
		return ResponseEntity.ok(result);
	}
	
	@RequestMapping(value = "/preOrderRegisterPop.do")
	public String preOrderRegisterPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
		
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
		
		return "sales/order/preOrderRegisterPop";
	}
	
	@RequestMapping(value = "/registerPreOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> registerPreOrder(@RequestBody PreOrderVO preOrderVO, HttpServletRequest request, Model model, SessionVO sessionVO) throws Exception {

		preOrderService.insertPreOrder(preOrderVO, sessionVO);

		String msg = "", appTypeName = "";
		
		switch(preOrderVO.getAppTypeId()) {
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
        msg += "SOF No : " + preOrderVO.getSofNo() + "<br />";
        msg += "Application Type : " + appTypeName + "<br />";
		
		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}
	
}
