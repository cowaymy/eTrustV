/**
 *
 */
package com.coway.trust.web.homecare.po;

import java.util.ArrayList;
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
import com.coway.trust.biz.homecare.po.HcPurchasePriceService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Controller
@RequestMapping(value = "/homecare/po")
public class HcPurchasePriceController {

	private static Logger logger = LoggerFactory.getLogger(HcPurchasePriceController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "hcPurchasePriceService")
	private HcPurchasePriceService hcPurchasePriceService;


	@RequestMapping(value = "/hcPurchasePrice.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		//String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString("dd-MM-yyyy");
		model.put("toDay", toDay);

		model.addAttribute("curList", hcPurchasePriceService.selectComonCodeList("94"));
		model.addAttribute("uomList", hcPurchasePriceService.selectComonCodeList("42"));

		// Supplier
		model.addAttribute("vendorList", hcPurchasePriceService.selectVendorList(null));
		return "homecare/po/hcPurchasePrice";
	}

	// main 조회
	@RequestMapping(value = "/selectHcPurchasePriceList.do", method = RequestMethod.POST)
	//public ResponseEntity<ReturnMessage> selectHcPurchasePriceList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
	public ResponseEntity<ReturnMessage> selectHcPurchasePriceList(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		ReturnMessage result = new ReturnMessage();
		//params.put("sMsttype", (String[])request.getParameterValues("sMsttype"));

		int firstIndex = -1;
		int lastIndex  = -1;

		// 한페이지에서 보여줄 행 수
		//int rowCount = StringUtils.isBlank((String)params.get("rowCount"))?0:Integer.parseInt((String)params.get("rowCount"));
		int rowCount = params.containsKey("rowCount")?(int)params.get("rowCount"):0;

		// 호출한 페이지
		//int goPage = StringUtils.isBlank((String)params.get("goPage"))?0:Integer.parseInt((String)params.get("goPage"));
		int goPage = params.containsKey("goPage")?(int)params.get("goPage"):0;

		if(rowCount != 0 && goPage != 0){
			firstIndex = (rowCount * goPage) - rowCount;
			lastIndex = rowCount * goPage;
		}
		params.put("firstIndex", firstIndex);
		params.put("lastIndex", lastIndex);

		String sValidDt = "";
		if(StringUtils.isNotEmpty((String)params.get("sValidDt"))){
			String[] sValidDts =((String)params.get("sValidDt")).split("-");
			for(String str : sValidDts){
				sValidDt = str + sValidDt;
			}
			params.put("sValidDt", sValidDt);
		}

		List<EgovMap> list = null;
		result.setTotal(hcPurchasePriceService.selectHcPurchasePriceListCnt(params));
		if(result.getTotal() != 0){
			list =  hcPurchasePriceService.selectHcPurchasePriceList(params);
		}

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

	// history grid 조회
	@RequestMapping(value = "/selectHcPurchasePriceHstList.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectHcPurchasePriceHstList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		ReturnMessage result = new ReturnMessage();
		List<EgovMap> list = hcPurchasePriceService.selectHcPurchasePriceHstList(params);
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setTotal(list.size());
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

	// 저장
	@RequestMapping(value = "/multiHcPurchasePrice.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> multiHcPurchasePrice(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) throws Exception  {

		int totCnt = hcPurchasePriceService.multiHcPurchasePrice(params, sessionVO);
		logger.info("CommCd_카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
}
