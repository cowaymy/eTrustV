package com.coway.trust.web.payment.billinggroup.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.billinggroup.service.BillingGroupService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BillingGroupController {
	
	@Resource(name = "billingGroupService")
	private BillingGroupService billGroupService;
	
	/**
	 * BillGroupManagement 초기 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillGroupManagement.do")
	public String initBillGroupManagement(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("ord_No", params.get("ord_No"));
		return "payment/billinggroup/billGroupManagement";
	}
	
	/**
	 * BillGroupManagementAdmin 초기 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillGroupManagementAdmin.do")
	public String initBillGroupManagementAdmin(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("ord_No", params.get("ord_No"));
		return "payment/billinggroup/billGroupManagementAdmin";
	}
	
	/**
	 * AddNewGroup 초기 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initAddNewGroup.do")
	public String initAddNewGroup(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billinggroup/billGrpMng_addNwGrp";
	}
	
	/**
	 * initChangeBillingTypePop 초기 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initChangeBillingTypePop.do")
	public String initChangeBillingTypePop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callPrgm", params.get("callPrgm"));
		model.addAttribute("custBillId", params.get("custBillId"));
		return "payment/billinggroup/changeBillingTypePop";
	}
	
	/**
	 * billGroupMngEstmConfirm 초기 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initbillGroupMngEstmConfirm.do")
	public String initbillGroupMngEstmConfirm(@RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap selectEStatementReqs = billGroupService.selectEStatementReqs(params);
		String stusCodeId = selectEStatementReqs.get("stusCodeId") != null ? String.valueOf(selectEStatementReqs.get("stusCodeId")) : "";
		String message;

		if(selectEStatementReqs != null){

			if("44".equals(stusCodeId)){

				Map<String, Object> insHisMap = new HashMap<String, Object>();
				insHisMap.put("custBillId", String.valueOf(selectEStatementReqs.get("custBillId")));
				insHisMap.put("userId", 0);
				insHisMap.put("reasonUpd", "[System] Customer confirmed E-Statement.");
				insHisMap.put("salesOrderIDOld", 0);
				insHisMap.put("salesOrderIDNew", 0);
				insHisMap.put("contactIDOld", 0);
				insHisMap.put("contactIDNew", 0);
				insHisMap.put("addressIDOld", 0);
				insHisMap.put("addressIDNew", 0);
				insHisMap.put("statusIDOld", 0);
				insHisMap.put("statusIDNew", 0);
				insHisMap.put("remarkOld", "");
				insHisMap.put("remarkNew", "");
				insHisMap.put("emailOld", "");
				insHisMap.put("emailNew", String.valueOf(selectEStatementReqs.get("email")));
				insHisMap.put("isEStatementOld", 0);
				insHisMap.put("isEStatementNew", 1);
				insHisMap.put("isSMSOld", 0);
				insHisMap.put("isSMSNew", 0);
				insHisMap.put("isPostOld", 0);
				insHisMap.put("isPostNew", 0);
				insHisMap.put("typeId", 1047);
				insHisMap.put("sysHisRemark", "[System] E-Statement Confirm");

				boolean updResult = billGroupService.updEStatementConfirm(selectEStatementReqs, insHisMap);

				if(updResult){
					message = "<span style='font-size:20px;font-family:Arial;font-weight:bold'>Registration successful.</span><br /><br />" +
							"<span style='font-size:20px;font-family:Arial;font-weight:bold'>Thank You.</span><br /><br /><br />" +
							"<span style='font-size:12px;font-family:Arial;'>Your subscription has been confirmed. You have been added to our system listing.</span><br />" +
							"<span style='font-size:12px;font-family:Arial;'>E-invoice will be sent to your registered email on next billing cycle.</span><br /><br />" +
							"<span style='font-size:12px;font-family:Arial;'>This message is an automated reply to your registration request.</span><br />";
				}else{
					message = "<span style='font-size:15px;color:red;'>* Sorry! Verification is unsuccessful.<br />" +
							"Please try again later or kindly contact Coway customer hotline 1800-888-111 for assistance.</span>";
				}

			}else if("5".equals(stusCodeId)){
				message = "<span style='font-size:15px;color:red;'>* Invalid request. Your e-mail is already registered.<br />" +
						"For other query, kindly contact Coway customer hotline 1800-888-111 for assistance.</span>";
			}else if("10".equals(stusCodeId)){
				message = "<span style='font-size:15px;color:red;'>* Invalid request. The link has expired.<br />" +
						"Kindly contact Coway customer hotline 1800-888-111 to request for a new link.</span>";
			}else{
				message = "<span style='font-size:15px;color:red;'>* Invalid request. The link has expired.<br />" +
						"Kindly contact Coway customer hotline 1800-888-111 to request for a new link.</span>";
			}


		}else{
			message = "<span style='font-size:15px;color:red;'>* Invalid request. The link has expired.<br />" +"Kindly contact Coway customer hotline 1800-888-111 to request for a new link.";
		}

		model.addAttribute("message", message);

		return "message/paymentConfirmation";
	}
	
	/**
	 * 주문 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectBillGroup", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectBillGroup(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		
        //고객아이디 조회
        String getCustId = billGroupService.selectCustBillId(params);
        EgovMap selectBasicInfo = new EgovMap();
        EgovMap selectMailInfo = new EgovMap();
        EgovMap selecContractInfo = new EgovMap();
        List<EgovMap> selectGroupList = new ArrayList<EgovMap>();
        List<EgovMap> selectEstmReqHistory = new ArrayList<EgovMap>();
        String resultMessage = "";
        String defaultDate = "1900-01-01";
        
        if( getCustId != null){
        	
        	getCustId = getCustId != null ? getCustId : "";
        	Map<String, Object> custMap = new HashMap<String, Object>();
        	custMap.put("custBillId", getCustId);
        	custMap.put("defaultDate", defaultDate);
        	//Basic Info 조회
            selectBasicInfo = billGroupService.selectBasicInfo(custMap);
            
            Map<String, Object> mailMap = new HashMap<String, Object>();
            Map<String, Object> contractMap = new HashMap<String, Object>();
            Map<String, Object> groupMap = new HashMap<String, Object>();
            String custBillAddId = "";
            String custBillCntId = "";
            String custBillId = "";
            
            if(selectBasicInfo != null){
            	custBillAddId = selectBasicInfo.get("custBillAddId") != null ? String.valueOf(selectBasicInfo.get("custBillAddId")) : ""  ;
                custBillCntId = selectBasicInfo.get("custBillCntId") != null ? String.valueOf(selectBasicInfo.get("custBillCntId")) : "";
                custBillId = selectBasicInfo.get("custBillId") != null ? String.valueOf(selectBasicInfo.get("custBillId")) : "";
            }
            
            mailMap.put("custBillAddId", custBillAddId);
            mailMap.put("defaultDate", defaultDate);
            selectMailInfo = billGroupService.selectMaillingInfo(mailMap);
            
            contractMap.put("defaultDate", defaultDate);
            contractMap.put("custBillCntId", custBillCntId);
            selecContractInfo = billGroupService.selectContractInfo(contractMap);
            
            groupMap.put("defaultDate", defaultDate);
            groupMap.put("custBillId", custBillId);
            selectGroupList = billGroupService.selectOrderGroupList(groupMap);
            
            selectEstmReqHistory = billGroupService.selectEstmReqHistory(groupMap);
        	
        }else{
        	
        	resultMessage = "No billing group found for this order.";
        	selectBasicInfo = null;
        	getCustId = "";
        	
        }

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("selectBasicInfo", selectBasicInfo);
        resultMap.put("selectMaillingInfo", selectMailInfo);
        resultMap.put("selecContractInfo", selecContractInfo);
        resultMap.put("selectGroupList", selectGroupList);
        resultMap.put("selectEstmReqHistory", selectEstmReqHistory);
        resultMap.put("custBillId", getCustId);
        
        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
    	message.setMessage(resultMessage);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectBillGrpHistory 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectBillGrpHistory", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBillGrpHistory(@RequestParam Map<String, Object> params, ModelMap model) {
        // 조회.
        List<EgovMap> resultList = billGroupService.selectBillGrpHistory(params);
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/**
	 * selectChangeOrder 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectChangeOrder", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectChangeOrder(@RequestParam Map<String, Object> params, ModelMap model) {
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		// 조회.
		EgovMap selectBasicInfo = billGroupService.selectBasicInfo(params);
		EgovMap grpOrder = billGroupService.selectBillGrpOrder(params);
		List<EgovMap> selectBillGroupOrderView = billGroupService.selectBillGroupOrderView(params);
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("basicInfo", selectBasicInfo);
        resultMap.put("grpOrder", grpOrder);
        resultMap.put("billGroupOrderView", selectBillGroupOrderView);
        
        // 조회 결과 리턴.
        ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectUpdRemark 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectUpdRemark", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectUpdRemark(@RequestParam Map<String, Object> params, ModelMap model) {
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		// 조회.
		EgovMap selectBasicInfo = billGroupService.selectBasicInfo(params);
		EgovMap grpOrder = billGroupService.selectBillGrpOrder(params);
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("basicInfo", selectBasicInfo);
        resultMap.put("grpOrder", grpOrder);
        
        // 조회 결과 리턴.
        ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectChangeBillType 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectChangeBillType", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectChangeBillType(@RequestParam Map<String, Object> params, ModelMap model) {
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		// 조회.
		EgovMap selectBasicInfo = billGroupService.selectBasicInfo(params);
		EgovMap grpOrder = billGroupService.selectBillGrpOrder(params);
		
		//ESTM REQ HISTORY 조회
		List<EgovMap> selectEstmReqHistory = billGroupService.selectEstmReqHistory(params);
        
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("basicInfo", selectBasicInfo);
        resultMap.put("grpOrder", grpOrder);
        resultMap.put("estmReqHistory", selectEstmReqHistory);
        
        // 조회 결과 리턴.
        ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectChgMailAddr 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectChgMailAddr", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectChgMailAddr(@RequestParam Map<String, Object> params, ModelMap model) {
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		// 조회.
		EgovMap selectBasicInfo = billGroupService.selectBasicInfo(params);
		EgovMap grpOrder = billGroupService.selectBillGrpOrder(params);
		
		String custBillAddId = selectBasicInfo.get("custBillAddId") != null ? String.valueOf(selectBasicInfo.get("custBillAddId")) : "" ;
		params.put("custBillAddId", custBillAddId);
		EgovMap selectMailInfo = billGroupService.selectMaillingInfo(params);
        
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("basicInfo", selectBasicInfo);
        resultMap.put("grpOrder", grpOrder);
        resultMap.put("mailInfo", selectMailInfo);
        
        // 조회 결과 리턴.
        ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectChgContPerson 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectChgContPerson", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectChgContPerson(@RequestParam Map<String, Object> params, ModelMap model) {
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		
		//베이직인포 조회.
		EgovMap selectBasicInfo = billGroupService.selectBasicInfo(params);
		
		//그룹오더 조회
		EgovMap grpOrder = billGroupService.selectBillGrpOrder(params);
		
		//계약정보 조회
		String custBillCntId = selectBasicInfo.get("custBillCntId") != null ? String.valueOf(selectBasicInfo.get("custBillCntId")) : "";

		params.put("custBillCntId", custBillCntId);
		EgovMap selecContractInfo = billGroupService.selectContractInfo(params);
        
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("basicInfo", selectBasicInfo);
        resultMap.put("grpOrder", grpOrder);
        resultMap.put("contractInfo", selecContractInfo);
        
        // 조회 결과 리턴.
        ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveRemark 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveRemark", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveRemark(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		ReturnMessage message = new ReturnMessage();
		
		boolean saveResult = billGroupService.saveRemark(params, sessionVO);
		
		if(saveResult){
			message.setMessage("Remark has been updated.");
			message.setCode(AppConstants.SUCCESS);
		}else{
			message.setMessage("Failed to update remark.");
			message.setCode(AppConstants.FAIL);
		}
        
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectDetailHistoryView 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectDetailHistoryView", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectDetailHistoryView(@RequestParam Map<String, Object> params, ModelMap model) {
		
		EgovMap detailHistoryView = billGroupService.selectDetailHistoryView(params);
		EgovMap mailAddrOldHistorty = new EgovMap();
		EgovMap mailAddrNewHistorty = new EgovMap();
		EgovMap cntcIdOldHistory = new EgovMap();
		EgovMap cntcIdNewHistory = new EgovMap();
		EgovMap selectSalesOrderMsNw = new EgovMap();
		EgovMap selectSalesOrderMsOld = new EgovMap();
		
		String typeId = String.valueOf(detailHistoryView.get("typeId"));
		String addrIdOld = String.valueOf(detailHistoryView.get("addrIdOld"));
		String addrIdNw = String.valueOf(detailHistoryView.get("addrIdNw"));
		String cntcIdOld = String.valueOf(detailHistoryView.get("cntcIdOld"));
		String cntcIdNw = String.valueOf(detailHistoryView.get("cntcIdNw"));
		String salesOrdIdOld = String.valueOf(detailHistoryView.get("salesOrdIdOld"));
		String salesOrdIdNw = String.valueOf(detailHistoryView.get("salesOrdIdNw"));
		
		if(typeId.equals("1042")){
			
			mailAddrOldHistorty = billGroupService.selectMailAddrHistorty(addrIdOld);
			mailAddrNewHistorty = billGroupService.selectMailAddrHistorty(addrIdNw);
			
		}else if(typeId.equals("1043")){
			
			cntcIdOldHistory = billGroupService.selectContPersonHistorty(cntcIdOld);
			cntcIdNewHistory = billGroupService.selectContPersonHistorty(cntcIdNw);
			
		}else if(typeId.equals("1046") || typeId.equals("1048")){
			
			Map<String, Object> oldMap = new HashMap<String, Object>();
			oldMap.put("salesOrdId", salesOrdIdOld);
			selectSalesOrderMsOld = billGroupService.selectMainOrderHistory(oldMap);
			
			Map<String, Object> newMap = new HashMap<String, Object>();
			newMap.put("salesOrdId", salesOrdIdNw);
			selectSalesOrderMsNw = billGroupService.selectMainOrderHistory(newMap);
		}
		
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("detailHistoryView", detailHistoryView);
        resultMap.put("mailAddrOldHistorty", mailAddrOldHistorty);
        resultMap.put("mailAddrNewHistorty", mailAddrNewHistorty);
        resultMap.put("cntcIdOldHistory", cntcIdOldHistory);
        resultMap.put("cntcIdNewHistory", cntcIdNewHistory);
        resultMap.put("salesOrderMsNw", selectSalesOrderMsNw);
        resultMap.put("salesOrderMsOld", selectSalesOrderMsOld);
        
        // 조회 결과 리턴.
        ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectCustMailAddrList 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCustMailAddrList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCustMailAddrList(@RequestParam Map<String, Object> params, ModelMap model) {
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		List<EgovMap> resultList = billGroupService.selectCustMailAddrList(params);
		
		// 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/**
	 * saveNewAddr 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveNewAddr", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveNewAddr(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		ReturnMessage message = new ReturnMessage();
		boolean saveResult = billGroupService.saveNewAddr(params, sessionVO);
		
		if(saveResult){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage("<b>Mailing address has been updated.</b>");
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage("<b>Failed to update mailing address.</b>");
		}
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectContPersonList 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectContPersonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectContPersonList(@RequestParam Map<String, Object> params, ModelMap model) {
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		List<EgovMap> resultList = billGroupService.selectContPersonList(params);
		
		// 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/**
	 * saveNewContPerson 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveNewContPerson", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveNewContPerson(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		ReturnMessage message = new ReturnMessage();
		
		boolean saveResult = billGroupService.saveNewContPerson(params, sessionVO);
		
		if(saveResult){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage("<b>Contact person has been updated.</b>");
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage("<b>Failed to update contact person.</b>");
		}
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveNewReq 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveNewReq", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveNewReq(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		 ReturnMessage message = new ReturnMessage();

		 boolean saveResult = billGroupService.saveNewReq(params, sessionVO);
		 
		 if(saveResult){
			 message.setCode(AppConstants.SUCCESS);
			 message.setMessage("E-Statement request has sent out.");
		 }else{
			 message.setCode(AppConstants.FAIL);
			 message.setMessage("Failed to request E-Statement. Please try again later.");
		 }
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveChangeBillType 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveChangeBillType", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveChangeBillType(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		 ReturnMessage message = new ReturnMessage();
		 
		 boolean saveResult = billGroupService.saveChangeBillType(params, sessionVO);
		 
		 if(saveResult){
			 message.setCode(AppConstants.SUCCESS);
			 message.setMessage("<b>Billing type has successfully updated.</b>");
		 }else{
				message.setCode(AppConstants.FAIL);
				message.setMessage("<b>Failed to update billing type. Please try again later.</b>");
		 }
		 
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectEstmReqHisView 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectEstmReqHisView", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectEstmReqHisView(@RequestParam Map<String, Object> params, ModelMap model) {
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		// 조회.
		EgovMap selectEstmReqHisView = billGroupService.selectEstmReqHisView(params);
		
		
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("estmReqHisView", selectEstmReqHisView);
        
        // 조회 결과 리턴.
        ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveApprRequest 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveApprRequest", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveApprRequest(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		ReturnMessage message = new ReturnMessage();
		
		boolean saveResult = billGroupService.saveApprRequest(params, sessionVO);
		
		if(saveResult){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage("<b>E-Statement request has been approved.</b>");
		 }else{
			message.setCode(AppConstants.FAIL);
			message.setMessage("<b>Failed to approve this E-Statement request. Please try again later.</b>");
		 }
        
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveCancelRequest 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveCancelRequest", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveCancelRequest(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		
		ReturnMessage message = new ReturnMessage();
		
		boolean saveResult = billGroupService.saveCancelRequest(params, sessionVO);
		
		if(saveResult){
			message.setCode(AppConstants.SUCCESS);
	    	message.setMessage("<b>E-Statement request has been cancelled.</b>");
		 }else{
			message.setCode(AppConstants.FAIL);
			message.setMessage("<b>Failed to cancel this E-Statement request. Please try again later.</b>");
		 }
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectEStmRequestById 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectEStmRequestById", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectEStmRequestById(@RequestParam Map<String, Object> params, ModelMap model) {
        
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		
		// 조회.
		EgovMap estmReqHisView = billGroupService.selectEstmReqHisView(params);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("estmReqHisView", estmReqHisView);
		
		// 조회 결과 리턴.
        ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectDetailOrdGrp 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectDetailOrdGrp", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectDetailOrdGrp(@RequestParam Map<String, Object> params, ModelMap model) {
        
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		
		EgovMap selectBasicInfo = billGroupService.selectBasicInfo(params);
		EgovMap selectBillGrpOrdView = billGroupService.selectBillGrpOrdView(params);
		EgovMap selectBillGrpOrder = billGroupService.selectBillGrpOrder(params);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("basicInfo", selectBasicInfo);
		resultMap.put("grpOrder", selectBillGrpOrder);
		resultMap.put("billGrpOrdView", selectBillGrpOrdView);
		
		// 조회 결과 리턴.
        ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveRemoveOrder 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveRemoveOrder", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveRemoveOrder(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		ReturnMessage message = new ReturnMessage();
		
		boolean saveResult = billGroupService.saveRemoveOrder(params, sessionVO);
		EgovMap selectBillGrpOrder = billGroupService.selectBillGrpOrder(params);
		
		if(saveResult){
			message.setCode(AppConstants.SUCCESS);
	    	message.setMessage("<b>The order has been removed from billing group.</b>");
		 }else{
			message.setCode(AppConstants.FAIL);
		    message.setMessage("<b>Failed to remove order from this billing group. Please try again later.</b>");
		 }
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("grpOrder", selectBillGrpOrder);
		message.setData(resultMap);
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectAddOrder 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectAddOrder", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectAddOrder(@RequestParam Map<String, Object> params, ModelMap model) {
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		// 조회.
		EgovMap selectBasicInfo = billGroupService.selectBasicInfo(params);
		String custId = String.valueOf(selectBasicInfo.get("custBillCustId"));
		
		EgovMap grpOrder = billGroupService.selectBillGrpOrder(params);
		
		params.put("custId", custId);
		List<EgovMap> selectAddOrdList = billGroupService.selectAddOrdList(params);
        
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("basicInfo", selectBasicInfo);
        resultMap.put("grpOrder", grpOrder);
        resultMap.put("orderGrpList", selectAddOrdList);
        
        // 조회 결과 리턴.
        ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveChgMainOrd 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveChgMainOrd", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveChgMainOrd(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		ReturnMessage message = new ReturnMessage();
		
		boolean saveResult = billGroupService.saveChgMainOrd(params, sessionVO);
		
		if(saveResult){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage("Main order has been changed.");
		 }else{
			message.setCode(AppConstants.FAIL);
			message.setMessage("Failed to change main order. Please try again later.");
		 }
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveAddOrder 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveAddOrder", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveAddOrder(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		
		String resultMessage = billGroupService.saveAddOrder(params, sessionVO);
		
		if(!"".equals(resultMessage) || resultMessage != null){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(resultMessage);
		 }else{
			message.setCode(AppConstants.FAIL);
			message.setMessage("Failed to manage grouping. Please try again later.");
		 }
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveAddNewGroup 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveAddNewGroup", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAddNewGroup(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		ReturnMessage message = new ReturnMessage();
		
		String resultMessage = billGroupService.saveAddNewGroup(params, sessionVO);
		
		if(resultMessage != null || !"".equals(resultMessage)){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage("New billing group created.<br /> " +
                    "Billing Group Number : " + resultMessage + "<br />");
		}else{
			message.setCode(AppConstants.FAIL);
	    	message.setMessage("Failed to create new billing group. Please try again later.");
		}

		
		return ResponseEntity.ok(message);
	}
	
	
	/**
	 * selectLoadOrderInfo 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectLoadOrderInfo", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectLoadOrderInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		String resultMessage = "";
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		
		EgovMap selectOrderInfo = billGroupService.selectGetOrder(params);
		EgovMap selectMailInfo = new EgovMap();
        EgovMap selecContractInfo = new EgovMap();
		
		if(selectOrderInfo != null){
			
			String custAddId = selectOrderInfo.get("custAddId")  != null ? String.valueOf(selectOrderInfo.get("custAddId")) : "" ;
			String custCntcId = selectOrderInfo.get("custCntcId")  != null ? String.valueOf(selectOrderInfo.get("custCntcId")) : "" ;
			
			params.put("custBillAddId", custAddId);
			params.put("custBillCntId", custCntcId);
			selectMailInfo = billGroupService.selectMaillingInfo (params);
			selecContractInfo = billGroupService.selectContractInfo(params);
		}
		
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("orderInfo", selectOrderInfo);
        resultMap.put("maillingInfo", selectMailInfo);
        resultMap.put("contactInfo", selecContractInfo);

        
        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
    	message.setMessage(resultMessage);
		
		return ResponseEntity.ok(message);
	}
}
