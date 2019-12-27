package com.coway.trust.web.homecare.services.install;

import java.text.ParseException;
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

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.HomecareCmService;
import com.coway.trust.biz.homecare.services.install.HcInstallResultListService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcInstallResultListController.java
 * @Description : Homecare Installaion Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 19.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/services/install")
public class HcInstallResultListController {

	//@Resource(name = "homecareCmService")
	//private HomecareCmService homecareCmService;

	@Resource(name = "installationResultListService")
	private InstallationResultListService installationResultListService;

	@Resource(name = "hcInstallResultListService")
	private HcInstallResultListService hcInstallResultListService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;

	/**
	 * Homecare Install List 화면호출
	 * @Author KR-SH
	 * @Date 2019. 12. 19.
	 * @param params
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcInstallationList.do")
	public String hcInstallationList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		List<EgovMap> instTypeList = installationResultListService.selectInstallationType();
		List<EgovMap> appTypeList = installationResultListService.selectApplicationType();
		List<EgovMap> installStatus = installationResultListService.selectInstallStatus();

		//String _brnchType = CommonUtils.nvl2(params.get("brnchType"), HomecareConstants.HDC_BRANCH_TYPE);
		//params.put("brnchType", _brnchType);
		//List<EgovMap> branchList = homecareCmService.selectHomecareBranchList(params);

		model.addAttribute("instTypeList", instTypeList);
		model.addAttribute("appTypeList", appTypeList);
		model.addAttribute("installStatus", installStatus);
		//model.addAttribute("branchList", branchList);

		return "homecare/services/install/hcInstallationList";
	}

	/**
	 * Select Homecare Installation List
	 * @Author KR-SH
	 * @Date 2019. 12. 19.
	 * @param params
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/hcInstallationListSearch.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> hcInstallationListSearch(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		String[] installStatusList = request.getParameterValues("installStatus");
		String[] typeList = request.getParameterValues("type");
		String[] appTypeList = request.getParameterValues("appType");
		String[] dscCodeList = request.getParameterValues("dscCode"); /* dscCode- kv testing */

		String product = "";
		if (!"".equals(params.get("product"))) {
			product = params.get("product").toString();
			product = product.substring(0, product.indexOf(" - "));
		}

		params.put("product", product);
		params.put("installStatusList", installStatusList);
		params.put("typeList", typeList);
		params.put("appTypeList", appTypeList);
		/* KV- DSC Code */
		params.put("dscCodeList", dscCodeList);

		List<EgovMap> installationResultList = hcInstallResultListService.hcInstallationListSearch(params);

		return ResponseEntity.ok(installationResultList);
  }


	@RequestMapping(value = "/installationResultPop.do")
	public String installationResultPop(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap resultInfo = installationResultListService.getInstallationResultInfo(params);
		model.addAttribute("resultInfo", resultInfo);

		// 호출될 화면
		return "services/installation/installationResultPop";
	}


	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/installationResultDetailPop.do")
	public String installationResultDetail(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap callType = installationResultListService.selectCallType(params);
		EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
		EgovMap orderInfo = null;

		if (params.get("codeId").toString().equals("258")) {
			orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
		} else {
			orderInfo = installationResultListService.getOrderInfo(params);
		}

		EgovMap customerInfo = installationResultListService.getcustomerInfo(orderInfo);
		EgovMap customerContractInfo = installationResultListService.getCustomerContractInfo(customerInfo);
		EgovMap installation = installationResultListService.getInstallationBySalesOrderID(installResult);
		EgovMap installationContract = installationResultListService.getInstallContactByContactID(installation);
		EgovMap salseOrder = installationResultListService.getSalesOrderMBySalesOrderID(installResult);
		EgovMap hpMember = installationResultListService.getMemberFullDetailsByMemberIDCode(salseOrder);

		model.addAttribute("installResult", installResult);
		model.addAttribute("orderInfo", orderInfo);
		model.addAttribute("customerInfo", customerInfo);
		model.addAttribute("customerContractInfo", customerContractInfo);
		model.addAttribute("installationContract", installationContract);
		model.addAttribute("salseOrder", salseOrder);
		model.addAttribute("hpMember", hpMember);
		model.addAttribute("callType", callType);

		// 호출될 화면
		return "services/installation/installationResultDetailPop";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/hcAddInstallationPopup.do")
	public String hcAddInstallationPopup(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		params.put("ststusCodeId", 1);
		params.put("reasonTypeId", 172);

		List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
        List<EgovMap> failReason = installationResultListService.selectFailReason(params);
        EgovMap callType = installationResultListService.selectCallType(params);
        EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
        EgovMap stock = installationResultListService.getStockInCTIDByInstallEntryIDForInstallationView(installResult);
        EgovMap sirimLoc = installationResultListService.getSirimLocByInstallEntryID(installResult);

        EgovMap orderInfo = new EgovMap();
        if (params.get("codeId").toString().equals("258")) { // PRODUCT EXCHANGE
        	orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
        } else { // NEW PRODUCT INSTALLATION
        	orderInfo = installationResultListService.getOrderInfo(params);
        }

        int promotionId = 0;
        if (CommonUtils.nvl(params.get("codeId")).toString().equals("258")) {
        	promotionId = CommonUtils.intNvl(orderInfo.get("c8"));
        } else {
        	promotionId = CommonUtils.intNvl(orderInfo.get("c2"));
        }

        EgovMap promotionView = new EgovMap();

        List<EgovMap> CheckCurrentPromo = installationResultListService.checkCurrentPromoIsSwapPromoIDByPromoID(promotionId);
        if (CheckCurrentPromo.size() > 0) {
        	promotionView = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(promotionId, CommonUtils.intNvl(installResult.get("installStkId")), true);

        } else {
        	if (promotionId != 0) {
        		promotionView = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(promotionId, CommonUtils.intNvl(installResult.get("installStkId")), false);

        	} else {
        		promotionView.put("promoId", "0");
        		promotionView.put("promoPrice", CommonUtils.nvl(params.get("codeId")) == "258" ? CommonUtils.nvl(orderInfo.get("c15")) : CommonUtils.nvl(orderInfo.get("c5")));
        		promotionView.put("promoPV", CommonUtils.nvl(params.get("codeId")) == "258" ? CommonUtils.nvl(orderInfo.get("c16")) : CommonUtils.nvl(orderInfo.get("c6")));
        		promotionView.put("swapPromoId", "0");
        		promotionView.put("swapPromoPV", "0");
        		promotionView.put("swapPormoPrice", "0");
        	}
        }

        Object custId = (orderInfo == null ? installResult.get("custId") : orderInfo.get("custId"));
        Object salesOrdNo = (orderInfo == null ? installResult.get("salesOrdNo") : orderInfo.get("salesOrdNo"));
        params.put("custId", custId);
        params.put("salesOrdNo", salesOrdNo);

        EgovMap customerInfo = installationResultListService.getcustomerInfo(params);
        EgovMap customerContractInfo = installationResultListService.getCustomerContractInfo(customerInfo);
        EgovMap installation = installationResultListService.getInstallationBySalesOrderID(installResult);
        EgovMap installationContract = installationResultListService.getInstallContactByContactID(installation);
        EgovMap salseOrder = installationResultListService.getSalesOrderMBySalesOrderID(installResult);
        EgovMap hpMember = installationResultListService.getMemberFullDetailsByMemberIDCode(salseOrder);

        model.addAttribute("installResult", installResult);
        model.addAttribute("orderInfo", orderInfo);
        model.addAttribute("customerInfo", customerInfo);
        model.addAttribute("installation", installation);
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

        EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
        model.put("orderDetail", orderDetail);

        // 호출될 화면
        return "homecare/services/install/hcAddInstallationResultPop";
	}

	/**
	 * Add Installation Result
	 * @Author KR-SH
	 * @Date 2019. 12. 20.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/hcAddInstallationSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> hcAddInstallationSerial(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage message = hcInstallResultListService.hcInsertInstallationResultSerial(params, sessionVO);

		return ResponseEntity.ok(message);
	}

}
