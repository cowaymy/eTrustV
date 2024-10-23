package com.coway.trust.web.homecare.sales.order;

import java.text.ParseException;
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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.sales.order.HcPreOrderService;
import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.PreOrderService;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.sales.SalesConstants;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcPreOrderController.java
 * @Description : Homecare Pre Order Controller
 *
 * @History
 *
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 17.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/sales/order")
public class HcPreOrderController {

    @Resource(name = "salesCommonService")
    private SalesCommonService salesCommonService;

    @Resource(name = "commonService")
    private CommonService commonService;

    @Resource(name = "hcPreOrderService")
    private HcPreOrderService hcPreOrderService;

    @Resource(name = "preOrderService")
    private PreOrderService preOrderService;

    @Resource(name = "hcOrderListService")
    private HcOrderListService hcOrderListService;

    /**
     * Homecare Pre OrderList 화면 호출
     * @Author KR-SH
     * @Date 2019. 11. 4.
     * @param params
     * @param model
     * @param sessionVO
     * @return
     * @throws ParseException
     */
    @RequestMapping(value = "/hcPreOrderList.do")
    public String hcPreOrderList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws ParseException {

        if (sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7) {
        	params.put("userId", sessionVO.getUserId());

            EgovMap result = salesCommonService.getUserInfo(params);

            model.put("orgCode", result.get("orgCode"));
            model.put("grpCode", result.get("grpCode"));
            model.put("deptCode", result.get("deptCode"));
            model.put("memCode", result.get("memCode"));
        }

        int userTypeId = 14;

        if(sessionVO.getUserTypeId() == 1) {    // HP
            userTypeId = 29;
        } else if(sessionVO.getUserTypeId() == 2) {     // CODY
            userTypeId = 28;
        }

        String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

        // BranchCodeList
        params.clear();
        params.put("groupCode", 1);
        List<EgovMap> branchCdList = commonService.selectBranchList(params);

        // code List
        params.clear();
        params.put("groupCode", 8);
        List<EgovMap> codeList_8 = commonService.selectCodeList(params);

        //product
        List<EgovMap> productList_1 = hcOrderListService.selectProductCodeList();

        model.put("fromDay", CommonUtils.getAddDay(toDay, -1, SalesConstants.DEFAULT_DATE_FORMAT1));
        model.put("toDay", toDay);
        model.put("isAdmin", "true");
        model.put("isAdmin", "true");
        params.put("userId", sessionVO.getUserId());
        EgovMap branchTypeRes = salesCommonService.getUserBranchType(params);
		if (branchTypeRes != null) {
			model.put("branchType", branchTypeRes.get("codeId"));
		}
        model.put("userTypeId", userTypeId);

        model.put("branchCdList", branchCdList);
        model.put("codeList_8", codeList_8);
        model.put("productList_1", productList_1);

        return "homecare/sales/order/hcPreOrderList";
    }

    /**
     * Search Homecare Pre OrderList
     * @Author KR-SH
     * @Date 2019. 11. 5.
     * @param params
     * @param request
     * @param model
     * @return
     */
    @RequestMapping(value = "/selectHcPreOrderList.do")
	public ResponseEntity<List<EgovMap>> selectHcPreOrderList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		String[] arrAppType      	= request.getParameterValues("_appTypeId"); 	// Application Type
		String[] arrPreOrdStusId 	= request.getParameterValues("_stusId");    		// Pre-Order Status
		String[] arrKeyinBrnchId 	= request.getParameterValues("_brnchId");   	// Key-In Branch
		String[] arrCustType     	= request.getParameterValues("_typeId");    		// Customer Type
		String[] arrOrdProudctList    	= request.getParameterValues("ProudctList");    		// Product
		String[] arrDtBranch    	= request.getParameterValues("dscBrnchId");			// DT Branch

		if(arrAppType      != null && !CommonUtils.containsEmpty(arrAppType))       	params.put("arrAppType", arrAppType);
		if(arrPreOrdStusId != null && !CommonUtils.containsEmpty(arrPreOrdStusId)) 	params.put("arrPreOrdStusId", arrPreOrdStusId);
		if(arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) 	params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrCustType      != null && !CommonUtils.containsEmpty(arrCustType))      	params.put("arrCustType", arrCustType);
		if(arrOrdProudctList      != null && !CommonUtils.containsEmpty(arrOrdProudctList))      	params.put("arrOrdProudctList", arrOrdProudctList);
		if(arrDtBranch      != null && !CommonUtils.containsEmpty(arrDtBranch))      	params.put("arrDtBranch", arrDtBranch);

		List<EgovMap> result = hcPreOrderService.selectHcPreOrderList(params);

		return ResponseEntity.ok(result);
	}

    /**
     * Homecare Pre Order Register Popup 화면 호출
     * @Author KR-SH
     * @Date 2019. 11. 4.
     * @param params
     * @param model
     * @return
     * @throws ParseException
     */
	@RequestMapping(value = "/hcPreOrderRegisterPop.do")
	public String hcPreOrderRegisterPop(@RequestParam Map<String, Object> params, ModelMap model) throws ParseException {
		// Search code List
        model.put("codeList_19", commonService.selectCodeList("19", "CODE_NAME"));
        Map<String, Object> extradeParam = new HashMap();
        extradeParam.put("notlike", "2");
        extradeParam.put("groupCode", "325");
        //model.put("codeList_325", commonService.selectCodeList("325"));
        model.put("codeList_325", commonService.selectCodeList(extradeParam));
        model.put("codeList_415", commonService.selectCodeList("415", "CODE_ID"));
        model.put("codeList_416", commonService.selectCodeList("416", "CODE_ID"));
        model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));
        // Search BranchCodeList
        model.put("branchCdList_1", commonService.selectBranchList("1", "-"));
        model.put("branchCdList_5", commonService.selectBranchList("5", "-"));
		model.put("nextDay", CommonUtils.getAddDay(CommonUtils.getDateToFormat(SalesConstants.DEFAULT_DATE_FORMAT1), 1, SalesConstants.DEFAULT_DATE_FORMAT1));

	    EgovMap checkExtradeSchedule = preOrderService.checkExtradeSchedule();

        String dayFrom = "", dayTo = "";

        if(checkExtradeSchedule!=null){
        	dayFrom = checkExtradeSchedule.get("startDate").toString();
        	dayTo = checkExtradeSchedule.get("endDate").toString();
        }
        else{
        	dayFrom = "20"; // default 20-{month-1}
       	  dayTo = "31"; // default LAST DAY OF THE MONTH
        }

		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
					SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("hsBlockDtFrom", dayFrom);
		model.put("hsBlockDtTo", dayTo);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);


		return "homecare/sales/order/hcPreOrderRegisterPop";
	}

	/**
	 * Homecare Pre Order Register Confirm Popup 화면 호출
	 * @Author KR-SH
	 * @Date 2019. 11. 4.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/cnfmHcPreOrderDetailPop.do")
	public String cnfmHcPreOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("atchFileGrpId", params.get("atchFileGrpId"));

		return "homecare/sales/order/cnfmHcPreOrderDetailPop";
	}

	/**
	 * Homecare Pre Order 저장
	 * @Author KR-SH
	 * @Date 2019. 11. 5.
	 * @param preOrderVO
	 * @param request
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/registerHcPreOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> registerHcPreOrder(@RequestBody PreOrderVO preOrderVO, SessionVO sessionVO) throws Exception {
		String appTypeStr = HomecareConstants.cnvAppTypeName(preOrderVO.getAppTypeId());
		// 주문 저장
		hcPreOrderService.registerHcPreOrder(preOrderVO, sessionVO);

		HcOrderVO hcOrderVO = preOrderVO.getHcOrderVO();

		String msg = "Order successfully saved.<br />";

		if(!"".equals(CommonUtils.nvl(hcOrderVO.getMatPreOrdId())) && !"0".equals(CommonUtils.nvl(hcOrderVO.getMatPreOrdId()))) {
			msg += "Pre Order Number(Mattres) : " + hcOrderVO.getMatPreOrdId() + "<br />";
		}
		if(!"".equals(CommonUtils.nvl(hcOrderVO.getFraPreOrdId())) && !"0".equals(CommonUtils.nvl(hcOrderVO.getFraPreOrdId()))) {
			msg += "Pre Order Number(Frame) : "   + hcOrderVO.getFraPreOrdId() + "<br />";
		}
		msg += "Bundle Number : " + hcOrderVO.getBndlNo() + "<br />";
		msg += "Application Type : " + appTypeStr + "<br />";

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}

	/**
	 * Homecare Pre Order Modify Popup창 호출
	 * @Author KR-SH
	 * @Date 2019. 11. 6.
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcPreOrderModifyPop.do")
	public String hcPreOrderModifyPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {
		// Search Pre Order Info
		EgovMap preOrderInfo = null;
		// 매핑테이블 조회. - HMC0011D
		EgovMap hcPreOrdInfo = hcPreOrderService.selectHcPreOrderInfo(params);
		EgovMap matOrderInfo = null;
		EgovMap frmOrderInfo = null;

		String matPreOrdId = CommonUtils.nvl(hcPreOrdInfo.get("matPreOrdId"));
		String fraPreOrdId =  CommonUtils.nvl(hcPreOrdInfo.get("fraPreOrdId"));

		if(!"".equals(matPreOrdId) && !"0".equals(matPreOrdId)) {
			// Mattress Order Info
			params.put("preOrdId", matPreOrdId);
			matOrderInfo = preOrderService.selectPreOrderInfo(params);
			preOrderInfo = preOrderService.selectPreOrderInfo(params);
		}
		if(!"".equals(fraPreOrdId) && !"0".equals(fraPreOrdId)) {
    		// Frame Order Info
    		params.put("preOrdId", fraPreOrdId);
    		frmOrderInfo = preOrderService.selectPreOrderInfo(params);
		}

		//model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

	   EgovMap checkExtradeSchedule = preOrderService.checkExtradeSchedule();

        String dayFrom = "", dayTo = "";

        if(checkExtradeSchedule!=null){
        	dayFrom = checkExtradeSchedule.get("startDate").toString();
        	dayTo = checkExtradeSchedule.get("endDate").toString();
        }
        else{
        	dayFrom = "20"; // default 20-{month-1}
       	  dayTo = "31"; // default LAST DAY OF THE MONTH
        }

		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
					SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("hsBlockDtFrom", dayFrom);
		model.put("hsBlockDtTo", dayTo);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		model.put("preOrderInfo", preOrderInfo);
		model.put("hcPreOrdInfo", hcPreOrdInfo);
		model.put("preMatOrderInfo", matOrderInfo);
		model.put("preFrmOrderInfo", frmOrderInfo);

        model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));
        
        if(params.containsKey("pageAuth")) {
        	ObjectMapper objectMapper = new ObjectMapper();
            Map<String, String> pageAuthMap = objectMapper.readValue(params.get("pageAuth").toString(), new TypeReference<Map<String, String>>() {});

    		model.put("pageAuth", pageAuthMap);
        }

		return "homecare/sales/order/hcPreOrderModifyPop";
	}

	/**
	 * Homecare Pre Order 수정
	 * @Author KR-SH
	 * @Date 2019. 11. 7.
	 * @param preOrderVO
	 * @param request
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateHcPreOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateHcPreOrder(@RequestBody PreOrderVO preOrderVO, SessionVO sessionVO) throws Exception {
		// 주문 수정
		hcPreOrderService.updateHcPreOrder(preOrderVO, sessionVO);

		String msg = "Order successfully saved.<br />";

		if(!"".equals(CommonUtils.nvl(preOrderVO.getHcOrderVO().getMatPreOrdId())) && !"0".equals(CommonUtils.nvl(preOrderVO.getHcOrderVO().getMatPreOrdId()))) {
			msg += "Pre Order Number(Mattres) : " + preOrderVO.getHcOrderVO().getMatPreOrdId() + "<br />";
		}
		if(!"".equals(CommonUtils.nvl(preOrderVO.getHcOrderVO().getFraPreOrdId())) && !"0".equals(CommonUtils.nvl(preOrderVO.getHcOrderVO().getFraPreOrdId()))) {
			msg += "Pre Order Number(Frame) : "   + preOrderVO.getHcOrderVO().getFraPreOrdId() + "<br />";
		}
		msg += "Application Type : " + HomecareConstants.cnvAppTypeName(preOrderVO.getAppTypeId()) + "<br />";

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}

	/**
	 * Homecare Pre Order Status Update
	 * @Author KR-SH
	 * @Date 2019. 11. 11.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/updateHcPreOrderStatus.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateHcPreOrderStatus(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws ParseException {
		// 주문 수정
		hcPreOrderService.updateHcPreOrderStatus(params, sessionVO);

		String msg = "Order Status successfully updated.<br />";

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}

	/**
	 * Convert Homecare Order Popup창 호출
	 * @Author KR-SH
	 * @Date 2019. 11. 6.
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/convertToHcOrderPop.do")
	public String convertToHcOrderPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {
		// Search Pre Order Info
		EgovMap preOrderInfo = null;
		// 매핑테이블 조회. - HMC0011D
		EgovMap hcPreOrdInfo = hcPreOrderService.selectHcPreOrderInfo(params);
		EgovMap matOrderInfo = null;
		EgovMap frmOrderInfo = null;

		String matPreOrdId = CommonUtils.nvl(hcPreOrdInfo.get("matPreOrdId"));
		String fraPreOrdId =  CommonUtils.nvl(hcPreOrdInfo.get("fraPreOrdId"));

		if(!"".equals(matPreOrdId) && !"0".equals(matPreOrdId)) {
			// Mattress Order Info
			params.put("preOrdId", matPreOrdId);
			matOrderInfo = preOrderService.selectPreOrderInfo(params);
			preOrderInfo = preOrderService.selectPreOrderInfo(params);
		}
		if(!"".equals(fraPreOrdId) && !"0".equals(fraPreOrdId)) {
    		// Frame Order Info
    		params.put("preOrdId", fraPreOrdId);
    		frmOrderInfo = preOrderService.selectPreOrderInfo(params);
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
        model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));
		model.put("preOrderInfo", preOrderInfo);
		model.put("hcPreOrdInfo", hcPreOrdInfo);
		model.put("preMatOrderInfo", matOrderInfo);
		model.put("preFrmOrderInfo", frmOrderInfo);
		model.put("CONV_TO_ORD_YN", "Y");
		model.put("matPreOrdId", matPreOrdId);
		model.put("fraPreOrdId", fraPreOrdId);
		model.put("ordSeqNo", hcPreOrdInfo.get("ordSeqNo"));
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		return "homecare/sales/order/hcOrderRegisterPop";
	}

}
