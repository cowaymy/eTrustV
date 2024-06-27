package com.coway.trust.web.supplement;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jettison.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.biz.sales.pos.vo.PosGridVO;
import com.coway.trust.biz.sales.pos.vo.PosLoyaltyRewardVO;
import com.coway.trust.biz.sales.rcms.vo.uploadAssignAgentDataVO;
import com.coway.trust.biz.sales.rcms.vo.uploadAssignConvertVO;
import com.coway.trust.biz.supplement.SupplementTagManagementService;
import com.coway.trust.biz.supplement.SupplementUpdateService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/supplement")
public class SupplementTagManagementController {

  private static final Logger LOGGER = LoggerFactory.getLogger(SupplementTagManagementController.class);

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  @Value("${web.resource.upload.file}")
  private String uploadDir;

  @Autowired
  private CsvReadComponent csvReadComponent;

  @Autowired
  private FileApplication fileApplication;

  @Resource(name = "posService")
  private PosService posService;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  @Resource(name = "supplementUpdateService")
  private SupplementUpdateService supplementUpdateService;

  @Resource(name = "supplementTagManagementService")
  private SupplementTagManagementService supplementTagManagementService;

  @RequestMapping(value = "/supplementTagManagementList.do")
  public String selectSupplementTagManagementList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

	List<EgovMap> tagStus = supplementTagManagementService.selectTagStus();
	List<EgovMap> mainTopic = supplementTagManagementService.getMainTopicList();
	List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();

	 LOGGER.debug("===========================supplementTagManagementList.do=====================================");
	 LOGGER.debug(" SelectTagStus : {}", tagStus);
	 LOGGER.debug(" MainTopic : {}", mainTopic);
	 LOGGER.debug(" InchgDept : {}", inchgDept);
	 LOGGER.debug("===========================supplementTagManagementList.do=====================================");

	 model.addAttribute("tagStus", tagStus);
	 model.addAttribute("mainTopic", mainTopic);
	 model.addAttribute("inchgDept", inchgDept);

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    return "supplement/supplementTagManagementList";
  }

  @RequestMapping(value = "/selectTagManagementList")
  public ResponseEntity<List<EgovMap>> selectSupplementList(@RequestParam Map<String, Object> params,
      HttpServletRequest request) throws Exception {

    List<EgovMap> listMap = null;

    LOGGER.info("############################ selectTagManagementList  params.toString :    " + params.toString());

    listMap = supplementTagManagementService.selectTagManagementList(params);
    return ResponseEntity.ok(listMap);

  }

  @RequestMapping(value = "/getSubTopicList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSubTopicList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
	  LOGGER.debug("===========================/getSubTopicList.do===============================");
	  LOGGER.debug("== params heres" + params.toString());

    List<EgovMap> getSubTopicList = supplementTagManagementService.getSubTopicList(params);

    LOGGER.debug("== getSubTopicList : {}" + getSubTopicList);
    LOGGER.debug("===========================/getSubTopicList.do===============================");
    return ResponseEntity.ok(getSubTopicList);
  }

  @RequestMapping(value = "/getSubDeptList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSubDeptList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
	  LOGGER.debug("===========================/getSubDeptList.do===============================");
	  LOGGER.debug("== params heres" + params.toString());

    List<EgovMap> getSubDeptList = supplementTagManagementService.getSubDeptList(params);

    LOGGER.debug("== getSubDeptList : {}" + getSubDeptList);
    LOGGER.debug("===========================/getSubDeptList.do===============================");
    return ResponseEntity.ok(getSubDeptList);
  }

  @RequestMapping(value = "/tagMngApprovalPop.do")
  public String supplementTagManagementApproval(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    EgovMap orderInfoMap = null;
    EgovMap tagInfoMap = null;
    List<EgovMap> tagStus = supplementTagManagementService.selectTagStus();
    List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();

    LOGGER.debug("!@##############################################################################");
    LOGGER.debug("!@###### supRefId : " + params.get("supRefId"));
    LOGGER.debug(" SelectTagStus : {}", tagStus);
    LOGGER.debug(" InchgDept : {}", inchgDept);
    LOGGER.debug("!@##############################################################################");

    orderInfoMap = supplementUpdateService.selectOrderBasicInfo(params);
    tagInfoMap = supplementTagManagementService.selectOrderBasicInfo(params);

    params.put("userId", sessionVO.getUserId());
    model.put("userBr", sessionVO.getUserBranchId());
    model.addAttribute("orderInfo", orderInfoMap);
    model.addAttribute("tagInfo", tagInfoMap);
    model.addAttribute("tagStus", tagStus);
    model.addAttribute("inchgDept", inchgDept);

    return "supplement/supplementTagManagementApprovalPop";
  }

  @RequestMapping(value = "/newTagRequestPop.do")
  public String newTagRequestPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

	List<EgovMap> mainTopic = supplementTagManagementService.getMainTopicList();
	List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();

	 LOGGER.debug("===========================newTagRequestPop.do=====================================");
	 LOGGER.debug(" MainTopic : {}", mainTopic);
	 LOGGER.debug(" InchgDept : {}", inchgDept);
	 LOGGER.debug("===========================newTagRequestPop.do=====================================");

	 model.addAttribute("mainTopic", mainTopic);
	 model.addAttribute("inchgDept", inchgDept);
	 model.put("userBr", sessionVO.getUserBranchId());
    params.put("userId", sessionVO.getUserId());


    return "supplement/supplementTagManagementCreationPop";
  }

  @RequestMapping(value = "/searchOrdNoPop.do")
  public String searchOrdNoPop( @RequestParam Map<String, Object> params, ModelMap model ) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    model.put( "userId", sessionVO.getUserId() );

    return "supplement/include/ordSlctPop";
  }

/*  @RequestMapping(value = "/searchOrderNo", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectOrderNo(@RequestParam Map<String, Object> params, ModelMap model) {
	  LOGGER.debug("===========================/searchOrderNo.do===============================");
	  LOGGER.debug("== params " + params.toString());
	  LOGGER.debug("===========================/searchOrderNo.do===============================");

    EgovMap basicInfo = supplementTagManagementService.searchOrderBasicInfo(params);
    model.addAttribute("orderInfo", basicInfo);
    return ResponseEntity.ok(basicInfo);
  }*/

  @RequestMapping(value = "/searchOrderNo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectOrderNo( @RequestParam Map<String, Object> params, ModelMap model ) {
    LOGGER.debug( "===========================/searchOrderNo.do===============================" );
    LOGGER.debug( "== params " + params.toString() );
    LOGGER.debug( "===========================/searchOrderNo.do===============================" );
    List<EgovMap> listMap = null;
    listMap = supplementTagManagementService.searchOrderBasicInfo( params );
    return ResponseEntity.ok( listMap );
  }

  @RequestMapping(value = "/supplementViewBasicPop.do")
  public String supplementViewPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

	List<EgovMap> mainTopic = supplementTagManagementService.getMainTopicList();
	List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();

    EgovMap orderInfoMap = null;

    LOGGER.debug("!@##############################################################################");
    LOGGER.debug("!@###### supRefNo : " + params.get("supRefNo"));
	LOGGER.debug(" MainTopic : {}", mainTopic);
	LOGGER.debug(" InchgDept : {}", inchgDept);
    LOGGER.debug("!@##############################################################################");

    orderInfoMap = supplementTagManagementService.selectViewBasicInfo(params);

	model.addAttribute("mainTopic", mainTopic);
	model.addAttribute("inchgDept", inchgDept);

    params.put("userId", sessionVO.getUserId());
    model.put("userBr", sessionVO.getUserBranchId());
    model.addAttribute("orderInfo", orderInfoMap);

    return "supplement/supplementTagManagementCreationPop";
  }

  @RequestMapping(value = "/getResponseLst")
  public ResponseEntity<List<EgovMap>> getResponseLst(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> responceList = null;
    responceList = supplementTagManagementService.getResponseLst(params);
    return ResponseEntity.ok(responceList);
  }

/*	@RequestMapping(value = "/attachFileUploadId.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> sampleUploadCommon(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);


		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "Supplement" + File.separator + "tagManagement", 1024 * 1024 * 6);

		LOGGER.debug("list.size : {}", list.size());

		params.put("userId", sessionVO.getUserId());

		supplementTagManagementService.insertAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params);

		params.put("attachFiles", list);

		LOGGER.debug("list SIZE=============" + list.size());

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		//message.setData(params.get("fileGroupKey"));
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}*/

  @RequestMapping(value = "/attachFileUploadId.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request,
      @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

	  LOGGER.debug("params =====================================>>  " + params);

    String err = "";
    String code = "";
    List<String> seqs = new ArrayList<>();

    LocalDate date = LocalDate.now();
    String year = String.valueOf(date.getYear());
    String month = String.format("%02d", date.getMonthValue());

    String subPath = File.separator + "supplement" + File.separator + "tagSubmission" + File.separator + year
        + File.separator + month + File.separator + CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT3);

    try {
      Set set = request.getFileMap().entrySet();
      Iterator i = set.iterator();

      while (i.hasNext()) {
        Map.Entry me = (Map.Entry) i.next();
        String key = (String) me.getKey();
        seqs.add(key);
      }

      // List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadImageFilesWithCompress(request, uploadDir, subPath , AppConstants.UPLOAD_MIN_FILE_SIZE, true);
      List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, subPath,
          AppConstants.UPLOAD_MIN_FILE_SIZE, true);

      LOGGER.debug("list.size : {}", list.size());

      params.put(CommonConstants.USER_ID, sessionVO.getUserId());

      supplementTagManagementService.insertTagSubmissionAttachBiz(FileVO.createList(list),
          FileType.WEB_DIRECT_RESOURCE, params, seqs);

      params.put("attachFiles", list);
      code = AppConstants.SUCCESS;
    } catch (ApplicationException e) {
      err = e.getMessage();
      code = AppConstants.FAIL;
    }

    ReturnMessage message = new ReturnMessage();
    message.setCode(code);
    message.setData(params);
    message.setMessage(err);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/supplementTagSubmission.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> supplementTagSubmission(@RequestBody Map<String, Object> params)
      throws Exception {
    ReturnMessage message = new ReturnMessage();
    String msg = "";

    try {
      // Retrieve the current session user info
      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
      params.put("userId", sessionVO.getUserId());

      LOGGER.info("############################ supplementTagSubmission - params: {}", params);

      // Call the service method
      Map<String, Object> returnMap = supplementTagManagementService.supplementTagSubmission(params);

      // Check the response and set the message accordingly
      if ("000".equals(returnMap.get("logError"))) {
        msg += "New Tag Submission successfully saved.<br />";
        message.setCode(AppConstants.SUCCESS);
      } else {
        msg += "New Tag Submission failed to save.<br />";
        msg += returnMap.get("message") + "<br />";
        message.setCode(AppConstants.FAIL);
      }
      message.setMessage(msg);

    } catch (Exception e) {
      LOGGER.error("Error during New Tag Submission", e);
      msg += "An unexpected error occurred.<br />";
      message.setCode(AppConstants.FAIL);
      message.setMessage(msg);
    }

    return ResponseEntity.ok(message);
  }

}
