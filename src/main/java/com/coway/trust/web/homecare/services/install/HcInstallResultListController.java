package com.coway.trust.web.homecare.services.install;

import java.io.File;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.homecare.services.install.HcInstallResultListService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.installation.InstallationApplication;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;

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

	@Autowired
	private InstallationApplication installationApplication; //attachmentm

	@Value("${web.resource.upload.file}") // attachmentm
	private String uploadDir;

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
		String[] dscCodeList2 = request.getParameterValues("dscCode2"); // added for HA & HC branch code enhancement - Hui Ding, 11/3/2024
		String[] productList = request.getParameterValues("product"); //added by frango
		String[] delvryGrList = request.getParameterValues("delvryGr"); //
		String[] returnGrList = request.getParameterValues("returnGr"); //
		String[] preinsChkList = request.getParameterValues("preinsChk");

		params.put("installStatusList", installStatusList);
		params.put("typeList", typeList);
		params.put("appTypeList", appTypeList);
		/* KV- DSC Code */
		params.put("dscCodeList", dscCodeList);
		params.put("dscCodeList2", dscCodeList2);// added for HA & HC branch code enhancement - Hui Ding, 11/3/2024
		params.put("productList", productList); //added by frango
		params.put("delvryGrList", delvryGrList);
		params.put("returnGrList", returnGrList);
		params.put("preinsChkList", preinsChkList);

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

	  List<EgovMap> installAcc = installationResultListService.selectInstallAccWithInstallEntryId(params);

    List<String> installAccValues = new ArrayList<>();

    for (EgovMap map : installAcc) {
        Object value = map.get("insAccPartId");
        if (value != null) {
            installAccValues.add(value.toString());
        }
    }

    model.put("installAccValues", installAccValues);

	  // 호출될 화면
	  return "homecare/services/install/hcInstallationResultPop";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/installationResultDetailPop.do")
	public String installationResultDetail(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		EgovMap callType = installationResultListService.selectCallType(params);
		EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
		EgovMap orderInfo = null;

		if (params.get("codeId").toString().equals("258")) {
			orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
		} else {
			orderInfo = installationResultListService.getOrderInfo(params);
		}

		 Map<String, Object> orderParams = params;
		 EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(orderParams, sessionVO);//

		EgovMap customerInfo = installationResultListService.getcustomerInfo(orderInfo);
		EgovMap customerContractInfo = installationResultListService.getCustomerContractInfo(customerInfo);
		EgovMap installation = installationResultListService.getInstallationBySalesOrderID(installResult);
		EgovMap installationContract = installationResultListService.getInstallContactByContactID(installation);
		EgovMap salseOrder = installationResultListService.getSalesOrderMBySalesOrderID(installResult);
		EgovMap hpMember = installationResultListService.getMemberFullDetailsByMemberIDCode(salseOrder);

		model.addAttribute("orderDetail", orderDetail);

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
//TEST
		    List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
		    List<EgovMap> failParent = installationResultListService.failParent(); //Added by keyi HC Fail INS 20220120
        List<EgovMap> failReason = installationResultListService.selectFailReason(params);
        EgovMap callType = installationResultListService.selectCallType(params);
        EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
        EgovMap stock = installationResultListService.getStockInCTIDByInstallEntryIDForInstallationView(installResult);
        EgovMap sirimLoc = installationResultListService.getSirimLocByInstallEntryID(installResult);
        List<EgovMap> dtPairList = installationResultListService.getInstallDtPairByCtCode(installResult);

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
        model.addAttribute("failParent", failParent); //Added by keyi HC Fail INS 20220120
        model.addAttribute("failReason", failReason);
        model.addAttribute("installStatus", installStatus);
        model.addAttribute("stock", stock);
        model.addAttribute("sirimLoc", sirimLoc);
        model.addAttribute("CheckCurrentPromo", CheckCurrentPromo);
        model.addAttribute("promotionView", promotionView);
        model.addAttribute("dtPairList", dtPairList);

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
	  logger.debug("hcAddInstallationSerial - params :" + params);
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

      List<EgovMap> installAcc = installationResultListService.selectInstallAccWithInstallEntryId(params);

      List<String> installAccValues = new ArrayList<>();

      for (EgovMap map : installAcc) {
          Object value = map.get("insAccPartId");
          if (value != null) {
              installAccValues.add(value.toString());
          }
      }

      model.put("installAccValues", installAccValues);

      // 호출될 화면
      return "homecare/services/install/hcEditInstallationResultPop";
    }


    @RequestMapping(value = "/hceditInstallationSerial.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> editInstallationSerial(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
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

    //Added by keyi HC Fail INS 20220120
    @RequestMapping(value = "/hcFailInstallationPopup.do")
    public String failInstallationPopup(@RequestParam Map<String, Object> params, ModelMap model , SessionVO sessionVO) throws Exception {

      List<EgovMap> failParent = installationResultListService.failParent();
      params.put("reasonTypeId", 172);
      params.put("ststusCodeId", 1);
      List<EgovMap> failReason = installationResultListService.selectFailReason(params);

      EgovMap installInfo = installationResultListService.selectInstallInfo(params);
      model.addAttribute("installInfo", installInfo);

      EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);//
      model.put("orderDetail", orderDetail);
      model.put("codeId", params.get("codeId"));

      //AUX serial info
      String ordNo = ((EgovMap)orderDetail.get("basicInfo")).get("ordNo").toString();
      params.put("salesOrdNo", ordNo);

      params.put("stusCodeId", 21);		// status : FAL
      EgovMap hcFrmOrder = hcInstallResultListService.selectFrmInfo(params);

      if(hcFrmOrder != null){
    	  String frmSerial = hcInstallResultListService.selectFrmSerial(hcFrmOrder);
    	  hcFrmOrder.put("frmSerial", frmSerial);
      }
      model.addAttribute("frameInfo", hcFrmOrder);
      model.addAttribute("failParent", failParent);
      model.addAttribute("failReason", failReason);

      EgovMap orderInfo = null;
      if (params.get("codeId").toString().equals("258")) {
        orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
      } else {
        orderInfo = installationResultListService.getOrderInfo(params);
      }
      model.put("orderInfo", orderInfo);

      return "homecare/services/install/hcFailInstallationResultPop";
    }

    @RequestMapping(value = "/hcFailInstallation.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> failInstallationResult(@RequestBody Map<String, Object> params,
        SessionVO sessionVO) throws Exception {
      ReturnMessage message = new ReturnMessage();
      int resultValue = 0;

      int userId = sessionVO.getUserId();
      params.put("user_id", userId);

      resultValue = hcInstallResultListService.hcFailInstallationResult(params, sessionVO);
      if (resultValue > 0) {
        message.setMessage("Installation result successfully updated.");
      } else {
        message.setMessage("Failed to update installation result. Please try again later.");
      }

      return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
      logger.debug("params111 : {}", params);
      String err = "";
      String code = "";
      List<String> seqs = new ArrayList<>();

      try{
         Set set = request.getFileMap().entrySet();
         Iterator i = set.iterator();

         while(i.hasNext()) {
             Map.Entry me = (Map.Entry)i.next();
             String key = (String)me.getKey();
             seqs.add(key);
         }

      //List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "Services" + File.separator + "installation", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
      List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, "service/web/installation", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
      params.put(CommonConstants.USER_ID, sessionVO.getUserId());

      installationApplication.insertInstallationAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params, seqs);

      params.put("attachFiles", list);
      code = AppConstants.SUCCESS;
      }catch(ApplicationException e){
        err = e.getMessage();
        code = AppConstants.FAIL;
      }

      ReturnMessage message = new ReturnMessage();
      message.setCode(code);
      message.setData(params);
      message.setMessage(err);

      return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/attachFileUploadEdit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUploadEdit(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
    String err = "";
		String code = "";
		List<String> seqs = new ArrayList<>();

		try{
			 Set set = request.getFileMap().entrySet();
			 Iterator i = set.iterator();

			 while(i.hasNext()) {
			     Map.Entry me = (Map.Entry)i.next();
			     String key = (String)me.getKey();
			     seqs.add(key);
			 }

			 List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, "service/web/installation", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
		   logger.debug("list.size : {}", list.size());

		   params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		   installationApplication.insertInstallationAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params, seqs);

		    params.put("attachFiles", list);
		    code = AppConstants.SUCCESS;
		}catch(ApplicationException e){
			err = e.getMessage();
			code = AppConstants.FAIL;
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(code);
		message.setData(params);
		message.setMessage(err);

		return ResponseEntity.ok(message);
	}

    @RequestMapping(value = "/updateFileKey.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> updateFileKey(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
      ReturnMessage message = new ReturnMessage();
	    int resultValue = 0;

	    EgovMap fileID = new EgovMap();

	    Map<String, Object> locInfoEntry = new HashMap<String, Object>();
	    int userId = sessionVO.getUserId();
	    params.put("user_id", userId);
	    params.put("resultId", CommonUtils.nvl(params.get("resultId")));
	    params.put("StkId", CommonUtils.nvl(params.get("hidStkId")));
	    params.put("atchFileGrpId", CommonUtils.nvl(params.get("fileGroupKey")));
	    params.put("SalesOrderId", CommonUtils.nvl(params.get("SalesOrderId")));
	    params.put("installDt", CommonUtils.nvl(params.get("installdt")));
	    params.put("installEntryId", CommonUtils.nvl(params.get("installEntryId")));

	    locInfoEntry.put("userId", sessionVO.getUserId());

	    EgovMap locInfo = (EgovMap) installationResultListService.getFileID(locInfoEntry);

	    logger.debug("params : {}", params);
	    logger.debug("params ================================>>  " + locInfo);
	    params.put("atchFileGrpId", locInfo.get("atchFileGrpId"));
	    logger.debug("params ================================>>  " + params);

	    resultValue = hcInstallResultListService.updateInstallFileKey(params, sessionVO);

	    return ResponseEntity.ok(message);
	  }


    @RequestMapping(value = "/getAcInstallationInfo.do")
	 public String getAcInstallationInfo(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO, HttpServletRequest request) throws Exception  {
    	model.put("insNo", params.get("insNo"));
    	model.put("installationInfo", hcInstallResultListService.selectInstallationInfo(params));

    	if(((BigDecimal) ((EgovMap)model.get("installationInfo")).get("dupCheck")).compareTo(BigDecimal.ZERO) == 0 && ((BigDecimal) ((EgovMap)model.get("installationInfo")).get("mainStus")).compareTo(new BigDecimal("1")) == 0){
    		return "homecare/services/install/getAcInstallationInfo";
    	}
    	else{
    		return "homecare/services/install/getAcPreInsResult";
    	}
	 }

    @RequestMapping(value="/getAcInsFail.do")
    public String getAcInsFail(@RequestParam Map<String, Object> params, ModelMap model) {
    	model.put("insNo", params.get("insNo"));
    	model.put("installationInfo", hcInstallResultListService.selectInstallationInfo(params));

    	if(((BigDecimal) ((EgovMap)model.get("installationInfo")).get("dupCheck")).compareTo(BigDecimal.ZERO) == 0 && ((BigDecimal) ((EgovMap)model.get("installationInfo")).get("mainStus")).compareTo(new BigDecimal("1")) == 0){
    		return "homecare/services/install/getAcInsFail";
    	}
    	else{
    		return "homecare/services/install/getAcPreInsResult";
    	}
    }

    @RequestMapping(value = "/selectFailChild.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectFailChild(@RequestParam Map<String, Object> params, ModelMap model) {
      List<EgovMap> selectFailChild = hcInstallResultListService.selectFailChild(params);
      return ResponseEntity.ok(selectFailChild);
    }

    @RequestMapping(value="/insertPreInsFail.do", method = RequestMethod.POST)
    public ResponseEntity<HashMap<String, Object>> insertPreInsFail(@RequestBody Map<String, Object> params) {
    	params.put("status", 21);
    	hcInstallResultListService.insertPreIns(params);
    	return ResponseEntity.ok(new HashMap<String, Object>());
    }

    @RequestMapping(value="/insertPreInsCompleted.do", method = RequestMethod.POST)
    public ResponseEntity<HashMap<String, Object>> insertPreInsCompleted(@RequestBody Map<String, Object> params) {
    	params.put("status", 4);
    	hcInstallResultListService.insertPreIns(params);
    	return ResponseEntity.ok(new HashMap<String, Object>());
    }

    @RequestMapping(value="/getAcPreInsResult.do")
    public String getAcPreInsResult(@RequestParam Map<String, Object> params, ModelMap model) {
    	model.put("insNo", params.get("insNo"));
    	model.put("installationInfo", hcInstallResultListService.selectInstallationInfo(params));
    	return "homecare/services/install/getAcPreInsResult";
    }

    @RequestMapping(value="/getAcInsComplete.do")
    public String getAcInsComplete(@RequestParam Map<String, Object> params, ModelMap model) {
    	model.put("insNo", params.get("insNo"));
    	model.put("installationInfo", hcInstallResultListService.selectInstallationInfo(params));
    	params.put("bndlId", ((EgovMap)model.get("installationInfo")).get("bndlId").toString());

    	model.put("outdoorStkCode", hcInstallResultListService.getOutdoorAcStkCode(params));

    	if(((BigDecimal) ((EgovMap)model.get("installationInfo")).get("dupCheck")).compareTo(BigDecimal.ZERO) == 0 && ((BigDecimal) ((EgovMap)model.get("installationInfo")).get("mainStus")).compareTo(new BigDecimal("1")) == 0){
    		return "homecare/services/install/getAcInsComplete";
    	}
    	else{
    		return "homecare/services/install/getAcPreInsResult";
    	}
    }

    @RequestMapping(value = "/selectInstallationInfo.do", method = RequestMethod.GET)
    public ResponseEntity <EgovMap> selectInstallationInfo(@RequestParam Map<String, Object> params, ModelMap model) {
      EgovMap selectInstallationInfo = hcInstallResultListService.selectInstallationInfo(params);
      return ResponseEntity.ok(selectInstallationInfo);
    }

    @RequestMapping(value="/uploadInsImage.do", method=RequestMethod.POST)
    public ResponseEntity<Map<String, Object>> uploadInsImage(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params) throws Exception {
    	List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadImageFilesWithCompress(request, uploadDir, "/service/mobile/installation", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
    	List<String> seqs = new ArrayList<>();
    	Set set = request.getFileMap().entrySet();
        Iterator i = set.iterator();
        params.put("userId", "349");

         while(i.hasNext()) {
             Map.Entry me = (Map.Entry)i.next();
             String key = (String)me.getKey();
             seqs.add(key);
         }
    	installationApplication.insertInstallationAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params, seqs);
    	return ResponseEntity.ok(params);
    }

    @RequestMapping(value = "/batchJobInstallationPreCom.do", method = RequestMethod.GET)
    public ResponseEntity<String> batchJobInstallationPreCom() {
    	SessionVO sessionVO = new SessionVO();
    	sessionVO.setUserId(349);

    	Map<String,Object> selectParam = new HashMap();
    	selectParam.put("preInstallStus", 4);
    	List<EgovMap> preInstRecordResultList = hcInstallResultListService.selectPreInstallationRecord(selectParam);

    	if(preInstRecordResultList.size() > 0)
    	{
    		for(int i = 0; i<preInstRecordResultList.size(); i++){
    	    	try {
    	        	Map<String,Object> preInstRecordResult = preInstRecordResultList.get(i);
    	        	Map<String,Object> params = new HashMap();
    	        	//installEntryId
    	        	params.put("installEntryId",preInstRecordResult.get("installEntryId"));
    	        	params.put("stusCodeId", 1);

    			    EgovMap callType = installationResultListService.selectCallType(params);
    			    params.put("codeId", callType.get("typeId"));
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
    		        params.put("salesOrdId", preInstRecordResult.get("salesOrdId"));
    		        params.put("salesOrderId", preInstRecordResult.get("salesOrdId"));
    		        EgovMap customerInfo = installationResultListService.getcustomerInfo(params);
    		        // EgovMap customerAddress =
    		        // installationResultListService.getCustomerAddressInfo(customerInfo);
    		        EgovMap customerContractInfo = installationResultListService.getCustomerContractInfo(customerInfo);
    		        EgovMap installation = installationResultListService.getInstallationBySalesOrderID(installResult);
//    		        EgovMap installationContract = installationResultListService.getInstallContactByContactID(installation);
    		        EgovMap salseOrder = installationResultListService.getSalesOrderMBySalesOrderID(installResult);
    		        EgovMap hpMember = installationResultListService.getMemberFullDetailsByMemberIDCode(salseOrder);
    				EgovMap frameInfo = hcInstallResultListService.selectFrmInfo(params);
    			    EgovMap basicInfo = orderDetailService.selectBasicInfo(params);
    			    EgovMap salesmanInfo = orderDetailService.selectOrderSalesmanViewByOrderID(params);
    			    EgovMap installationInfo = orderDetailService.selectOrderInstallationInfoByOrderID(params);

    		        params.put("installEntryId",installResult.get("installEntryId"));
    		        params.put("hidCallType",callType.get("typeId"));
    		        params.put("hidEntryId",installResult.get("installEntryId"));
    		        params.put("hidCustomerId",installResult.get("custId"));
    		        params.put("hidSalesOrderId",installResult.get("salesOrdId"));
    		        params.put("hidSirimNo",installResult.get("sirimNo"));
    		        params.put("hidSerialNo",installResult.get("serialNo"));
    		        params.put("hidStockIsSirim",installResult.get("isSirim"));
    		        params.put("hidStockGrade",installResult.get("stkGrad"));
    		        params.put("hidSirimTypeId",installResult.get("stkCtgryId"));
    		        params.put("hidAppTypeId",installResult.get("codeId"));
    		        params.put("hidProductId",installResult.get("installStkId"));
    		        params.put("hidCustAddressId",installResult.get("custAddId"));
    		        params.put("hidCustContactId",installResult.get("custCntId"));
    		        params.put("hiddenBillId",installResult.get("custBillId"));
    		        params.put("hiddenCustomerPayMode",installResult.get("codeName"));
    		        params.put("hiddeninstallEntryNo",installResult.get("installEntryNo"));

    		        if(stock != null){
        		        params.put("hidActualCTMemCode",stock.get("memCode"));
        		        params.put("hidActualCTId",stock.get("movToLocId"));
    		        }
    		        else{
        		        params.put("hidActualCTMemCode","0");
        		        params.put("hidActualCTId","0");
    		        }

    		        if(sirimLoc != null){
        		        params.put("hidSirimLoc",sirimLoc.get("whLocCode"));
    		        }
    		        else{
        		        params.put("hidSirimLoc","");
    		        }

    		        params.put("hidCategoryId","");
    		        params.put("hidStockCode","");
    		        params.put("hidFrmStockCode","");
    		        if(orderInfo.get("installEntryId") != null){
        		        params.put("hidCategoryId",orderInfo.get("stkCtgryId"));
        		        params.put("hidStockCode",orderInfo.get("stkCode"));
        		        params.put("hidFrmStockCode",orderInfo.get("stockCode"));
    		        }

    		        params.put("hidPromotionId","");
    		        params.put("hidPriceId","");
    		        params.put("hiddenOriPriceId","");
    		        params.put("hiddenOriPrice","");
    		        params.put("hiddenOriPV","");
    		        params.put("hiddenCatogory","");
    		        params.put("hiddenProductItem","");
    		        params.put("hidPERentAmt","");
    		        params.put("hidPEDefRentAmt","");
    		        params.put("hidInstallStatusCodeId","");
    		        params.put("hidPEPreviousStatus","");
    		        params.put("hidDocId","");
    		        params.put("hidOldPrice","");
    		        params.put("hidExchangeAppTypeId","");
    		        if(callType.get("typeId").toString().equals("258"))
    		        {
        		        params.put("hidPromotionId",orderInfo.get(("c8")));
        		        params.put("hidPriceId",orderInfo.get("c11"));
        		        params.put("hiddenOriPriceId",orderInfo.get("c11"));
        		        params.put("hiddenOriPrice",orderInfo.get(orderInfo.get("c12")));
        		        params.put("hiddenOriPV",orderInfo.get("c13"));
        		        params.put("hiddenProductItem",orderInfo.get("c7"));
        		        params.put("hidPERentAmt",orderInfo.get("c17"));
        		        params.put("hidPEDefRentAmt",orderInfo.get("c18"));
        		        params.put("hidInstallStatusCodeId",orderInfo.get("c19"));
        		        params.put("hidPEPreviousStatus",orderInfo.get("c20"));
        		        params.put("hidDocId",orderInfo.get("docId"));
        		        params.put("hidOldPrice",orderInfo.get("c15"));
        		        params.put("hidExchangeAppTypeId",orderInfo.get("c21"));
    		        }
    		        else
    		        {
        		        params.put("hidPromotionId",orderInfo.get(("c2")));
        		        params.put("hidPriceId",orderInfo.get("itmPrcId"));
        		        params.put("hiddenOriPriceId",orderInfo.get("itmPrcId"));
        		        params.put("hiddenOriPrice",orderInfo.get(orderInfo.get("c5")));
        		        params.put("hiddenOriPV",orderInfo.get("c6"));
        		        params.put("hiddenCatogory",orderInfo.get("codename1"));
        		        params.put("hiddenProductItem",orderInfo.get("stkDesc"));
        		        params.put("hidPERentAmt",orderInfo.get("c7"));
        		        params.put("hidPEDefRentAmt",orderInfo.get("c8"));
        		        params.put("hidInstallStatusCodeId",orderInfo.get("c9"));

    		        }

    		        params.put("hiddenCustomerType","");
    		        params.put("hiddenPostCode","");
    		        params.put("hiddenCountryName","");
    		        params.put("hiddenStateName","");
    		        params.put("hidPromoId",promotionView.get("promoId"));
    		        params.put("hidPromoPrice",promotionView.get("promoPrice"));
    		        params.put("hidPromoPV",promotionView.get("promoPV"));
    		        params.put("hidSwapPromoId",promotionView.get("swapPromoId"));
    		        params.put("hidSwapPromoPrice",promotionView.get("swapPormoPrice"));
    		        params.put("hidSwapPromoPV",promotionView.get("swapPromoPV"));
    		        params.put("hiddenInstallPostcode","");
    		        params.put("hiddenInstallPostcode","");
    		        params.put("hiddenInstallStateName","");
    		        params.put("hidCustomerName",customerInfo.get("name"));
    		        params.put("hidCustomerContact",customerContractInfo.get("telM1"));
    		        params.put("hidTaxInvDSalesOrderNo",installResult.get("salesOrdNo"));
    		        params.put("hidTradeLedger_InstallNo",installResult.get("installEntryNo"));

    		        if(callType.get("typeId").toString().equals("257"))
    		        {
        		        params.put("hidOutright_Price",orderInfo.get("c5"));
    		        }
    		        else if (callType.get("typeId").toString().equals("258"))
    		        {
        		        params.put("hidOutright_Price",orderInfo.get("c12"));
    		        }

    		        params.put("hidInstallation_AddDtl",installation.get("address"));
    		        params.put("hidInstallation_AreaID",installation.get("areaId"));
    		        params.put("hidInatallation_ContactPerson",customerContractInfo.get("name"));
    		        params.put("rcdTms",installResult.get("rcdTms"));
    		        params.put("hidSerialRequireChkYn",installResult.get("serialRequireChkYn"));
    		        params.put("hidFrmSerialChkYn",frameInfo.get("serialChk"));
    		        params.put("hidFrmOrdId",frameInfo.get("salesOrdId"));
    		        params.put("hidFrmOrdNo",frameInfo.get("salesOrdNo"));
    		        params.put("failDeptChk","");
    		        params.put("custType",basicInfo.get("custType"));
    		        params.put("hpPhoneNo",salesmanInfo.get("telMobile"));
    		        params.put("hpMemId",salesmanInfo.get("memId"));
    		        params.put("ordCtgryCd",basicInfo.get("ordCtgryCd"));
    		        params.put("hidDismantle","");

    		        Date todayDate = new Date();
    		        DateFormat dateParser = new SimpleDateFormat("dd/MM/yyyy");
    		        //User Key In Part
    		        params.put("installStatus",4); //DEFAULT COMPLETE INSTALLATION
    		        params.put("installDate", dateParser.format(todayDate)); //TODAY DATE
    		        params.put("ctCode",installResult.get("ctMemCode"));
    		        params.put("CTID",installResult.get("ctId"));
    		        params.put("sirimNo","");
    		        params.put("serialNo",preInstRecordResult.get("serialNo"));
    		        params.put("custMobileNo",installationInfo.get("instCntTelM"));
    		        params.put("chkSms","");
    		        params.put("frmSerialNo",preInstRecordResult.get("serialNo2"));
    		        params.put("dtPairCode","");
    		        params.put("refNo1","");
    		        params.put("refNo2","");
    		        params.put("gaspreBefIns","");
    		        params.put("totalWire","");
    		        params.put("gaspreAftIns","");
    		        params.put("installAcc","");
    		        params.put("checkCommission","on");
//    		        params.put("checkTrade",false);
    		        params.put("checkSms","on");
    		        params.put("checkSend","on");
    		        params.put("hpMsg","COWAY: Order No: " + installResult.get("salesOrdNo") + "\nName" + hpMember.get("name1") + " \nInstall Status: Completed");
    		        params.put("msgRemark","Remark:");
    		        params.put("failLocCde","");
    		        params.put("hiddenFailReasonCode","");
    		        params.put("failReasonCode","");
    		        params.put("nextCallDate","");
    		        params.put("remark",preInstRecordResult.get("remark"));

    		    	Map<String,Object> insertParams = new HashMap();
    		    	insertParams.put("installForm", params);

    				hcInstallResultListService.hcInsertInstallationResultSerial(insertParams, sessionVO);

    		    	Map<String,Object> preComResult = new HashMap();
    		    	preComResult.put("statusId",4);
    		    	preComResult.put("addRemark","Auto Pre-com Approve Completed");
    		    	preComResult.put("installEntryNo",preInstRecordResult.get("installEntryNo").toString());
    				hcInstallResultListService.updateSVC0136DAutoPreComStatus(preComResult);
    			} catch (Exception e) {
    		    	Map<String,Object> preComResult = new HashMap();
    		    	preComResult.put("statusId",21);
    		    	preComResult.put("addRemark",CommonUtils.nvl(e + "-" + e.getMessage()));
    		    	preComResult.put("installEntryNo",preInstRecordResultList.get(i).get("installEntryNo").toString());
    				hcInstallResultListService.updateSVC0136DAutoPreComStatus(preComResult);
    			}
    		}
    	}
    	return ResponseEntity.ok("Process Finished");
    }
}