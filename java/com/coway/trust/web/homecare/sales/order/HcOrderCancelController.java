package com.coway.trust.web.homecare.sales.order;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.HomecareCmService;
import com.coway.trust.biz.homecare.sales.order.HcOrderCancelService;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.sales.order.OrderCancelService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.sales.SalesConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderCancelController.java
 * @Description : Homecare Cancel Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 28.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/sales/order")
public class HcOrderCancelController {

	private static Logger logger = LoggerFactory.getLogger(HcOrderCancelController.class);

	@Resource(name = "orderCancelService")
	private OrderCancelService orderCancelService;

	@Resource(name = "hcOrderCancelService")
	private HcOrderCancelService hcOrderCancelService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "hcOrderListService")
	private HcOrderListService hcOrderListService;

	@Resource(name = "homecareCmService")
	private HomecareCmService homecareCmService;

	@Resource(name = "installationResultListService")
	private InstallationResultListService installationResultListService;

	@Resource(name = "orderListService")
	private OrderListService orderListService;

	/**
	 * Homecare Order Cancellation List 초기화 화면
	 * @Author KR-SH
	 * @Date 2019. 10. 28.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcOrderCancelList.do")
	public String HcOrderCancelList(@RequestParam Map<String, Object>params, ModelMap model){
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		List<EgovMap> dscBranchList = orderCancelService.dscBranch(params);

	    List<EgovMap> productRetReasonList = orderCancelService.productRetReason(params);

	    List<EgovMap> rsoStatusList = orderCancelService.rsoStatus(params);

	    List<EgovMap> productList_1 = hcOrderListService.selectProductCodeList();

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);
		model.addAttribute("dscBranchList", dscBranchList);
	    model.addAttribute("productRetReasonList", productRetReasonList);
		model.addAttribute("rsoStatusList", rsoStatusList);
		model.addAttribute("productList_1", productList_1);

		return "homecare/sales/order/hcOrderCancelList";
	}


	/**
	 * Homecare Order Cancellation List 데이터조회
	 * @Author KR-SH
	 * @Date 2019. 10. 28.
	 * @param params
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcOrderCancellationList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> hcOrderCancellationList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		String[] appTypeId = request.getParameterValues("cmbAppTypeId");
		String[] callStusId = request.getParameterValues("callStusId");
		String[] reqStageId = request.getParameterValues("reqStageId");
		String[] dscBranchId = request.getParameterValues("cmbDscBranchId");
		String[] dscBranchId2 = request.getParameterValues("cmbDscBranchId2");
		String[] productRetReasonId = request.getParameterValues("cmbproductRetReasonId");
		String[] rsoStatusId = request.getParameterValues("cmbrsoStatusId");
		String[] arrProdId     = request.getParameterValues("productId");

		params.put("typeIdList", appTypeId);
		params.put("stusIdList", callStusId);
		params.put("reqStageList", reqStageId);
		params.put("branchList", dscBranchId);
		params.put("branchList2", dscBranchId2);
		params.put("productRetReasonList", productRetReasonId);
		params.put("rsoStatusList", rsoStatusId);
		params.put("arrProd", arrProdId);

		List<EgovMap> orderCancelList = hcOrderCancelService.hcOrderCancellationList(params);

		return ResponseEntity.ok(orderCancelList);
	}

	/**
	 * 화면 호출. - New Cancellation Log Result
	 * @Author KR-SH
	 * @Date 2019. 10. 29.
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcCancelNewLogResultPop.do")
	public String hcCancelNewLogResultPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {
        // order detail
		params.put("prgrsId", 0);
		params.put("salesOrderId", CommonUtils.nvl(params.get("salesOrdId")));
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

		EgovMap cancelReqInfo = orderCancelService.cancelReqInfo(params);

		List<EgovMap> selectFeedback = orderCancelService.selectFeedback(params);
		// homecare 주문 조회
		params.put("ordNo", CommonUtils.nvl(params.get("paramSalesOrdNo")));
		EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);

		model.put("orderDetail", orderDetail);
		model.put("hcOrder", hcOrder);
		model.addAttribute("salesOrderNo", CommonUtils.nvl(params.get("salesOrderNo")));
		model.addAttribute("cancelReqInfo", cancelReqInfo);
		model.addAttribute("paramTypeId", CommonUtils.nvl(params.get("typeId")));
		model.addAttribute("paramDocId", CommonUtils.nvl(params.get("docId")));
		model.addAttribute("paramRefId", CommonUtils.nvl(params.get("refId")));
		model.addAttribute("selectFeedback", selectFeedback);
		model.addAttribute("reqStageId", params.get("paramReqStageId"));
	    model.addAttribute("rcdTms", params.get("rcdTms"));
	    model.addAttribute("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);

		return "homecare/sales/order/hcCancelNewLogResultPop";

	}

	/**
	 * 화면 호출. - New Cancellation Log Result
	 * @Author KR-SH
	 * @Date 2019. 10. 30.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcSaveCancel.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveCancel(@RequestParam Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage rtnMap = hcOrderCancelService.hcSaveCancel(params, sessionVO);

		return ResponseEntity.ok(rtnMap);
	}

	/**
	 * 화면 호출. - Add PR Result
	 * @Author KR-SH
	 * @Date 2020. 1. 7.
	 * @param params
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/hcAddProductReturnPop.do")
	public String hcAddProductReturnPop(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
		params.put("ststusCodeId", 1);
		params.put("reasonTypeId", 172);
		params.put("codeId", 257);

		EgovMap installParam = orderListService.selectInstallParam(params);
		params.put("installEntryId", CommonUtils.nvl(installParam.get("installEntryId")));

		List<EgovMap> failReason = installationResultListService.selectFailReason(params);
		EgovMap callType = installationResultListService.selectCallType(params);
		EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
		EgovMap stock = installationResultListService.getStockInCTIDByInstallEntryIDForInstallationView(installResult);
		EgovMap sirimLoc = installationResultListService.getSirimLocByInstallEntryID(installResult);
		EgovMap orderInfo = installationResultListService.getOrderInfo(params);

		if(null == orderInfo){
			orderInfo = new EgovMap();
		}
		int promotionId = CommonUtils.intNvl(orderInfo.get("c2"));
		int installStkId = CommonUtils.intNvl(installResult.get("installStkId"));

		EgovMap promotionView = new EgovMap();
		List<EgovMap> CheckCurrentPromo = installationResultListService.checkCurrentPromoIsSwapPromoIDByPromoID(promotionId);

		if(promotionId > 0) {
			 promotionView  = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(promotionId, installStkId, false);

		} else {
			promotionView.put("promoId", promotionId);
			promotionView.put("promoPrice", CommonUtils.nvl(orderInfo.get("c5")));
			promotionView.put("promoPV", CommonUtils.nvl(orderInfo.get("c6")));
			promotionView.put("swapPromoId", "0");
			promotionView.put("swapPromoPV", "0");
			promotionView.put("swapPormoPrice", "0");
		}

		String custId = CommonUtils.nvl2(installResult.get("custId"), CommonUtils.nvl(orderInfo.get("custId")));
		params.put("custId", custId);
		params.put("salesOrdNo", params.get("salesOrderNO"));

		EgovMap customerInfo = installationResultListService.getcustomerInfo(params);
		EgovMap customerContractInfo = installationResultListService.getCustomerContractInfo(customerInfo);
		EgovMap installation = installationResultListService.getInstallationBySalesOrderID(installResult);
		EgovMap installationContract = installationResultListService.getInstallContactByContactID(installation);
		EgovMap salseOrder = installationResultListService.getSalesOrderMBySalesOrderID(installResult);
		EgovMap hpMember= installationResultListService.getMemberFullDetailsByMemberIDCode(salseOrder);
		EgovMap pRCtInfo =orderListService.getPrCTInfo(params);

		// 시리얼 번호 조회 - Mattress
		Map<String, Object> schParams = new HashMap<String, Object>() ;
		schParams.put("pItmCode", orderInfo.get("stkCode"));
		schParams.put("pSalesOrdId", installResult.get("salesOrdId"));

		Map<String, Object> orderSerialMap = orderListService.selectOrderSerial(schParams);
		String orderSerialNo = CommonUtils.nvl(orderSerialMap.get("orderSerial"));

		// 프레임 정보조회 -- Start
		Map<String, Object> schParams2 = new HashMap<String, Object>() ;
		schParams2.put("srvOrdId", installResult.get("salesOrdId"));

		// Serch Homecare Info
		EgovMap orderHcInfo = hcOrderListService.selectHcOrderInfo(schParams2);
		int anoOrdId = 0; // another Order ID

		if(orderHcInfo != null) {
			anoOrdId = CommonUtils.intNvl(orderHcInfo.get("anoOrdId"));

			// has another Order
			if(anoOrdId > 0) {
				// Serch another Order Product Info
				EgovMap producInfo = hcOrderListService.selectProductInfo(String.valueOf(anoOrdId));

				schParams2.put("pSalesOrdId", anoOrdId);
				schParams2.put("pItmCode", CommonUtils.nvl(producInfo.get("stkCode")));
				schParams2.put("salesOrdNo", CommonUtils.nvl(orderHcInfo.get("anoOrdNo")));

				// 시리얼 번호 조회 - Frame
				Map<String, Object> orderSerialMap2 = orderListService.selectOrderSerial(schParams2);
				orderHcInfo.put("anoOrderSerial", CommonUtils.nvl(orderSerialMap2.get("orderSerial")));
				orderHcInfo.put("anoStkCode", CommonUtils.nvl(producInfo.get("stkCode")));

				List<EgovMap> productRtn = orderListService.selectProductReturnView(schParams2);
				if(productRtn.size() > 0) {
					orderHcInfo.put("anoRetnNo", CommonUtils.nvl(productRtn.get(0).get("retnNo")));
				}
			}
		}

		model.addAttribute("installResult", installResult);
		model.addAttribute("orderInfo", orderInfo);
		model.addAttribute("customerInfo", customerInfo);
		model.addAttribute("customerContractInfo", customerContractInfo);
		model.addAttribute("installationContract", installationContract);
		model.addAttribute("salseOrder", salseOrder);
		model.addAttribute("hpMember", hpMember);
		model.addAttribute("callType", callType);
		model.addAttribute("failReason", failReason);
		model.addAttribute("installStatus", installStatus);
		model.addAttribute("stock", stock);
		model.addAttribute("sirimLoc", sirimLoc);
		model.addAttribute("CheckCurrentPromo", CheckCurrentPromo);
		model.addAttribute("promotionView", promotionView);
		model.addAttribute("pRCtInfo", pRCtInfo);
		model.addAttribute("callEntryId" , params.get("callEntryId"));
		model.addAttribute("orderSerial" , orderSerialNo);
		model.addAttribute("orderHcInfo" , orderHcInfo);

		// 호출될 화면
		return "homecare/sales/order/hcAddProductReturnPop";
	}

	/**
	 * return Homecare Product
	 * @Author KR-SH
	 * @Date 2020. 1. 8.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/hcAddProductReturnSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> hcAddProductReturnSerial(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws ParseException {
		ReturnMessage rtnMap = hcOrderCancelService.hcAddProductReturnSerial(params, sessionVO);

		return ResponseEntity.ok(rtnMap);
	}

	/**
	 * Call Popup - Assignment DT Information
	 * @Author KR-SH
	 * @Date 2020. 1. 8.
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/orderCancelDTAssignmentPop.do")
	public String orderCancelDTAssignmentPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		String paramTypeId = CommonUtils.nvl(params.get("typeId"));
		String paramDocId = CommonUtils.nvl(params.get("docId"));
		String paramRefId = CommonUtils.nvl(params.get("refId"));

		// order detail start
		params.put("prgrsId", 0);
		params.put("salesOrderId", CommonUtils.nvl(params.get("salesOrdId")));
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

        List<EgovMap> selectAssignCTList = orderCancelService.selectAssignCT(params);

        EgovMap cancelReqInfo = orderCancelService.cancelReqInfo(params);

        params.put("stusCodeId", 1);
        EgovMap ctAssignmentInfo = orderCancelService.ctAssignmentInfo(params);

        model.put("orderDetail", orderDetail);
        model.addAttribute("salesOrderNo", CommonUtils.nvl(params.get("paramSalesOrdNo")));
        model.addAttribute("cancelReqInfo", cancelReqInfo);
        model.addAttribute("paramTypeId", paramTypeId);
        model.addAttribute("paramDocId", paramDocId);
        model.addAttribute("paramRefId", paramRefId);
        model.addAttribute("selectAssignCTList", selectAssignCTList);
        model.addAttribute("ctAssignmentInfo", ctAssignmentInfo);

        // 호출될 화면
     	return "homecare/sales/order/orderCancelDTAssignmentPop";
	}

	/**
	 * Call Popup - Order Cancel DT Search
	 * @Author KR-SH
	 * @Date 2020. 1. 8.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/orderCancelDTSearchPop.do")
	public String orderCancelDTSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("params ===========> " + params);
		String stkCode = CommonUtils.nvl(params.get("stockCode"));
		if(stkCode != null && (stkCode.equals("200001") || stkCode.equals("200002") || stkCode.equals("200003") || stkCode.equals("200004"))){
			model.addAttribute("dtMemType", HomecareConstants.MEM_TYPE.CT);
		}

		else {
			model.addAttribute("dtMemType", HomecareConstants.MEM_TYPE.DT);
		}

		return "homecare/sales/order/orderCancelDTSearchPop";
	}

	/**
	 * Order Cancel - Save Assignment DT
	 * @Author KR-SH
	 * @Date 2020. 1. 8.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/saveDTAssignment.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveDtAssignment(@RequestParam Map<String, Object> params, SessionVO sessionVO) throws ParseException {
		ReturnMessage rtnMap = hcOrderCancelService.saveDTAssignment(params, sessionVO);

		return ResponseEntity.ok(rtnMap);
	}

	@RequestMapping(value = "/getPartnerMemInfo.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> getPartnerMemInfo(@RequestParam Map<String, Object> params, HttpServletRequest request,
        ModelMap model) throws Exception {

  	  List<EgovMap> list = hcOrderCancelService.getPartnerMemInfo(params);
        return ResponseEntity.ok(list);
    }

}
