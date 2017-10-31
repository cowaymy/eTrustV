package com.coway.trust.web.services.installation;

import java.text.ParseException;
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
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

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
		if(params.get("codeId").toString().equals("258")){
			orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
		}else{
			orderInfo = installationResultListService.getOrderInfo(params);
		}
		
		EgovMap customerInfo = installationResultListService.getcustomerInfo(orderInfo == null ?installResult.get("custId") :  orderInfo.get("custId"));
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
		String promotionId = "";
		if(params.get("codeId").toString().equals("258")){
			promotionId = orderInfo.get("c8").toString();
		}else{
			promotionId = orderInfo.get("c2").toString();
		}
		logger.debug("promotionId : {}", promotionId);
		EgovMap promotionView = null;
		List<EgovMap> CheckCurrentPromo  = installationResultListService.checkCurrentPromoIsSwapPromoIDByPromoID(Integer.parseInt(promotionId));
		if(CheckCurrentPromo.size() > 0){
			promotionView  = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(Integer.parseInt(promotionId), Integer.parseInt(installResult.get("installStkId").toString()),true);
		}else{
			if(promotionId != "0"){
				 promotionView  = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(Integer.parseInt(promotionId), Integer.parseInt(installResult.get("installStkId").toString()),false);
				
			}else{
				promotionView.put("promoId", "0");
				promotionView.put("promoPrice", params.get("codeId").toString() == "258" ? orderInfo.get("c15") : orderInfo.get("c5"));
				promotionView.put("promoPV", params.get("codeId").toString() == "258" ? orderInfo.get("c16") : orderInfo.get("c6"));
				promotionView.put("swapPromoId","0");
				promotionView.put("swapPromoPV","0");
				promotionView.put("swapPormoPrice","0");
			}
		}
		EgovMap customerInfo = installationResultListService.getcustomerInfo(orderInfo == null ?installResult.get("custId") :  orderInfo.get("custId"));
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
	public String installationResultProductExchangeDetail(@RequestParam Map<String, Object> params, ModelMap mode ,SessionVO sessionVOl) throws Exception {
		logger.debug("params : {}",params);
		EgovMap viewDetail = installationResultListService.selectViewDetail(params);
		//Order Detail Tab
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params ,sessionVOl);
		mode.addAttribute("viewDetail", viewDetail);
		mode.addAttribute("orderDetail", orderDetail);
		
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
		
		resultValue = installationResultListService.insertInstallationResult(params, sessionVO);
		
		message.setMessage(resultValue.get("value") + " to " + resultValue.get("installEntryNo"));
		
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
		
		int   rtnValue = installationResultListService.updateAssignCT(params);  
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(99);
		message.setMessage("");

				
		return ResponseEntity.ok(message);  
		
	}
	
	
}
