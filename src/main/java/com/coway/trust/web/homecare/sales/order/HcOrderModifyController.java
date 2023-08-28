/**
 *
 */
package com.coway.trust.web.homecare.sales.order;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.sales.order.HcOrderModifyService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderModifyService;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderModifyController.java
 * @Description : Homecare Order Modify Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 23.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/sales/order")
public class HcOrderModifyController {

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "hcOrderListService")
	private HcOrderListService hcOrderListService;

	@Resource(name = "hcOrderModifyService")
	private HcOrderModifyService hcOrderModifyService;

	@Resource(name = "orderModifyService")
	private OrderModifyService orderModifyService;

	@Resource(name = "commonService")
	private CommonService commonService;

	/**
	 * Call - Homecare Order Modify Popup
	 * @Author KR-SH
	 * @Date 2020. 1. 9.
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
  	@RequestMapping(value = "/hcOrderModifyPop.do")
  	public String hcOrderModifyPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
        String callCenterYn = "N";

        if (CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))) {
          callCenterYn = "Y";
        }

        // Search Only Mattress
   		EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);
   		params.put("salesOrderId", CommonUtils.nvl(hcOrder.get("srvOrdId")));  // set - Mattress Order Id

        // [Tap]Basic Info
        EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);  // APP_TYPE_ID
        EgovMap basicInfo = (EgovMap) orderDetail.get("basicInfo");

        model.put("orderDetail", orderDetail);
        model.put("salesOrderId", params.get("salesOrderId"));
        model.put("ordEditType", params.get("ordEditType"));
        model.put("custId", basicInfo.get("custId"));
        model.put("appTypeId", basicInfo.get("appTypeId"));
        model.put("appTypeDesc", basicInfo.get("appTypeDesc"));
        model.put("salesOrderNo", basicInfo.get("ordNo"));
        model.put("custNric", basicInfo.get("custNric"));
        model.put("ordStusId", basicInfo.get("ordStusId"));
        model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
        model.put("promoCode", basicInfo.get("ordPromoCode"));
        model.put("promoDesc", basicInfo.get("ordPromoDesc"));
        model.put("srvPacId", basicInfo.get("srvPacId"));
        model.put("callCenterYn", callCenterYn);
        model.put("memType", sessionVO.getUserTypeId());
        model.put("ordPvMonth", basicInfo.get("ordPvMonth"));
        model.put("ordPvYear", basicInfo.get("ordPvYear"));
        model.put("typeId", basicInfo.get("typeId"));
        model.put("eKeyinYn", !CommonUtils.nvl(basicInfo.get("ekeyCrtUser")).equals("") ? "Y" : "N");
        model.put("dtMemType", HomecareConstants.MEM_TYPE.DT);
        model.put("modFraOrdNo", CommonUtils.nvl(hcOrder.get("fraOrdNo")));
        model.put("modBndlId", CommonUtils.nvl(hcOrder.get("ordSeqNo")));
        model.put("stkId", basicInfo.get("stockId"));
        model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));

        return "homecare/sales/order/hcOrderModifyPop";
  	}

  	/**
  	 * Homecare Order Modify - Basic Info
  	 * @Author KR-SH
  	 * @Date 2020. 1. 9.
  	 * @param params
  	 * @param sessionVO
  	 * @return
  	 */
    @RequestMapping(value = "/updateHcOrderBasinInfo.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateHcOrderBasinInfo(@RequestBody Map<String, Object> params, SessionVO sessionVO) {
    	String rtnMsg = "Order Number : " + CommonUtils.nvl(params.get("salesOrdNo"));
    	orderModifyService.updateOrderBasinInfo(params, sessionVO);

    	if(!"".equals(CommonUtils.nvl(params.get("modBndlId")))) {
    		rtnMsg += ", " + CommonUtils.nvl(params.get("modFraOrdNo"));
    	}

    	// 결과 만들기
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage(rtnMsg + "</br>Information successfully updated.");

    	return ResponseEntity.ok(message);
    }

  	/**
  	 * Homecare Order Modify - Install Info
  	 * @Author KR-SH
  	 * @Date 2020. 1. 9.
  	 * @param params
  	 * @return
  	 * @throws Exception
  	 */
	@RequestMapping(value = "/updateHcInstallInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateHcInstallInfo(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage rtnMsg = hcOrderModifyService.updateHcInstallInfo(params, sessionVO);

		return ResponseEntity.ok(rtnMsg);
    }

	/**
	 * Homecare Order Modify - Promotion
	 * @Author KR-SH
	 * @Date 2020. 1. 15.
	 * @param salesOrderMVO
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateHcPromoPriceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateHcPromoPriceInfo(@RequestBody SalesOrderMVO salesOrderMVO, SessionVO sessionVO) throws Exception {
		ReturnMessage rtnMsg = hcOrderModifyService.updateHcPromoPriceInfo(salesOrderMVO, sessionVO);

	    return ResponseEntity.ok(rtnMsg);
	}

}
