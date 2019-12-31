package com.coway.trust.web.homecare.sales.order;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.sales.order.HcOrderRegisterService;
import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderRegisterController.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 17.   KR-SH        First creation
 *          </pre>
 */
@Controller
@RequestMapping(value = "/homecare/sales/order")
public class HcOrderRegisterController {

	@Resource(name = "hcOrderRegisterService")
	private HcOrderRegisterService hcOrderRegisterService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "hcOrderListService")
	private HcOrderListService hcOrderListService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	/**
	 * New Order Popup
	 *
	 * @Author KR-SH
	 * @Date 2019. 10. 17.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcOrderRegisterPop.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		// code List
        params.clear();
        params.put("groupCode", 10);
        params.put("orderValue", "CODE_ID");
        List<EgovMap> codeList_10 = commonService.selectCodeList(params);

        params.put("groupCode", 19);
        params.put("orderValue", "CODE_NAME");
        List<EgovMap> codeList_19 = commonService.selectCodeList(params);

        params.put("groupCode", 17);
        params.put("orderValue", "CODE_NAME");
        List<EgovMap> codeList_17 = commonService.selectCodeList(params);

        params.put("groupCode", 322);
        params.put("orderValue", "CODE_ID");
        List<EgovMap> codeList_322 = commonService.selectCodeList(params);

        model.put("codeList_10", codeList_10);
        model.put("codeList_17", codeList_17);
        model.put("codeList_19", codeList_19);
        model.put("codeList_322", codeList_322);
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		return "homecare/sales/order/hcOrderRegisterPop";
	}

	/**
	 * Salese Order - select Product List(Homacare)
	 *
	 * @Author KR-SH
	 * @Date 2019. 10. 18.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectHcProductCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProductCodeList(@RequestParam Map<String, Object> params) {
		// Homecare Product List
		List<EgovMap> codeList = hcOrderRegisterService.selectHcProductCodeList(params);

		return ResponseEntity.ok(codeList);
	}

	/**
	 * Homecare Order Confirm Popup
	 *
	 * @Author KR-SH
	 * @Date 2019. 10. 22.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcCnfmOrderDetailPop.do")
	public String hcCnfmOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "homecare/sales/order/hcCnfmOrderDetailPop";
	}

	/**
	 * Homecare Register Order
	 *
	 * @Author KR-SH
	 * @Date 2019. 10. 23.
	 * @param orderVO
	 * @param request
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcRegisterOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> hcRegisterOrder(@RequestBody OrderVO orderVO, SessionVO sessionVO) throws Exception {
		String appTypeName = HomecareConstants.cnvAppTypeName(orderVO.getSalesOrderMVO1().getAppTypeId());
		// Registe Homecare Order
		hcOrderRegisterService.hcRegisterOrder(orderVO, sessionVO);
		// Ex-Trade : 1
		/*if (orderVO.getSalesOrderMVO().getExTrade() == 1 && CommonUtils.isNotEmpty(orderVO.getSalesOrderMVO().getBindingNo())) {
			logger.debug("@#### Order Cancel START");
			String nowDate = CommonUtils.getDateToFormat("dd/MM/yyyy");

			logger.debug("@#### nowDate:" + nowDate);

			Map<String, Object> cParam = new HashMap<String, Object>();

			cParam.put("salesOrdNo", orderVO.getSalesOrderMVO().getBindingNo());

			EgovMap rMap = orderRegisterService.selectOldOrderId(cParam);

			cParam.put("salesOrdId", String.valueOf(rMap.get("salesOrdId")));
			cParam.put("cmbRequestor", "527");
			cParam.put("dpCallLogDate", nowDate);
			cParam.put("cmbReason", "1993");
			cParam.put("txtRemark", "Auto Cancellation for Ex-Trade");
			cParam.put("txtTotalAmount", "0");
			cParam.put("txtPenaltyCharge", "0");
			cParam.put("txtObPeriod", "0");
			cParam.put("txtCurrentOutstanding", "0");
			cParam.put("txtTotalUseMth", "0");
			cParam.put("txtPenaltyAdj", "0");

			orderRequestService.requestCancelOrder(cParam, sessionVO);
		}*/

		String msg = "";
		HcOrderVO hcOrderVO = orderVO.getHcOrderVO();

		msg += "Order successfully saved.<br />";

		if ("Y".equals(orderVO.getCopyOrderBulkYN())) {
			msg += "Order Number : " + orderVO.getSalesOrdNoFirst() + " ~ " + orderVO.getSalesOrderMVO().getSalesOrdNo()
					+ "<br />";
		} else {
			if(!"".equals(CommonUtils.nvl(hcOrderVO.getMatOrdNo()))) {
				msg += "Order Number(Mattres) : " + hcOrderVO.getMatOrdNo() + "<br />";
			}
			if(!"".equals(CommonUtils.nvl(hcOrderVO.getFraOrdNo()))) {
				msg += "Order Number(Frame) : "   + hcOrderVO.getFraOrdNo() + "<br />";
			}
		}

		if (orderVO.getSalesOrderDVO().getItmCompId() == 2 || orderVO.getSalesOrderDVO().getItmCompId() == 3
				|| orderVO.getSalesOrderDVO().getItmCompId() == 4) {
			msg += "AS Number : " + orderVO.getASEntryVO().getAsNo() + "<br />";
		}
		msg += "Bundle Number : " + hcOrderVO.getBndlNo() + "<br />";
		msg += "Application Type : " + appTypeName + "<br />";

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}

	/**
	 * Check Product Size
	 * @Author KR-SH
	 * @Date 2019. 12. 16.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/checkProductSize.do")
	public ResponseEntity<ReturnMessage> checkProductSize(@RequestParam Map<String, Object> params) {
		boolean chkSize = hcOrderRegisterService.checkProductSize(params);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		if(chkSize) {
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage("Product Size is different.");
		}

		return ResponseEntity.ok(message);
	}

	/**
	 * Select Promotion By Frame
	 * @Author KR-SH
	 * @Date 2019. 12. 24.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectPromotionByFrame.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromotionByFrame(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = hcOrderRegisterService.selectPromotionByFrame(params);
	    return ResponseEntity.ok(codeList);
	}

	/**
	 * Copy(change) Homecare Order
	 * @Author KR-SH
	 * @Date 2019. 12. 30.
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/copyChangeHcOrder.do")
	public String copyChangeHcOrder(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		// 매핑테이블 조회. - HMC0011D
		EgovMap hcPreOrdInfo = hcOrderListService.selectHcOrderInfo(params);
		EgovMap matOrderInfo = null;
		EgovMap frmOrderInfo = null;
		String matOrdId = "";
		String fraOrdId =  "";
		String ordCtgryCd = CommonUtils.nvl(hcPreOrdInfo.get("ordCtgryCd")); // Homecare Category CD

		if(ordCtgryCd.equals(HomecareConstants.HC_CTGRY_CD.MAT)) {
			matOrdId = CommonUtils.nvl(hcPreOrdInfo.get("ordId"));
			fraOrdId = CommonUtils.nvl(hcPreOrdInfo.get("anoOrdId"));
		} else {
			matOrdId = CommonUtils.nvl(hcPreOrdInfo.get("anoOrdId"));
			fraOrdId = CommonUtils.nvl(hcPreOrdInfo.get("ordId"));
		}

		if(!"".equals(matOrdId) && !"0".equals(matOrdId)) {
			// Mattress Order Info
			params.put("salesOrderId", matOrdId);
			matOrderInfo = orderDetailService.selectOrderBasicInfo(params, sessionVO);
		}
		if(!"".equals(fraOrdId) && !"0".equals(fraOrdId)) {
    		// Frame Order Info
    		params.put("salesOrderId", fraOrdId);
    		frmOrderInfo = orderDetailService.selectOrderBasicInfo(params, sessionVO);
		}

		// code List
        params.clear();
        params.put("groupCode", 10);
        params.put("orderValue", "CODE_ID");
        List<EgovMap> codeList_10 = commonService.selectCodeList(params);

        params.put("groupCode", 19);
        params.put("orderValue", "CODE_NAME");
        List<EgovMap> codeList_19 = commonService.selectCodeList(params);

        params.put("groupCode", 17);
        params.put("orderValue", "CODE_NAME");
        List<EgovMap> codeList_17 = commonService.selectCodeList(params);

        params.put("groupCode", 322);
        params.put("orderValue", "CODE_ID");
        List<EgovMap> codeList_322 = commonService.selectCodeList(params);

        model.put("codeList_10", codeList_10);
        model.put("codeList_17", codeList_17);
        model.put("codeList_19", codeList_19);
        model.put("codeList_322", codeList_322);
		model.put("hcPreOrdInfo", hcPreOrdInfo);
		model.put("orderInfo", matOrderInfo);
		model.put("orderInfo2", frmOrderInfo);
		model.put("COPY_CHANGE_YN", "Y");
		model.put("matOrdId", matOrdId);
		model.put("fraOrdId", fraOrdId);
		model.put("ordSeqNo", hcPreOrdInfo.get("ordSeqNo"));
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		return "homecare/sales/order/hcOrderRegisterPop";
	}
}
