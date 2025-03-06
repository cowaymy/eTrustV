package com.coway.trust.web.homecare.services.install;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.services.install.HcOrderCallListService;
import com.coway.trust.biz.organization.organization.AllocationService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.orderCall.OrderCallListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderCallListController.java
 * @Description : Homecare OrderCall List Controller
 *
 * @History
 *
 *          <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 2.   KR-SH        First creation
 *          </pre>
 */
@Controller
@RequestMapping(value = "/homecare/services/install")
public class HcOrderCallListController {

	@Resource(name = "hcOrderCallListService")
	private HcOrderCallListService hcOrderCallListService;

	@Resource(name = "orderCallListService")
	private OrderCallListService orderCallListService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "allocationService")
	private AllocationService allocationService;

	@Resource(name = "hcOrderListService")
	private HcOrderListService hcOrderListService;

	/**
	 * Homecare Order Call 화면 호출
	 *
	 * @Author KR-SH
	 * @Date 2019. 12. 3.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcOrderCallList.do")
	public String hcOrderCallList(@RequestParam Map<String, Object> params, ModelMap model) {
		// FeedBack Code
		List<EgovMap> callStatus = orderCallListService.selectCallStatus();
		List<EgovMap> callLogTyp = orderCallListService.selectCallLogTyp();
		List<EgovMap> callLogSta = orderCallListService.selectCallLogSta();
		List<EgovMap> callLogSrt = orderCallListService.selectCallLogSrt();
		List<EgovMap> promotionList = orderCallListService.selectPromotionList();

		model.addAttribute("callStatus", callStatus);
		model.addAttribute("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
		model.addAttribute("callLogTyp", callLogTyp);
		model.addAttribute("callLogSta", callLogSta);
		model.addAttribute("callLogSrt", callLogSrt);
		model.addAttribute("promotionList", promotionList);

		// 호출될 화면
		return "homecare/services/install/hcOrderCallList";
	}

	/**
	 * Search Order Call List
	 *
	 * @Author KR-SH
	 * @Date 2019. 12. 26.
	 * @param params
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/searchHcOrderCallList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> searchHcOrderCallList(@RequestParam Map<String, Object> params,
			HttpServletRequest request) {

		String[] appTypeList = request.getParameterValues("appType");
		String[] callLogTypeList = request.getParameterValues("callLogType");
		String[] callLogStatusList = request.getParameterValues("callLogStatus");//added by keyi
		String[] DSCCodeList = request.getParameterValues("DSCCode");
		String[] DSCCodeList2 = request.getParameterValues("DSCCode2");// added for HA & HC Branch code enhancement by Hui Ding, 5/3/2024
		String[] promotionListSp = request.getParameterValues("promotion"); //added by keyi
		String[] searchFeedBackCode = request.getParameterValues("searchFeedBackCode"); //added by keyi
		String[] productList = request.getParameterValues("product"); //added by frango
		String[] waStusCodeId = request.getParameterValues("waStusCodeId"); //added by frango

		params.put("appTypeList", appTypeList);
		params.put("callLogTypeList", callLogTypeList);
		params.put("callLogStatusList", callLogStatusList); //added by keyi
		params.put("DSCCodeList", DSCCodeList);
		params.put("DSCCodeList2", DSCCodeList2);
		params.put("promotionListSp", promotionListSp); //added by keyi
		params.put("searchFeedBackCode", searchFeedBackCode); //added by keyi
		params.put("productList", productList); //added by frango
		params.put("waStusCodeId", waStusCodeId); //added by frango

		String[] branchTypeArray = {HomecareConstants.HDC_BRANCH_TYPE, HomecareConstants.DSC_BRANCH_TYPE};

		params.put("branchTypeList", branchTypeArray);

		List<EgovMap> orderCallList = hcOrderCallListService.searchHcOrderCallList(params);

		return ResponseEntity.ok(orderCallList);
	}

	/**
	 * Call Center - order Call List - Add Call Log Result
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/hcAddCallLogResultPop.do")
	public String hcAddCallLogResultPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
			throws Exception {
		EgovMap orderCall = orderCallListService.getOrderCall(params);
		EgovMap rdcincdc = orderCallListService.getRdcInCdc(orderCall);
		List<EgovMap> callStatus = orderCallListService.selectCallStatus();
		List<EgovMap> callLogSta = orderCallListService.selectCallLogSta();

		String productCode = CommonUtils.nvl(orderCall.get("productCode"));
		params.put("productCode", productCode);

		EgovMap cdcAvaiableStock = orderCallListService.selectCdcAvaiableStock(params);
		EgovMap rdcStock = orderCallListService.selectRdcStock(params);

		// Order Detail Tab
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
		// another order
		EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);
		// anoProduct Info
		EgovMap anoProduct = hcOrderListService.selectProductInfo(CommonUtils.nvl(hcOrder.get("anoOrdId")));

		Map<String, Object> anoRdcMap = new HashMap<String, Object>();
		EgovMap anoRdcincdc = null;

		Map<String, Object> isComToPexMap = (Map<String, Object>) orderDetail.get("basicInfo");
		String isComToPex = isComToPexMap.get("ordStusId").toString();
		if(isComToPex.equals("4")){
			anoProduct = null;
			hcOrder.put("anoOrdNo","");
		}

		if (anoProduct != null) {
			anoRdcMap.put("dscBrnchId", CommonUtils.nvl(orderCall.get("dscBrnchId")));
			anoRdcMap.put("productCode", CommonUtils.nvl(anoProduct.get("stkCode")));

			anoRdcincdc = orderCallListService.getRdcInCdc(anoRdcMap);
		}

		model.addAttribute("callStusCode", CommonUtils.nvl(params.get("callStusCode")));
		model.addAttribute("callStusId", CommonUtils.nvl(params.get("callStusId")));
		model.addAttribute("salesOrdId", CommonUtils.nvl(params.get("salesOrdId")));
		model.addAttribute("callEntryId", CommonUtils.nvl(params.get("callEntryId")));
		model.addAttribute("salesOrdNo", CommonUtils.nvl(params.get("salesOrdNo")));
		model.addAttribute("rcdTms", CommonUtils.nvl(params.get("rcdTms")));
		model.addAttribute("cdcAvaiableStock", cdcAvaiableStock);
		model.addAttribute("rdcStock", rdcStock);
		model.addAttribute("orderCall", orderCall);
		model.addAttribute("callStatus", callStatus);
		model.addAttribute("callLogSta", callLogSta);
		model.addAttribute("orderDetail", orderDetail);
		model.addAttribute("orderRdcInCdc", rdcincdc);
		model.addAttribute("hcOrder", hcOrder);
		model.addAttribute("anoRdcincdc", anoRdcincdc);
		model.addAttribute("anoProduct", anoProduct);

		// 호출될 화면
		return "homecare/services/install/hcAddCallLogResultPop";
	}

	/**
	 * Save Call Log Result [ENHANCE OLD insertCallResult]
	 *
	 * @Author KR-SH
	 * @Date 2019. 12. 11.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	@RequestMapping(value = "/hcInsertCallResult.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> hcInsertCallResult(@RequestBody Map<String, Object> params,
			SessionVO sessionVO) {
		ReturnMessage message = hcOrderCallListService.hcInsertCallResult(params, sessionVO);

		return ResponseEntity.ok(message);
	}

	/**
	 * organization territoryList page (Homecare)
	 *
	 * @Author KR-SH
	 * @Date 2019. 12. 11.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcAllocation.do")
	public String hcAllocation(@RequestParam Map<String, Object> params, ModelMap model) {

		model.addAttribute("ORD_ID", CommonUtils.nvl(params.get("ORD_ID")));
		model.addAttribute("S_DATE", CommonUtils.nvl(params.get("S_DATE")));
		model.addAttribute("TYPE", CommonUtils.nvl(params.get("TYPE")));
		model.addAttribute("ANO_ORD_NO", CommonUtils.nvl(params.get("ANO_ORD_NO")));
		model.addAttribute("PROD_CAT", CommonUtils.nvl(params.get("PROD_CAT")));

		// 호출될 화면
		return "homecare/services/install/hcAllocationListPop";
	}

	/**
	 * Select organization territoryList page (Homecare)
	 *
	 * @Author KR-SH
	 * @Date 2019. 12. 11.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectHcAllocation.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHcAllocation(@RequestParam Map<String, Object> params) throws Exception {
		params.put("termDtCd", HomecareConstants.TERM_DT_CD);
		List<EgovMap> resultList = hcOrderCallListService.hcInsertCallResult(params);

		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/selectHcDetailList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHcDetailList(@RequestParam Map<String, Object> params) throws Exception {
		List<EgovMap> resultList = hcOrderCallListService.selectHcDetailList(params);
		return ResponseEntity.ok(resultList);
	}

//	@RequestMapping(value = "/selectPromotionList.do", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> selectPromotionList(@RequestParam Map<String, Object> params) {
//
//		List<EgovMap> codeList = orderCallListService.selectPromotionList();
//		return ResponseEntity.ok(codeList);
//	}

}