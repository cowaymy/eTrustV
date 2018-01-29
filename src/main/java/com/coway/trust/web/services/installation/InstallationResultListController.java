package com.coway.trust.web.services.installation;

import java.math.BigDecimal;
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
import com.coway.trust.api.mobile.services.RegistrationConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services")
public class InstallationResultListController {
	private static final Logger logger = LoggerFactory.getLogger(InstallationResultListController.class);

	@Resource(name = "installationResultListService")
	private InstallationResultListService installationResultListService;
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;

	/**
	 * organization transfer page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationResultList.do")
	public String installationResultList(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> appTypeList = installationResultListService.selectApplicationType();
		logger.debug("appTypeList : {}", appTypeList);
		List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
		logger.debug("installStatus : {}", installStatus);

		model.addAttribute("appTypeList", appTypeList);
		model.addAttribute("installStatus", installStatus);
		// 호출될 화면
		return "services/installation/installationResultList";
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
		return "services/installation/installationResultPop";
	}
	
	
	
	@RequestMapping(value = "/viewInstallationResult.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> viewInstallationResult(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		logger.debug("params : {}", params);
		List<EgovMap> viewInstallation = installationResultListService.viewInstallationResult(params);
		logger.debug("viewInstallation : {}", viewInstallation);
		return ResponseEntity.ok(viewInstallation);
	}
	
		
		
		
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationListSearch.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectInstallationListSearch(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		String[] installStatusList = request.getParameterValues("installStatus");
		String[] typeList = request.getParameterValues("type");
		String[] appTypeList = request.getParameterValues("appType");

		params.put("installStatusList", installStatusList);
		params.put("typeList", typeList);
		params.put("appTypeList", appTypeList);
		List<EgovMap> installationResultList = installationResultListService.installationResultList(params);
		logger.debug("installationResultList : {}", installationResultList);
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
	@RequestMapping(value = "/installationResultDetailPop.do")
	public String installationResultDetail(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap callType = installationResultListService.selectCallType(params);
		EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
		EgovMap orderInfo = null;
		logger.debug("params1111111 {}",params);
		
		if(params.get("codeId").toString().equals("258")){
			orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
		}else{
			orderInfo = installationResultListService.getOrderInfo(params);
		}

		//EgovMap customerInfo = installationResultListService.getcustomerInfo(orderInfo == null ?installResult.get("custId") :  orderInfo.get("custId"));
		
		
		EgovMap customerInfo = installationResultListService.getcustomerInfo(orderInfo);
		//EgovMap customerAddress = installationResultListService.getCustomerAddressInfo(customerInfo);
		EgovMap customerContractInfo = installationResultListService.getCustomerContractInfo(customerInfo);
		EgovMap installation = installationResultListService.getInstallationBySalesOrderID(installResult);
		EgovMap installationContract = installationResultListService.getInstallContactByContactID(installation);
		EgovMap salseOrder = installationResultListService.getSalesOrderMBySalesOrderID(installResult);
		EgovMap hpMember= installationResultListService.getMemberFullDetailsByMemberIDCode(salseOrder);
		logger.debug("installResult : {}", installResult);
		logger.debug("orderInfo : {}", orderInfo);
		logger.debug("customerInfo : {}", customerInfo);
		logger.debug("customerContractInfo : {}", customerContractInfo);
		logger.debug("installation : {}", installation);
		logger.debug("installationContract : {}", installationContract);
		logger.debug("salseOrder : {}", salseOrder);
		logger.debug("hpMember : {}", hpMember);
		logger.debug("callType : {}", callType);
		//logger.debug("customerAddress : {}", customerAddress);
		model.addAttribute("installResult", installResult);
		model.addAttribute("orderInfo", orderInfo);
		model.addAttribute("customerInfo", customerInfo);
		//model.addAttribute("customerAddress", customerAddress);
		model.addAttribute("customerContractInfo", customerContractInfo);
		model.addAttribute("installationContract", installationContract);
		model.addAttribute("salseOrder", salseOrder);
		model.addAttribute("hpMember", hpMember);
		model.addAttribute("callType", callType);


		// 호출될 화면
		return "services/installation/installationResultDetailPop";
	}

	
	
	

	
	
	
	/**
	 * InstallationResultDetailPop View Installation Result
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/viewInstallationSearch.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectViewInstallationSearch(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		logger.debug("params : {}", params);
		List<EgovMap> viewInstallation = installationResultListService.selectViewInstallation(params);
		logger.debug("viewInstallation : {}", viewInstallation);
		return ResponseEntity.ok(viewInstallation);
	}

	/**
	 * InstallationResult Add Installation Result Popup
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/addInstallationPopup.do")
	public String addInstallationPopup(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
		params.put("ststusCodeId", 1);
		params.put("reasonTypeId", 172);
		List<EgovMap> failReason = installationResultListService.selectFailReason(params);
		EgovMap callType = installationResultListService.selectCallType(params);
		EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
		EgovMap stock = installationResultListService.getStockInCTIDByInstallEntryIDForInstallationView(installResult);
		EgovMap sirimLoc = installationResultListService.getSirimLocByInstallEntryID(installResult);

		EgovMap orderInfo = null;
		if(params.get("codeId").toString().equals("258")){
			orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
		}else{
			orderInfo = installationResultListService.getOrderInfo(params);
		}

		if(null == orderInfo){
			orderInfo = new EgovMap();
		}
		String promotionId = "";
		if(CommonUtils.nvl(params.get("codeId")).toString().equals("258")){
			promotionId = CommonUtils.nvl(orderInfo.get("c8"));
		}else{
			promotionId = CommonUtils.nvl(orderInfo.get("c2"));
		}

		if( promotionId.equals("")){
			promotionId="0";
		}

		logger.debug("promotionId : {}", promotionId);

		EgovMap promotionView = new EgovMap();

		List<EgovMap> CheckCurrentPromo  = installationResultListService.checkCurrentPromoIsSwapPromoIDByPromoID(Integer.parseInt( promotionId));
		if(CheckCurrentPromo.size() > 0){
			promotionView  = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(Integer.parseInt(promotionId), Integer.parseInt(installResult.get("installStkId").toString()),true);
		}else{
			if(promotionId != "0"){
				 promotionView  = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(Integer.parseInt(promotionId), Integer.parseInt(installResult.get("installStkId").toString()),false);

			}else{


				if(null == promotionView){
					promotionView = new EgovMap();
				}

				promotionView.put("promoId", "0");
				promotionView.put("promoPrice", CommonUtils.nvl(params.get("codeId")).toString() == "258" ? CommonUtils.nvl(orderInfo.get("c15")) : CommonUtils.nvl(orderInfo.get("c5")));
				promotionView.put("promoPV", CommonUtils.nvl(params.get("codeId")).toString() == "258" ?  CommonUtils.nvl(orderInfo.get("c16")) : CommonUtils.nvl(orderInfo.get("c6")));
				promotionView.put("swapPromoId","0");
				promotionView.put("swapPromoPV","0");
				promotionView.put("swapPormoPrice","0");
			}
		}
		
		logger.debug("paramsqqqq {}",params);
		Object custId =( orderInfo == null ? installResult.get("custId") :  orderInfo.get("custId") );
		params.put("custId", custId);
		EgovMap customerInfo = installationResultListService.getcustomerInfo(params);
		//EgovMap customerAddress = installationResultListService.getCustomerAddressInfo(customerInfo);
		EgovMap customerContractInfo = installationResultListService.getCustomerContractInfo(customerInfo);
		EgovMap installation = installationResultListService.getInstallationBySalesOrderID(installResult);
		EgovMap installationContract = installationResultListService.getInstallContactByContactID(installation);
		EgovMap salseOrder = installationResultListService.getSalesOrderMBySalesOrderID(installResult);
		EgovMap hpMember= installationResultListService.getMemberFullDetailsByMemberIDCode(salseOrder);

		//if(params.get("codeId").toString().equals("258")){

		//}


		logger.debug("installResult : {}", installResult);
		logger.debug("orderInfo : {}", orderInfo);
		logger.debug("customerInfo : {}", customerInfo);
		logger.debug("customerContractInfo : {}", customerContractInfo);
		logger.debug("installation : {}", installation);
		logger.debug("installationContract : {}", installationContract);
		logger.debug("salseOrder : {}", salseOrder);
		logger.debug("hpMember : {}", hpMember);
		logger.debug("callType : {}", callType);
		logger.debug("failReason : {}", failReason);
		logger.debug("installStatus : {}",installStatus);
		logger.debug("stock : {}",stock);
		logger.debug("sirimLoc : {}",sirimLoc);
		logger.debug("promotionView : {}",promotionView);
		logger.debug("CheckCurrentPromo : {}",CheckCurrentPromo);
		//logger.debug("customerAddress : {}", customerAddress);
		model.addAttribute("installResult", installResult);
		model.addAttribute("orderInfo", orderInfo);
		model.addAttribute("customerInfo", customerInfo);
		//model.addAttribute("customerAddress", customerAddress);
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

		// 호출될 화면
		return "services/installation/addInstallationResultPop";
	}

	/**
	 * Installation Result DetailPopup
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/addinstallationResultProductDetailPop.do")
	public String installationResultProductExchangeDetail(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVOl) throws Exception {
		logger.debug("params : {}",params);
		EgovMap viewDetail = installationResultListService.selectViewDetail(params);
		//Order Detail Tab
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params ,sessionVOl);
		model.addAttribute("viewDetail", viewDetail);
		model.addAttribute("orderDetail", orderDetail);
		
		// 180125_추가
		List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
		params.put("ststusCodeId", 1);
		params.put("reasonTypeId", 172);
		List<EgovMap> failReason = installationResultListService.selectFailReason(params);
		EgovMap callType = installationResultListService.selectCallType(params);
		EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
		EgovMap stock = installationResultListService.getStockInCTIDByInstallEntryIDForInstallationView(installResult);
		EgovMap sirimLoc = installationResultListService.getSirimLocByInstallEntryID(installResult);

		EgovMap orderInfo = null;
		if(params.get("codeId").toString().equals("258")){
			orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
		}else{
			orderInfo = installationResultListService.getOrderInfo(params);
		}

		if(null == orderInfo){
			orderInfo = new EgovMap();
		}
		String promotionId = "";
		if(CommonUtils.nvl(params.get("codeId")).toString().equals("258")){
			promotionId = CommonUtils.nvl(orderInfo.get("c8"));
		}else{
			promotionId = CommonUtils.nvl(orderInfo.get("c2"));
		}

		if( promotionId.equals("")){
			promotionId="0";
		}

		logger.debug("promotionId : {}", promotionId);

		EgovMap promotionView = new EgovMap();

		List<EgovMap> CheckCurrentPromo  = installationResultListService.checkCurrentPromoIsSwapPromoIDByPromoID(Integer.parseInt( promotionId));
		if(CheckCurrentPromo.size() > 0){
			promotionView  = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(Integer.parseInt(promotionId), Integer.parseInt(installResult.get("installStkId").toString()),true);
		}else{
			if(promotionId != "0"){
				 promotionView  = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(Integer.parseInt(promotionId), Integer.parseInt(installResult.get("installStkId").toString()),false);

			}else{


				if(null == promotionView){
					promotionView = new EgovMap();
				}

				promotionView.put("promoId", "0");
				promotionView.put("promoPrice", CommonUtils.nvl(params.get("codeId")).toString() == "258" ? CommonUtils.nvl(orderInfo.get("c15")) : CommonUtils.nvl(orderInfo.get("c5")));
				promotionView.put("promoPV", CommonUtils.nvl(params.get("codeId")).toString() == "258" ?  CommonUtils.nvl(orderInfo.get("c16")) : CommonUtils.nvl(orderInfo.get("c6")));
				promotionView.put("swapPromoId","0");
				promotionView.put("swapPromoPV","0");
				promotionView.put("swapPormoPrice","0");
			}
		}
		
		logger.debug("paramsqqqq {}",params);
		Object custId =( orderInfo == null ? installResult.get("custId") :  orderInfo.get("custId") );
		params.put("custId", custId);
		EgovMap customerInfo = installationResultListService.getcustomerInfo(params);
		//EgovMap customerAddress = installationResultListService.getCustomerAddressInfo(customerInfo);
		EgovMap customerContractInfo = installationResultListService.getCustomerContractInfo(customerInfo);
		EgovMap installation = installationResultListService.getInstallationBySalesOrderID(installResult);
		EgovMap installationContract = installationResultListService.getInstallContactByContactID(installation);
		EgovMap salseOrder = installationResultListService.getSalesOrderMBySalesOrderID(installResult);
		EgovMap hpMember= installationResultListService.getMemberFullDetailsByMemberIDCode(salseOrder);

		//if(params.get("codeId").toString().equals("258")){

		//}


		logger.debug("installResult : {}", installResult);
		logger.debug("orderInfo : {}", orderInfo);
		logger.debug("customerInfo : {}", customerInfo);
		logger.debug("customerContractInfo : {}", customerContractInfo);
		logger.debug("installation : {}", installation);
		logger.debug("installationContract : {}", installationContract);
		logger.debug("salseOrder : {}", salseOrder);
		logger.debug("hpMember : {}", hpMember);
		logger.debug("callType : {}", callType);
		logger.debug("failReason : {}", failReason);
		logger.debug("installStatus : {}",installStatus);
		logger.debug("stock : {}",stock);
		logger.debug("sirimLoc : {}",sirimLoc);
		logger.debug("promotionView : {}",promotionView);
		logger.debug("CheckCurrentPromo : {}",CheckCurrentPromo);
		//logger.debug("customerAddress : {}", customerAddress);
		model.addAttribute("installResult", installResult);
		model.addAttribute("orderInfo", orderInfo);
		model.addAttribute("customerInfo", customerInfo);
		//model.addAttribute("customerAddress", customerAddress);
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

		// 호출될 화면
		return "services/installation/addInstallationResultProductDetailPop";
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws ParseException
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveInstallationProductExchange.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertInstallationProductExchange(@RequestBody Map<String, Object> params,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();
		logger.debug("params : {}", params);

		boolean success = false;

		success = installationResultListService.insertInstallationProductExchange(params, sessionVO);

		return ResponseEntity.ok(message);
	}

	/**
	 * Search rule book management list
	 *
	 * @param requestaddInstallation
	 * @param model
	 * @return
	 * @throws ParseException
	 * @throws Exception
	 */
	@RequestMapping(value = "/addInstallation.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertInstallationResult(@RequestBody Map<String, Object> params,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();
		logger.debug("params : {}", params);

		boolean success = false;
		EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
		EgovMap locInfo = installationResultListService.getLocInfo(installResult);
		
		
		EgovMap validMap =  installationResultListService.validationInstallationResult(params);
		int resultCnt = ((BigDecimal)validMap.get("resultCnt")).intValue();
		
		//failed  add  by hgham 
		if(CommonUtils.nvl(params.get("installStatus")).equals("21")){
		
			if(resultCnt > 0){
				message.setMessage("There is complete result exist already, 'ResultID : "+validMap.get("resultId")+". Can't save the result again");
    		} else {
    			resultValue = installationResultListService.insertInstallationResult(params, sessionVO);
    			if( null !=resultValue){
        			HashMap   spMap =(HashMap)resultValue.get("spMap");
        			logger.debug("spMap :"+ spMap.toString());
        			if(!"000".equals(spMap.get("P_RESULT_MSG"))){
        				resultValue.put("logerr","Y");
        				message.setMessage("Error in Logistics Transaction !");
        			}else{
        				message.setData("Y");
        				message.setMessage(resultValue.get("value") + " to " + resultValue.get("installEntryNo"));
        			}
        			servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
        		}
    		}
			
			
		}else{
		if(locInfo==null){
				message.setMessage("Can't complete the Installation without available stock in the CT");
			}else{
				if(Integer.parseInt(locInfo.get("availQty").toString())<1){
					message.setMessage("Can't complete the Installation without available stock in the CT");
				}else{    		
	        	
	        		if(resultCnt > 0){
	        			message.setMessage("There is complete result exist already, 'ResultID : "+validMap.get("resultId")+". Can't save the result again");
	        		} else {
	            		resultValue = installationResultListService.insertInstallationResult(params, sessionVO);
	            		
	            		if( null !=resultValue){
	            			HashMap   spMap =(HashMap)resultValue.get("spMap");
	            			logger.debug("spMap :"+ spMap.toString());
	            			if(!"000".equals(spMap.get("P_RESULT_MSG"))){
	        
	            				resultValue.put("logerr","Y");
	            				message.setMessage("Error in Logistics Transaction !");
	        
	            			}else{
	            				message.setData("Y");
	            				message.setMessage(resultValue.get("value") + " to " + resultValue.get("installEntryNo"));
	        
	            			}
	            			servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
	            		}
	            		}
			}
			}
		
		}
		
		
		return ResponseEntity.ok(message);
	}




	@RequestMapping(value = "/assignCTTransferPop.do")
	public String assignCTTransferPop(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  assignCTTransferPop ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		// 호출될 화면
		return "services/installation/assignCTTransferPop";
	}



	@RequestMapping(value = "/assignCtList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> assignCtList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("in  assignCtList.....");
		logger.debug("params : {}", params.toString());
		//BRNCH_ID
		List<EgovMap>  list = installationResultListService.assignCtList(params);

		return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/assignCtOrderList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> assignCtOrderList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		logger.debug("in  assignCtOrderList.....");
		logger.debug("params : {}", params.toString());

		String vAsNo =  (String)params.get("installNo");
		String[] asNo =  null;

		if(! StringUtils.isEmpty(vAsNo)){
			asNo =  ((String)params.get("installNo")).split(",");
			params.put("installNo" ,asNo);
		}

		List<EgovMap>  list =  installationResultListService.assignCtOrderList(params);

		return ResponseEntity.ok(list);
	}




	@RequestMapping(value = "/assignCtOrderListSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> assignCtOrderListSave(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

		logger.debug("in  assignCtOrderListSave ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		params.put("updator", sessionVO.getUserId());
		List<EgovMap>  update 	= (List<EgovMap>)  params.get("update");
		logger.debug("asResultM ===>"+update.toString());

		Map<String, Object> returnValue = new HashMap<String, Object>();
		returnValue = installationResultListService.updateAssignCT(params);
		
		logger.debug("rtnValue ===> "+returnValue);
		
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
		successList =  (List<String>) returnValue.get("successList");
		failList =  (List<String>) returnValue.get("failList");
		
		if (successCnt > 0) {
			content += "<br/>Complete INS Number : ";
			for (int i=0; i<successCnt; i++) {
				successCon += successList.get(i) + ", ";
			}
			successCon = successCon.substring(0, successCon.length()-2);
			content += successCon;
		}
		
		if (failCnt > 0) {
			content += "<br/>Fail INS Number : ";
			for (int i=0; i<failCnt; i++) {
				failCon += failList.get(i) + ", ";
			}
			failCon = failCon.substring(0, failCon.length()-2);
			content += failCon;
			content += "<br/>Can't transfer CT to the Installation order";
		}
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(99);
		message.setMessage(content);
		
		/*if (rtnValue == -1) {
			message.setCode(AppConstants.FAIL);
			message.setMessage("Can't transfer CT to the Installation order");
		} else {
			message.setCode(AppConstants.SUCCESS);
			message.setData(99);
			message.setMessage("");
		}*/
		
		logger.debug("message : {}", message);
		return ResponseEntity.ok(message);

	}

	/**
	 * organization transfer page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationNotePop.do")
	public String installationNotePop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/installation/installationNotePop";
	}

	/**
	 * Installation Report Do Active List
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/doActiveListPop.do")
	public String doActiveListPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/installation/doActiveListPop";
	}

	/**
	 * Installation Report Do Active List
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dailyDscReportPop.do")
	public String dailyDscReportPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/installation/dailyDscReportPop";
	}

	/**
	 * Installation Report Installation Raw Data
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationRawDataPop.do")
	public String installationRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/installation/installationRawDataPop";
	}

	/**
	 * Installation Report Installation Log Book Listing
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationLogBookPop.do")
	public String installationLogBookPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/installation/installationLogBookListingPop";
	}

	/**
	 * Installation Report Installation Note Listing
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationNoteListingPop.do")
	public String installationNoteListingPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/installation/installationNoteListingPop";
	}

	/**
	 * Installation Report Installation Note Listing Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws ParseException
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectInstallationNoteListing.do")
	public  ResponseEntity<List<EgovMap>> selectInstallationNoteListing(@RequestParam Map<String, Object> params,SessionVO sessionVO) throws ParseException {
		logger.debug("params : {}", params);
		  installationResultListService.selectInstallationNoteListing(params);

		  List<EgovMap>  list =  (List<EgovMap>)params.get("cv_1");
		  logger.debug("list : {}", list);
		return ResponseEntity.ok(list);
	}

	/**
	 * Installation Report Installation Free Gift List
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationFreeGiftListPop.do")
	public String installationFreeGiftListPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/installation/installationFreeGiftListPop";
	}

	/**
	 * Installation Report Installation Free Gift List
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationDscReportPop.do")
	public String installationDscReportPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/installation/dscReportDataPop";
	}

	/**
	 * InstallationResult edit Installation Result Popup
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/editInstallationPopup.do")
	public String editInstallationPopup(@RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap installInfo = installationResultListService.selectInstallInfo(params);
		model.addAttribute("installInfo", installInfo);
		// 호출될 화면
		return "services/installation/editInstallationResultPop";
	}

	@RequestMapping(value = "/editInstallation.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> editInstallationResult(@RequestBody Map<String, Object> params,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();
		int resultValue = 0;

		int userId = sessionVO.getUserId();
		params.put("user_id", userId);
		logger.debug("params : {}", params);
	
		resultValue = installationResultListService.editInstallationResult(params, sessionVO);
		if(resultValue>0){
			message.setMessage("Installation result successfully updated.");
		}else{
			message.setMessage("Failed to update installation result. Please try again later.");
		}

		return ResponseEntity.ok(message);
	}
}
