/**
 *
 */
package com.coway.trust.web.sales.order;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
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
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.BizException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/order")
public class OrderListController {

	private static Logger logger = LoggerFactory.getLogger(OrderListController.class);

	@Resource(name = "accessMonitoringService")
	private AccessMonitoringService accessMonitoringService;

	@Resource(name = "orderListService")
	private OrderListService orderListService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "installationResultListService")
	private InstallationResultListService installationResultListService;

	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;


	@RequestMapping(value = "/orderList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		if(sessionVO.getUserTypeId() != 4 && sessionVO.getUserTypeId() != 6) {
		    params.put("userId", sessionVO.getUserId());
		    EgovMap result =  salesCommonService.getUserInfo(params);

		    model.put("memId", result.get("memId"));
		    model.put("memCode", result.get("memCode"));
		    model.put("orgCode", result.get("orgCode"));
		    model.put("grpCode", result.get("grpCode"));
		    model.put("deptCode", result.get("deptCode"));
		}

		return "sales/order/orderList";
	}

	@RequestMapping(value = "/selectOrderJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		//Log down user search params
    	StringBuffer requestUrl = new StringBuffer(request.getRequestURI());
    	requestUrl.replace(requestUrl.lastIndexOf("/"), requestUrl.lastIndexOf("/") + 1, "/orderList.do/");
		accessMonitoringService.insertSubAccessMonitoring(requestUrl.toString(), params, request,sessionVO);

		String[] arrAppType   = request.getParameterValues("appType"); //Application Type
		String[] arrOrdStusId = request.getParameterValues("ordStusId"); //Order Status
		String[] arrKeyinBrnchId = request.getParameterValues("keyinBrnchId"); //Key-In Branch
		String[] arrDscBrnchId = request.getParameterValues("dscBrnchId"); //DSC Branch
		String[] arrRentStus = request.getParameterValues("rentStus"); //Rent Status
		String[] orderIDList=new String[255];

		if(StringUtils.isEmpty(params.get("ordStartDt"))) params.put("ordStartDt", "01/01/1900");
    	if(StringUtils.isEmpty(params.get("ordEndDt")))   params.put("ordEndDt",   "31/12/9999");

    	params.put("ordStartDt", CommonUtils.changeFormat(String.valueOf(params.get("ordStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    	params.put("ordEndDt", CommonUtils.changeFormat(String.valueOf(params.get("ordEndDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

		if(arrAppType      != null && !CommonUtils.containsEmpty(arrAppType))      params.put("arrAppType", arrAppType);
		if(arrOrdStusId    != null && !CommonUtils.containsEmpty(arrOrdStusId))    params.put("arrOrdStusId", arrOrdStusId);
		if(arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrDscBrnchId   != null && !CommonUtils.containsEmpty(arrDscBrnchId))   params.put("arrDscBrnchId", arrDscBrnchId);
		if(arrRentStus     != null && !CommonUtils.containsEmpty(arrRentStus))     params.put("arrRentStus", arrRentStus);

		if(sessionVO.getUserTypeId() != 4 && sessionVO.getUserTypeId() != 6) {
		    params.put("memType", sessionVO.getUserTypeId());
		    params.put("memlvl", sessionVO.getMemberLevel());
		}

		if(params.get("custIc") == null) {logger.debug("!@###### custIc is null");}
		if("".equals(params.get("custIc"))) {logger.debug("!@###### custIc ''");}

		logger.debug("!@##############################################################################");
		logger.debug("!@###### ordNo : "+params.get("ordNo"));
		logger.debug("!@###### ordStartDt : "+params.get("ordStartDt"));
		logger.debug("!@###### ordEndDt : "+params.get("ordEndDt"));
		logger.debug("!@###### ordDt : "+params.get("ordDt"));
		logger.debug("!@###### custIc : "+params.get("custIc"));
		logger.debug("!@##############################################################################");


		List<EgovMap> orderList =null;

		/*****************************************
		 *
		 *****************************************/
		logger.debug("vaNo,{}", StringUtils.isEmpty(params.get("vaNo")));
		logger.debug("listContactNo,{}", StringUtils.isEmpty(params.get("contactNo")));
		logger.debug("listCustIc,{}", StringUtils.isEmpty(params.get("custIc")));
		logger.debug("listCustName,{}", StringUtils.isEmpty(params.get("custName")));
		logger.debug("listCrtUserId,{}", StringUtils.isEmpty(params.get("crtUserId")));

		// 20210310 - LaiKW - Added 2 steps searching by removal of installation sirim/serial search
        if(params.containsKey("sirimNo") || params.containsKey("serialNo")) {
            if(!"".equals(params.get("sirimNo").toString()) || !"".equals(params.get("serialNo").toString())) {
            	//29-12-2022 - Chou Jia Cheng - edited serial number to be able to view more than one result at a time
            	List<EgovMap> ordID = orderListService.getSirimOrdID(params);
            	orderIDList=new String[ordID.size()];
            	for (int i=0;i<ordID.size();i++){
            		orderIDList[i]=String.valueOf(ordID.get(i).get("salesOrdId"));
            	}
                params.put("ordId", orderIDList);
            }
        }

        if(params.containsKey("salesmanCode")) {
            if(!"".equals(params.get("salesmanCode").toString())) {
                int memberID = orderListService.getMemberID(params);
                params.put("memID", memberID);
            }
        }

        if(params.containsKey("billGroupNo")) {
            if(!"".equals(params.get("billGroupNo").toString())) {
                int billGroupNo = orderListService.selectCustBillId(params);
                params.put("billGroupNo", billGroupNo);
            }
        }

		//if  Customer  (NRIC / VANo / ContactNo/ NAME / CrtUserId )   not empty
		if( ! StringUtils.isEmpty(params.get("vaNo"))
					 ||! StringUtils.isEmpty(params.get("contactNo"))
					 ||! StringUtils.isEmpty(params.get("custIc"))
					 ||! StringUtils.isEmpty(params.get("custName"))
					 ||! StringUtils.isEmpty(params.get("crtUserId"))
					 ||! StringUtils.isEmpty(params.get("refNo"))
					 ||! StringUtils.isEmpty(params.get("poNo"))){

			String[] arrayCustId =null;

			try{
				 arrayCustId =this.getExtCustIdList(params);
				 params.put("arrayCustId", arrayCustId);

				 if(null !=arrayCustId  || arrayCustId.length>0){
					 orderList = orderListService.selectOrderList(params);
				 }

			}catch (NullPointerException  nex){
				throw new ApplicationException(AppConstants.FAIL, "no data found");

			}catch(Exception  e){
				throw new ApplicationException(AppConstants.FAIL, "Please key in the correct data");
			}

		}else{
			orderList = orderListService.selectOrderList(params);
		}


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

	@RequestMapping(value="/outstandingLetterPop.do")
	public String outstandingLetterPop(){

		return "sales/order/outstandingLetterPop";
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
		params.put("reasonTypeId", 174);
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
			if(!promotionId.equals("0")){
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
		EgovMap pRCtInfo =orderListService.getPrCTInfo(params);
		//if(params.get("codeId").toString().equals("258")){

		//}

		// 시리얼 번호 조회
		Map<String, Object> schParams = new HashMap<String, Object>() ;
		System.out.println("++++ codeId ::" + params.get("codeId") );
		System.out.println("++++ orderInfo ::" + orderInfo );
		if(CommonUtils.nvl(params.get("codeId")).toString().equals("258")){
			schParams.put("pItmCode", orderInfo.get("c6"));
		}else{
			schParams.put("pItmCode", orderInfo.get("stkCode"));
		}
		schParams.put("pSalesOrdId", installResult.get("salesOrdId"));
		Map<String, Object> orderSerialMap = orderListService.selectOrderSerial(schParams);
		String orderSerialNo = "";
		if(!StringUtils.isEmpty( orderSerialMap ) ) orderSerialNo = (String)orderSerialMap.get("orderSerial");

		logger.debug("orderSerialMap : {}", orderSerialMap);
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
		model.addAttribute("pRCtInfo", pRCtInfo);
		model.addAttribute("callEntryId" , params.get("callEntryId"));
		model.addAttribute("orderSerial" , orderSerialNo );
		model.addAttribute("homecareYn" , CommonUtils.nvl2(params.get("homecareYn"), "N"));

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
		logger.debug("AddProductreturn + params : {}", params);

		EgovMap   pReturnParam =orderListService.getPReturnParam(params);
		if(String.valueOf(params.get("returnStatus")).equals("4") ) { //성공시
			Map<String, Object>    cvMp = new HashMap<String, Object>();

		     int noRcd = orderListService.chkRcdTms(params);


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


        	// Data Preparation for 3 Month Cooling Off Block List
        	cvMp.put("salesOrderId",  params.get("hidSalesOrderId"));
          cvMp.put("appTypeId",  params.get("hidAppTypeId"));
          cvMp.put("custId",  params.get("hidCustomerId"));
          cvMp.put("productId",  params.get("hidProductId"));
          cvMp.put("categoryId",  params.get("hidCategoryId"));
          cvMp.put("brnchId",  sessionVO.getUserBranchId());

          //INSERT SMS FOR APPOINTMENT - KEYI - 2022/01/12
          cvMp.put("soReqCurStusId",  String.valueOf(pReturnParam.get("soReqCurStusId"))); //REQ_STAGE_ID
          cvMp.put("memCode",  String.valueOf(pReturnParam.get("memCode"))); //CT CODE

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
			message.setMessage("Success : Product Return is Complete");

		}

		else{ // 실패시
			Map<String, Object> failParam = params;

			failParam.put("userId", sessionVO.getUserId() );
			failParam.put("salesOrderNo",  params.get("hidTaxInvDSalesOrderNo") );
			failParam.put("serviceNo",  pReturnParam.get("retnNo") );
			failParam.put("failReasonCode",  params.get("failReason") );

			//INSERT SMS FOR APPOINTMENT - KEYI - 2022/01/12
			failParam.put("appTypeId",  params.get("hidAppTypeId"));
			failParam.put("soReqCurStusId",  String.valueOf(pReturnParam.get("soReqCurStusId"))); //REQ_STAGE_ID

			orderListService.setPRFailJobRequest(params);
			message.setMessage("Success : Product Return is Fail");

		}

		return ResponseEntity.ok(message);
	}

	// KR_HAN : Serial 추가
	@RequestMapping(value = "/addProductReturnSerial.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertProductReturnResultSerial(@RequestBody Map<String, Object> params,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();


		params.put("userId", sessionVO.getUserId() );
		params.put("brnchId", sessionVO.getUserBranchId() );

		logger.debug("params : {}", params);

		EgovMap rtnMap = orderListService.insertProductReturnResultSerial(params);



//		Map<String, Object> resultValue = new HashMap<String, Object>();
//		EgovMap   pReturnParam =orderListService.getPReturnParam(params);
//		if(String.valueOf(params.get("returnStatus")).equals("4") ) { //성공시
//			Map<String, Object>    cvMp = new HashMap<String, Object>();
//
//		     int noRcd = orderListService.chkRcdTms(params);
//
//
//        	cvMp.put("stkRetnStusId",  			"4");
//        	cvMp.put("stkRetnStkIsRet",  			"1");
//        	cvMp.put("stkRetnRem",  			    String.valueOf(params.get("remark")));
//        	cvMp.put("stkRetnResnId", 		    pReturnParam.get("soReqResnId"));   //?
//        	cvMp.put("stkRetnCcId",  		     	"1781"); //?
//        	cvMp.put("stkRetnCrtUserId",         sessionVO.getUserId());
//        	cvMp.put("stkRetnUpdUserId",        sessionVO.getUserId());
//        	cvMp.put("stkRetnResultIsSynch",   "0");
//        	cvMp.put("stkRetnAllowComm",  	"1");
//        	cvMp.put("stkRetnCtMemId",  		params.get("CTID"));
//        	cvMp.put("checkinDt",  					String.valueOf( params.get("returnDate") ) );
//        	cvMp.put("checkinTm",  				"");
//        	cvMp.put("checkinGps",  				"");
//        	cvMp.put("signData",  					"");
//        	cvMp.put("signRegDt",  			    String.valueOf( params.get("returnDate") ) );
//        	cvMp.put("signRegTm",  				"");
//        	cvMp.put("ownerCode",                String.valueOf(params.get("custRelationship")));
//        	cvMp.put("resultCustName",  		String.valueOf(params.get("hidCustomerName")));
//        	cvMp.put("resultIcmobileNo",  		String.valueOf(params.get("hidCustomerContact")));
//        	cvMp.put("resultRptEmailNo",  		"");
//        	cvMp.put("resultAceptName",  		String.valueOf(params.get("custName")));
//        	cvMp.put("salesOrderNo",  String.valueOf(params.get("hidTaxInvDSalesOrderNo")));
//        	cvMp.put("userId",  sessionVO.getUserId());
//        	cvMp.put("serviceNo",  String.valueOf(pReturnParam.get("retnNo")));
//        	//cvMp.put("transactionId",  String.valueOf(paramsTran.get("transactionId")));
//        	logger.debug("cvMp : {}", cvMp);
//
//        		EgovMap  rtnValue = orderListService.productReturnResult(cvMp);
//
//			if( null !=rtnValue){
//				HashMap   spMap =(HashMap)rtnValue.get("spMap");
//				logger.debug("spMap :"+ spMap.toString());
//				if(!"000".equals(spMap.get("P_RESULT_MSG"))){
//					rtnValue.put("logerr","Y");
//				}
//				servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
//			}
//			message.setMessage("Success : Product Return is Complete");
//
//		}
//
//		else{ // 실패시
//			Map<String, Object> failParam = params;
//
//			failParam.put("userId", sessionVO.getUserId() );
//			failParam.put("salesOrderNo",  params.get("hidTaxInvDSalesOrderNo") );
//			failParam.put("serviceNo",  pReturnParam.get("retnNo") );
//			failParam.put("failReasonCode",  params.get("failReason") );
//
//
//			orderListService.setPRFailJobRequest(params);
//			message.setMessage("Success : Product Return is Fail");
//
//		}

//		message.setMessage("Success : Product Return is Fail");
		message.setMessage( (String) rtnMap.get("message"));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectOrderJsonListVRescue", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderJsonListVRescue(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

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

		List<EgovMap> orderList = orderListService.selectOrderListVRescue(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orderList);
	}

	@RequestMapping(value="/orderEKeyInListPop.do")
	public String orderEKeyInListPop(){

		return "sales/order/orderEKeyInListingPop";
	}

	// KR_HAN
	// 시러얼 수정 팝업 호출
	@RequestMapping(value="/serialNoModifyPop.do")
	public String serialNoModifyPop(@RequestParam Map<String, Object> params, ModelMap model){

		logger.debug("serialNoModificationPop params : {}",params);

		model.put("pSerialNo"		, params.get("pSerialNo") );
		model.put("pSalesOrdId"	, params.get("pSalesOrdId") );
		model.put("pSalesOrdNo"	, params.get("pSalesOrdNo") );
		model.put("pRetnNo"			, params.get("pRetnNo") );
		model.put("pStkCode"		, params.get("pStkCode") );

		return "sales/order/serialNoModifyPop";
	}

	@RequestMapping(value = "/selectCboPckLinkOrdSub", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCboPckLinkOrdSub(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
	   List<EgovMap> orderList = orderListService.selectCboPckLinkOrdSub(params);
	  return ResponseEntity.ok(orderList);
	}

	@RequestMapping(value = "/selectCboPckLinkOrdSub2", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCboPckLinkOrdSub2(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
	  List<EgovMap> orderList = orderListService.selectCboPckLinkOrdSub2(params);
	  return ResponseEntity.ok(orderList);
	}

	@RequestMapping(value="/orderMSOFListPop.do")
    public String orderMSOFListPop(){

        return "sales/order/orderMSOFListPop";
    }

    // KR HAN : Save Serial No Modify
//	@RequestMapping(value = "/saveSerialNoModify.do", method = RequestMethod.POST)
//	public ResponseEntity<ReturnMessage> saveSerialNoModify(@RequestBody Map<String, Object> params, Model model,
//			SessionVO sessionVo) {
//
//		Map<String, Object> rmap = new HashMap<>();
//
//		params.put("userId", sessionVo.getUserId());
//
//		logger.debug("saveSerialNoModify.do :::: params {} ", params);
//
//		rmap =  orderListService.saveSerialNoModify(params);
//
//		System.out.println("++++ rmap.toString() ::" + rmap.toString() );
//
//	    String reVal = (String) rmap.get("dryNo");
//
//	    // 결과 만들기
//	    ReturnMessage message = new ReturnMessage();
//	    message.setCode(AppConstants.SUCCESS);
//	    message.setData(rmap);
//	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
//		return ResponseEntity.ok(message);
//	}





	/*****************************************
	 *
	 *
	 * vaNo   listContactNo  listCustIc  listCustName  listCustId listCrtUserId
	 * @return  sal0029d.CUST_ID
	 */
   public  String[]  getExtCustIdList( Map<String, Object> params ) throws Exception  {

	   	String[]  arrayCustId =null;

		logger.debug("getExtCustIdList in ......");
		logger.debug("params {}",params);


	   //get Cust_ID for sal0029d
		List<EgovMap> custIdList = null;
		custIdList = orderListService.getCustIdOfOrderList(params);

		if( null != custIdList  && custIdList.size() >0){
			//init
			arrayCustId = new String[custIdList.size()];

			for (int i=0;i<custIdList.size(); i++){
				EgovMap am=(EgovMap)custIdList.get(i);
				arrayCustId[i]=  ((BigDecimal) am.get("custId")).toString();
			}
		}

		logger.debug("custIdList {}" ,custIdList);
		logger.debug("getExtCustIdList  end ......");
		return arrayCustId;
   }

   @RequestMapping(value = "/mcoRemPop.do")
   public String mcoRemPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
       logger.debug("mcoRemPop");
       logger.debug("params {}", params);

       params.put("salesOrderId", params.get("ordId"));
       EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
       model.addAttribute("salesOrdId", params.get("ordId"));
       model.addAttribute("orderDetail", orderDetail);

       return "sales/order/mcoRemPop";
   }

	@RequestMapping(value = "/selectOrderOutstandingList.do" , method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectOrderOutstandingList(@RequestParam Map<String, Object>params, ModelMap model, HttpServletRequest request) throws Exception{

		logger.debug("params ======================================>>> " + params);

		Map<String, Object> result = orderListService.getOderOutsInfo(params);

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value="/autoDebitMatrixPop.do")
	public String autoDebitMatrixPop(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request){

		logger.debug("params ======================================>>> " + params);

		EgovMap headerInfo = orderListService.selectHeaderInfo(params);
		model.addAttribute("headerInfo", headerInfo);

		List<EgovMap> histInfo = orderListService.selectHistInfo(params);
		model.addAttribute("histInfo", new Gson().toJson(histInfo));

		List<EgovMap> matrixInfo = orderListService.selectMatrixInfo(params);
		model.addAttribute("matrixInfo", new Gson().toJson(matrixInfo));

		List<EgovMap> accLinkInfo = orderListService.selectAccLinkInfo(params);
		model.addAttribute("accLinkInfo", new Gson().toJson(accLinkInfo));

		model.addAttribute("ordId", params.get("ordId").toString());

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);
		model.addAttribute("today", today);

		return "sales/order/autoDebitMatrixPop";
	}
}
