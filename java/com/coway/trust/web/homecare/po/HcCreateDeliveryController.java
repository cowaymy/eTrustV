/**
 *
 */
package com.coway.trust.web.homecare.po;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
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
import com.coway.trust.biz.homecare.po.HcConfirmPoService;
import com.coway.trust.biz.homecare.po.HcCreateDeliveryService;
import com.coway.trust.biz.homecare.po.HcPoIssueService;
import com.coway.trust.biz.homecare.po.HcPurchasePriceService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.CommonController;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Controller
@RequestMapping(value = "/homecare/po")
public class HcCreateDeliveryController {
	private static Logger logger = LoggerFactory.getLogger(HcCreateDeliveryController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private CommonController commonController;

	@Autowired
	private SessionHandler sessionHandler;
	@Resource(name = "hcConfirmPoService")
	private HcConfirmPoService hcConfirmPoService;

	@Resource(name = "hcCreateDeliveryService")
	private HcCreateDeliveryService hcCreateDeliveryService;

	@Resource(name = "hcPurchasePriceService")
	private HcPurchasePriceService hcPurchasePriceService;
	@Resource(name = "hcPoIssueService")
	private HcPoIssueService hcPoIssueService;


	@RequestMapping(value = "/hcCreateDelivery.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		String dateFormat = SalesConstants.DEFAULT_DATE_FORMAT1;
		List<EgovMap> vendorList = null;

		String toDay = CommonUtils.getFormattedString(dateFormat);
		//String fourteenDtBf   = CommonUtils.getAddDay(toDay, -14, dateFormat);
        //String nextMonthDay = CommonUtils.getAddMonth(toDay, 1, dateFormat);
        String threeMonthBf = CommonUtils.getAddMonth(toDay, -3, dateFormat);
		model.put("toDay", toDay);
		model.put("threeMonthBf", threeMonthBf);

		// CDC - HMC0003M
		model.addAttribute("cdcList", hcPoIssueService.selectCdcList());

		// Supplier : vendor // Edited for Vendor list special access by Hui Ding, 2020-05-20
		vendorList = commonController.getVendorList(params);
		model.addAttribute("vendorList", vendorList);

		// Supplier
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		HashMap<String, Integer> sMemAccMap = new HashMap<String, Integer>();
		sMemAccMap.put("sUserId", sessionVO.getUserId());
		model.put("zMemAccId", hcConfirmPoService.selectUserSupplierId(sMemAccMap));

		return "homecare/po/hcCreateDelivery";
	}

	// Po main 조회
	@RequestMapping(value = "/hcCreateDelivery/selectPoList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectPoList(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		ReturnMessage result = new ReturnMessage();

		String poDtFrom = "";
		if(StringUtils.isNotEmpty((String)params.get("sPoDtFrom"))){
			String[] poDtFroms =((String)params.get("sPoDtFrom")).split("/");
			for(String str : poDtFroms){
				poDtFrom = str + poDtFrom;
			}
			params.put("sPoDtFrom", poDtFrom);
		}

		String poDtTo = "";
		if(StringUtils.isNotEmpty((String)params.get("sPoDtTo"))){
			String[] poDtTos =((String)params.get("sPoDtTo")).split("/");
			for(String str : poDtTos){
				poDtTo = str + poDtTo;
			}
			params.put("sPoDtTo", poDtTo);
		}

		int firstIndex = -1;
		int lastIndex  = -1;
		// 한페이지에서 보여줄 행 수
		int rowCount = params.containsKey("rowCount")?(int)params.get("rowCount"):25;
		// 호출한 페이지
		int goPage = params.containsKey("goPage")?(int)params.get("goPage"):0;
		if(rowCount != 0 && goPage != 0){
			firstIndex = (rowCount * goPage) - rowCount;
			lastIndex = rowCount * goPage;
		}
		params.put("firstIndex", firstIndex);
		params.put("lastIndex", lastIndex);

		List<EgovMap> list = null;
		result.setTotal(hcCreateDeliveryService.selectPoListCnt(params));
		if(result.getTotal() != 0){
			list =  hcCreateDeliveryService.selectPoList(params);
		}

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

	// Po Detail 조회
	@RequestMapping(value = "/hcCreateDelivery/selectPoDetailList.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectPoDetailList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		ReturnMessage result = new ReturnMessage();

		List<EgovMap> list = hcCreateDeliveryService.selectPoDetailList(params);
		result.setTotal(list.size());

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}



	// Delivery List 조회
	@RequestMapping(value = "/hcCreateDelivery/selectDeliveryList.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectDeliveryList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		ReturnMessage result = new ReturnMessage();

		List<EgovMap> list = hcCreateDeliveryService.selectDeliveryList(params);
		result.setTotal(list.size());

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

	// Deliverry Save
	@RequestMapping(value = "/hcCreateDelivery/multiHcCreateDelivery.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> multiHcCreateDelivery(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception {
		ReturnMessage result = new ReturnMessage();
		List<EgovMap> list = hcCreateDeliveryService.multiHcCreateDelivery(params, sessionVO);

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		result.setTotal(list.size());
		return ResponseEntity.ok(result);
	}

	// delete 처리
	@RequestMapping(value = "/hcCreateDelivery/deleteHcCreateDelivery.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteHcCreateDelivery(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception {
		ReturnMessage result = new ReturnMessage();
		List<EgovMap> list = hcCreateDeliveryService.deleteHcCreateDelivery(params, sessionVO);

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		result.setTotal(list.size());
		return ResponseEntity.ok(result);
	}

	//  Delivery 처리
	@RequestMapping(value = "/hcCreateDelivery/deliveryHcCreateDelivery.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deliveryHcCreateDelivery(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception {
		ReturnMessage result = new ReturnMessage();
		List<EgovMap> list = hcCreateDeliveryService.deliveryHcCreateDelivery(params, sessionVO);

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		result.setTotal(list.size());
		return ResponseEntity.ok(result);
	}

	//
	@RequestMapping(value = "/hcCreateDelivery/selectProductionCompar.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> selectProductionCompar(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		ReturnMessage result = new ReturnMessage();
		List<EgovMap> list = hcCreateDeliveryService.selectProductionCompar(params);
		result.setTotal(list.size());
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

	// Cancel Delivery
	@RequestMapping(value = "/hcCreateDelivery/cancelDeliveryHc.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> cancelDeliveryHc(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage result = new ReturnMessage();
		List<EgovMap> list = hcCreateDeliveryService.cancelDeliveryHc(params, sessionVO);

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		result.setTotal(list.size());
		return ResponseEntity.ok(result);
	}

}