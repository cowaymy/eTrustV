/**
 *
 */
package com.coway.trust.web.homecare.sales;

import java.text.ParseException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.htOrderDetailService;
import com.coway.trust.biz.homecare.services.htManualService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Tommy
 *
 */
@Controller
@RequestMapping(value = "/homecare/sales")
public class htOrderDetailController {

	private static Logger logger = LoggerFactory.getLogger(htOrderDetailController.class);

	@Resource(name = "htOrderDetailService")
	private htOrderDetailService htOrderDetailService;

    @Resource(name = "htManualService")
    private htManualService htManualService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/htOrderDetailPop.do")
	public String getOrderDetailPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {

		//params.put("salesOrderId", 256488);

		int prgrsId = 0;

		params.put("prgrsId", prgrsId);

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");

		//[Tap]Basic Info
		EgovMap orderDetail = htOrderDetailService.selectOrderBasicInfo(params, sessionVO);//

		model.put("orderDetail", orderDetail);

		return "homecare/sales/htOrderDetailPop";
	}

	@RequestMapping(value = "/selectBasicInfoJson.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectBasicInfoJson(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");

		EgovMap basicInfo = htOrderDetailService.selectBasicInfo(params);

		// 데이터 리턴.
		return ResponseEntity.ok(basicInfo);
	}

	@RequestMapping(value = "/selectSameRentalGrpOrderJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSameRentalGrpOrderJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");

		List<EgovMap> sameRentalGrpOrderJsonList = htOrderDetailService.selectSameRentalGrpOrderList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(sameRentalGrpOrderJsonList);
	}

	@RequestMapping(value = "/selectMembershipInfoJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipInfoJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");

		List<EgovMap> memInfoList = htOrderDetailService.selectMembershipInfoList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}

	@RequestMapping(value = "/selectDocumentJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDocumentJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");

		List<EgovMap> memInfoList = htOrderDetailService.selectDocumentList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}

	@RequestMapping(value = "/selectCallLogJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCallLogJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");

		List<EgovMap> memInfoList = htOrderDetailService.selectCallLogList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}

	@RequestMapping(value = "/selectPaymentJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPaymentJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");

		List<EgovMap> memInfoList = htOrderDetailService.selectPaymentMasterList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}

	@RequestMapping(value = "/selectAutoDebitJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAutoDebitJsonList(@RequestParam Map<String, Object>params, ModelMap model) {
		List<EgovMap> memInfoList = htOrderDetailService.selectAutoDebitList(params);
		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}

	@RequestMapping(value = "/selectEcashList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectEcashList(@RequestParam Map<String, Object>params, ModelMap model) {
		List<EgovMap> result = htOrderDetailService.selectEcashList(params);
		// 데이터 리턴.
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectDiscountJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDiscountJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");

		List<EgovMap> memInfoList = htOrderDetailService.selectDiscountList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}

	@RequestMapping(value = "/selectLast6MonthTransJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLast6MonthTransJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> resultList = htOrderDetailService.selectLast6MonthTransListNew(params);

		// 데이터 리턴.
		return ResponseEntity.ok(resultList);
	}


    @RequestMapping(value = "/selectCurrentBSResultByBSNo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectCurrentBSResultByBSNo(@RequestParam Map<String, Object> params) {
    	EgovMap rslt = htOrderDetailService.selectCurrentBSResultByBSNo(params);
    	return ResponseEntity.ok(rslt);
    }

	@RequestMapping(value = "/selectASInfoList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectASInfoList(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> resultList = htOrderDetailService.selectASInfoList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/hsBasicInfoPop.do")
	public String selecthsBasicInfoPop(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) throws Exception {

		EgovMap basicinfo = null;

		params.put("salesOrderId", params.get("salesOrdId"));
		logger.debug("===========================================>");
		logger.debug("params : {}", params);
		logger.debug("===========================================>");

		basicinfo = htManualService.selectHsViewBasicInfo(params);

		List<EgovMap>  cmbCollectTypeComboList = htManualService.cmbCollectTypeComboList(params);
		List<EgovMap>  failReasonList = htManualService.failReasonList(params);
		model.addAttribute("basicinfo", basicinfo);
		logger.debug("basicinfo : {}", basicinfo);
		model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);
		model.addAttribute("failReasonList", failReasonList);
		model.addAttribute("MOD", params.get("MOD"));

		return "homecare/sales/include/htEditPop";
	}

	@RequestMapping(value = "/htCvrgAreaList.do")
	public String htCvrgAreaList(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "homecare/sales/htCvrgAreaList";
	}

	@RequestMapping(value = "/htUpdateCovrgAreaStatusPop.do")
	public String htUpdateCovrgAreaStatusPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		EgovMap covrgAreaList = null;

		logger.debug("htUpdateCovrgAreaStatusPop : " + params);
		covrgAreaList = htOrderDetailService.getHTCovrgAreaList(params);
		model.addAttribute("covrgAreaList", covrgAreaList);

		return "homecare/sales/htUpdateCovrgAreaStatusPop";
	}

	@RequestMapping(value = "/selectCovrgAreaList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHsBasicList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {

		params.put("user_id", sessionVO.getUserId());

        // 조회.
		List<EgovMap> covrgAreaList = htOrderDetailService.selectCovrgAreaList(params);

		return ResponseEntity.ok(covrgAreaList);
	}


	@RequestMapping(value = "/updateCovrgAreaStatus.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCovrgAreaStatus(@RequestBody Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();

		logger.debug("params : {}", params);
		params.put("updUserId", sessionVO.getUserId());

	    htOrderDetailService.updateCovrgAreaStatus(params);

		//message.setMessage("Update Successful for Area ID : " + params.get("areaId"));

	return ResponseEntity.ok(message);

	}


	@RequestMapping(value = "/htUpdateCovrgAreaStatusByGrpPop.do")
	public String htUpdateCovrgAreaStatusByGrpPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "homecare/sales/htUpdateCovrgAreaStatusByGrpPop";
	}

	@RequestMapping(value = "/selectCovrgAreaListByGrp.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCovrgAreaListByGrp(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {

		params.put("user_id", sessionVO.getUserId());

        // 조회.
		List<EgovMap> covrgAreaList = htOrderDetailService.selectCovrgAreaListByGrp(params);

		return ResponseEntity.ok(covrgAreaList);
	}

	@RequestMapping(value = "/updateCoverageAreaActive.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCoverageAreaActive(@RequestBody Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();

		logger.debug("updateCoverageAreaActive - params : {}", params);

		if(null != params.get("areaId")){
			String olist = (String)params.get("areaId");
			String[] spl = olist.split(",");
			params.put("areaIdListSp", spl);
		}

		logger.debug("updateCoverageAreaActive - params : {}", params);

		// UPDATE SAL0233M
		int resultValue = htOrderDetailService.updateCoverageAreaActive(params, sessionVO);

		//int resultValue = 0;

		if(resultValue >0 ){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/updateCoverageAreaInactive.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCoverageAreaInactive(@RequestBody Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();

		logger.debug("updateCoverageAreaInactive - params : {}", params);

		if(null != params.get("areaId")){
			String olist = (String)params.get("areaId");
			String[] spl = olist.split(",");
			params.put("areaIdListSp", spl);
		}

		logger.debug("updateCoverageAreaInactive - params : {}", params);

		// UPDATE SAL0233M
		int resultValue = htOrderDetailService.updateCoverageAreaInactive(params, sessionVO);

		//int resultValue = 0;

		if(resultValue >0 ){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		return ResponseEntity.ok(message);

	}

	   @RequestMapping(value = "/htOrderCancelRequestPop.do")
	    public String htOrderCancelRequestPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {

	        int prgrsId = 0;

	        params.put("prgrsId", prgrsId);

	        logger.debug("!@##############################################################################");
	        logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
	        logger.debug("!@##############################################################################");

	        //[Tap]Basic Info
	        EgovMap orderDetail = htOrderDetailService.selectOrderBasicInfo(params, sessionVO);//

	        model.put("orderDetail", orderDetail);

	        return "homecare/sales/htOrderCancellationPop";
	    }

	   @RequestMapping(value = "/htRequestCancelCSOrder.do", method = RequestMethod.POST)
	    public ResponseEntity<ReturnMessage> htRequestCancelCSOrder(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {


	        logger.info("##### params #####" +params);


	        ReturnMessage message = htOrderDetailService.requestCancelCSOrder(params, sessionVO);

	        return ResponseEntity.ok(message);
	    }

	   @RequestMapping(value = "/selectResnCodeList.do", method = RequestMethod.GET)
	   public ResponseEntity<List<EgovMap>> selectResnCodeList(@RequestParam Map<String, Object> params) {
	     List<EgovMap> rsltList = htOrderDetailService.selectResnCodeList(params);
	     return ResponseEntity.ok(rsltList);
	   }

}
