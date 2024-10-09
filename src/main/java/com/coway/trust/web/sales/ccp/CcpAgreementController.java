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
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.ccp.CcpAgreementService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileUtil;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ccp")
public class CcpAgreementController {


	private static final Logger LOGGER = LoggerFactory.getLogger(CcpAgreementController.class);

	@Resource(name = "ccpAgreementService")
	private CcpAgreementService ccpAgreementService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private FileService fileService;

	@RequestMapping(value = "/selectCcpAgreementList.do")
	public String selectCcpAgreementList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		return "sales/ccp/ccpAgreementList";
	}

	@RequestMapping(value="/ccpAgreementRawPop.do" )
	public String ccpAgreementRawPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/ccp/ccpAgreementRawPop";
	}

	@RequestMapping(value="/ccpAgreementListingPop.do")
	public String ccpAgreementListingPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/ccp/ccpAgreementListingPop";
	}

	@RequestMapping(value="/ccpAgreementSummaryReportPop.do")
	public String ccpAgreementSummaryReportPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/ccp/ccpAgreementSummaryReportPop";
	}

	@RequestMapping(value="/ccpAgreementConsignmentCourierListingPop.do")
	public String ccpAgreementConsignmentCourierListingPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/ccp/ccpAgreementConsignmentCourierListingPop";
	}

	@RequestMapping(value="/ccpCalListingPop.do")
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

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;


	@RequestMapping(value = "/selectCcpAgreementJsonList" , method = RequestMethod.GET)
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

	    ccpAgrList = ccpAgreementService.selectContactAgreementList(params);

		return ResponseEntity.ok(ccpAgrList);

	}


	@RequestMapping(value = "/newCcpAgreementSearchPop.do")
	public String newCcpAgreementSearchPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		return "sales/ccp/ccpAgreementNewSearchPop";
	}


	@RequestMapping(value = "/getOrderId", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> getOrderId(@RequestParam Map<String, Object> params) throws Exception{

		EgovMap resultMap = null;
		//서비스
		resultMap = ccpAgreementService.getOrderId(params);

		return ResponseEntity.ok(resultMap);
	}


	@RequestMapping(value = "/newCcpAgreementSearchResultPop.do", method = RequestMethod.POST)
	public String newCcpAgreementSearchResultPop (@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

		int prgrsId = 0;
		EgovMap orderDetail = null;
		params.put("prgrsId", prgrsId);

        orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

		model.put("orderDetail", orderDetail);
		model.addAttribute("salesOrderNo", params.get("salesOrderNo"));

		return "sales/ccp/ccpAgreementNewSearchResultPop";
	}


	@RequestMapping(value = "/selectAfterServiceJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAfterServiceJsonList (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> afServiceList = null;

		afServiceList = ccpAgreementService.selectAfterServiceJsonList(params);

		return ResponseEntity.ok(afServiceList);

	}


	@RequestMapping(value = "/selectBeforeServiceJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBeforeServiceJsonList (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> afServiceList = null;

		afServiceList = ccpAgreementService.selectBeforeServiceJsonList(params);

		return ResponseEntity.ok(afServiceList);

	}


	@RequestMapping(value = "/searchOrderNoPop.do")
	public String	searchOrderNoPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "sales/ccp/ccpAgreementSearchOrderNoPop";
	}


	@RequestMapping(value = "/selectsearchOrderNo")
	public ResponseEntity<List<EgovMap>> selectsearchOrderNo (@RequestParam Map<String, Object> params , HttpServletRequest request) throws Exception{

		List<EgovMap> ordList = null;

		String appType [] = request.getParameterValues("searchOrdAppType");

		params.put("appType", appType);

		ordList = ccpAgreementService.selectSearchOrderNo(params);

		return ResponseEntity.ok(ordList);

	}


	@RequestMapping(value = "/searchMemberPop.do")
	public String searchMemberPop (@RequestParam Map<String, Object> params) throws Exception{

		return "sales/ccp/ccpAgreementSearchMemberPop";
	}


	@RequestMapping(value = "/selectSearchMemberCode")
	public ResponseEntity<List<EgovMap>> selectSearchMemberCode (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> memList = null;

		memList = ccpAgreementService.selectSearchMemberCode(params);

		return ResponseEntity.ok(memList);
	}

	@RequestMapping(value = "/getMemCodeConfirm")
	public ResponseEntity<EgovMap> getMemCodeConfirm (@RequestParam Map<String, Object> params) throws Exception{

		EgovMap memMap = null;

		memMap = ccpAgreementService.getMemCodeConfirm(params);

		return ResponseEntity.ok(memMap);
	}

	@RequestMapping(value = "/selectCurierListJsonList")
	public ResponseEntity<List<EgovMap>> selectCurierListJsonList() throws Exception{

		LOGGER.info("################## Call CurierList(Combo Box) ##################");

		List<EgovMap> curierList = null;

		curierList = ccpAgreementService.selectCurierListJsonList();

		return ResponseEntity.ok(curierList);
	}

	@RequestMapping(value ="/selectOrderJsonList")
	public ResponseEntity<List<EgovMap>> selectOrderJsonList (@RequestParam Map<String, Object> params) throws Exception{

		LOGGER.info("################## selectOrderJsonList Start ##################");

		List<EgovMap> orderList = null;

		orderList = ccpAgreementService.selectOrderJsonList(params);

		return ResponseEntity.ok(orderList);

	}


	@RequestMapping(value ="/selectOrderAddJsonList")
	public ResponseEntity<List<EgovMap>> selectOrderAddJsonList (@RequestParam Map<String, Object> params) throws Exception{

		LOGGER.info("################## selectOrderJsonList Start ##################");

		List<EgovMap> orderList = null;

		//Set Params
		params.put("salesOrderId", params.get("addOrdId"));

		orderList = ccpAgreementService.selectOrderJsonList(params);

		return ResponseEntity.ok(orderList);

	}


	@RequestMapping(value = "/insertAgreement.do" , method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertAgreement (@RequestBody Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.info("################## insertAgreement Start #######################");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		Map<String, Object> returnMap = new HashMap<String, Object>();

		returnMap = ccpAgreementService.insertAgreement(params);

		return ResponseEntity.ok(returnMap);

	}

	@RequestMapping(value = "/sendSuccessEmail.do")
	public ResponseEntity<ReturnMessage> sendSuccessEmail (@RequestParam Map<String, Object> params) throws Exception{

		LOGGER.info("################## sendSuccessEmail Start #######################");

		boolean isResult = false;
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		params.put("fullName", sessionVO.getUserFullname());

		isResult = ccpAgreementService.sendSuccessEmail(params);

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


	@RequestMapping(value = "/selectAgreementMtcViewEditPop.do")
	public String  selectAgreementMtcViewEditPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.info("################### Params Confirm[/selectAgreementMtcViewEditPop]  : " + params.toString());

		EgovMap infoMap = null;

		infoMap = ccpAgreementService.selectAgreementInfo(params);
		LOGGER.info("################### 가져온 infoMap  : " + infoMap.toString());
		model.addAttribute("infoMap", infoMap);

		//TODO Agreement Type 에 대한 업무 설명 필요 추후 수정

		return "sales/ccp/ccpAgreementMtcViewEditPop";
	}


	@RequestMapping(value = "/getMessageStatusCode.do")
	public ResponseEntity<List<EgovMap>>  getMessageStatusCode (@RequestParam Map<String, Object> params) throws Exception {

		List<EgovMap> codeList = null;
		codeList = ccpAgreementService.getMessageStatusCode(params);

		return ResponseEntity.ok(codeList);
	}


	@RequestMapping(value = "/selectConsignmentLogAjax")
	public ResponseEntity<List<EgovMap>> selectConsignmentLogAjax (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> consignList = null;
		consignList = ccpAgreementService.selectConsignmentLogAjax(params);

		return ResponseEntity.ok(consignList);

	}


	@RequestMapping(value = "/selectMessageLogAjax")
	public ResponseEntity<List<EgovMap>> selectMessageLogAjax (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> msgList = null;
		msgList = ccpAgreementService.selectMessageLogAjax(params);

		return ResponseEntity.ok(msgList);

	}


	@RequestMapping(value = "/selectContactOrdersAjax")
	public ResponseEntity<List<EgovMap>> selectContactOrdersAjax (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> orderList = null;
		orderList = ccpAgreementService.selectContactOrdersAjax(params);

		return ResponseEntity.ok(orderList);

	}


	@RequestMapping(value = "/selectListOrdersAjax")
	public ResponseEntity<List<EgovMap>> selectListOrdersAjax (@RequestParam Map<String, Object> params) throws Exception{

		params.put("govAgId", params.get("ordAgId"));
		List<EgovMap> orderList = null;
		orderList = ccpAgreementService.selectContactOrdersAjax(params);

		return ResponseEntity.ok(orderList);

	}


	@RequestMapping(value = "/updateAgreementMtcEdit.do")
	public ResponseEntity<Map<String, Object>> updateAgreementMtcEdit (@RequestParam Map<String, Object> params) throws Exception{

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		Map<String, Object> returnMap = new HashMap<String, Object>();
		params.put("userId", sessionVO.getUserId());

		returnMap = ccpAgreementService.updateAgreementMtcEdit(params);

		return ResponseEntity.ok(returnMap);
	}


	@RequestMapping(value = "/addNewConsign.do")
	public String addNewConsign(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		model.addAttribute("updAgrId", params.get("updAgrId"));


		return "sales/ccp/ccpAgreementMtcNewConsignPop";
	}


	@RequestMapping(value = "/updateNewConsignment.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage>  updateNewConsignment (@RequestParam Map<String, Object> params) throws Exception{

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		params.put("userId", sessionVO.getUserId());
		//TODO 추후 삭제 세션
		params.put("userId", "52366");

		//params Set
		params.put("updAgrId", params.get("conAgrId"));

		ccpAgreementService.updateNewConsignment(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("New agreement consignment successfully saved.");

		return ResponseEntity.ok(message);

	}


	@RequestMapping(value = "/sendUpdateEmail.do")
	public ResponseEntity<ReturnMessage> sendUpdateEmail (@RequestParam Map<String, Object> params) throws Exception{

		LOGGER.info("################## sendUpdateEmail Start #######################");

		LOGGER.info("#########################################################");
		LOGGER.info("########### Params 확인 : " + params.toString());
		//Session
		boolean isResult = false;
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("fullName", sessionVO.getUserFullname());
		//TODO 추후 삭제 세션
		params.put("fullName", "Jang Gwang Ryul");

		isResult = ccpAgreementService.sendUpdateEmail(params);

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


	@RequestMapping(value = "/openFileUploadPop.do")
	public String openFileUploadPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		model.addAttribute("msgId", params.get("msgId"));

		LOGGER.info("######################## move msgId  :   " + params.get("msgId"));

		return "sales/ccp/ccpAgreementMtxViewEditUploadPop";

	}


	@RequestMapping(value = "/searchOrderNoByEditPop.do")
	public String	searchOrderNoByEditPop (@RequestParam Map<String, Object> params) throws Exception{

		return "sales/ccp/ccpAgreementSearchOrderNoByEditPop";
	}


	@RequestMapping(value = "/uploadCcpFile.do")
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
		ccpAgreementService.uploadCcpFile(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}
}

