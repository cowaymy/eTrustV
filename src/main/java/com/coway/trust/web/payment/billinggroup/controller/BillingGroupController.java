package com.coway.trust.web.payment.billinggroup.controller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.stringtemplate.v4.compiler.CodeGenerator.list_return;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.payment.billinggroup.service.BillingGroupService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BillingGroupController {

	private static final Logger logger = LoggerFactory.getLogger(BillingGroupController.class);

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "billingGroupService")
	private BillingGroupService billGroupService;

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	
	/**
	 * BillGroupManagement 초기 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillGroupManagement.do")
	public String initEnrollmentList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billinggroup/billGroupManagement";
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
        
        if( getCustId == null){
        	resultMessage = "No billing group found for this order.";
        	selectBasicInfo = null;
        	getCustId = "";
        }else{
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
    	//message.setMessage(resultMessage);
		
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
    	//message.setMessage(resultMessage);
		
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
    	//message.setMessage(resultMessage);
		
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
    	//message.setMessage(resultMessage);
		
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
    	//message.setMessage(resultMessage);
		
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
		EgovMap custBillMasters = billGroupService.selectCustBillMaster(params);
		String custBillId = custBillMasters.get("custBillId") != null ? String.valueOf(custBillMasters.get("custBillId")) : "0";
		
		if(custBillMasters !=null && Integer.parseInt(custBillId) > 0){
			int userId = sessionVO.getUserId();
			String salesOrderIDOld = "0";
			String salesOrderIDNew = "0";
			String contactIDOld = "0";
			String contactIDNew = "0";
			String addressIDOld = "0";
			String addressIDNew ="0"; 
			String statusIDOld = "0";
			String statusIDNew = "0";
			String remarkOld = custBillMasters.get("custBillRem") != null ? String.valueOf(custBillMasters.get("custBillRem")) : "";
			String remarkNew = String.valueOf(params.get("remarkNew"));
			String emailOld = "";
			String emailNew = "";
			String isEStatementOld = "0";
			String isEStatementNew = "0";
			String isSMSOld = "0";
			String isSMSNew = "0";
			String isPostOld = "0";
			String isPostNew = "0";
			String typeId = "1044";
			String sysHisRemark = "[System] Change Remark";
			String emailAddtionalNew = "";
			String emailAddtionalOld = "";
			
			Map<String, Object> insHisMap = new HashMap<String, Object>();
			insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
			insHisMap.put("userId", userId);
			insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
			insHisMap.put("salesOrderIDOld", salesOrderIDOld);
			insHisMap.put("salesOrderIDNew", salesOrderIDNew);
			insHisMap.put("contactIDOld", contactIDOld);
			insHisMap.put("contactIDNew", contactIDNew);
			insHisMap.put("addressIDOld", addressIDOld);
			insHisMap.put("addressIDNew", addressIDNew);
			insHisMap.put("statusIDOld", statusIDOld);
			insHisMap.put("statusIDNew", statusIDNew);
			insHisMap.put("remarkOld", remarkOld);
			insHisMap.put("remarkNew", remarkNew);
			insHisMap.put("emailOld", emailOld);
			insHisMap.put("emailNew", emailNew);
			insHisMap.put("isEStatementOld", isEStatementOld);
			insHisMap.put("isEStatementNew", isEStatementNew);
			insHisMap.put("isSMSOld", isSMSOld);
			insHisMap.put("isSMSNew", isSMSNew);
			insHisMap.put("isPostOld", isPostOld);
			insHisMap.put("isPostNew", isPostNew);
			insHisMap.put("typeId", typeId);
			insHisMap.put("sysHisRemark", sysHisRemark);
			insHisMap.put("emailAddtionalNew", emailAddtionalNew);
			insHisMap.put("emailAddtionalOld", emailAddtionalOld);
					
			//마스터테이블 업데이트
			Map<String, Object> updCustMap = new HashMap<String, Object>();
			updCustMap.put("remarkNew", String.valueOf(params.get("remarkNew")));
			updCustMap.put("remarkFlag", "Y");
			updCustMap.put("custBillId", String.valueOf(params.get("custBillId")));
			updCustMap.put("userId", userId);
			billGroupService.updCustMaster(updCustMap);
			
			//히스토리테이블 인서트
			billGroupService.insHistory(insHisMap);
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
    	//message.setMessage(resultMessage);
		
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
	 * selectAddrKeywordList 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectAddrKeywordList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAddrKeywordList(@RequestParam Map<String, Object> params, ModelMap model) {
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		List<EgovMap> resultList = billGroupService.selectAddrKeywordList(params);
		
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
		String defaultDate = "1900-01-01";
		int userId = sessionVO.getUserId();
		params.put("defaultDate", defaultDate);
		params.put("userId", userId);
		ReturnMessage message = new ReturnMessage();
		
		//베이직인포 조회.
		EgovMap selectBasicInfo = billGroupService.selectBasicInfo(params);
		String custBillAddIdOld = selectBasicInfo.get("custBillAddId") != null ? String.valueOf(selectBasicInfo.get("custBillAddId")) : "" ;
		String custBillId = selectBasicInfo.get("custBillId") != null ?  String.valueOf(selectBasicInfo.get("custBillId")) : "";
		
		if(selectBasicInfo != null && Integer.parseInt(custBillId) > 0){
			
			//인서트 셋팅 시작
			String salesOrderIDOld = "0";
			String salesOrderIDNew = "0";
			String contactIDOld = "0";
			String contactIDNew = "0";
			String addressIDOld = custBillAddIdOld;
			String addressIDNew = String.valueOf(params.get("custAddId"));
			String statusIDOld = "0";
			String statusIDNew = "0";
			String remarkOld = "";
			String remarkNew = "";
			String emailOld = "";
			String emailNew = "";
			String isEStatementOld = "0";
			String isEStatementNew = "0";
			String isSMSOld = "0";
			String isSMSNew = "0";
			String isPostOld = "0";
			String isPostNew = "0";
			String typeId = "1042";
			String sysHisRemark = "[System] Change Mailing Address";
			String emailAddtionalNew = "";
			String emailAddtionalOld = "";
			
			Map<String, Object> insHisMap = new HashMap<String, Object>();
			insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
			insHisMap.put("userId", userId);
			insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
			insHisMap.put("salesOrderIDOld", salesOrderIDOld);
			insHisMap.put("salesOrderIDNew", salesOrderIDNew);
			insHisMap.put("contactIDOld", contactIDOld);
			insHisMap.put("contactIDNew", contactIDNew);
			insHisMap.put("addressIDOld", addressIDOld);
			insHisMap.put("addressIDNew", addressIDNew);
			insHisMap.put("statusIDOld", statusIDOld);
			insHisMap.put("statusIDNew", statusIDNew);
			insHisMap.put("remarkOld", remarkOld);
			insHisMap.put("remarkNew", remarkNew);
			insHisMap.put("emailOld", emailOld);
			insHisMap.put("emailNew", emailNew);
			insHisMap.put("isEStatementOld", isEStatementOld);
			insHisMap.put("isEStatementNew", isEStatementNew);
			insHisMap.put("isSMSOld", isSMSOld);
			insHisMap.put("isSMSNew", isSMSNew);
			insHisMap.put("isPostOld", isPostOld);
			insHisMap.put("isPostNew", isPostNew);
			insHisMap.put("typeId", typeId);
			insHisMap.put("sysHisRemark", sysHisRemark);
			insHisMap.put("emailAddtionalNew", emailAddtionalNew);
			insHisMap.put("emailAddtionalOld", emailAddtionalOld);
			//히스토리테이블 인서트
			billGroupService.insHistory(insHisMap);
			
			//마스터테이블 업데이트
			Map<String, Object> updCustMap = new HashMap<String, Object>();
			updCustMap.put("userId", userId);
			updCustMap.put("addrFlag", "Y");
			updCustMap.put("addressIDNew", String.valueOf(params.get("custAddId")));
			updCustMap.put("custBillId", custBillId);
			billGroupService.updCustMaster(updCustMap);
			
			
			List<EgovMap> selectSalesOrderM = billGroupService.selectSalesOrderM(params);
			for(int i = 0 ; i < selectSalesOrderM.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)selectSalesOrderM.get(i);
				String salesOrdId = String.valueOf(map.get("salesOrdId"));
				
				Map<String, Object> updSalesMap = new HashMap<String, Object>();
				updSalesMap.put("salesOrdId", salesOrdId);
				updSalesMap.put("addressIDNew", String.valueOf(params.get("custAddId")));
				updSalesMap.put("addrFlag", "Y");
				//SALES ORDER MASTER UPDATE
				billGroupService.updSalesOrderMaster(updSalesMap);
			}
			message.setCode(AppConstants.SUCCESS);
			message.setMessage("<b>Mailing address has been updated.</b>");
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage("<b>Failed to update mailing address.</b>");
		}

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("basicInfo", selectBasicInfo);
        
        // 조회 결과 리턴.
    	message.setData(resultMap);
		
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
	 * selectContPerKeywordList 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectContPerKeywordList", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectContPerKeywordList(@RequestParam Map<String, Object> params, ModelMap model) {
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		
		List<EgovMap> resultList = billGroupService.selectContPerKeywordList(params);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultList", resultList);
		
		// 조회 결과 리턴.
        ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
    	//message.setMessage("");
    	
    	return ResponseEntity.ok(message);
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
		String defaultDate = "1900-01-01";
		int userId = sessionVO.getUserId();
		params.put("defaultDate", defaultDate);
		params.put("userId", userId);
		ReturnMessage message = new ReturnMessage();
		
		//master 조회.
		EgovMap selectCustBillMaster = billGroupService.selectCustBillMaster(params);
		String custBillCntId = selectCustBillMaster.get("custBillCntId") != null ?  String.valueOf(selectCustBillMaster.get("custBillCntId")) : "" ;
		String custBillId = selectCustBillMaster.get("custBillId") != null ? String.valueOf(selectCustBillMaster.get("custBillId")) : "" ;
		
		if(selectCustBillMaster != null && Integer.parseInt(custBillId) > 0){
			
			//인서트 셋팅 시작
			String salesOrderIDOld = "0";
			String salesOrderIDNew = "0";
			String contactIDOld = custBillCntId;
			String contactIDNew = String.valueOf(params.get("custCntcId"));;
			String addressIDOld = "0";
			String addressIDNew = "0";
			String statusIDOld = "0";
			String statusIDNew = "0";
			String remarkOld = "";
			String remarkNew = "";
			String emailOld = "";
			String emailNew = "";
			String isEStatementOld = "0";
			String isEStatementNew = "0";
			String isSMSOld = "0";
			String isSMSNew = "0";
			String isPostOld = "0";
			String isPostNew = "0";
			String typeId = "1043";
			String sysHisRemark = "[System] Change Contact Person";
			String emailAddtionalNew = "";
			String emailAddtionalOld = "";
			
			Map<String, Object> insHisMap = new HashMap<String, Object>();
			insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
			insHisMap.put("userId", userId);
			insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
			insHisMap.put("salesOrderIDOld", salesOrderIDOld);
			insHisMap.put("salesOrderIDNew", salesOrderIDNew);
			insHisMap.put("contactIDOld", contactIDOld);
			insHisMap.put("contactIDNew", contactIDNew);
			insHisMap.put("addressIDOld", addressIDOld);
			insHisMap.put("addressIDNew", addressIDNew);
			insHisMap.put("statusIDOld", statusIDOld);
			insHisMap.put("statusIDNew", statusIDNew);
			insHisMap.put("remarkOld", remarkOld);
			insHisMap.put("remarkNew", remarkNew);
			insHisMap.put("emailOld", emailOld);
			insHisMap.put("emailNew", emailNew);
			insHisMap.put("isEStatementOld", isEStatementOld);
			insHisMap.put("isEStatementNew", isEStatementNew);
			insHisMap.put("isSMSOld", isSMSOld);
			insHisMap.put("isSMSNew", isSMSNew);
			insHisMap.put("isPostOld", isPostOld);
			insHisMap.put("isPostNew", isPostNew);
			insHisMap.put("typeId", typeId);
			insHisMap.put("sysHisRemark", sysHisRemark);
			insHisMap.put("emailAddtionalNew", emailAddtionalNew);
			insHisMap.put("emailAddtionalOld", emailAddtionalOld);
			
					
			//마스터테이블 업데이트
			Map<String, Object> updCustMap = new HashMap<String, Object>();
			updCustMap.put("contPerFlag", "Y");
			updCustMap.put("custBillId", custBillId);
			updCustMap.put("custBillCntId", String.valueOf(params.get("custCntcId")));
			updCustMap.put("userId", userId);
			billGroupService.updCustMaster(updCustMap);
			
			//히스토리테이블 인서트
			billGroupService.insHistory(insHisMap);
			
			List<EgovMap> selectSalesOrderM = billGroupService.selectSalesOrderM(params);
			for(int i = 0 ; i < selectSalesOrderM.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)selectSalesOrderM.get(i);
				String salesOrdId = String.valueOf(map.get("salesOrdId"));
				
				//SALES ORDER MASTER UPDATE
				Map<String, Object> updSalesMap = new HashMap<String, Object>();
				updSalesMap.put("salesOrdId", salesOrdId);
				updSalesMap.put("conPerFlag", "Y");
				updSalesMap.put("custBillCntId", String.valueOf(params.get("custCntcId")));
				billGroupService.updSalesOrderMaster(updSalesMap);
			}
			
			message.setCode(AppConstants.SUCCESS);
			message.setMessage("<b>Contact person has been updated.</b>");
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage("<b>Failed to update contact person.</b>");
		}
        
        Map<String, Object> resultMap = new HashMap<String, Object>();
        
        resultMap.put("masterInfo", selectCustBillMaster);
        
        // 조회 결과 리턴.
    	message.setData(resultMap);
    	
		
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
		String defaultDate = "1900-01-01";
		int userId = sessionVO.getUserId();
		params.put("defaultDate", defaultDate);
		params.put("userId", userId);
		 ReturnMessage message = new ReturnMessage();
		 
		//master 조회.
		List<EgovMap> reqMaster = billGroupService.selectReqMaster(params);
		EgovMap selectCustBillMaster = billGroupService.selectCustBillMaster(params);
		String custBillEmail = selectCustBillMaster.get("custBillEmail") != null ? String.valueOf(selectCustBillMaster.get("custBillEmail")) : "";
		String custBillIsEstm = selectCustBillMaster.get("custBillIsEstm") != null ? String.valueOf(selectCustBillMaster.get("custBillIsEstm")) : "";
		String custBillIsSms = selectCustBillMaster.get("custBillIsSms") != null ? String.valueOf(selectCustBillMaster.get("custBillIsSms")) : "";
		String custBillIsPost = selectCustBillMaster.get("custBillIsPost") != null ? String.valueOf(selectCustBillMaster.get("custBillIsPost")) : "";
		String custBillId = selectCustBillMaster.get("custBillId") != null ? String.valueOf(selectCustBillMaster.get("custBillId")) : "0";

		//인서트 셋팅 시작
		String salesOrderIDOld = "0";
		String salesOrderIDNew = "0";
		String contactIDOld = "0";
		String contactIDNew = "0";
		String addressIDOld = "0";
		String addressIDNew = "0";
		String statusIDOld = "0";
		String statusIDNew = "0";
		String remarkOld = "";
		String remarkNew = "";
		String emailOld = custBillEmail;
		String emailNew = String.valueOf(params.get("reqEmail")).trim();;
		String isEStatementOld = custBillIsEstm;
		String isEStatementNew = custBillIsEstm;
		String isSMSOld = custBillIsSms;
		String isSMSNew = custBillIsSms;
		String isPostOld = custBillIsPost;
		String isPostNew = custBillIsPost;
		String typeId = "1047";
		String sysHisRemark = "[System] E-Statement Request";
		String emailAddtionalNew = "";
		String emailAddtionalOld = "";
		
		if(selectCustBillMaster != null && Integer.parseInt(custBillId) > 0){
			
			if(reqMaster.size() > 0){
				for(int i = 0 ; i < reqMaster.size() ; i++){
					Map<String, Object> map = (Map<String, Object>)reqMaster.get(i);
					params.put("reqId", String.valueOf(map.get("reqId")));
					params.put("stusCodeId", 10);
					//REQ마스터테이블 업데이트
					billGroupService.updReqEstm(params);
				}
			}
			
			Map<String, Object> insHisMap = new HashMap<String, Object>();
			insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
			insHisMap.put("userId", userId);
			insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
			insHisMap.put("salesOrderIDOld", salesOrderIDOld);
			insHisMap.put("salesOrderIDNew", salesOrderIDNew);
			insHisMap.put("contactIDOld", contactIDOld);
			insHisMap.put("contactIDNew", contactIDNew);
			insHisMap.put("addressIDOld", addressIDOld);
			insHisMap.put("addressIDNew", addressIDNew);
			insHisMap.put("statusIDOld", statusIDOld);
			insHisMap.put("statusIDNew", statusIDNew);
			insHisMap.put("remarkOld", remarkOld);
			insHisMap.put("remarkNew", remarkNew);
			insHisMap.put("emailOld", emailOld);
			insHisMap.put("emailNew", emailNew);
			insHisMap.put("isEStatementOld", isEStatementOld);
			insHisMap.put("isEStatementNew", isEStatementNew);
			insHisMap.put("isSMSOld", isSMSOld);
			insHisMap.put("isSMSNew", isSMSNew);
			insHisMap.put("isPostOld", isPostOld);
			insHisMap.put("isPostNew", isPostNew);
			insHisMap.put("typeId", typeId);
			insHisMap.put("sysHisRemark", sysHisRemark);
			insHisMap.put("emailAddtionalNew", emailAddtionalNew);
			insHisMap.put("emailAddtionalOld", emailAddtionalOld);
			
			//히스토리테이블 인서트
			billGroupService.insHistory(insHisMap);

			Map<String, Object> estmMap = new HashMap<String, Object>();
			estmMap.put("stusCodeId", "44");
			estmMap.put("custBillId", String.valueOf(params.get("custBillId")));
			estmMap.put("email", String.valueOf(params.get("reqEmail")));
			estmMap.put("cnfmCode", CommonUtils.getRandomNumber(10));
			estmMap.put("userId", userId);
			estmMap.put("defaultDate", defaultDate);
			estmMap.put("emailFailInd", "0");
			estmMap.put("emailFailDesc", "");
			estmMap.put("emailAdd", "");
			//estmReq 인서트
			billGroupService.insEstmReq(estmMap);
			
			message.setCode(AppConstants.SUCCESS);
			message.setMessage("E-Statement request has sent out.");
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage("Failed to request E-Statement. Please try again later.");
		}
		
		
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("masterInfo", selectCustBillMaster);
        
        // 조회 결과 리턴.
    	message.setData(resultMap);
    	
		
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
		String defaultDate = "1900-01-01";
		int userId = sessionVO.getUserId();
		params.put("defaultDate", defaultDate);
		params.put("userId", userId);
		 ReturnMessage message = new ReturnMessage();
		 
		//master 조회.
		EgovMap selectBasicInfo = billGroupService.selectBasicInfo(params);
		String custBillIsEstm = selectBasicInfo.get("custBillIsEstm") != null ? String.valueOf(selectBasicInfo.get("custBillIsEstm")) : "";
		String custBillIsSms = selectBasicInfo.get("custBillIsSms") != null ?  String.valueOf(selectBasicInfo.get("custBillIsSms")) : "" ;
		String custBillIsPost = selectBasicInfo.get("custBillIsPost") != null ? String.valueOf(selectBasicInfo.get("custBillIsPost")) : "";
		String custBillId = selectBasicInfo.get("custBillId") != null ? String.valueOf(selectBasicInfo.get("custBillId")) : "0" ;
		
		if(selectBasicInfo != null && Integer.parseInt(custBillId) > 0){
			
			//인서트 셋팅 시작
			String salesOrderIDOld = "0";
			String salesOrderIDNew = "0";
			String contactIDOld = "0";
			String contactIDNew = "0";
			String addressIDOld = "0";
			String addressIDNew = "0";
			String statusIDOld = "0";
			String statusIDNew = "0";
			String remarkOld = "";
			String remarkNew = "";
			String emailOld = "";
			String emailNew = "";
			String typeId = "1045";
			String isEStatementOld = custBillIsEstm;
			String isEStatementNew = String.valueOf(params.get("estm"));
			String isSMSOld = custBillIsSms;
			String isSMSNew = String.valueOf(params.get("sms"));
			String isPostOld = custBillIsPost;
			String isPostNew = String.valueOf(params.get("post"));
			String sysHisRemark = "[System] Change Billing Type";
			String emailAddtionalNew = "";
			String emailAddtionalOld = "";
			
			Map<String, Object> insHisMap = new HashMap<String, Object>();
			insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
			insHisMap.put("userId", userId);
			insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
			insHisMap.put("salesOrderIDOld", salesOrderIDOld);
			insHisMap.put("salesOrderIDNew", salesOrderIDNew);
			insHisMap.put("contactIDOld", contactIDOld);
			insHisMap.put("contactIDNew", contactIDNew);
			insHisMap.put("addressIDOld", addressIDOld);
			insHisMap.put("addressIDNew", addressIDNew);
			insHisMap.put("statusIDOld", statusIDOld);
			insHisMap.put("statusIDNew", statusIDNew);
			insHisMap.put("remarkOld", remarkOld);
			insHisMap.put("remarkNew", remarkNew);
			insHisMap.put("emailOld", emailOld);
			insHisMap.put("emailNew", emailNew);
			insHisMap.put("isEStatementOld", isEStatementOld);
			insHisMap.put("isEStatementNew", isEStatementNew);
			insHisMap.put("isSMSOld", isSMSOld);
			insHisMap.put("isSMSNew", isSMSNew);
			insHisMap.put("isPostOld", isPostOld);
			insHisMap.put("isPostNew", isPostNew);
			insHisMap.put("typeId", typeId);
			insHisMap.put("sysHisRemark", sysHisRemark);
			insHisMap.put("emailAddtionalNew", emailAddtionalNew);
			insHisMap.put("emailAddtionalOld", emailAddtionalOld);
			
			//히스토리테이블 인서트
			billGroupService.insHistory(insHisMap);

			Map<String, Object> custMap = new HashMap<String, Object>();
			custMap.put("custBillIsPost", String.valueOf(params.get("post")));
			custMap.put("custBillIsSMS", String.valueOf(params.get("sms")));
			custMap.put("custBillIsEstm", String.valueOf(params.get("estm")));
			custMap.put("chgBillFlag", "Y");
			custMap.put("userId", userId);
			custMap.put("custBillId", String.valueOf(params.get("custBillId")));
			//마스터테이블 업데이트
			billGroupService.updCustMaster(custMap);
			
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
    	//message.setMessage(resultMessage);
		
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
		String defaultDate = "1900-01-01";
		int userId = sessionVO.getUserId();
		params.put("defaultDate", defaultDate);
		params.put("userId", userId);
		params.put("reqId", String.valueOf(params.get("reqId")));
		ReturnMessage message = new ReturnMessage();
		
		//master 조회.
		EgovMap selectEStatementReqs = billGroupService.selectEStatementReqs(params);
		String reqId = selectEStatementReqs.get("reqId") != null ? String.valueOf(selectEStatementReqs.get("reqId")) : "0";
		String email = selectEStatementReqs.get("email") != null ? String.valueOf(selectEStatementReqs.get("email")) : "";
		
		if(selectEStatementReqs != null && Integer.parseInt(reqId) > 0){
			EgovMap selectCustBillMaster = billGroupService.selectCustBillMaster(params);
			String custBillId = selectCustBillMaster.get("custBillId") != null ? String.valueOf(selectCustBillMaster.get("custBillId")) : "0";
			String custBillIsEstm = selectCustBillMaster.get("custBillIsEstm") != null ? String.valueOf(selectCustBillMaster.get("custBillIsEstm")) : "";
			String custBillEmail = selectCustBillMaster.get("custBillEmail") != null ? String.valueOf(selectCustBillMaster.get("custBillEmail")) : "";
			
			if(selectCustBillMaster != null && Integer.parseInt(custBillId) > 0){
				
				Map<String, Object> updCustMap = new HashMap<String, Object>();
				updCustMap.put("custBillId", custBillId);
				updCustMap.put("emailOld", custBillEmail);//old
				updCustMap.put("emailNew", email);//new
				updCustMap.put("apprReqFlag", "Y");
				updCustMap.put("userId", userId);
				updCustMap.put("custBillIsEstm", "1");
				billGroupService.updCustMaster(updCustMap);
				
				//인서트 셋팅 시작
				String salesOrderIDOld = "0";
				String salesOrderIDNew = "0";
				String contactIDOld = "0";
				String contactIDNew = "0";
				String addressIDOld = "0";
				String addressIDNew = "0";
				String statusIDOld = "0";
				String statusIDNew = "0";
				String remarkOld = "";
				String remarkNew = "";
				String emailOld = custBillEmail;
				String emailNew = email;
				String isEStatementOld = "0";
				String isEStatementNew = "1";
				String isSMSOld = "0";
				String isSMSNew = "0";
				String isPostOld = "0";
				String isPostNew = "0";
				String typeId = "1047";
				String sysHisRemark = "[System] E-Statement Approve";
				String emailAddtionalNew = "";
				String emailAddtionalOld = "";
				
				Map<String, Object> insHisMap = new HashMap<String, Object>();
				
				insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
				insHisMap.put("userId", userId);
				insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
				insHisMap.put("salesOrderIDOld", salesOrderIDOld);
				insHisMap.put("salesOrderIDNew", salesOrderIDNew);
				insHisMap.put("contactIDOld", contactIDOld);
				insHisMap.put("contactIDNew", contactIDNew);
				insHisMap.put("addressIDOld", addressIDOld);
				insHisMap.put("addressIDNew", addressIDNew);
				insHisMap.put("statusIDOld", statusIDOld);
				insHisMap.put("statusIDNew", statusIDNew);
				insHisMap.put("remarkOld", remarkOld);
				insHisMap.put("remarkNew", remarkNew);
				insHisMap.put("emailOld", emailOld);
				insHisMap.put("emailNew", emailNew);
				insHisMap.put("isEStatementOld", isEStatementOld);
				insHisMap.put("isEStatementNew", isEStatementNew);
				insHisMap.put("isSMSOld", isSMSOld);
				insHisMap.put("isSMSNew", isSMSNew);
				insHisMap.put("isPostOld", isPostOld);
				insHisMap.put("isPostNew", isPostNew);
				insHisMap.put("typeId", typeId);
				insHisMap.put("sysHisRemark", sysHisRemark);
				insHisMap.put("emailAddtionalNew", emailAddtionalNew);
				insHisMap.put("emailAddtionalOld", emailAddtionalOld);
				billGroupService.insHistory(insHisMap);
				//인서트 셋팅  끝
				
				Map<String, Object> updReqMap = new HashMap<String, Object>();
				updReqMap.put("reqId", reqId);
				updReqMap.put("stusCodeId", "5");
				billGroupService.updReqEstm(updReqMap);
				
			}
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
		String defaultDate = "1900-01-01";
		int userId = sessionVO.getUserId();
		params.put("defaultDate", defaultDate);
		params.put("userId", userId);
		params.put("reqId", String.valueOf(params.get("reqId")));
		ReturnMessage message = new ReturnMessage();
		
		//master 조회.
		EgovMap selectEStatementReqs = billGroupService.selectEStatementReqs(params);
		String reqId = selectEStatementReqs.get("reqId") != null ? String.valueOf(selectEStatementReqs.get("reqId")) : "0";
		String email = selectEStatementReqs.get("email") != null ? String.valueOf(selectEStatementReqs.get("email")) : "";
		
		if(selectEStatementReqs != null && Integer.parseInt(reqId) > 0){
			
			Map<String, Object> updCanMap = new HashMap<String, Object>();
			updCanMap.put("reqId", reqId);
			updCanMap.put("stusCodeId", "10");
			billGroupService.updReqEstm(updCanMap);
			
			//인서트 셋팅 시작
			String salesOrderIDOld = "0";
			String salesOrderIDNew = "0";
			String contactIDOld = "0";
			String contactIDNew = "0";
			String addressIDOld = "0";
			String addressIDNew = "0";
			String statusIDOld = "0";
			String statusIDNew = "0";
			String remarkOld = "";
			String remarkNew = "";
			String emailOld = "";
			String emailNew = email;
			String isEStatementOld = "0";
			String isEStatementNew = "0";
			String isSMSOld = "0";
			String isSMSNew = "0";
			String isPostOld = "0";
			String isPostNew = "0";
			String typeId = "1047";
			String sysHisRemark = "[System] E-Statement Cancel";
			String emailAddtionalNew = "";
			String emailAddtionalOld = "";
			
			Map<String, Object> insHisMap = new HashMap<String, Object>();
			insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
			insHisMap.put("userId", userId);
			insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
			insHisMap.put("salesOrderIDOld", salesOrderIDOld);
			insHisMap.put("salesOrderIDNew", salesOrderIDNew);
			insHisMap.put("contactIDOld", contactIDOld);
			insHisMap.put("contactIDNew", contactIDNew);
			insHisMap.put("addressIDOld", addressIDOld);
			insHisMap.put("addressIDNew", addressIDNew);
			insHisMap.put("statusIDOld", statusIDOld);
			insHisMap.put("statusIDNew", statusIDNew);
			insHisMap.put("remarkOld", remarkOld);
			insHisMap.put("remarkNew", remarkNew);
			insHisMap.put("emailOld", emailOld);
			insHisMap.put("emailNew", emailNew);
			insHisMap.put("isEStatementOld", isEStatementOld);
			insHisMap.put("isEStatementNew", isEStatementNew);
			insHisMap.put("isSMSOld", isSMSOld);
			insHisMap.put("isSMSNew", isSMSNew);
			insHisMap.put("isPostOld", isPostOld);
			insHisMap.put("isPostNew", isPostNew);
			insHisMap.put("typeId", typeId);
			insHisMap.put("sysHisRemark", sysHisRemark);
			insHisMap.put("emailAddtionalNew", emailAddtionalNew);
			insHisMap.put("emailAddtionalOld", emailAddtionalOld);
			billGroupService.insHistory(insHisMap);
			//인서트 셋팅  끝
			
				
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
    	//message.setMessage("");
		
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
		int userId =sessionVO.getUserId();
		params.put("defaultDate", defaultDate);
		ReturnMessage message = new ReturnMessage();
		
		EgovMap selectSalesOrderMs = billGroupService.selectSalesOrderMs(params);
		String salesOrdId = selectSalesOrderMs.get("salesOrdId") != null ? String.valueOf(selectSalesOrderMs.get("salesOrdId")) : "0";
		
		if(selectSalesOrderMs != null && Integer.parseInt(salesOrdId) > 0){
			
			EgovMap selectCustBillMaster = billGroupService.selectCustBillMaster(params);
			String custBillId = selectSalesOrderMs.get("custBillId") != null ? String.valueOf(selectSalesOrderMs.get("custBillId")) : "0";
			
			if(selectCustBillMaster != null && Integer.parseInt(custBillId) > 0){
				
				//Is Main Order Of Group
                String changeOrderId = "0";
                //Get first complete order
                Map<String, Object> replaceOrdMap = new HashMap<String, Object>();
                replaceOrdMap.put("replaceOrd", "Y");
                replaceOrdMap.put("custBillId", String.valueOf(params.get("custBillId")));
                replaceOrdMap.put("salesOrdId", String.valueOf(params.get("salesOrdId")));
                EgovMap replcaceOrder_1 = billGroupService.selectReplaceOrder(replaceOrdMap);
                if(replcaceOrder_1 != null && Integer.parseInt(String.valueOf(replcaceOrder_1.get("salesOrdId"))) > 0){
                	String replaceSalesOrdId = replcaceOrder_1.get("salesOrdId") != null ? String.valueOf(replcaceOrder_1.get("salesOrdId")) : "0";
                	changeOrderId = replaceSalesOrdId;
                	
                }else{
                	
                	Map<String, Object> replaceOrd2Map = new HashMap<String, Object>();
                	replaceOrd2Map.put("replaceOrd2", "Y");
                	replaceOrd2Map.put("custBillId", String.valueOf(params.get("custBillId")));
                	replaceOrd2Map.put("salesOrdId", String.valueOf(params.get("salesOrdId")));
                    EgovMap replcaceOrder_2 = billGroupService.selectReplaceOrder(replaceOrd2Map);
                    if(replcaceOrder_2 != null && Integer.parseInt(String.valueOf(replcaceOrder_2.get("salesOrdId"))) > 0){
                    	String replaceSalesOrdId2 = replcaceOrder_2.get("salesOrdId") != null ? String.valueOf(replcaceOrder_2.get("salesOrdId")) : "0";
                    	changeOrderId = replaceSalesOrdId2;
                    }else{
                    	
                    	Map<String, Object> replaceOrd3Map = new HashMap<String, Object>();
                    	replaceOrd3Map.put("replaceOrd3", "Y");
                    	replaceOrd3Map.put("custBillId", String.valueOf(params.get("custBillId")));
                    	replaceOrd3Map.put("salesOrdId", String.valueOf(params.get("salesOrdId")));
                        EgovMap replcaceOrder_3 = billGroupService.selectReplaceOrder(replaceOrd3Map);
                        
                        if(replcaceOrder_3 != null && Integer.parseInt(String.valueOf(replaceOrd3Map.get("salesOrdId"))) > 0){
                        	String replaceSalesOrdId3 = replaceOrd3Map.get("salesOrdId") != null ? String.valueOf(replaceOrd3Map.get("salesOrdId")) : "0";
                        	changeOrderId = replaceSalesOrdId3;
                        }
                    }
                    
                }
                
                if(Integer.parseInt(changeOrderId) > 0){
                	
                	// Got order to replace
                    //Insert history (Change Main Order) - previous group
        			String salesOrderIDOld = salesOrdId;
        			String salesOrderIDNew = changeOrderId;
        			String contactIDOld = "0";
        			String contactIDNew = "0";
        			String addressIDOld = "0";
        			String addressIDNew = "0";
        			String statusIDOld = "0";
        			String statusIDNew = "0";
        			String remarkOld = "";
        			String remarkNew = "";
        			String emailOld = "";
        			String emailNew = "";
        			String isEStatementOld = "0";
        			String isEStatementNew = "0";
        			String isSMSOld = "0";
        			String isSMSNew = "0";
        			String isPostOld = "0";
        			String isPostNew = "0";
        			String typeId = "1046";
        			String sysHisRemark = "[System] Group Order - Remove Order";
        			String emailAddtionalNew = "";
        			String emailAddtionalOld = "";
        			
        			Map<String, Object> insChangeHisMap = new HashMap<String, Object>();
        			insChangeHisMap.put("custBillId", custBillId);
        			insChangeHisMap.put("userId", userId);
        			insChangeHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
        			insChangeHisMap.put("salesOrderIDOld", salesOrderIDOld);
        			insChangeHisMap.put("salesOrderIDNew", salesOrderIDNew);
        			insChangeHisMap.put("contactIDOld", contactIDOld);
        			insChangeHisMap.put("contactIDNew", contactIDNew);
        			insChangeHisMap.put("addressIDOld", addressIDOld);
        			insChangeHisMap.put("addressIDNew", addressIDNew);
        			insChangeHisMap.put("statusIDOld", statusIDOld);
        			insChangeHisMap.put("statusIDNew", statusIDNew);
        			insChangeHisMap.put("remarkOld", remarkOld);
        			insChangeHisMap.put("remarkNew", remarkNew);
        			insChangeHisMap.put("emailOld", emailOld);
        			insChangeHisMap.put("emailNew", emailNew);
        			insChangeHisMap.put("isEStatementOld", isEStatementOld);
        			insChangeHisMap.put("isEStatementNew", isEStatementNew);
        			insChangeHisMap.put("isSMSOld", isSMSOld);
        			insChangeHisMap.put("isSMSNew", isSMSNew);
        			insChangeHisMap.put("isPostOld", isPostOld);
        			insChangeHisMap.put("isPostNew", isPostNew);
        			insChangeHisMap.put("typeId", typeId);
        			insChangeHisMap.put("sysHisRemark", sysHisRemark);
        			insChangeHisMap.put("emailAddtionalNew", emailAddtionalNew);
        			insChangeHisMap.put("emailAddtionalOld", emailAddtionalOld);
        			billGroupService.insHistory(insChangeHisMap);
        			
        			Map<String, Object> updChangeMap = new HashMap<String, Object>();
        			updChangeMap.put("removeOrdFlag", "Y");
        			updChangeMap.put("salesOrdId", changeOrderId);
        			updChangeMap.put("custBillId", custBillId);
        			billGroupService.updSalesOrderMaster(updChangeMap);
                	
                }
				
			}
			
			//인서트 셋팅 시작
			String salesOrderIDOld = String.valueOf(params.get("salesOrdId"));
			String salesOrderIDNew = "0";
			String contactIDOld = "0";
			String contactIDNew = "0";
			String addressIDOld = "0";
			String addressIDNew = "0";
			String statusIDOld = "0";
			String statusIDNew = "0";
			String remarkOld = "";
			String remarkNew = "";
			String emailOld = "";
			String emailNew = "";
			String isEStatementOld = "0";
			String isEStatementNew = "0";
			String isSMSOld = "0";
			String isSMSNew = "0";
			String isPostOld = "0";
			String isPostNew = "0";
			String typeId = "1046";
			String sysHisRemark = "[System] Group Order - Remove Order";
			String emailAddtionalNew = "";
			String emailAddtionalOld = "";
			
			Map<String, Object> insHisMap = new HashMap<String, Object>();
			insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
			insHisMap.put("userId", userId);
			insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
			insHisMap.put("salesOrderIDOld", salesOrderIDOld);
			insHisMap.put("salesOrderIDNew", salesOrderIDNew);
			insHisMap.put("contactIDOld", contactIDOld);
			insHisMap.put("contactIDNew", contactIDNew);
			insHisMap.put("addressIDOld", addressIDOld);
			insHisMap.put("addressIDNew", addressIDNew);
			insHisMap.put("statusIDOld", statusIDOld);
			insHisMap.put("statusIDNew", statusIDNew);
			insHisMap.put("remarkOld", remarkOld);
			insHisMap.put("remarkNew", remarkNew);
			insHisMap.put("emailOld", emailOld);
			insHisMap.put("emailNew", emailNew);
			insHisMap.put("isEStatementOld", isEStatementOld);
			insHisMap.put("isEStatementNew", isEStatementNew);
			insHisMap.put("isSMSOld", isSMSOld);
			insHisMap.put("isSMSNew", isSMSNew);
			insHisMap.put("isPostOld", isPostOld);
			insHisMap.put("isPostNew", isPostNew);
			insHisMap.put("typeId", typeId);
			insHisMap.put("sysHisRemark", sysHisRemark);
			insHisMap.put("emailAddtionalNew", emailAddtionalNew);
			insHisMap.put("emailAddtionalOld", emailAddtionalOld);
			billGroupService.insHistory(insHisMap);
			//인서트 셋팅  끝
			
			Map<String, Object> updChangeMap = new HashMap<String, Object>();
			updChangeMap.put("removeOrdFlag", "Y");
			updChangeMap.put("salesOrdId", String.valueOf(params.get("salesOrdId")));
			updChangeMap.put("custBillId", "0");
			billGroupService.updSalesOrderMaster(updChangeMap);
			
				
			message.setCode(AppConstants.SUCCESS);
	    	message.setMessage("<b>The order has been removed from billing group.</b>");
			
		}else{
			message.setCode(AppConstants.FAIL);
	    	message.setMessage("<b>Failed to remove order from this billing group. Please try again later.</b>");
		}

        
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
    	//message.setMessage(resultMessage);
		
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
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		int userId = sessionVO.getUserId();
		ReturnMessage message = new ReturnMessage();
		
		EgovMap selectCustBillMaster = billGroupService.selectCustBillMaster(params);
		String custBillId = selectCustBillMaster.get("custBillId") != null ? String.valueOf(selectCustBillMaster.get("custBillId")) : "0" ;
		
		if(selectCustBillMaster != null && Integer.parseInt(custBillId) > 0){
			
			//인서트 셋팅 시작
			String salesOrderIDOld = String.valueOf(params.get("custBillSoId"));
			String salesOrderIDNew = String.valueOf(params.get("salesOrdId"));
			String contactIDOld = "0";
			String contactIDNew = "0";
			String addressIDOld = "0";
			String addressIDNew = "0";
			String statusIDOld = "0";
			String statusIDNew = "0";
			String remarkOld = "";
			String remarkNew = "";
			String emailOld = "";
			String emailNew = "";
			String isEStatementOld = "0";
			String isEStatementNew = "0";
			String isSMSOld = "0";
			String isSMSNew = "0";
			String isPostOld = "0";
			String isPostNew = "0";
			String typeId = "1048";
			String sysHisRemark = "[System] Change Main Order";
			String emailAddtionalNew = "";
			String emailAddtionalOld = "";
			
			Map<String, Object> insHisMap = new HashMap<String, Object>();
			insHisMap.put("custBillId", String.valueOf(params.get("custBillId")));
			insHisMap.put("userId", userId);
			insHisMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
			insHisMap.put("salesOrderIDOld", salesOrderIDOld);
			insHisMap.put("salesOrderIDNew", salesOrderIDNew);
			insHisMap.put("contactIDOld", contactIDOld);
			insHisMap.put("contactIDNew", contactIDNew);
			insHisMap.put("addressIDOld", addressIDOld);
			insHisMap.put("addressIDNew", addressIDNew);
			insHisMap.put("statusIDOld", statusIDOld);
			insHisMap.put("statusIDNew", statusIDNew);
			insHisMap.put("remarkOld", remarkOld);
			insHisMap.put("remarkNew", remarkNew);
			insHisMap.put("emailOld", emailOld);
			insHisMap.put("emailNew", emailNew);
			insHisMap.put("isEStatementOld", isEStatementOld);
			insHisMap.put("isEStatementNew", isEStatementNew);
			insHisMap.put("isSMSOld", isSMSOld);
			insHisMap.put("isSMSNew", isSMSNew);
			insHisMap.put("isPostOld", isPostOld);
			insHisMap.put("isPostNew", isPostNew);
			insHisMap.put("typeId", typeId);
			insHisMap.put("sysHisRemark", sysHisRemark);
			insHisMap.put("emailAddtionalNew", emailAddtionalNew);
			insHisMap.put("emailAddtionalOld", emailAddtionalOld);
			billGroupService.insHistory(insHisMap);
			//인서트 셋팅  끝
			
			Map<String, Object> updCustMap = new HashMap<String, Object>();
			updCustMap.put("changeMainFlag", "Y");
			updCustMap.put("userId", userId);
			updCustMap.put("custBillSoId", String.valueOf(params.get("salesOrdId")));
			updCustMap.put("custBillId", String.valueOf(params.get("custBillId")));
			billGroupService.updCustMaster(updCustMap);
			
			
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
		String defaultDate = "1900-01-01";
		params.put("defaultDate", defaultDate);
		int userId = sessionVO.getUserId();
		String salesOrdNo = String.valueOf(params.get("salesOrdNo"));
		String salesOrdId2 = String.valueOf(params.get("salesOrdId"));
		String[]  salesOrdNoArr = salesOrdNo.split("\\:");
		String[]  salesOrdIdArr = salesOrdId2.split("\\:");
		int total = salesOrdNoArr.length;
		int successCnt =0;
		int failCnt =0;
		String message1 = "";
		String message2 = "";
		boolean valid = true;
    	for(int i=0 ; i < salesOrdNoArr.length; i++){
    		
    		params.put("salesOrdId", salesOrdIdArr[i].trim());
    		params.put("salesOrdNo", salesOrdNoArr[i].trim());
    		EgovMap selectSalesOrderMs = billGroupService.selectSalesOrderMs(params);
    		
    		if(selectSalesOrderMs != null && Integer.parseInt(String.valueOf(selectSalesOrderMs.get("salesOrdId"))) > 0){
    			String salesOrdId =  CommonUtils.nvl(String.valueOf(selectSalesOrderMs.get("salesOrdId")), "");
    			String custBillId =  CommonUtils.nvl(String.valueOf(selectSalesOrderMs.get("custBillId")), "");
    			
    			EgovMap selectCustBillMaster = billGroupService.selectCustBillMaster(params);
    			
    			if(selectCustBillMaster != null && Integer.parseInt(String.valueOf(selectCustBillMaster.get("custBillId"))) > 0){
    				
    				if(!custBillId.equals(String.valueOf(params.get("custBillId")))){
    					
    					//인서트 셋팅 시작
    					String salesOrderIDOld = salesOrdId;
    					String salesOrderIDNew = "0";
    					String contactIDOld = "0";
    					String contactIDNew = "0";
    					String addressIDOld = "0";
    					String addressIDNew = "0";
    					String statusIDOld = "0";
    					String statusIDNew = "0";
    					String remarkOld = "";
    					String remarkNew = "";
    					String emailOld = "";
    					String emailNew = "";
    					String isEStatementOld = "0";
    					String isEStatementNew = "0";
    					String isSMSOld = "0";
    					String isSMSNew = "0";
    					String isPostOld = "0";
    					String isPostNew = "0";
    					String typeId = "1046";
    					String sysHisRemark = "[System] Group Order - Remove Order";
    					String emailAddtionalNew = "";
    					String emailAddtionalOld = "";
    					
    					Map<String, Object> hisRemoveOrdMap = new HashMap<String, Object>();
    					hisRemoveOrdMap.put("custBillId", custBillId);
    					hisRemoveOrdMap.put("userId", userId);
    					hisRemoveOrdMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
    					hisRemoveOrdMap.put("salesOrderIDOld", salesOrderIDOld);
    					hisRemoveOrdMap.put("salesOrderIDNew", salesOrderIDNew);
    					hisRemoveOrdMap.put("contactIDOld", contactIDOld);
    					hisRemoveOrdMap.put("contactIDNew", contactIDNew);
    					hisRemoveOrdMap.put("addressIDOld", addressIDOld);
    					hisRemoveOrdMap.put("addressIDNew", addressIDNew);
    					hisRemoveOrdMap.put("statusIDOld", statusIDOld);
    					hisRemoveOrdMap.put("statusIDNew", statusIDNew);
    					hisRemoveOrdMap.put("remarkOld", remarkOld);
    					hisRemoveOrdMap.put("remarkNew", remarkNew);
    					hisRemoveOrdMap.put("emailOld", emailOld);
    					hisRemoveOrdMap.put("emailNew", emailNew);
    					hisRemoveOrdMap.put("isEStatementOld", isEStatementOld);
    					hisRemoveOrdMap.put("isEStatementNew", isEStatementNew);
    					hisRemoveOrdMap.put("isSMSOld", isSMSOld);
    					hisRemoveOrdMap.put("isSMSNew", isSMSNew);
    					hisRemoveOrdMap.put("isPostOld", isPostOld);
    					hisRemoveOrdMap.put("isPostNew", isPostNew);
    					hisRemoveOrdMap.put("typeId", typeId);
    					hisRemoveOrdMap.put("sysHisRemark", sysHisRemark);
    					hisRemoveOrdMap.put("emailAddtionalNew", emailAddtionalNew);
    					hisRemoveOrdMap.put("emailAddtionalOld", emailAddtionalOld);
    					billGroupService.insHistory(hisRemoveOrdMap);
    					//인서트 셋팅  끝
    
    					if(salesOrdId.equals(String.valueOf(selectCustBillMaster.get("custBillSoId")))){
    						
    						String changeOrderId = "0";
    						Map<String, Object> replaceOrdMap = new HashMap<String, Object>();
    		                replaceOrdMap.put("replaceOrd", "Y");
    		                replaceOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillSoId")));
    		                replaceOrdMap.put("salesOrdId", salesOrdId);
    						EgovMap replcaceOrder_1 = billGroupService.selectReplaceOrder(replaceOrdMap);
    						
    						if (replcaceOrder_1 != null && Integer.parseInt(String.valueOf(replcaceOrder_1.get("salesOrdId"))) > 0){
    							
    							changeOrderId = String.valueOf(replcaceOrder_1.get("salesOrdId"));
    							
    						}else{
    							Map<String, Object> replaceOrd2Map = new HashMap<String, Object>();
    							replaceOrd2Map.put("replaceOrd2", "Y");
    							replaceOrd2Map.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillSoId")));
    							replaceOrd2Map.put("salesOrdId", salesOrdId);
    							EgovMap replcaceOrder_2 = billGroupService.selectReplaceOrder(replaceOrd2Map);
    							
    							if (replcaceOrder_2 != null && Integer.parseInt(String.valueOf(replcaceOrder_2.get("salesOrdId"))) > 0){
    								
    								changeOrderId = String.valueOf(replcaceOrder_2.get("salesOrdId"));
    								
    							}else{
    								
    								Map<String, Object> replaceOrd3Map = new HashMap<String, Object>();
    								replaceOrd3Map.put("replaceOrd3", "Y");
    								replaceOrd3Map.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillSoId")));
    								replaceOrd3Map.put("salesOrdId", salesOrdId);
    								EgovMap replcaceOrder_3 = billGroupService.selectReplaceOrder(replaceOrd3Map);
    								
    								if (replcaceOrder_3 != null && Integer.parseInt(String.valueOf(replcaceOrder_3.get("salesOrdId"))) > 0){
    									changeOrderId = String.valueOf(replcaceOrder_3.get("salesOrdId"));
    								}
    								
    							}
    							
    						}
    						
    						if(Integer.parseInt(changeOrderId) > 0 ){
    							
    							// Got order to replace
                                //Insert history (Change Main Order) - previous group
    							String salesOrderIDOld2 = salesOrdId;
    							String salesOrderIDNew2 = changeOrderId;
    							String contactIDOld2 = "0";
    							String contactIDNew2 = "0";
    							String addressIDOld2 = "0";
    							String addressIDNew2 = "0";
    							String statusIDOld2 = "0";
    							String statusIDNew2 = "0";
    							String remarkOld2 = "";
    							String remarkNew2 = "";
    							String emailOld2 = "";
    							String emailNew2 = "";
    							String isEStatementOld2 = "0";
    							String isEStatementNew2 = "0";
    							String isSMSOld2 = "0";
    							String isSMSNew2 = "0";
    							String isPostOld2 = "0";
    							String isPostNew2 = "0";
    							String typeId2 = "1046";
    							String sysHisRemark2 = "[System] Group Order - Auto Select Main Order";
    							String emailAddtionalNew2 = "";
    							String emailAddtionalOld2 = "";
    							
    							Map<String, Object> hisChgOrdMap = new HashMap<String, Object>();
    							hisChgOrdMap.put("custBillId", String.valueOf(selectCustBillMaster.get("custBillId")));
    							hisChgOrdMap.put("userId", userId);
    							hisChgOrdMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
    							hisChgOrdMap.put("salesOrderIDOld", salesOrderIDOld2);
    							hisChgOrdMap.put("salesOrderIDNew", salesOrderIDNew2);
    							hisChgOrdMap.put("contactIDOld", contactIDOld2);
    							hisChgOrdMap.put("contactIDNew", contactIDNew2);
    							hisChgOrdMap.put("addressIDOld", addressIDOld2);
    							hisChgOrdMap.put("addressIDNew", addressIDNew2);
    							hisChgOrdMap.put("statusIDOld", statusIDOld2);
    							hisChgOrdMap.put("statusIDNew", statusIDNew2);
    							hisChgOrdMap.put("remarkOld", remarkOld2);
    							hisChgOrdMap.put("remarkNew", remarkNew2);
    							hisChgOrdMap.put("emailOld", emailOld2);
    							hisChgOrdMap.put("emailNew", emailNew2);
    							hisChgOrdMap.put("isEStatementOld", isEStatementOld2);
    							hisChgOrdMap.put("isEStatementNew", isEStatementNew2);
    							hisChgOrdMap.put("isSMSOld", isSMSOld2);
    							hisChgOrdMap.put("isSMSNew", isSMSNew2);
    							hisChgOrdMap.put("isPostOld", isPostOld2);
    							hisChgOrdMap.put("isPostNew", isPostNew2);
    							hisChgOrdMap.put("typeId", typeId2);
    							hisChgOrdMap.put("sysHisRemark", sysHisRemark2);
    							hisChgOrdMap.put("emailAddtionalNew", emailAddtionalNew2);
    							hisChgOrdMap.put("emailAddtionalOld", emailAddtionalOld2);
    							billGroupService.insHistory(hisChgOrdMap);
    							//인서트 셋팅  끝
    							
    							Map<String, Object> updChangeMap = new HashMap<String, Object>();
    		        			updChangeMap.put("addOrdFlag", "Y");
    		        			updChangeMap.put("salesOrdId", changeOrderId);
    		        			updChangeMap.put("custBillId", custBillId);
    		        			billGroupService.updSalesOrderMaster(updChangeMap);
    						}else{
    							
    							// No replace order found - Inactive billing group
                                //Insert history (Change Main Order) - previous group
    							String salesOrderIDOld2 = salesOrdId;
    							String salesOrderIDNew2 = changeOrderId;
    							String contactIDOld2 = "0";
    							String contactIDNew2 = "0";
    							String addressIDOld2 = "0";
    							String addressIDNew2 = "0";
    							String statusIDOld2 = String.valueOf(selectCustBillMaster.get("custBillStusId"));
    							String statusIDNew2 = "8";
    							String remarkOld2 = "";
    							String remarkNew2 = "";
    							String emailOld2 = "";
    							String emailNew2 = "";
    							String isEStatementOld2 = "0";
    							String isEStatementNew2 = "0";
    							String isSMSOld2 = "0";
    							String isSMSNew2 = "0";
    							String isPostOld2 = "0";
    							String isPostNew2 = "0";
    							String typeId2 = "1046";
    							String sysHisRemark2 = "[System] Group Order - Auto Deactivate";
    							String emailAddtionalNew2 = "";
    							String emailAddtionalOld2 = "";
    							
    							Map<String, Object> hisChgOrdMap = new HashMap<String, Object>();
    							hisChgOrdMap.put("custBillId", custBillId);
    							hisChgOrdMap.put("userId", userId);
    							hisChgOrdMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
    							hisChgOrdMap.put("salesOrderIDOld", salesOrderIDOld2);
    							hisChgOrdMap.put("salesOrderIDNew", salesOrderIDNew2);
    							hisChgOrdMap.put("contactIDOld", contactIDOld2);
    							hisChgOrdMap.put("contactIDNew", contactIDNew2);
    							hisChgOrdMap.put("addressIDOld", addressIDOld2);
    							hisChgOrdMap.put("addressIDNew", addressIDNew2);
    							hisChgOrdMap.put("statusIDOld", statusIDOld2);
    							hisChgOrdMap.put("statusIDNew", statusIDNew2);
    							hisChgOrdMap.put("remarkOld", remarkOld2);
    							hisChgOrdMap.put("remarkNew", remarkNew2);
    							hisChgOrdMap.put("emailOld", emailOld2);
    							hisChgOrdMap.put("emailNew", emailNew2);
    							hisChgOrdMap.put("isEStatementOld", isEStatementOld2);
    							hisChgOrdMap.put("isEStatementNew", isEStatementNew2);
    							hisChgOrdMap.put("isSMSOld", isSMSOld2);
    							hisChgOrdMap.put("isSMSNew", isSMSNew2);
    							hisChgOrdMap.put("isPostOld", isPostOld2);
    							hisChgOrdMap.put("isPostNew", isPostNew2);
    							hisChgOrdMap.put("typeId", typeId2);
    							hisChgOrdMap.put("sysHisRemark", sysHisRemark2);
    							hisChgOrdMap.put("emailAddtionalNew", emailAddtionalNew2);
    							hisChgOrdMap.put("emailAddtionalOld", emailAddtionalOld2);
    							billGroupService.insHistory(hisChgOrdMap);
    							//인서트 셋팅  끝
    							
    							Map<String, Object> updChangeMap = new HashMap<String, Object>();
    							updChangeMap.put("addOrdFlag", "Y");
    		        			updChangeMap.put("salesOrdId", changeOrderId);
    		        			updChangeMap.put("custBillId", custBillId);
    		        			billGroupService.updSalesOrderMaster(updChangeMap);
    							
    						}
    					}
    				}
    			}
    			
    			String salesOrderIDOld = "0";
    			String salesOrderIDNew = salesOrdIdArr[i].trim();
    			String contactIDOld = "0";
    			String contactIDNew = "0";
    			String addressIDOld = "0";
    			String addressIDNew = "0";
    			String statusIDOld = "0";
    			String statusIDNew = "0";
    			String remarkOld = "";
    			String remarkNew = "";
    			String emailOld = "";
    			String emailNew = "";
    			String isEStatementOld = "0";
    			String isEStatementNew = "0";
    			String isSMSOld = "0";
    			String isSMSNew = "0";
    			String isPostOld = "0";
    			String isPostNew = "0";
    			String typeId = "1046";
    			String sysHisRemark = "[System] Group Order - Add Order";
    			String emailAddtionalNew = "";
    			String emailAddtionalOld = "";
    			
    			Map<String, Object> hisAddOrdMap = new HashMap<String, Object>();
    			hisAddOrdMap.put("custBillId", String.valueOf(params.get("custBillId")));
    			hisAddOrdMap.put("userId", userId);
    			hisAddOrdMap.put("reasonUpd", String.valueOf(params.get("reasonUpd")).trim());
    			hisAddOrdMap.put("salesOrderIDOld", salesOrderIDOld);
    			hisAddOrdMap.put("salesOrderIDNew", salesOrderIDNew);
    			hisAddOrdMap.put("contactIDOld", contactIDOld);
    			hisAddOrdMap.put("contactIDNew", contactIDNew);
    			hisAddOrdMap.put("addressIDOld", addressIDOld);
    			hisAddOrdMap.put("addressIDNew", addressIDNew);
    			hisAddOrdMap.put("statusIDOld", statusIDOld);
    			hisAddOrdMap.put("statusIDNew", statusIDNew);
    			hisAddOrdMap.put("remarkOld", remarkOld);
    			hisAddOrdMap.put("remarkNew", remarkNew);
    			hisAddOrdMap.put("emailOld", emailOld);
    			hisAddOrdMap.put("emailNew", emailNew);
    			hisAddOrdMap.put("isEStatementOld", isEStatementOld);
    			hisAddOrdMap.put("isEStatementNew", isEStatementNew);
    			hisAddOrdMap.put("isSMSOld", isSMSOld);
    			hisAddOrdMap.put("isSMSNew", isSMSNew);
    			hisAddOrdMap.put("isPostOld", isPostOld);
    			hisAddOrdMap.put("isPostNew", isPostNew);
    			hisAddOrdMap.put("typeId", typeId);
    			hisAddOrdMap.put("sysHisRemark", sysHisRemark);
    			hisAddOrdMap.put("emailAddtionalNew", emailAddtionalNew);
    			hisAddOrdMap.put("emailAddtionalOld", emailAddtionalOld);
    			
    			if(1 == billGroupService.insHistory(hisAddOrdMap)){
    				successCnt += 1;
    				message2 += String.valueOf(params.get("salesOrdNo")) + ": " +"Success \n";
    			}else{
    				failCnt += 1;
    				message2 += String.valueOf(params.get("salesOrdNo")) + ": " +"Failed \n";
    			}

    			Map<String, Object> updChangeMap = new HashMap<String, Object>();
    			updChangeMap.put("addOrdFlag", "Y");
    			updChangeMap.put("salesOrdId", salesOrdIdArr[i].trim());
    			updChangeMap.put("custBillId", String.valueOf(params.get("custBillId")));
    			billGroupService.updSalesOrderMaster(updChangeMap);
    			
    			
    		}else{
    			valid = false;
    		}
		}
		
    	if(valid){
    		
    		message1 += "Total order : " + total + " || " +
	                "Total success : " + successCnt + " || " +
	                "Total fail : " + failCnt + "\n";
    		
    		message.setMessage(message1 + message2);
    		message.setCode(AppConstants.SUCCESS);
    	}else{
    		message.setMessage("Failed to manage grouping. Please try again later.");
    		message.setCode(AppConstants.FAIL);
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
		
		String saveResult = billGroupService.saveAddNewGroup(params, sessionVO);
		
		if(saveResult != null || !"".equals(saveResult)){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage("New billing group created.<br /> " +
                    "Billing Group Number : " + saveResult + "<br />");
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
