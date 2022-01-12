package com.coway.trust.web.homecare.services.install;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.homecare.services.install.HcInstallResultListService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

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
	private static final Logger logger = LoggerFactory.getLogger(HcInstallResultListController.class);

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

		params.put("installStatusList", installStatusList);
		params.put("typeList", typeList);
		params.put("appTypeList", appTypeList);
		/* KV- DSC Code */
		params.put("dscCodeList", dscCodeList);

		List<EgovMap> installationResultList = hcInstallResultListService.hcInstallationListSearch(params);

		return ResponseEntity.ok(installationResultList);
	}

	/**
	 * Installation Result DetailPopup
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationResultPop.do")
	public String installationResultPop(@RequestParam Map<String, Object> params, ModelMap model) {

	  EgovMap resultInfo = installationResultListService.getInstallationResultInfo(params);
	  model.addAttribute("resultInfo", resultInfo);
	  logger.debug("viewInstallation : {}", resultInfo);

	  // 호출될 화면
	  return "homecare/services/install/hcInstallationResultPop";
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
		return "homecare/services/install/hcInstallationResultDetailPop";
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

        // frame order no
        // frame stock id, code
        // frame location info
        // frame serial no
        params.put("stusCodeId", 1);
		EgovMap hcFrmOrder = hcInstallResultListService.selectFrmInfo(params);
		model.addAttribute("frameInfo", hcFrmOrder);

        // 호출될 화면
        return "homecare/services/install/hcAddInstallationResultPop";
	}

    /**
     * Installation Result DetailPopup
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/hcAddinstallationResultProductDetailPop.do")
    public String hcAddinstallationResultProductDetailPop(@RequestParam Map<String, Object> params, ModelMap model,
        SessionVO sessionVOl) throws Exception {
      logger.debug("params : {}", params);

      EgovMap viewDetail = installationResultListService.selectViewDetail(params);
      EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVOl);
      model.addAttribute("viewDetail", viewDetail);
      model.addAttribute("orderDetail", orderDetail);

      List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
      params.put("ststusCodeId", 1);
      params.put("reasonTypeId", 172);
      List<EgovMap> failReason = installationResultListService.selectFailReason(params);
      EgovMap callType = installationResultListService.selectCallType(params);
      EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
      EgovMap stock = installationResultListService.getStockInCTIDByInstallEntryIDForInstallationView(installResult);
      EgovMap sirimLoc = installationResultListService.getSirimLocByInstallEntryID(installResult);
      EgovMap orderInfo = null;

      if (params.get("codeId").toString().equals("258")) {
        orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
      } else {
        orderInfo = installationResultListService.getOrderInfo(params);
      }

      if (null == orderInfo) {
        orderInfo = new EgovMap();
      }

      String promotionId = "";
      if (CommonUtils.nvl(params.get("codeId")).toString().equals("258")) {
        promotionId = CommonUtils.nvl(orderInfo.get("c8"));
      } else {
        promotionId = CommonUtils.nvl(orderInfo.get("c2"));
      }

      if (promotionId.equals("")) {
        promotionId = "0";
      }

      logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");
      logger.debug("Promotion ID : {}", promotionId);
      logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");

      EgovMap promotionView = new EgovMap();

      List<EgovMap> CheckCurrentPromo = installationResultListService
          .checkCurrentPromoIsSwapPromoIDByPromoID(Integer.parseInt(promotionId));
      if (CheckCurrentPromo.size() > 0) {
        promotionView = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(
            Integer.parseInt(promotionId), Integer.parseInt(installResult.get("installStkId").toString()), true);
      } else {
        if (promotionId != "0") {
          promotionView = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(
              Integer.parseInt(promotionId), Integer.parseInt(installResult.get("installStkId").toString()), false);

        } else {

          // if (null == promotionView) {
          // promotionView = new EgovMap();
          // }

          promotionView.put("promoId", "0");
          promotionView.put("promoPrice", CommonUtils.nvl(params.get("codeId")).toString() == "258"
              ? CommonUtils.nvl(orderInfo.get("c15")) : CommonUtils.nvl(orderInfo.get("c5")));
          promotionView.put("promoPV", CommonUtils.nvl(params.get("codeId")).toString() == "258"
              ? CommonUtils.nvl(orderInfo.get("c16")) : CommonUtils.nvl(orderInfo.get("c6")));
          promotionView.put("swapPromoId", "0");
          promotionView.put("swapPromoPV", "0");
          promotionView.put("swapPormoPrice", "0");
        }
      }

      logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");
      logger.debug("New Params {}", params);
      logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");

      Object custId = (orderInfo == null ? installResult.get("custId") : orderInfo.get("custId"));
      Object salesOrdNo = (orderInfo == null ? installResult.get("salesOrdNo") : orderInfo.get("salesOrdNo"));
      params.put("custId", custId);
      params.put("salesOrdNo", salesOrdNo);
      EgovMap customerInfo = installationResultListService.getcustomerInfo(params);
      // EgovMap customerAddress =
      // installationResultListService.getCustomerAddressInfo(customerInfo);
      EgovMap customerContractInfo = installationResultListService.getCustomerContractInfo(customerInfo);
      EgovMap installation = installationResultListService.getInstallationBySalesOrderID(installResult);
      EgovMap installationContract = installationResultListService.getInstallContactByContactID(installation);
      EgovMap salseOrder = installationResultListService.getSalesOrderMBySalesOrderID(installResult);
      EgovMap hpMember = installationResultListService.getMemberFullDetailsByMemberIDCode(salseOrder);

      // if(params.get("codeId").toString().equals("258")){
      // }

      logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");
      logger.debug("INSTALLATION RESULT : {}", installResult);
      logger.debug("ORDER INFO : {}", orderInfo);
      logger.debug("CUSTOMER INFO. : {}", customerInfo);
      logger.debug("CUSTOMER CONTACT NUMBER : {}", customerContractInfo);
      logger.debug("INSTALLATION : {}", installation);
      logger.debug("INSTALLATION CONTRACT : {}", installationContract);
      logger.debug("SALES ORDER : {}", salseOrder);
      logger.debug("HP MEMBER : {}", hpMember);
      logger.debug("CALL TYPE : {}", callType);
      logger.debug("FAIL REASON : {}", failReason);
      logger.debug("INSTALL STATUS : {}", installStatus);
      logger.debug("STOCK : {}", stock);
      logger.debug("SIRIM LOC. : {}", sirimLoc);
      logger.debug("PROMOTION VIEW : {}", promotionView);
      logger.debug("CURRENT PROMO : {}", CheckCurrentPromo);
      logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");

      // logger.debug("customerAddress : {}", customerAddress);
      // model.addAttribute("customerAddress", customerAddress);
      // RETURN RESULT TO FRONTEND
      model.addAttribute("installResult", installResult);
      model.addAttribute("orderInfo", orderInfo);
      model.addAttribute("customerInfo", customerInfo);
      model.addAttribute("customerContractInfo", customerContractInfo);
      model.addAttribute("installation", installation);
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

      params.put("stusCodeId", 1);
      EgovMap hcFrmOrder = hcInstallResultListService.selectFrmInfo(params);
      model.addAttribute("frameInfo", hcFrmOrder);

      return "homecare/services/install/hcAddInstallationResultProductDetailPop";
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

	/**
	 *  Assign DT Transfer popup
	 *  @Author KR-JIN
	 **/
    @RequestMapping(value = "/hcAssignDTTransferPop.do")
    public String assignCTTransferPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
      return "homecare/services/install/hcAssignDTTransferPop";
    }


    @RequestMapping(value = "/assignCtOrderList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> assignCtOrderList(@RequestParam Map<String, Object> params,
        HttpServletRequest request, ModelMap model) throws Exception{

      String vAsNo = (String) params.get("installNo");
      String[] asNo = null;

      if (!StringUtils.isEmpty(vAsNo)) {
        asNo = ((String) params.get("installNo")).split(",");
        params.put("installNo", asNo);
      }

      List<EgovMap> list = hcInstallResultListService.assignCtOrderList(params);

      return ResponseEntity.ok(list);
    }

    @RequestMapping(value = "/assignCtOrderListSaveSerial.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage>  assignCtOrderListSaveSerial(@RequestBody Map<String, Object> params, Model model,
    	     HttpServletRequest request, SessionVO sessionVO) throws Exception{

    	//logger.debug("assignCtOrderListSave param :" + params.toString());
    	params.put("updator", sessionVO.getUserId());
    	//List<EgovMap> update = (List<EgovMap>) params.get("update");
        //logger.debug("asResultM ===>" + update.toString());

        Map<String, Object> returnValue = new HashMap<String, Object>();
        returnValue = hcInstallResultListService.updateAssignCTSerial(params);

        logger.debug("rtnValue ===> " + returnValue);

        String content = "";
        String successCon = "";
        String failCon = "";

        int successCnt = 0;
        int failCnt = 0;
        successCnt = Integer.parseInt(returnValue.get("successCnt").toString());
        failCnt = Integer.parseInt(returnValue.get("failCnt").toString());
        content = "[ Complete Count : " + successCnt + ", Fail Count : " + failCnt + " ]";

        List<String> successList = new ArrayList<String>();
        List<String> failList = new ArrayList<String>();
        successList = (List<String>) returnValue.get("successList");
        failList = (List<String>) returnValue.get("failList");

        if (successCnt > 0) {
          content += "<br/>Complete INS Number : ";
          for (int i = 0; i < successCnt; i++) {
            successCon += successList.get(i) + ", ";
          }
          successCon = successCon.substring(0, successCon.length() - 2);
          content += successCon;
        }

        if (failCnt > 0) {
          content += "<br/>Fail INS Number : ";
          for (int i = 0; i < failCnt; i++) {
            failCon += failList.get(i) + ", ";
          }
          failCon = failCon.substring(0, failCon.length() - 2);
          content += failCon;
          content += "<br/>Can't transfer CT to the Installation order";
        }

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(99);
        message.setMessage(content);

        /*
         * if (rtnValue == -1) { message.setCode(AppConstants.FAIL);
         * message.setMessage("Can't transfer CT to the Installation order"); } else
         * { message.setCode(AppConstants.SUCCESS); message.setData(99);
         * message.setMessage(""); }
         */

        logger.debug("message : {}", message);
        return ResponseEntity.ok(message);
    }


    /**
     * InstallationResult edit Installation Result Popup
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/hcEditInstallationResultPop.do")
    public String hcEditInstallationResultPop(@RequestParam Map<String, Object> params, ModelMap model , SessionVO sessionVO) throws Exception {

      EgovMap installInfo = installationResultListService.selectInstallInfo(params);
      model.addAttribute("installInfo", installInfo);

      EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);//
      model.put("orderDetail", orderDetail);

      // KR-JIN, AUX serial info
      String ordNo = ((EgovMap)orderDetail.get("basicInfo")).get("ordNo").toString();
      params.put("salesOrdNo", ordNo);

      params.put("stusCodeId", 4);		// status : COM
      EgovMap hcFrmOrder = hcInstallResultListService.selectFrmInfo(params);

      if(hcFrmOrder != null){
    	  String frmSerial = hcInstallResultListService.selectFrmSerial(hcFrmOrder);
    	  hcFrmOrder.put("frmSerial", frmSerial);
      }
      model.addAttribute("frameInfo", hcFrmOrder);

      // 호출될 화면
      return "homecare/services/install/hcEditInstallationResultPop";
    }


    @RequestMapping(value = "/hceditInstallationSerial.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> editInstallationSerial(@RequestBody Map<String, Object> params,
        SessionVO sessionVO) throws Exception {
      ReturnMessage message = new ReturnMessage();
      int resultValue = 0;

      int userId = sessionVO.getUserId();
      params.put("user_id", userId);
      logger.debug("params : {}", params);

      resultValue = hcInstallResultListService.hcEditInstallationResultSerial(params, sessionVO);

      if (resultValue > 0) {
        message.setMessage("Installation result successfully updated.");
      } else {
        message.setMessage("Failed to update installation result. Please try again later.");
      }

      return ResponseEntity.ok(message);
    }


}