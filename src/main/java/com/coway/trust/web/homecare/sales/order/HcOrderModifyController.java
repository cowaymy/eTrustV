/**
 *
 */
package com.coway.trust.web.homecare.sales.order;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
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

  	@RequestMapping(value = "/hcOrderModifyPop.do")
  	public String hcOrderModifyPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
        String callCenterYn = "N";

        if (CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))) {
          callCenterYn = "Y";
        }

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

        return "homecare/sales/order/hcOrderModifyPop";
  	}

}
