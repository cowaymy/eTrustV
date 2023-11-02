package com.coway.trust.web.sales.ccp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.tiles.request.Request;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.ccp.CcpRentalAgreementService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.impl.OrderDetailMapper;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileUtil;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ccp")
public class CcpRentalAgreementController {


	private static final Logger LOGGER = LoggerFactory.getLogger(CcpRentalAgreementController.class);

	@Resource(name = "ccpRentalAgreementService")
	private CcpRentalAgreementService ccpRentalAgreementService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "orderDetailMapper")
	private OrderDetailMapper orderDetailMapper;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private AdaptorService adaptorService;

	@Autowired
	private FileService fileService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/selectRentalCcpAgreementList.do")
	public String selectCcpAgreementList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		EgovMap result =  salesCommonService.getUserInfo(params);

		model.put("mainDept", sessionVO.getUserMainDeptId());
		if(result != null){
			model.put("orgCode", result.get("orgCode"));
			model.put("grpCode", result.get("grpCode"));
			model.put("deptCode", result.get("deptCode"));
		}


		return "sales/ccp/ccpRentalAgreementList";
	}

	@RequestMapping(value = "/selectRentalCcpAgreementJsonList" , method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCcpAgreementJsonList (@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception{

		LOGGER.info("_______________________-_______________-_______________-_______________-_______________-");
		LOGGER.info("_______________________ 파라미터 확인 : " + params.toString());
		LOGGER.info("_______________________-_______________-_______________-_______________-_______________-");


		List<EgovMap> ccpAgrList = null;

		String govAgPrgsIdList[] = request.getParameterValues("progressVal");
		String govAgStusIdList[] = request.getParameterValues("statusVal");
		String govAgTypeIdList[] = request.getParameterValues("typeVal");

		params.put("govAgPrgsIdList", govAgPrgsIdList);
		params.put("govAgStusIdList", govAgStusIdList);
		params.put("govAgTypeIdList", govAgTypeIdList);

		LOGGER.info("########## selectCcpAgreementJsonList Start ############");

	    ccpAgrList = ccpRentalAgreementService.selectContactAgreementList(params);

		return ResponseEntity.ok(ccpAgrList);

	}

	@RequestMapping(value = "/selectRentalAgrViewEditPop.do")
	public String  selectRentalAgrViewEditPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.info("################### Params Confirm[/selectRentalAgrViewEditPop]  : " + params.toString());

		EgovMap infoMap = null;

		infoMap = ccpRentalAgreementService.selectAgreementInfo(params);
		LOGGER.info("################### 가져온 infoMap  : " + infoMap.toString());
		model.addAttribute("infoMap", infoMap);

		params.put("salesOrderId", infoMap.get("govAgSalesOrdId"));
		EgovMap salesmanInfo = orderDetailMapper.selectOrderSalesmanViewByOrderID(params);
		EgovMap codyInfo = orderDetailMapper.selectOrderServiceMemberViewByOrderID(params);
		model.addAttribute("salesMan", salesmanInfo);
		model.addAttribute("codyInfo", codyInfo);
		model.addAttribute("params", params);
		//TODO Agreement Type 에 대한 업무 설명 필요 추후 수정

		return "sales/ccp/ccpRentalAgrViewEditPop";
	}

	@RequestMapping(value = "/selectRentalConsignmentLogAjax")
	public ResponseEntity<List<EgovMap>> selectConsignmentLogAjax (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> consignList = null;
		consignList = ccpRentalAgreementService.selectConsignmentLogAjax(params);

		return ResponseEntity.ok(consignList);

	}

	@RequestMapping(value = "/selectRentalMessageLogAjax")
	public ResponseEntity<List<EgovMap>> selectMessageLogAjax (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> msgList = null;
		msgList = ccpRentalAgreementService.selectMessageLogAjax(params);

		return ResponseEntity.ok(msgList);

	}

	@RequestMapping(value = "/selectRentalContactOrdersAjax")
	public ResponseEntity<List<EgovMap>> selectContactOrdersAjax (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> orderList = null;
		orderList = ccpRentalAgreementService.selectContactOrdersAjax(params);

		return ResponseEntity.ok(orderList);

	}

	@RequestMapping(value = "/getRentalMessageStatusCode.do")
	public ResponseEntity<List<EgovMap>>  getMessageStatusCode (@RequestParam Map<String, Object> params) throws Exception {

		List<EgovMap> codeList = null;
		codeList = ccpRentalAgreementService.getMessageStatusCode(params);

		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/getRentalOrderId", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> getOrderId(@RequestParam Map<String, Object> params) throws Exception{

		EgovMap resultMap = null;
		//서비스
		resultMap = ccpRentalAgreementService.getOrderId(params);

		return ResponseEntity.ok(resultMap);
	}

	@RequestMapping(value = "/updateRentalAgrMtcEdit.do")
	public ResponseEntity<Map<String, Object>> updateAgreementMtcEdit (@RequestBody Map<String, Object> params) throws Exception{

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		Map<String, Object> returnMap = new HashMap<String, Object>();
		params.put("userId", sessionVO.getUserId());

		returnMap = ccpRentalAgreementService.updateAgreementMtcEdit(params);

		Map<String, Object> paramsSMS = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		paramsSMS.put("userId", params.get("userId"));
		paramsSMS.put("salesOrderId",paramsSMS.get("salesOrdId"));
		//Send SMS
		int chkSms =  Integer.parseInt(String.valueOf(paramsSMS.get("isChkSms")));
		String smsResultMSg = "";
		String isSendSales = String.valueOf(paramsSMS.get("isSendSales"));
		String isSendCody = String.valueOf(paramsSMS.get("isSendCody"));
		EgovMap salesmanInfo = null;
		EgovMap codyInfo = null;
		List<String> mobileNumList = new ArrayList<String>();
		if(chkSms > 0){
			if(("1").equals(isSendSales) || ("1").equals(isSendCody)){
				SmsVO sms = new SmsVO(sessionVO.getUserId(), 975);

				if(("1").equals(isSendSales)){
					salesmanInfo = orderDetailMapper.selectOrderSalesmanViewByOrderID(paramsSMS);
				}
				if(("1").equals(isSendCody)){
					codyInfo = orderDetailMapper.selectOrderServiceMemberViewByOrderID(paramsSMS);
				}

				LOGGER.info(" Message Contents : " + (String)paramsSMS.get("hiddenUpdSmsMsg"));
				LOGGER.info(" Salesman Mobile Phone Number : " + (String)paramsSMS.get("hiddenSalesMobile"));
				LOGGER.info(" Cody Mobile Phone Number : " + (String)paramsSMS.get("hiddenCodyMobile"));
				if(!(salesmanInfo == null)){
					mobileNumList.add((String) salesmanInfo.get("telMobile"));
					if(!(salesmanInfo.get("telMobile1") == null || salesmanInfo.get("telMobile1") == "")){
						mobileNumList.add((String) salesmanInfo.get("telMobile1"));
					}
					if(!(salesmanInfo.get("telMobile2") == null || salesmanInfo.get("telMobile2") == "")){
						mobileNumList.add((String) salesmanInfo.get("telMobile2"));
					}
					if(!(salesmanInfo.get("telMobile3") == null || salesmanInfo.get("telMobile3") == "")){
						mobileNumList.add((String) salesmanInfo.get("telMobile3"));
					}
				}
				if(!(codyInfo == null)){
					mobileNumList.add((String) codyInfo.get("telMobile1"));
					if(!(codyInfo.get("telMobile1") == null || codyInfo.get("telMobile1") == "")){
						mobileNumList.add((String) codyInfo.get("telMobile1"));
					}
					if(!(codyInfo.get("telMobile2") == null || codyInfo.get("telMobile2") == "")){
						mobileNumList.add((String) codyInfo.get("telMobile2"));
					}
					if(!(codyInfo.get("telMobile3") == null || codyInfo.get("telMobile3") == "")){
						mobileNumList.add((String) codyInfo.get("telMobile3"));
					}
				}

				sms.setMessage((String) paramsSMS.get("hiddenUpdSmsMsg"));
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
			}
		}
		//Return MSG
//		ReturnMessage message = new ReturnMessage();

//	    message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(smsResultMSg));

		return ResponseEntity.ok(returnMap);
	}

	@RequestMapping(value ="/selectOrderRentalAddJsonList")
	public ResponseEntity<List<EgovMap>> selectOrderAddJsonList (@RequestParam Map<String, Object> params) throws Exception{

		LOGGER.info("################## selectOrderJsonList Start ##################");

		List<EgovMap> orderList = null;

		//Set Params
		params.put("salesOrderId", params.get("addOrdId"));

		orderList = ccpRentalAgreementService.selectOrderJsonList(params);

		return ResponseEntity.ok(orderList);

	}

	@RequestMapping(value = "/uploadRentalCcpFile.do")
	public ResponseEntity<ReturnMessage> uploadCcpFile(MultipartHttpServletRequest request, @RequestParam Map<String, Object>  params, ModelMap model, SessionVO sessionVO) throws Exception{

		List<EgovFormBasedFileVo> files  = EgovFileUploadUtil.uploadFiles(request, uploadDir, SalesConstants.CCP_AGREEMENT_SUB_PATH, AppConstants.UPLOAD_MAX_FILE_SIZE);

		params.put("userId", sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		//MSG ID

		List<EgovFormBasedFileVo> newFiles = new ArrayList<EgovFormBasedFileVo>();

		for (int idx = 0; idx < files.size(); idx++) {

			EgovFormBasedFileVo vo = new EgovFormBasedFileVo();

			vo.setContentType(files.get(idx).getContentType());
			vo.setExtension(files.get(idx).getExtension());
			vo.setPhysicalName(files.get(idx).getPhysicalName());
			vo.setServerPath(files.get(idx).getServerPath());
			vo.setServerSubPath(files.get(idx).getServerSubPath());
			vo.setSize(files.get(idx).getSize());

			vo.setFileName(String.valueOf(params.get("updMsgId")));

			newFiles.add(vo);

		}

		int fileGroupKey = fileService.insertFiles(FileVO.createList(newFiles), FileType.WEB, (Integer) params.get("userId"));

		params.put("fileGroupKey", fileGroupKey);

		LOGGER.info("#################### upload after params : "  + params.toString());
		//ccpRentalAgreementService.uploadCcpFile(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(params);

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/sendRentalUpdateEmail.do")
	public ResponseEntity<ReturnMessage> sendUpdateEmail (@RequestParam Map<String, Object> params) throws Exception{

		LOGGER.info("################## sendUpdateEmail Start #######################");

		LOGGER.info("#########################################################");
		LOGGER.info("########### Params 확인 : " + params.toString());
		//Session
		boolean isResult = false;
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("fullName", sessionVO.getUserFullname());
		//TODO 추후 삭제 세션
		//params.put("fullName", "Jang Gwang Ryul");

		isResult = ccpRentalAgreementService.sendUpdateEmail(params);

		//Return MSG
		ReturnMessage message = new ReturnMessage();

		if(isResult == true){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		LOGGER.info("################## sendUpdateEmail End #######################");
		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/selectRentalListOrdersAjax")
	public ResponseEntity<List<EgovMap>> selectListOrdersAjax (@RequestParam Map<String, Object> params) throws Exception{

		params.put("govAgId", params.get("ordAgId"));
		List<EgovMap> orderList = null;
		orderList = ccpRentalAgreementService.selectContactOrdersAjaxIncludeInactive(params);

		return ResponseEntity.ok(orderList);

	}

	@RequestMapping(value="/ccpRentalRawPop.do" )
	public String ccpRentalRawPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/ccp/ccpRentalRawPop";
	}

	@RequestMapping(value="/ccpRentalListingPop.do")
	public String ccpRentalListingPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/ccp/ccpRentalListingPop";
	}

	@RequestMapping(value="/ccpRentalSummaryReportPop.do")
	public String ccpRentalSummaryReportPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/ccp/ccpRentalSummaryReportPop";
	}

	@RequestMapping(value="/ccpRentalSummaryAgmActivePop.do")
  public String ccpRentalSummaryAgmActivePop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
	  model.put("orgInfo", params);
    return "sales/ccp/ccpRentalSummaryAgmActivePop";
  }

	@RequestMapping(value="/ccpRentalConsignmentCourierListingPop.do")
	public String ccpRentalConsignmentCourierListingPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/ccp/ccpRentalConsignmentCourierListingPop";
	}

	@RequestMapping(value = "/newCcpRenAgrSearchPop.do")
	public String newCcpAgreementSearchPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		return "sales/ccp/ccpRentalAgrNewSearchPop";
	}

	@RequestMapping(value = "/newCcpRenAgrSearchResultPop.do", method = RequestMethod.POST)
	public String newCcpAgreementSearchResultPop (@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

		int prgrsId = 0;
		EgovMap orderDetail = null;
		params.put("prgrsId", prgrsId);

        orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

		model.put("orderDetail", orderDetail);
		model.addAttribute("salesOrderNo", params.get("salesOrderNo"));

		return "sales/ccp/ccpRentalAgrNewSearchResultPop";
	}

	@RequestMapping(value = "/insertRentalAgreement.do" , method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertAgreement (@RequestBody Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.info("################## insertAgreement Start #######################");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		Map<String, Object> returnMap = new HashMap<String, Object>();

		returnMap = ccpRentalAgreementService.insertAgreement(params);

		return ResponseEntity.ok(returnMap);

	}

	@RequestMapping(value = "/cancelRentalAgrMtcEdit.do")
	public ResponseEntity<Map<String, Object>> cancelRentalAgrMtcEdit (@RequestBody Map<String, Object> params) throws Exception{

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		Map<String, Object> returnMap = new HashMap<String, Object>();
		params.put("userId", sessionVO.getUserId());

		Map<String, Object> params1 = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		params1.put("updMsgStatus", "10");
		params1.put("agreementAgmRemark", "Agreement Cancelled");
		params1.put("updResultRemark", "Agreement Cancelled");

		returnMap = ccpRentalAgreementService.updateAgreementMtcEdit(params);

		return ResponseEntity.ok(returnMap);
	}

	@RequestMapping(value = "/selectAgreementProgressStatus.do")
  public ResponseEntity<List<EgovMap>> selectAgreementProgressStatus (@RequestParam Map<String, Object> params) throws Exception{
    return ResponseEntity.ok(ccpRentalAgreementService.selectAgreementProgressStatus(params));
	}

	/*@RequestMapping(value="/ccpCalListingPop.do")
	public String ccpSearchListingPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/ccp/ccpCalListingPop";
	}

	@RequestMapping(value="/ccpCalRawDataPop.do")
	public String ccpSearchRawDataPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/ccp/ccpCalRawDataPop";
	}

	@RequestMapping(value="/ccpCalPerformancePop")
	public String ccpSearchPerformancePop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/ccp/ccpCalPerformancePop";
	}


	@RequestMapping(value = "/selectAfterServiceJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAfterServiceJsonList (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> afServiceList = null;

		afServiceList = ccpRentalAgreementService.selectAfterServiceJsonList(params);

		return ResponseEntity.ok(afServiceList);

	}


	@RequestMapping(value = "/selectBeforeServiceJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBeforeServiceJsonList (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> afServiceList = null;

		afServiceList = ccpRentalAgreementService.selectBeforeServiceJsonList(params);

		return ResponseEntity.ok(afServiceList);

	}


	@RequestMapping(value = "/searchOrderNoPop.do")
	public String	searchOrderNoPop (@RequestParam Map<String, Object> params) throws Exception{

		return "sales/ccp/ccpRentalAgreementSearchOrderNoPop";
	}


	@RequestMapping(value = "/selectsearchOrderNo")
	public ResponseEntity<List<EgovMap>> selectsearchOrderNo (@RequestParam Map<String, Object> params , HttpServletRequest request) throws Exception{

		List<EgovMap> ordList = null;

		String appType [] = request.getParameterValues("searchOrdAppType");

		params.put("appType", appType);

		ordList = ccpRentalAgreementService.selectSearchOrderNo(params);

		return ResponseEntity.ok(ordList);

	}


	@RequestMapping(value = "/searchMemberPop.do")
	public String searchMemberPop (@RequestParam Map<String, Object> params) throws Exception{

		return "sales/ccp/ccpRentalAgreementSearchMemberPop";
	}


	@RequestMapping(value = "/selectSearchMemberCode")
	public ResponseEntity<List<EgovMap>> selectSearchMemberCode (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> memList = null;

		memList = ccpRentalAgreementService.selectSearchMemberCode(params);

		return ResponseEntity.ok(memList);
	}

	@RequestMapping(value = "/getMemCodeConfirm")
	public ResponseEntity<EgovMap> getMemCodeConfirm (@RequestParam Map<String, Object> params) throws Exception{

		EgovMap memMap = null;

		memMap = ccpRentalAgreementService.getMemCodeConfirm(params);

		return ResponseEntity.ok(memMap);
	}

	@RequestMapping(value = "/selectCurierListJsonList")
	public ResponseEntity<List<EgovMap>> selectCurierListJsonList() throws Exception{

		LOGGER.info("################## Call CurierList(Combo Box) ##################");

		List<EgovMap> curierList = null;

		curierList = ccpRentalAgreementService.selectCurierListJsonList();

		return ResponseEntity.ok(curierList);
	}

	@RequestMapping(value ="/selectOrderJsonList")
	public ResponseEntity<List<EgovMap>> selectOrderJsonList (@RequestParam Map<String, Object> params) throws Exception{

		LOGGER.info("################## selectOrderJsonList Start ##################");

		List<EgovMap> orderList = null;

		orderList = ccpRentalAgreementService.selectOrderJsonList(params);

		return ResponseEntity.ok(orderList);

	}



	@RequestMapping(value = "/sendSuccessEmail.do")
	public ResponseEntity<ReturnMessage> sendSuccessEmail (@RequestParam Map<String, Object> params) throws Exception{

		LOGGER.info("################## sendSuccessEmail Start #######################");

		boolean isResult = false;
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		params.put("fullName", sessionVO.getUserFullname());

		isResult = ccpRentalAgreementService.sendSuccessEmail(params);

		//Return MSG
		ReturnMessage message = new ReturnMessage();

		if(isResult == true){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		LOGGER.info("################## sendSuccessEmail End #######################");
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/addNewConsign.do")
	public String addNewConsign(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		model.addAttribute("updAgrId", params.get("updAgrId"));


		return "sales/ccp/ccpRentalAgreementMtcNewConsignPop";
	}


	@RequestMapping(value = "/updateNewConsignment.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage>  updateNewConsignment (@RequestParam Map<String, Object> params) throws Exception{

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		params.put("userId", sessionVO.getUserId());
		//TODO 추후 삭제 세션
		params.put("userId", "52366");

		//params Set
		params.put("updAgrId", params.get("conAgrId"));

		ccpRentalAgreementService.updateNewConsignment(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("New agreement consignment successfully saved.");

		return ResponseEntity.ok(message);

	}





	@RequestMapping(value = "/openFileUploadPop.do")
	public String openFileUploadPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		model.addAttribute("msgId", params.get("msgId"));

		LOGGER.info("######################## move msgId  :   " + params.get("msgId"));

		return "sales/ccp/ccpRentalAgreementMtxViewEditUploadPop";

	}


	@RequestMapping(value = "/searchOrderNoByEditPop.do")
	public String	searchOrderNoByEditPop (@RequestParam Map<String, Object> params) throws Exception{

		return "sales/ccp/ccpRentalAgreementSearchOrderNoByEditPop";
	}


	*/
}

