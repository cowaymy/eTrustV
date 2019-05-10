/**
 *
 */
package com.coway.trust.web.homecare.sales;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.homecare.sales.htOrderDetailService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.SessionVO;
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

	@Resource(name = "hsManualService")
	private HsManualService hsManualService;

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

		basicinfo = hsManualService.selectHsViewBasicInfo(params);

		List<EgovMap>  cmbCollectTypeComboList = hsManualService.cmbCollectTypeComboList(params);
		List<EgovMap>  failReasonList = hsManualService.failReasonList(params);
		model.addAttribute("basicinfo", basicinfo);
		logger.debug("basicinfo : {}", basicinfo);
		model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);
		model.addAttribute("failReasonList", failReasonList);
		model.addAttribute("MOD", params.get("MOD"));

		return "sales/order/include/hsEditPop";
	}

	@RequestMapping(value = "/htCvrgAreaList.do")
	public String htCvrgAreaList(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "homecare/sales/htCvrgAreaList";
	}

	@RequestMapping(value = "/selectCovrgAreaList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHsBasicList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {

		params.put("user_id", sessionVO.getUserId());

        // 조회.
		List<EgovMap> covrgAreaList = htOrderDetailService.selectCovrgAreaList(params);

		//brnch 임시 셋팅
		for (int i=0 ; i < covrgAreaList.size() ; i++){
			EgovMap record = (EgovMap) covrgAreaList.get(i);//EgovMap으로 형변환하여 담는다.
		}

		return ResponseEntity.ok(covrgAreaList);
	}


}
