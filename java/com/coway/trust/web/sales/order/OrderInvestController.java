package com.coway.trust.web.sales.order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
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
import com.coway.trust.api.callcenter.common.FileDto;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderInvestService;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderInvestController {

	private static Logger logger = LoggerFactory.getLogger(OrderListController.class);

	@Resource(name = "orderInvestService")
	private OrderInvestService orderInvestService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private FileApplication fileApplication;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@RequestMapping(value = "/orderInvestList.do")
	public String orderInvestList(@RequestParam Map<String, Object> params, ModelMap model) {
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 3 || sessionVO.getUserTypeId() == 7 ||
	        sessionVO.getUserTypeId() == 5758 || sessionVO.getUserTypeId() == 6672){

			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memType", getUserInfo.get("memType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			logger.info("memType ##### " + getUserInfo.get("memType"));
		}

		return "sales/order/orderInvestigationList";
	}


	@RequestMapping(value = "/orderInvestJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderInvestJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		String[] invReqStusId = request.getParameterValues("invReqStusId");
		params.put("invReqStusIdList", invReqStusId);

		List<EgovMap> orderInvestList = orderInvestService.orderInvestList(params);
		return ResponseEntity.ok(orderInvestList);
	}


	/**
	 *
	 * Investigation View
	 * @param params
	 * @param model
	 * @return
	 * @author
	 * */
	@RequestMapping(value = "/orderInvestInfoPop.do")
	public String orderInvestInfoPop(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{

		EgovMap orderInvestInfo = null;
		EgovMap orderCustomerInfo = null;
		logger.info("##### orderInvestInfoPop START #####");
		logger.info("#orderInvestInfoPop # : " + params.toString());

		orderInvestInfo = orderInvestService.orderInvestInfo(params);
		orderCustomerInfo = orderInvestService.orderCustomerInfo(params);

		List<EgovMap> cmbRejReasonList = orderInvestService.cmbRejReasonList(params);

		model.addAttribute("orderInvestInfo", orderInvestInfo);
		model.addAttribute("orderCustomerInfo", orderCustomerInfo);
		model.addAttribute("cmbRejReasonList", cmbRejReasonList);

		return "sales/order/orderInvestigationDetailPop";
	}


	@RequestMapping(value = "/orderInvestDetailGridJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderInvestDetailGridJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> orderCustomerInfoGrid = orderInvestService.orderInvestInfoGrid(params);
		logger.info("##### orderCustomerInfoGrid #####" +orderCustomerInfoGrid.toString());
		return ResponseEntity.ok(orderCustomerInfoGrid);
	}


	@RequestMapping(value = "/inchargeJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> inchargeJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		logger.info("##### params #####" +params.toString());
		List<EgovMap> inchargeList = orderInvestService.inchargeList(params);

		return ResponseEntity.ok(inchargeList);
	}


	@RequestMapping(value = "/saveInvest.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> saveInvest(@RequestParam Map<String, Object> params, ModelMap mode)
			throws Exception {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		params.put("inchargeNmId", params.get("inchargeNm"));

		String retMsg = "SUCCESS";

		Map<String, Object> map = new HashMap();

		orderInvestService.saveInvest(params);

		map.put("msg", retMsg);

		return ResponseEntity.ok(map);
	}


	@RequestMapping(value = "/orderNewRequestSingleListPop.do")
	public String singleInvestList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/orderNewRequestSingleListPop";
	}


	@RequestMapping(value = "/orderNewRequestSingleChk", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> orderNewRequestSingleChk(@RequestParam Map<String, Object> params, ModelMap model)
			throws Exception {

		String retMsg = "";

		Map<String, Object> map = new HashMap();

		try{
			int orderInvestClosedDateChk = 0;//= orderInvestService.orderInvestClosedDateChk();

			if(orderInvestClosedDateChk < 1){
				EgovMap orderNoChk = orderInvestService.orderNoChk(params);
				logger.debug("##### orderNoChk #####" +orderNoChk.toString());
				logger.debug("##### orderNoChk #####" +orderNoChk);
				if(orderNoChk != null && !"".equals(orderNoChk)){
					EgovMap singleInvestView = orderInvestService.singleInvestView(params);
					map.put("salesOrdId", singleInvestView.get("salesOrdId"));
					map.put("salesOrdNo", singleInvestView.get("salesOrdNo"));
					map.put("salesDt", singleInvestView.get("salesDt"));
					map.put("name", singleInvestView.get("name"));
					map.put("stusCodeId", singleInvestView.get("stusCodeId"));
					map.put("codeName", singleInvestView.get("codeName"));
					map.put("stkCode", singleInvestView.get("stkCode"));
					map.put("stkDesc", singleInvestView.get("stkDesc"));
					map.put("name1", singleInvestView.get("name1"));
					map.put("nric", singleInvestView.get("nric"));

					if(singleInvestView.get("stusCodeId").equals("WOF") || singleInvestView.get("stusCodeId").equals("WOF_1") || singleInvestView.get("stusCodeId").equals("TER")){
					  retMsg = "TER";
					}else if(singleInvestView.get("stusCodeId").equals("RET")){
					  retMsg = "RET";
					}else{
					  retMsg = "OK";
					}
				}else{
					retMsg = "NO";
				}
			}else{
				retMsg = "NO";
			}
		}catch(Exception ex){
			retMsg = "Err";
		}finally{
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}


	/**
	 * 공통 파일 테이블 사용 Upload를 처리한다.
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/investFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<FileDto> sampleUploadCommon(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, SalesConstants.SALES_INVESTIGATION_SUBPATH, AppConstants.UPLOAD_MAX_FILE_SIZE);

		logger.debug("##### uploadDir ########" +uploadDir);
		logger.debug("##### uploadParams #####" +params.toString());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		//serivce 에서 파일정보를 가지고, DB 처리.
		int fileGroupKey = fileApplication.commonAttachByUserId(FileType.WEB, FileVO.createList(list), params);
		FileDto fileDto = FileDto.create(list, fileGroupKey);

		return ResponseEntity.ok(fileDto);
	}


	@RequestMapping(value = "/orderNewRequestSingleOk", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> orderNewRequestSingleOk(@RequestParam Map<String, Object> params, ModelMap model)
			throws Exception {

		String retMsg = AppConstants.MSG_SUCCESS;

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

//		String callDt = (String)params.get("callDt");
//		if(callDt != null && callDt != ""){
//			String insCallDt = callDt.substring(6) + "-" + callDt.substring(3, 5) + "-" + callDt.substring(0, 2) + " 00:00:00";
//			logger.info("##### callDt #####" +insCallDt);
//			params.put("callDt", insCallDt);
//		}
//		String visitDt = (String)params.get("visitDt");
//		if(visitDt != null && visitDt != ""){
//			String insVisitDt = visitDt.substring(6) + "-" + visitDt.substring(3, 5) + "-" + visitDt.substring(0, 2) + " 00:00:00";
//			logger.info("##### visitDt #####" +insVisitDt);
//			params.put("visitDt", insVisitDt);
//		}
//
//		logger.debug("##### callDt #####" +callDt);
//		logger.debug("##### visitDt #####" +visitDt);
//
		Map<String, Object> map = new HashMap();


//			int orderInvestClosedDateChk = orderInvestService.orderInvestClosedDateChk();

//			EgovMap singleInvestView = orderInvestService.singleInvestView(params);

			int seqSAL0050D = orderInvestService.seqSAL0050D();
			params.put("seqSAL0050D", seqSAL0050D);
			orderInvestService.insertNewRequestSingleOk(params);
//			EgovMap orderNoInfo = orderInvestService.orderNoInfo(params);

			map.put("invReqId", seqSAL0050D);


			map.put("msg", retMsg);

		return ResponseEntity.ok(map);
	}


	@RequestMapping(value = "/orderInvestReject", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> orderInvestReject(@RequestParam Map<String, Object> params, ModelMap model)
			throws Exception {

		String retMsg = AppConstants.MSG_SUCCESS;

		Map<String, Object> map = new HashMap();

		try{

			int existChk = orderInvestService.searchBSScheduleM(params);
			logger.info("##### existChk count #####" +existChk);
			map.put("existChkCnt", existChk);

		}catch(Exception ex){
			retMsg = AppConstants.MSG_FAIL;
		}finally{
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}


	@RequestMapping(value = "/saveOrderInvestOk", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> saveOrderInvestOk(@RequestParam Map<String, Object> params, ModelMap model)
			throws Exception {

		String retMsg = AppConstants.MSG_SUCCESS;

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		String callDt = (String)params.get("callDt");
		if(callDt != null && callDt != ""){
			String insCallDt = callDt.substring(6) + "-" + callDt.substring(3, 5) + "-" + callDt.substring(0, 2) + " 00:00:00";
			logger.info("##### callDt #####" +insCallDt);
			params.put("callDt", insCallDt);
		}
		String visitDt = (String)params.get("visitDt");
		if(visitDt != null && visitDt != ""){
			String insVisitDt = visitDt.substring(6) + "-" + visitDt.substring(3, 5) + "-" + visitDt.substring(0, 2) + " 00:00:00";
			logger.info("##### visitDt #####" +insVisitDt);
			params.put("visitDt", insVisitDt);
		}

		Map<String, Object> map = new HashMap();

		try{
//			int orderInvestClosedDateChk = orderInvestService.orderInvestClosedDateChk();

//			EgovMap singleInvestView = orderInvestService.singleInvestView(params);

			orderInvestService.saveOrderInvestOk(params);
			EgovMap orderNoInfo = orderInvestService.orderNoInfo(params);

			map.put("invReqId", orderNoInfo.get("invReqId"));

		}catch(Exception ex){
			retMsg = AppConstants.MSG_FAIL;
		}finally{
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}


	@RequestMapping(value = "/orderInvestCallRecallList.do")
	public String orderInvestCallRecallList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/orderInvestCallRecallList";
	}


	@RequestMapping(value = "/investCallResultJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> investCallResultJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		logger.debug("!@###### startCrtDt : "+params.get("startCrtDt"));
		logger.debug("!@###### ::::::::::: : "+params.toString());

		String[] invStusList = request.getParameterValues("invStusId");
		params.put("invStusList", invStusList);

		List<EgovMap> investCallResultList = orderInvestService.orderInvestCallRecallList(params);
		return ResponseEntity.ok(investCallResultList);
	}


	/**
	 *
	 * Investigation Call/Result View
	 * @param params
	 * @param model
	 * @return
	 * @author
	 * */
	@RequestMapping(value = "/orderInvestCallResultDtPop.do")
	public String orderInvestCallResultDtPop(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{

		EgovMap investCallResultInfo = null;
		EgovMap investCallResultCust = null;

		investCallResultInfo = orderInvestService.investCallResultInfo(params);
		investCallResultCust = orderInvestService.investCallResultCust(params);

		List<EgovMap> inchargeList = orderInvestService.inchargeList(params);

		model.addAttribute("investCallResultInfo", investCallResultInfo);
		model.addAttribute("investCallResultCust", investCallResultCust);
		model.addAttribute("inchargeList", inchargeList);


		return "sales/order/orderInvestCallResultDtPop";
	}


	@RequestMapping(value = "/ordInvestCallLogDtGridJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> ordInvestCallLogDtGridJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> investCallResultLog = orderInvestService.investCallResultLog(params);
		logger.info("##### investCallResultLog #####" +investCallResultLog.toString());
		return ResponseEntity.ok(investCallResultLog);
	}


	@RequestMapping(value = "/saveCallResultOk.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> saveCallResultOk(@RequestParam Map<String, Object> params, ModelMap model)
			throws Exception {

		String retMsg = AppConstants.MSG_SUCCESS;

		logger.debug("!@###### :::::::::::::::::::: : "+params.toString());

		Map<String, Object> map = new HashMap();

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		orderInvestService.saveCallResultOk(params);
		logger.debug("!@###### :::::::::::::::::::: : "+params.get("callResultStus"));
		map.put("resultStatus", params.get("callResultStus"));
		return ResponseEntity.ok(map);
	}


	@RequestMapping(value = "/bsMonthCheck.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> bsMonthCheck(@RequestParam Map<String, Object> params, ModelMap model)
			throws Exception {

		Map<String, Object> saveOkMap = new HashMap();

		int regSaveMsg = orderInvestService.bsMonthCheck(params);
//		String regSaveMsg = "0";
		logger.debug("!@###### :::::::::::::::::::: : "+regSaveMsg);
		saveOkMap.put("regSaveMsg", regSaveMsg);


		return ResponseEntity.ok(saveOkMap);
	}


	@RequestMapping(value = "/bsMonthCheckOKPop.do")
	public String bsMonthCheckOKPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("saveSalesOrdNo", params.get("saveSalesOrdNo"));
		model.addAttribute("callResultInvId", params.get("callResultInvId"));
		model.addAttribute("invCallEntryId", params.get("invCallEntryId"));
		model.addAttribute("saveSalesOrdId", params.get("saveSalesOrdId"));
		model.addAttribute("callResultStus", params.get("callResultStus"));
		model.addAttribute("callResultRem", params.get("callResultRem"));

		return "sales/order/orderInvestCallResultRegSavePop";
	}


	@RequestMapping(value = "/bsMonthCheckNoPop.do")
	public String bsMonthCheckNoPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("saveSalesOrdNo", params.get("saveSalesOrdNo"));
		model.addAttribute("callResultInvId", params.get("callResultInvId"));
		model.addAttribute("invCallEntryId", params.get("invCallEntryId"));
		model.addAttribute("saveSalesOrdId", params.get("saveSalesOrdId"));
		model.addAttribute("callResultStus", params.get("callResultStus"));
		model.addAttribute("callResultRem", params.get("callResultRem"));
		return "sales/order/orderInvestCallResultRegSave2Pop";
	}

	@RequestMapping(value="/orderInvestigationRequestRawDataPop.do")
	public String orderInvestigationRequestRawDataPop(){

		return "sales/order/orderInvestigationRequestRawDataPop";
	}


	@RequestMapping(value = "/orderNewRequestBatchListPop.do")
	public String batchInvestList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/orderNewRequestBatchListPop";
	}


	@RequestMapping(value = "/chkNewFileList", method = RequestMethod.POST)
	public ResponseEntity <ReturnMessage>chkNewFileList (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		logger.debug("in  chkNewFileList ");

		logger.debug("params =====================================>>  " + params);
		params.put("userId", sessionVO.getUserId());
		params.put("userFullname", sessionVO.getUserFullname());


		Map<String, Object> listMap = orderInvestService.chkNewFileList(params);
		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(listMap);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		logger.debug("===== =====================================>>  " + listMap.get("checkList"));
		logger.debug("===== =====================================>>  " + listMap.get("existYN"));

    	return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/saveNewFileList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveNewFileList (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		logger.debug("params =====================================>>  " + params);
		params.put("userId", sessionVO.getUserId());

		orderInvestService.saveNewFileList(params);

		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData("");
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);
	}

}
