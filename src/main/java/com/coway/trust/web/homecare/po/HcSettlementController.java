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
import com.coway.trust.biz.homecare.po.HcPoIssueService;
import com.coway.trust.biz.homecare.po.HcPurchasePriceService;
import com.coway.trust.biz.homecare.po.HcSettlementService;
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
public class HcSettlementController {

	private static Logger logger = LoggerFactory.getLogger(HcSettlementController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;
	@Resource(name = "hcConfirmPoService")
	private HcConfirmPoService hcConfirmPoService;

	@Resource(name = "hcSettlementService")
	private HcSettlementService hcSettlementService;

	@Resource(name = "hcPurchasePriceService")
	private HcPurchasePriceService hcPurchasePriceService;
	@Resource(name = "hcPoIssueService")
	private HcPoIssueService hcPoIssueService;


	@RequestMapping(value = "/hcSettlement.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		String dateFormat = SalesConstants.DEFAULT_DATE_FORMAT1;

		String toDay = CommonUtils.getFormattedString(dateFormat);
		String oneDay = "01/"+CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT4);
		//String sevenDtBf    = CommonUtils.getAddDay(toDay, -7, dateFormat);
		//String oneMonthBf = CommonUtils.getAddMonth(toDay, -1, dateFormat);
        String threeMonthBf = CommonUtils.getAddMonth(toDay, -3, dateFormat);

		model.put("toDay", toDay);
		model.put("threeMonthBf", threeMonthBf);

		// CDC - HMC0003M
		model.addAttribute("cdcList", hcPoIssueService.selectCdcList());
		// Supplier : vendor
		model.addAttribute("vendorList", hcPurchasePriceService.selectVendorList(null));

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		HashMap<String, Integer> sMemAccMap = new HashMap<String, Integer>();
		sMemAccMap.put("sUserId", sessionVO.getUserId());
		model.put("zMemAccId", hcConfirmPoService.selectUserSupplierId(sMemAccMap));

		return "homecare/po/hcSettlement";
	}

	@RequestMapping(value = "/hcSupplySettlement.do")
	public String hcSupplySettlement(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		String dateFormat = SalesConstants.DEFAULT_DATE_FORMAT1;

		String toDay = CommonUtils.getFormattedString(dateFormat);
		String oneDay = "01/"+CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT4);
		//String sevenDtBf    = CommonUtils.getAddDay(toDay, -7, dateFormat);
		//String oneMonthBf = CommonUtils.getAddMonth(toDay, -1, dateFormat);
        String threeMonthBf = CommonUtils.getAddMonth(toDay, -3, dateFormat);

		model.put("toDay", toDay);
		model.put("threeMonthBf", threeMonthBf);

		// CDC - HMC0003M
		model.addAttribute("cdcList", hcPoIssueService.selectCdcList());
		// Supplier : vendor
		model.addAttribute("vendorList", hcPurchasePriceService.selectVendorList(null));

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		HashMap<String, Integer> sMemAccMap = new HashMap<String, Integer>();
		sMemAccMap.put("sUserId", sessionVO.getUserId());
		model.put("zMemAccId", hcConfirmPoService.selectUserSupplierId(sMemAccMap));

		return "homecare/po/hcSupplySettlement";
	}


	// main 조회
	@RequestMapping(value = "/hcSettlement/selectHcSettlementMain.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectHcSettlementMain(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		ReturnMessage result = new ReturnMessage();

		String dtFrom = "";
		if(StringUtils.isNotEmpty((String)params.get("sGrDtFrom"))){
			String[] dtFroms =((String)params.get("sGrDtFrom")).split("/");
			for(String str : dtFroms){
				dtFrom = str + dtFrom;
			}
			params.put("sGrDtFrom", dtFrom);
		}

		String dtTo = "";
		if(StringUtils.isNotEmpty((String)params.get("sGrDtTo"))){
			String[] dtTos =((String)params.get("sGrDtTo")).split("/");
			for(String str : dtTos){
				dtTo = str + dtTo;
			}
			params.put("sGrDtTo", dtTo);
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
		result.setTotal(hcSettlementService.selectHcSettlementMainCnt(params));

		if(result.getTotal() != 0){
			list = hcSettlementService.selectHcSettlementMain(params);
		}
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

	// sub 조회
	@RequestMapping(value = "/hcSettlement/selectHcSettlementSub.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectHcSettlementSub(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		ReturnMessage result = new ReturnMessage();

		List<EgovMap> list = hcSettlementService.selectHcSettlementSub(params);
		result.setTotal(list.size());

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

	// SAVE
	@RequestMapping(value = "/hcSettlement/multiHcSettlement.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> multiHcSettlement(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

		int totCnt = hcSettlementService.multiHcSettlement(params, sessionVO);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	// Approve & Reject
	@RequestMapping(value = "/hcSettlement/confirmHcSettlement.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> confirmHcSettlement(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

		int totCnt = hcSettlementService.confirmHcSettlement(params, sessionVO);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

}
