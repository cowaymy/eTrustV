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
import com.coway.trust.biz.homecare.report.HcPoStatusService;
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
@RequestMapping(value = "/homecare/report")
public class HcPoStatusController {

	private static Logger logger = LoggerFactory.getLogger(HcPoStatusController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private CommonController commonController;

	@Autowired
	private SessionHandler sessionHandler;
	@Resource(name = "hcConfirmPoService")
	private HcConfirmPoService hcConfirmPoService;

	@Resource(name = "hcPoStatusService")
	private HcPoStatusService hcPoStatusService;

	@Resource(name = "hcPurchasePriceService")
	private HcPurchasePriceService hcPurchasePriceService;
	@Resource(name = "hcPoIssueService")
	private HcPoIssueService hcPoIssueService;


	@RequestMapping(value = "/hcPoStatus.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		String dateFormat = SalesConstants.DEFAULT_DATE_FORMAT1;
		List<EgovMap> vendorList = null;

		String toDay = CommonUtils.getFormattedString(dateFormat);
		//String oneDay = "01/"+CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT4);
		//String sevenDtBf    = CommonUtils.getAddDay(toDay, -7, dateFormat);
        String oneMonthBf = CommonUtils.getAddMonth(toDay, -1, dateFormat);
        //String threeMonthBf = CommonUtils.getAddMonth(toDay, -3, dateFormat);

		model.put("toDay", toDay);
		model.put("oneMonthBf", oneMonthBf);

		// CDC - HMC0003M
		model.addAttribute("cdcList", hcPoIssueService.selectCdcList());

		// Supplier : vendor// Edited for Vendor list special access by Hui Ding, 2020-05-20
		vendorList = commonController.getVendorList(params);
		model.addAttribute("vendorList", vendorList);
		//model.addAttribute("vendorList", hcPurchasePriceService.selectVendorList(null));

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		HashMap<String, Integer> sMemAccMap = new HashMap<String, Integer>();
		sMemAccMap.put("sUserId", sessionVO.getUserId());
		model.put("zMemAccId", hcConfirmPoService.selectUserSupplierId(sMemAccMap));

		return "homecare/report/hcPoStatus";
	}

	// main 조회
	@RequestMapping(value = "/hcPoStatus/selectHcPoStatusMainList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectHcPoStatusMainList(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
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
		result.setTotal(hcPoStatusService.selectHcPoStatusMainListCnt(params));

		if(result.getTotal() != 0){
			list = hcPoStatusService.selectHcPoStatusMainList(params);
		}
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}




	// 엑셀 다운
	@RequestMapping(value = "/hcPoStatus/selectHcPoStatusMainExcelList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectHcPoStatusMainExcelList(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
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
		params.put("firstIndex", firstIndex);
		params.put("lastIndex", lastIndex);

		List<EgovMap> list = null;
		result.setTotal(hcPoStatusService.selectHcPoStatusMainListCnt(params));

		if(result.getTotal() != 0){
			list = hcPoStatusService.selectHcPoStatusMainList(params);
		}
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

}