package com.coway.trust.web.sales.ccp;

import java.math.BigDecimal;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.ccp.CcpRentMemShipService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ccp")
public class CcpRentMemShipController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpRentMemShipController.class);
	
	@Resource(name = "ccpRentMemShipService")
	private CcpRentMemShipService ccpRentMemShipService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@RequestMapping(value = "/selectCcpRentList.do")
	public String selectCcpRentList (@RequestParam Map<String, Object>  Params) throws Exception{
		LOGGER.info("################ go To Ccp Rent Membership List");
		
		return "sales/ccp/ccpRentMemShipList";
	}
	
	
	@RequestMapping(value = "/getBranchCodeList")
	public ResponseEntity<List<EgovMap>> getBranchCodeList() throws Exception{
		
		LOGGER.info("#############################################");
		LOGGER.info("#############get Branch Code List Start");
		LOGGER.info("#############################################");
		
		List<EgovMap> branchMap = null;
		
		branchMap = ccpRentMemShipService.getBranchCodeList();
		
		return ResponseEntity.ok(branchMap);
		
	}
	
	
	@RequestMapping(value = "/getReasonCodeList")
	public ResponseEntity<List<EgovMap>> getReasonCodeList()throws Exception{
		
		LOGGER.info("#############################################");
		LOGGER.info("#############getReasonCodeList Start");
		LOGGER.info("#############################################");
		
		List<EgovMap> regionMap = null;
		
		regionMap = ccpRentMemShipService.getReasonCodeList();
		
		return ResponseEntity.ok(regionMap);
		
	}
	
	
	@RequestMapping(value = "/selectCcpRentListSearchList")
	public ResponseEntity<List<EgovMap>> selectCcpRentListSearchList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{
		
		LOGGER.info("#############################################");
		LOGGER.info("#############selectCcpRentListSearchList Start");
		LOGGER.info("#############################################");
		
		String arryStatus[] = request.getParameterValues("memShipStatus");
		String arryBranch[] = request.getParameterValues("keyInBranch");
		String arryReason[] = request.getParameterValues("reasonCode");
	
		//params Set
		params.put("arryStatus", arryStatus);
		params.put("arryBranch", arryBranch);
		params.put("arryReason", arryReason);
		
		List<EgovMap> resultList = null;
		
		resultList = ccpRentMemShipService.selectCcpRentListSearchList(params);
		
		return ResponseEntity.ok(resultList);
		
		
	}
	
	
	@RequestMapping(value = "/selectCcpRentDetailVeiwPop.do")
	public String selectCcpRentDetailVeiw(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		LOGGER.info("#############################################");
		LOGGER.info("#############selectCcpRentDetailVeiw Start");
		LOGGER.info("#############################################");
		
		EgovMap contractMap = null;
		Map<String, Object> unbillMap = null;
		EgovMap orderInfoMap = null; 
		EgovMap installMap = null;
		EgovMap cofigMap = null;
		EgovMap payMap = null;
		EgovMap thirdMap = null;
		EgovMap mailMap = null;
		
		//Basic Info
		LOGGER.info("_____________________________________________ (1)");
		contractMap =  ccpRentMemShipService.selectServiceContract(params);
		LOGGER.info("_____________________________________________ (2)");
		params.put("srvCntrctOrdId", contractMap.get("srvCntrctOrdId")); //Order Id
		
		//fee and Amount (Basic Info)
		LOGGER.info("_____________________________________________ (3)");
		unbillMap = ccpRentMemShipService.selectServiceContactBillingInfo(params);
		LOGGER.info("_____________________________________________ (4)");
		
		//Order Info
		LOGGER.info("_____________________________________________ (5)");
		orderInfoMap = ccpRentMemShipService.selectOrderInfo(params);
		LOGGER.info("_____________________________________________ (6)");
		
		installMap = ccpRentMemShipService.selectOrderInfoInstallation(params);
		LOGGER.info("_____________________________________________ (7)");
		cofigMap = ccpRentMemShipService.selectSrvMemConfigInfo(params);
		LOGGER.info("_____________________________________________ (8)");
		
		//Payment Info
		LOGGER.info("_____________________________________________ (9)");
		payMap = ccpRentMemShipService.selectPaySetInfo(params);
		LOGGER.info("_____________________________________________ (10)");
		
		if(payMap != null){
			BigDecimal thirdPartyDec = (BigDecimal)payMap.get("is3rdParty");
			
			if(thirdPartyDec.intValue() == 1){
				
				params.put("custId", payMap.get("custId"));
				LOGGER.info("_____________________________________________ (11)");
				thirdMap = ccpRentMemShipService.selectCustThridPartyInfo(params);
				LOGGER.info("_____________________________________________ (12)");
			}
		}
		
		//Mailing Info
		params.put("salesOrderId", params.get("srvCntrctOrdId"));
		LOGGER.info("_____________________________________________ (13)");
		mailMap = ccpRentMemShipService.selectOrderMailingInfoByOrderID(params);
		LOGGER.info("_____________________________________________ (14)");
		
		model.addAttribute("cnfmCntrctId", params.get("cnfmCntrctId"));
		model.addAttribute("contractInfo", contractMap);
		model.addAttribute("unbillMap", unbillMap);
		model.addAttribute("orderInfoMap", orderInfoMap);
		model.addAttribute("orderInfoMap", orderInfoMap);
		model.addAttribute("installMap", installMap);
		model.addAttribute("cofigMap", cofigMap);
		model.addAttribute("payMap", payMap);
		model.addAttribute("thirdMap", thirdMap); //3rdParty
		model.addAttribute("mailMap", mailMap);
		
		return "sales/ccp/ccpRentMemShipConfirmationViewPop";
		
	}
	
	
	@RequestMapping(value = "/selectPaymentList")
	public ResponseEntity<List<EgovMap>> selectPaymentList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> payList = null;
		
		payList = ccpRentMemShipService.selectPaymentList(params);
		
		return ResponseEntity.ok(payList);
	}
	
	
	@RequestMapping(value = "/selectCallLogList")
	public ResponseEntity<List<EgovMap>> selectCallLogList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> callList = null;
		
		callList = ccpRentMemShipService.selectCallLogList(params);
		
		return ResponseEntity.ok(callList);
		
	}
	
	
	@RequestMapping(value = "/selectCcpConfirmResultPop.do")
	public String	selectCcpConfirmResultPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		EgovMap confirmResultMap = null;
		EgovMap orderInfoMap = null;
		EgovMap cofigMap = null;
		EgovMap custBasicMap = null;
		EgovMap installMap = null;
		EgovMap payMap = null;
		EgovMap thirdMap = null;
		EgovMap contactMap = null;
		
		//Confirmation Result Info <params : cnfmCntrctId  (Contract ID)> 
		confirmResultMap = ccpRentMemShipService.confirmationInfoByContractID(params);
		
		//param Setting
		params.put("custId", confirmResultMap.get("custId")); //custId
		params.put("srvCntrctOrdId", confirmResultMap.get("srvCntrctOrdId")); //SalesOrdId
		
		//Order Info
		orderInfoMap = ccpRentMemShipService.selectOrderInfo(params);
		cofigMap = ccpRentMemShipService.selectSrvMemConfigInfo(params);
		
		//Customer Basic Info
		custBasicMap = ccpRentMemShipService.selectCustBasicInfo(params);
		
		//Installation Address
		installMap = ccpRentMemShipService.selectOrderInfoInstallation(params);
		
		//PayMode
		//Payment Info
		payMap = ccpRentMemShipService.selectPaySetInfo(params);
		
		if(payMap != null){
			BigDecimal thirdPartyDec = (BigDecimal)payMap.get("is3rdParty");
			
			if(thirdPartyDec.intValue() == 1){
				
				params.put("custId", payMap.get("custId"));
				thirdMap = ccpRentMemShipService.selectCustThridPartyInfo(params);
			}
		}
		
		//Contact Info
		contactMap = ccpRentMemShipService.selectContactPerson(params);
		
		model.addAttribute("cnfmCntrctId", params.get("cnfmCntrctId"));
		model.addAttribute("srvCntrctId", params.get("srvCntrctId"));
		model.addAttribute("confirmResultMap", confirmResultMap);
		model.addAttribute("orderInfoMap", orderInfoMap);
		model.addAttribute("cofigMap", cofigMap);
		model.addAttribute("custBasicMap", custBasicMap);
		model.addAttribute("installMap", installMap);
		model.addAttribute("payMap", payMap);
		model.addAttribute("thirdMap", thirdMap); //3rdParty
		model.addAttribute("contactMap", contactMap);
		
		
		return "sales/ccp/ccpRentMemShipConfirmResultPop";
		
	}
	
	
	@RequestMapping(value="/insUpdConfrimResult.do")
	public ResponseEntity<ReturnMessage> insUpdConfrimResult(@RequestParam Map<String, Object> params) throws Exception{
		
		//TODO 하단참조
		/*
		 * ASIS 에 SalesOrder 관련 파라미터를 받는 부분이 없어 무조건 0 으로 처리됨 .
		 * 화면단에 뿌려진 Sales Order Number(updSalesOrdNo) 를 TOBE 에서 추가하여 Cancel 의 Insert 에서 Parameter를 추가 하여 처리함
		 * CcpRentMemShip_SQL.xml >  insertServiceContractTerminations
		 * 
		 * 확인 필요.
		 *   
		 * */
		
		LOGGER.info("#############################################");
		LOGGER.info("#############insUpdConfrimResult Start");
		LOGGER.info("#############################################");
		LOGGER.info("############# insert Params Confrim : " + params.toString());
		
		//params Setting
		SessionVO session = sessionHandler.getCurrentSessionInfo();
		params.put("userId", session.getUserId());
		
		//Service Call
		ccpRentMemShipService.insUpdConfrimResult(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
		
	}
}
