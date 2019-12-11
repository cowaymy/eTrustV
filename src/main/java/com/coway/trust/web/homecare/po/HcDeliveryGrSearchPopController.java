/**
 *
 */
package com.coway.trust.web.homecare.po;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
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
import com.coway.trust.biz.homecare.po.HcConfirmPoService;
import com.coway.trust.biz.homecare.po.HcDeliveryGrSearchPopService;
import com.coway.trust.biz.homecare.po.HcPoIssueService;
import com.coway.trust.biz.homecare.po.HcPurchasePriceService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Controller
@RequestMapping(value = "/homecare/po")
public class HcDeliveryGrSearchPopController {
	//private static Logger logger = LoggerFactory.getLogger(HcDeliveryGrSearchPopController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "hcDeliveryGrSearchPopService")
	private HcDeliveryGrSearchPopService hcDeliveryGrSearchPopService;

	@Resource(name = "hcConfirmPoService")
	private HcConfirmPoService hcConfirmPoService;
	@Resource(name = "hcPurchasePriceService")
	private HcPurchasePriceService hcPurchasePriceService;
	@Resource(name = "hcPoIssueService")
	private HcPoIssueService hcPoIssueService;

	@RequestMapping(value = "/hcDeliveryGrSearchPop/hcDeliveryGrSearchPop.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		String dateFormat = SalesConstants.DEFAULT_DATE_FORMAT1;

		String toDay = CommonUtils.getFormattedString(dateFormat);
		String oneMonthBf = CommonUtils.getAddMonth(toDay, -1, dateFormat);

		model.put("toDay", toDay);
		model.put("oneMonthBf", oneMonthBf);

		// CDC - HMC0003M
		model.addAttribute("cdcList", hcPoIssueService.selectCdcList());
		// Supplier : vendor
		model.addAttribute("vendorList", hcPurchasePriceService.selectVendorList(null));

		// Supplier
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		HashMap<String, Integer> sMemAccMap = new HashMap<String, Integer>();
		sMemAccMap.put("sUserId", sessionVO.getUserId());
		model.put("zMemAccId", hcConfirmPoService.selectUserSupplierId(sMemAccMap));

		return "homecare/po/hcDeliveryGrSearchPop";
	}

	// main 조회
	@RequestMapping(value = "/hcDeliveryGrSearchPop/selectDeliveryGrSearchPop.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectDeliveryGrMain(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		ReturnMessage result = new ReturnMessage();

		String dtFrom = "";
		if(StringUtils.isNotEmpty((String)params.get("sDlvGiDtFrom"))){
			String[] dtFroms =((String)params.get("sDlvGiDtFrom")).split("/");
			for(String str : dtFroms){
				dtFrom = str + dtFrom;
			}
			params.put("sDlvGiDtFrom", dtFrom);
		}

		String dtTo = "";
		if(StringUtils.isNotEmpty((String)params.get("sDlvGiDtTo"))){
			String[] dtTos =((String)params.get("sDlvGiDtTo")).split("/");
			for(String str : dtTos){
				dtTo = str + dtTo;
			}
			params.put("sDlvGiDtTo", dtTo);
		}

		List<EgovMap> list = hcDeliveryGrSearchPopService.selectDeliveryGrSearchPop(params);
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		result.setTotal(list.size());
		return ResponseEntity.ok(result);
	}

}