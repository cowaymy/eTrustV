/**
 * 
 */
package com.coway.trust.web.sales.order;

import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/order")
public class OrderListController {

	private static Logger logger = LoggerFactory.getLogger(OrderListController.class);
	
	@Resource(name = "orderListService")
	private OrderListService orderListService;
	
	@Resource(name = "installationResultListService")
	private InstallationResultListService installationResultListService;
	
	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;
	

	
	@RequestMapping(value = "/orderList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		
		model.put("bfDay", bfDay);
		model.put("toDay", toDay);
		
		return "sales/order/orderList";
	}
	
	@RequestMapping(value = "/selectOrderJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		String[] arrAppType   = request.getParameterValues("appType"); //Application Type
		String[] arrOrdStusId = request.getParameterValues("ordStusId"); //Order Status 
		String[] arrKeyinBrnchId = request.getParameterValues("keyinBrnchId"); //Key-In Branch
		String[] arrDscBrnchId = request.getParameterValues("dscBrnchId"); //DSC Branch 
		String[] arrRentStus = request.getParameterValues("rentStus"); //Rent Status

		if(StringUtils.isEmpty(params.get("ordStartDt"))) params.put("ordStartDt", "01/01/1900");
    	if(StringUtils.isEmpty(params.get("ordEndDt")))   params.put("ordEndDt",   "31/12/9999");
    	
    	params.put("ordStartDt", CommonUtils.changeFormat(String.valueOf(params.get("ordStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    	params.put("ordEndDt", CommonUtils.changeFormat(String.valueOf(params.get("ordEndDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
		
		if(arrAppType      != null && !CommonUtils.containsEmpty(arrAppType))      params.put("arrAppType", arrAppType);
		if(arrOrdStusId    != null && !CommonUtils.containsEmpty(arrOrdStusId))    params.put("arrOrdStusId", arrOrdStusId);
		if(arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrDscBrnchId   != null && !CommonUtils.containsEmpty(arrDscBrnchId))   params.put("arrDscBrnchId", arrDscBrnchId);
		if(arrRentStus     != null && !CommonUtils.containsEmpty(arrRentStus))     params.put("arrRentStus", arrRentStus);
		
		if(params.get("custIc") == null) {logger.debug("!@###### custIc is null");}
		if("".equals(params.get("custIc"))) {logger.debug("!@###### custIc ''");}
		
		logger.debug("!@##############################################################################");
		logger.debug("!@###### ordNo : "+params.get("ordNo"));
		logger.debug("!@###### ordStartDt : "+params.get("ordStartDt"));
		logger.debug("!@###### ordEndDt : "+params.get("ordEndDt"));
		logger.debug("!@###### ordDt : "+params.get("ordDt"));
		logger.debug("!@###### custIc : "+params.get("custIc"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> orderList = orderListService.selectOrderList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orderList);
	}
	
	@RequestMapping(value = "/orderRentToOutrSimulPop.do")
	public String orderRentToOutrSimulPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO session) {
		
		model.put("ordNo", params.get("ordNo"));
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT3));
		
		//Report Param
		model.put("userName", session.getUserId());
		model.put("brnchCode", session.getBranchName());  //AS-IS Brnch Code 
		
		return "sales/order/orderRentToOutrSimulPop";
	}
	
	@RequestMapping(value="/orderRentalPaySettingUpdateListPop.do")
	public String orderRentalPaySettingUpdateListPop(){
		
		return "sales/order/orderRentalPaySettingUpdateListPop";
	}
	
	@RequestMapping(value="/orderSOFListPop.do")
	public String orderSOFListPop(){
		
		return "sales/order/orderSOFListPop";
	}
	
	@RequestMapping(value="/getApplicationTypeList")
	public ResponseEntity<List<EgovMap>> getApplicationTypeList(@RequestParam Map<String, Object> params) throws Exception{
	
		List<EgovMap> applicationTypeList = null;
		applicationTypeList = orderListService.getApplicationTypeList(params);
	
		return ResponseEntity.ok(applicationTypeList);	
	}
	
	@RequestMapping(value="/getUserCodeList")
	public ResponseEntity<List<EgovMap>> getUserCodeList() throws Exception{
	
		List<EgovMap> userCodeList = null;
		userCodeList = orderListService.getUserCodeList();
		
		return ResponseEntity.ok(userCodeList);
	}
	
	@RequestMapping(value="/orderDDCRCListPop.do")
	public String orderDDCRCListPop(){
		
		return "sales/order/orderDDCRCListPop";
	}
	
	@RequestMapping(value="/orderASOSalesReportPop.do")
	public String orderASOSalesReportPop(){
		
		return "sales/order/orderASOSalesReportPop";
	}
	
	@RequestMapping(value="/orderSalesYSListingPop.do")
	public String orderSalesYSListingPop(){
		
		return "sales/order/orderSalesYSListingPop";
	}
	
	@RequestMapping(value="/getOrgCodeList")
	public ResponseEntity<List<EgovMap>> getOrgCodeList(@RequestParam Map<String, Object> params) throws Exception{
	
		List<EgovMap> orgCodeList = null;
		orgCodeList = orderListService.getOrgCodeList(params);
		
		return ResponseEntity.ok(orgCodeList);
	}
	
	@RequestMapping(value="/getGrpCodeList")
	public ResponseEntity<List<EgovMap>> getGrpCodeList(@RequestParam Map<String, Object> params) throws Exception{
	
		List<EgovMap> grpCodeList = null;
		grpCodeList = orderListService.getGrpCodeList(params);
		
		return ResponseEntity.ok(grpCodeList);
	}

	@RequestMapping(value = "/getMemberOrgInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> getMemberOrgInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

        EgovMap result = orderListService.getMemberOrgInfo(params);

        return ResponseEntity.ok(result);
    }
	
	@RequestMapping(value="/getBankCodeList")
	public ResponseEntity<List<EgovMap>> getBankCodeList(@RequestParam Map<String, Object> params) throws Exception{
	
		List<EgovMap> bankCodeList = null;
		bankCodeList = orderListService.getBankCodeList(params);
	
		return ResponseEntity.ok(bankCodeList);
	}
	
	
	
	
	@RequestMapping(value = "/addProductReturnPopup.do")
	public String addInstallationPopup(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
		logger.debug("params : {}",params);
		params.put("ststusCodeId", 1);
		params.put("reasonTypeId", 172);
		params.put("codeId", 257);
		
		EgovMap installParam   = orderListService.selectInstallParam(params);
		
		
		params.put("installEntryId" ,  String.valueOf(installParam.get("installEntryId"))  );
		logger.debug("params : {}",params);
		
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
		logger.debug("paramsqqqq {}",   installResult  );
		Object custId =( orderInfo == null ? installResult.get("custId") :  orderInfo.get("custId") );
		params.put("custId", custId);
		params.put("salesOrdNo", params.get("salesOrderNO"));
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
		model.addAttribute("callEntryId" , params.get("callEntryId"));
		// 호출될 화면
		return "sales/order/addProductReturnResultPop";
	}
	
	@RequestMapping(value = "/viewProductReturnSearch.do")
	public ResponseEntity<List<EgovMap>> productReturnResultView(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model){
		
		logger.debug("params : {}", params);
		List<EgovMap> viewProductReturn = orderListService.selectProductReturnView(params);
		logger.debug("viewProductReturn : {}", viewProductReturn);
		return ResponseEntity.ok(viewProductReturn);
		
	}
	
	@RequestMapping(value = "/addProductReturn.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertProductReturnResult(@RequestBody Map<String, Object> params,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();
		logger.debug("params : {}", params);
		
		EgovMap   pReturnParam =orderListService.getPReturnParam(params);
		if(String.valueOf(params.get("returnStatus")).equals("4") ) { //성공시
			Map<String, Object>    cvMp = new HashMap<String, Object>(); 
			
			
			
        	cvMp.put("stkRetnStusId",  			"4");  
        	cvMp.put("stkRetnStkIsRet",  			"1");  
        	cvMp.put("stkRetnRem",  			    String.valueOf(params.get("remark"))); 
        	cvMp.put("stkRetnResnId", 		    pReturnParam.get("soReqResnId"));   //?
        	cvMp.put("stkRetnCcId",  		     	"1781"); //?
        	cvMp.put("stkRetnCrtUserId",         sessionVO.getUserId());
        	cvMp.put("stkRetnUpdUserId",        sessionVO.getUserId()); 
        	cvMp.put("stkRetnResultIsSynch",   "0"); 
        	cvMp.put("stkRetnAllowComm",  	"1"); 
        	cvMp.put("stkRetnCtMemId",  		params.get("CTID")); 
        	cvMp.put("checkinDt",  					String.valueOf( params.get("returnDate") ) ); 
        	cvMp.put("checkinTm",  				""); 
        	cvMp.put("checkinGps",  				""); 
        	cvMp.put("signData",  					""); 
        	cvMp.put("signRegDt",  			    String.valueOf( params.get("returnDate") ) );  
        	cvMp.put("signRegTm",  				""); 
        	cvMp.put("ownerCode",                String.valueOf(params.get("custRelationship"))); 
        	cvMp.put("resultCustName",  		String.valueOf(params.get("hidCustomerName"))); 
        	cvMp.put("resultIcmobileNo",  		String.valueOf(params.get("hidCustomerContact"))); 
        	cvMp.put("resultRptEmailNo",  		""); 
        	cvMp.put("resultAceptName",  		String.valueOf(params.get("custName"))); 
        	cvMp.put("salesOrderNo",  String.valueOf(params.get("hidTaxInvDSalesOrderNo"))); 
        	cvMp.put("userId",  sessionVO.getUserId()); 
        	cvMp.put("serviceNo",  String.valueOf(pReturnParam.get("retnNo"))); 
        	//cvMp.put("transactionId",  String.valueOf(paramsTran.get("transactionId"))); 
        	logger.debug("cvMp : {}", cvMp);
        	
        		EgovMap  rtnValue = orderListService.productReturnResult(cvMp);
			
			if( null !=rtnValue){
				HashMap   spMap =(HashMap)rtnValue.get("spMap");
				logger.debug("spMap :"+ spMap.toString());   
				if(!"000".equals(spMap.get("P_RESULT_MSG"))){
					rtnValue.put("logerr","Y");
				}
				servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
			}
        	
		}

		else{ // 실패시
			Map<String, Object> failParam = params;

			failParam.put("userId", sessionVO.getUserId() );
			failParam.put("salesOrderNo",  params.get("hidTaxInvDSalesOrderNo") );
			failParam.put("serviceNo",  pReturnParam.get("retnNo") );
			failParam.put("failReasonCode",  params.get("failReason") );
			
			
			orderListService.setPRFailJobRequest(params);		
			
			
		}
	
		return ResponseEntity.ok(message);
	}
	
	
	
}
