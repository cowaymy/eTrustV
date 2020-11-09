package com.coway.trust.web.sales.rcms;

import java.util.ArrayList;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderLedgerService;
import com.coway.trust.biz.sales.rcms.ROSCallLogService;
import com.coway.trust.biz.sales.rcms.vo.callerDataVO;
import com.coway.trust.biz.sales.rcms.vo.orderRemDataVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/rcms")
public class ROSCallLogController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ROSCallLogController.class);

	@Autowired
	private AdaptorService adaptorService;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "rosCallLogService")
	private ROSCallLogService rosCallLogService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "orderLedgerService")
	private OrderLedgerService orderLedgerService;

	@Autowired
	private CsvReadComponent csvReadComponent;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/rosCallLogList.do")
	public String rosCallLogList (@RequestParam Map<String, Object> params) throws Exception{

		return "sales/rcms/rosCallLogList";
	}


	@RequestMapping(value = "/getAppTypeList")
	public ResponseEntity<List<EgovMap>> getAppTypeList(@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> appTypeList = null;

		appTypeList = rosCallLogService.getAppTypeList(params);

		return ResponseEntity.ok(appTypeList);

	}


	@RequestMapping(value = "/selectRosCallLogList")
	public ResponseEntity<List<EgovMap>> selectRosCallLogList(@RequestParam Map<String, Object> params, HttpServletRequest request )throws Exception{

		String appTypeArr[] = request.getParameterValues("appType");
		String rentalArr[] = request.getParameterValues("rentalStatus");
		String corpTypeArr[] = request.getParameterValues("cmbCorpTypeId");
		String rosCallerArr[] = request.getParameterValues("rosCaller");

		params.put("appTypeArr", appTypeArr);
		params.put("rentalArr", rentalArr);
    params.put("corpTypeArr", corpTypeArr);
    params.put("rosCallerArr", rosCallerArr);

		List<EgovMap> rosCallList = null;

		LOGGER.info("############## selectRosCallLogList Params : " + params.toString());

		rosCallList = rosCallLogService.selectRosCallLogList(params);

		return ResponseEntity.ok(rosCallList);

	}


	@RequestMapping(value = "/newRosCallPop.do")
	public String newRosCallPop (@RequestParam Map<String, Object> params, SessionVO sessionVO, ModelMap model) throws Exception{

		/*** Billing Group (Grid Params)***/
		model.put("ordNo", params.get("ordNo"));
		model.put("ordId", params.get("salesOrderId"));
		model.put("custBillId", params.get("custBillId"));


		/****  Order Detail  ****/
		int prgrsId = 0;
		EgovMap orderDetail = null;
		params.put("prgrsId", prgrsId);

        orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

		model.put("orderDetail", orderDetail);
		model.addAttribute("salesOrderNo", params.get("salesOrderNo"));

		EgovMap basicMap = (EgovMap)orderDetail.get("basicInfo");

		params.put("ordId", params.get("salesOrderId"));
		params.put("salesOrdId", params.get("salesOrderId"));//sixmonth
		params.put("appTypeId", basicMap.get("appTypeId"));//sixmonth

		/**** OUTSTANDING ****/
		List<EgovMap> ordOutInfoList = orderLedgerService.getOderOutsInfo(params);
		EgovMap ordOutInfo = ordOutInfoList.get(0);
		LOGGER.debug("ordOutInfo =====================>>> " + ordOutInfo);
		model.addAttribute("ordOutInfo", ordOutInfo);

		/*** LAST 6 MONTH ***/
		List<EgovMap> resultList = orderDetailService.selectLast6MonthTransListNew(params);

		EgovMap sixMonthMap = new EgovMap();
		if(resultList != null && resultList.size() > 1 ){
			sixMonthMap = resultList.get(1);
		}else{
			sixMonthMap.put("curMonth", 0);
			sixMonthMap.put("prev1Month", 0);
		}
		model.addAttribute("sixMonthMap", sixMonthMap);

		/*** BILL MONTH(S)***/
		EgovMap billMonthMap = null;
		billMonthMap = rosCallLogService.getRentInstallLatestNo(params);
		model.addAttribute("billMonthMap", billMonthMap);

		/*** RENTAL STATUS ***/
		EgovMap rentalMap = null;
		rentalMap = rosCallLogService.getRentalStatus(params);
		model.addAttribute("rentalMap", rentalMap);

		/*** AGREEMENT LIST ***/
		List<EgovMap> agreList = orderLedgerService.selectAgreInfo(params);
		model.addAttribute("agreList", new Gson().toJson(agreList));

		/*** ORDER SALESMAN VIEW ***/
		EgovMap salesManMap = null;
		salesManMap = rosCallLogService.getOrderServiceMemberViewByOrderID(params);
		model.addAttribute("salesManMap", salesManMap);

		return "sales/rcms/newRosCallPop";
	}


	@RequestMapping(value = "/selectROSSMSCodyTicketLogList")
	public ResponseEntity<List<EgovMap>> selectROSSMSCodyTicketLogList (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> smsList = null;
		smsList = rosCallLogService.selectROSSMSCodyTicketLogList(params);

		return ResponseEntity.ok(smsList);

	}


	@RequestMapping(value = "/getReasonCodeList")
	public ResponseEntity<List<EgovMap>> getReasonCodeList (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> reasonList = null;

		reasonList = rosCallLogService.getReasonCodeList(params);

		return ResponseEntity.ok(reasonList);

	}


	@RequestMapping(value = "/getFeedbackCodeList")
	public ResponseEntity<List<EgovMap>> getFeedbackCodeList (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> feedbackList = null;

		feedbackList = rosCallLogService.getFeedbackCodeList(params);

		return ResponseEntity.ok(feedbackList);
	}


	@RequestMapping(value = "/selectROSCallLogBillGroupOrderCnt")
	public ResponseEntity<List<EgovMap>> selectROSCallLogBillGroupOrderCnt(@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> cntList = null;

		cntList = rosCallLogService.selectROSCallLogBillGroupOrderCnt(params);

		return ResponseEntity.ok(cntList);
	}


	@RequestMapping(value = "/insertNewRosCall", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertNewRosCall(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception{

		Map<String, Object> rtnMap = new HashMap<String, Object>();;

		//Params
		params.put("userId", sessionVO.getUserId());
		//_____________________________________________________________________________________New Ros Call
		boolean isResult = false;
		isResult = rosCallLogService.insertNewRosCall(params);
		rtnMap.put("isResult",isResult);
		//_____________________________________________________________________________________Send SMS
		int chkSms =  Integer.parseInt(String.valueOf(params.get("chkSmS")));
		rtnMap.put("chkSms", chkSms);

		String smsResultMSg = "";

		List<String> mobileNumList = new ArrayList<String>();
		if(chkSms > 0){
			SmsVO sms = new SmsVO(sessionVO.getUserId(), 975);

			LOGGER.info(" Message Contents : " + (String)params.get("fullSms"));
			LOGGER.info(" Mobile Phone Number : " + (String)params.get("salesManMemTelMobile"));
			mobileNumList.add((String) params.get("salesManMemTelMobile"));

			sms.setMessage((String) params.get("fullSms"));
			sms.setMobiles(mobileNumList);
			//send SMS
			SmsResult smsResult = adaptorService.sendSMS(sms);

			smsResultMSg += "Total Send Message : " + smsResult.getReqCount() + "</br>";
			smsResultMSg += "Success Count : " + smsResult.getSuccessCount() + "</br>";
			smsResultMSg += "Fail Count : " + smsResult.getFailCount() + "</br>";
			smsResultMSg += "Error Count : " + smsResult.getErrorCount() + "</br>";

			if(smsResult.getFailCount() > 0){
				smsResultMSg += "Fail Reason : " + smsResult.getFailReason() + "</br>";
			}

			rtnMap.put("smsResultMSg", smsResultMSg);
			rtnMap.put("total", smsResult.getReqCount());
			rtnMap.put("success", smsResult.getSuccessCount());
		}

		return ResponseEntity.ok(rtnMap);
	}


	@RequestMapping(value = "/orderUploadBatchListPop.do")
	public String orderUploadBatchListPop(@RequestParam Map<String, Object> params) throws Exception{
		return "/sales/rcms/orderUploadBatchListPop";
	}


	@RequestMapping(value = "/selectOrderRemList")
	public ResponseEntity<List<EgovMap>> selectOrderRemList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{

		List<EgovMap> ordRemList = null;
		String stusArr[] = request.getParameterValues("batchStatus");
		params.put("stusArr", stusArr);
		ordRemList = rosCallLogService.selectOrderRemList(params);

		return ResponseEntity.ok(ordRemList);
	}

	@RequestMapping(value = "/ordUploadPop.do")
	public String ordUploadPop(@RequestParam Map<String, Object> params) throws Exception{
		return "/sales/rcms/ordUploadPop";
	}


	@RequestMapping(value = "/uploadOrdRem.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> readExcel(MultipartHttpServletRequest request,SessionVO sessionVO) throws Exception {

		Map<String, MultipartFile> fileMap = request.getFileMap();

		MultipartFile multipartFile = fileMap.get("csvFile");

		//List<TerritoryRawDataVO> vos = excelReadComponent.readExcelToList(multipartFile, TerritoryRawDataVO::create);
		List<orderRemDataVO> vos = csvReadComponent.readCsvToList(multipartFile,true ,orderRemDataVO::create);

		//step 1 vaild
		Map param = new HashMap();
		param.put("voList", vos);
		param.put("userId", sessionVO.getUserId());

		//EgovMap  vailMap = territoryManagementService.uploadVaild(param,sessionVO);
		Map<String, Object> rtnMap = rosCallLogService.uploadOrdRem(param);
		//결과
		return ResponseEntity.ok(rtnMap);
	}



	@RequestMapping(value = "/orderModifyPop.do")
	public String orderModifyPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {

		//[Tap]Basic Info
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);//APP_TYPE_ID CUST_ID
		EgovMap basicInfo = (EgovMap) orderDetail.get("basicInfo");

		model.put("orderDetail",  orderDetail);
		model.put("salesOrderId", params.get("salesOrderId"));
		model.put("ordEditType",  params.get("ordEditType"));
		model.put("custId",       basicInfo.get("custId"));
		model.put("appTypeId",    basicInfo.get("appTypeId"));
		model.put("appTypeDesc",  basicInfo.get("appTypeDesc"));
		model.put("salesOrderNo", basicInfo.get("ordNo"));
		model.put("custNric",     basicInfo.get("custNric"));
		model.put("ordStusId",    basicInfo.get("ordStusId"));
		model.put("toDay", 		  CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
		model.put("promoCode",    basicInfo.get("ordPromoCode"));
		model.put("promoDesc",    basicInfo.get("ordPromoDesc"));
		model.put("srvPacId",     basicInfo.get("srvPacId"));

		LOGGER.debug("!@##############################################################################");
		LOGGER.debug("!@###### salesOrderId : "+model.get("salesOrderId"));
		LOGGER.debug("!@###### ordEditType  : "+model.get("ordEditType"));
		LOGGER.debug("!@###### custId       : "+model.get("custId"));
		LOGGER.debug("!@###### appTypeId    : "+model.get("appTypeId"));
		LOGGER.debug("!@###### appTypeDesc  : "+model.get("appTypeDesc"));
		LOGGER.debug("!@###### salesOrderNo : "+model.get("salesOrderNo"));
		LOGGER.debug("!@###### custNric     : "+model.get("custNric"));
		LOGGER.debug("!@##############################################################################");

		return "sales/rcms/editRentPayPop";
	}


	@RequestMapping(value = "/viewUploadBatchPop.do")
	public String viewUploadBatchPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		EgovMap infoMap = null;

		infoMap = rosCallLogService.selectBatchViewInfo(params);
		model.addAttribute("infoMap", infoMap);
		model.addAttribute("batchId", params.get("batchId"));


		return "/sales/rcms/viewUploadBatchPop";
	}


	@RequestMapping(value = "/getBatchDetailInfoList")
	public ResponseEntity<List<EgovMap>> getBatchDetailInfoList(@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> listMap = null;

		listMap = rosCallLogService.getBatchDetailInfoList(params);

		return ResponseEntity.ok(listMap);

	}


	@RequestMapping(value = "/confirmUploadBatchPop.do")
	public String confirmUploadBatchPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		EgovMap infoMap = null;

		infoMap = rosCallLogService.selectBatchViewInfo(params);
		model.addAttribute("infoMap", infoMap);
		model.addAttribute("batchId", params.get("batchId"));

		return "/sales/rcms/confirmUploadBatchPop";

	}


	@RequestMapping(value = "/addOrderRemBatch.do")
	public String addOrderRemBatch (@RequestParam Map<String, Object> params, ModelMap model)throws Exception{

		model.addAttribute("batchId", params.get("batchId"));

		return "/sales/rcms/addBatchItemPop";
	}


	@RequestMapping(value="/searchExistOrdNo")
	public ResponseEntity<EgovMap> searchExistOrdNo(@RequestParam Map<String, Object> params) throws Exception{

		EgovMap srcMap = null;
		srcMap = rosCallLogService.searchExistOrdNo(params);
		return ResponseEntity.ok(srcMap);
	}


	@RequestMapping(value = "/alreadyExistOrdNo")
	public ResponseEntity<EgovMap> alreadyExistOrdNo(@RequestParam Map<String, Object> params) throws Exception{
		EgovMap srcMap = null;
		srcMap = rosCallLogService.alreadyExistOrdNo(params);
		return ResponseEntity.ok(srcMap);
	}


	@RequestMapping(value = "/addNewOrdNo", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> addNewOrdNo(@RequestBody Map<String, Object> params) throws Exception{

		SessionVO session = sessionHandler.getCurrentSessionInfo();

		params.put("userId", session.getUserId());
		rosCallLogService.addNewOrdNo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/updOrdNo", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updOrdNo (@RequestBody Map<String, Object> params) throws Exception{

		SessionVO session = sessionHandler.getCurrentSessionInfo();
		params.put("userId", session.getUserId());

		rosCallLogService.updOrdNo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}


	@RequestMapping(value = "/updBatch", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updBatch (@RequestBody Map<String, Object> params) throws Exception{

		SessionVO session = sessionHandler.getCurrentSessionInfo();
		params.put("userId", session.getUserId());

		rosCallLogService.updBatch(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	//confirmBatch
	@RequestMapping(value = "/confirmBatch", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> confirmBatch (@RequestBody Map<String, Object> params) throws Exception{

		SessionVO session = sessionHandler.getCurrentSessionInfo();
		params.put("userId", session.getUserId());

		rosCallLogService.confirmBatch(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/rosCallerUpdList.do")
	public String rosCallerUpdList (@RequestParam Map<String, Object> params) throws Exception{

		return "sales/rcms/rosCallerUpdList";
	}


	@RequestMapping(value = "/selectCallerList")
	public ResponseEntity<List<EgovMap>> selectCallerList(@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> callerList = null;

		callerList = rosCallLogService.selectCallerList(params);


		return ResponseEntity.ok(callerList);
	}


	@RequestMapping(value = "/callerUploadPop.do")
	public String callerUploadPop (@RequestParam Map<String, Object> params) throws Exception{
		return "/sales/rcms/callerUploadPop";
	}



	@RequestMapping(value = "/uploadCaller.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> uploadCaller (MultipartHttpServletRequest request,SessionVO sessionVO) throws Exception {

		Map<String, MultipartFile> fileMap = request.getFileMap();

		MultipartFile multipartFile = fileMap.get("csvFile");

		//List<TerritoryRawDataVO> vos = excelReadComponent.readExcelToList(multipartFile, TerritoryRawDataVO::create);
		List<callerDataVO> vos = csvReadComponent.readCsvToList(multipartFile,true ,callerDataVO::create);

		//step 1 vaild
		Map param = new HashMap();
		param.put("voList", vos);
		param.put("userId", sessionVO.getUserId());

		//EgovMap  vailMap = territoryManagementService.uploadVaild(param,sessionVO);
		Map<String, Object> rtnMap = rosCallLogService.uploadCaller(param);
		//결과
		return ResponseEntity.ok(rtnMap);
	}


	@RequestMapping(value = "/getCallerDetailList")
	public ResponseEntity<List<EgovMap>> getCallerDetailList(@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> callerDetList = null;
		callerDetList = rosCallLogService.getCallerDetailList(params);

		return ResponseEntity.ok(callerDetList);
	}


	@RequestMapping(value = "/feedbackPop.do")
	public String feedbackPop(@RequestParam Map<String, Object> params) throws Exception{
		return "/sales/rcms/feedbackPop";
	}
}

