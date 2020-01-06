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
import com.coway.trust.biz.homecare.po.HcDeliveryGrService;
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
public class HcDeliveryGrController {

	private static Logger logger = LoggerFactory.getLogger(HcDeliveryGrController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;
	@Resource(name = "hcConfirmPoService")
	private HcConfirmPoService hcConfirmPoService;

	@Resource(name = "hcDeliveryGrService")
	private HcDeliveryGrService hcDeliveryGrService;

	@Resource(name = "hcPurchasePriceService")
	private HcPurchasePriceService hcPurchasePriceService;
	@Resource(name = "hcPoIssueService")
	private HcPoIssueService hcPoIssueService;

	@RequestMapping(value = "/hcDeliveryGr.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		String dateFormat = SalesConstants.DEFAULT_DATE_FORMAT1;

		String toDay = CommonUtils.getFormattedString(dateFormat);
		String threeMonthBf = CommonUtils.getAddMonth(toDay, -3, dateFormat);

		model.put("toDay", toDay);
		model.put("threeMonthBf", threeMonthBf);

		// CDC - HMC0003M
		model.addAttribute("cdcList", hcPoIssueService.selectCdcList());
		// Supplier : vendor
		model.addAttribute("vendorList", hcPurchasePriceService.selectVendorList(null));

		// Supplier
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		HashMap<String, Integer> sMemAccMap = new HashMap<String, Integer>();
		sMemAccMap.put("sUserId", sessionVO.getUserId());
		model.put("zMemAccId", hcConfirmPoService.selectUserSupplierId(sMemAccMap));

		return "homecare/po/hcDeliveryGr";
	}

	@RequestMapping(value = "/hcDeliveryGr/hcDeliveryGrPop.do")
	public String preOrderRegisterPop(@RequestParam Map<String, Object> params, ModelMap model) {
		//Calendar calendar = Calendar.getInstance();
		//calendar.add(Calendar.DAY_OF_YEAR,1);
		//Date nextDay = calendar.getTime();

		//model.put("nextDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1,nextDay));

		return "homecare/po/hcDeliveryGrPop";
	}


	// main 조회
	@RequestMapping(value = "/hcDeliveryGr/selectDeliveryGrMain.do", method = RequestMethod.POST)
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
		result.setTotal(hcDeliveryGrService.selectDeliveryGrMainCnt(params));

		if(result.getTotal() != 0){
			list = hcDeliveryGrService.selectDeliveryGrMain(params);
		}
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}


	// Delivery No 조회
	@RequestMapping(value = "/hcDeliveryGr/selectDeliveryConfirm.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectDeliveryConfirm(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		ReturnMessage result = new ReturnMessage();

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		List<EgovMap> list = hcDeliveryGrService.selectDeliveryConfirm(params, sessionVO);
		result.setTotal(list.size());

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

	// 팝업창 GR처리.
	@RequestMapping(value = "/hcDeliveryGr/multiHcDeliveryGr.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> multiHcDeliveryGr(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception {

		int totCnt = hcDeliveryGrService.multiHcDeliveryGr(params, sessionVO);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	// main Grid GR처리
	@RequestMapping(value = "/hcDeliveryGr/multiGridGr.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> multiGridGr(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception {

		int totCnt = hcDeliveryGrService.multiGridGr(params, sessionVO);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	// 진행중인 GR Serial 초기화
	@RequestMapping(value = "/hcDeliveryGr/clearIngSerialNo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> clearIngSerialNo(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

		int totCnt = hcDeliveryGrService.clearIngSerialNo(params, sessionVO);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

}
