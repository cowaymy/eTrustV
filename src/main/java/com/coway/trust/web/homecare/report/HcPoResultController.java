/**
 *
 */
package com.coway.trust.web.homecare.report;

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
import com.coway.trust.biz.homecare.report.HcPoResultService;
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
@RequestMapping(value = "/homecare/report")
public class HcPoResultController {

	private static Logger logger = LoggerFactory.getLogger(HcPoResultController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;
	@Resource(name = "hcConfirmPoService")
	private HcConfirmPoService hcConfirmPoService;

	@Resource(name = "hcPoResultService")
	private HcPoResultService hcPoResultService;

	@Resource(name = "hcPurchasePriceService")
	private HcPurchasePriceService hcPurchasePriceService;
	@Resource(name = "hcPoIssueService")
	private HcPoIssueService hcPoIssueService;


	@RequestMapping(value = "/hcPoResult.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		String dateFormat = SalesConstants.DEFAULT_DATE_FORMAT1;

		String toDay = CommonUtils.getFormattedString(dateFormat);
		//String oneDay = "01/"+CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT4);
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

		return "homecare/report/hcPoResult";
	}

	// main 조회
	@RequestMapping(value = "/hcPoResult/selecthcPoResultMainList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selecthcPoResultMainList(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
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
		/*
		// 한페이지에서 보여줄 행 수
		int rowCount = params.containsKey("rowCount")?(int)params.get("rowCount"):25;
		// 호출한 페이지
		int goPage = params.containsKey("goPage")?(int)params.get("goPage"):0;
		if(rowCount != 0 && goPage != 0){
			firstIndex = (rowCount * goPage) - rowCount;
			lastIndex = rowCount * goPage;
		}
		*/
		params.put("firstIndex", firstIndex);
		params.put("lastIndex", lastIndex);

		List<EgovMap> list = null;
		result.setTotal(hcPoResultService.selecthcPoResultMainListCnt(params));

		if(result.getTotal() != 0){
			list = hcPoResultService.selecthcPoResultMainList(params);
		}
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

	// sub 조회
	@RequestMapping(value = "/hcPoResult/selecthcPoResultSubList.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selecthcPoResultSubList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		ReturnMessage result = new ReturnMessage();

		List<EgovMap> list = hcPoResultService.selecthcPoResultSubList(params);
		result.setTotal(list.size());
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

	// PO GROUP 조회
	@RequestMapping(value = "/hcPoResult/selecthcPoResultGroupList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selecthcPoResultGroupList(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
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
		result.setTotal(hcPoResultService.selecthcPoResultGropListCnt(params));

		if(result.getTotal() != 0){
			list = hcPoResultService.selecthcPoResultGropList(params);
		}
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

}