package com.coway.trust.web.eAccounting.scmActivityFund;

import java.io.File;
import java.util.List;
import java.util.Map;

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
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.scmActivityFund.ScmActivityFundApplication;
import com.coway.trust.biz.eAccounting.scmActivityFund.ScmActivityFundService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.eAccounting.pettyCash.PettyCashController;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/scmActivityFund")
public class ScmActivityFundController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PettyCashController.class);

	@Value("${app.name}")
	private String appName;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private ScmActivityFundService scmActivityFundService;

	@Autowired
	private ScmActivityFundApplication scmActivityFundApplication;

	@Autowired
	private WebInvoiceService webInvoiceService;

	@RequestMapping(value = "/scmActivityFundMgmt.do")
    public String scmActivityFundMgmt(@RequestParam Map<String, Object> params, ModelMap model) {
        if (params != null) {
            String clmNo = (String) params.get("clmNo");
            model.addAttribute("clmNo", clmNo);
        }

        return "eAccounting/scmActivityFund/scmActivityFund";
    }

	@RequestMapping(value = "/selectScmActivityFundList.do")
	public ResponseEntity<List<EgovMap>> selectScmActivityFundList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
		if(!"A1101".equals(costCentr)) {
		    if(sessionVO.getRoleId() != 200 && sessionVO.getRoleId() != 252 && sessionVO.getRoleId() != 253) {
		        params.put("loginUserId", sessionVO.getUserId());
		    }
		}

		LOGGER.debug("params =====================================>>  " + params);

		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");

		params.put("appvPrcssStus", appvPrcssStus);

		List<EgovMap> claimList = scmActivityFundService.selectScmActivityFundList(params);

		return ResponseEntity.ok(claimList);
	}

	@RequestMapping(value = "/newScmActivityFundPop.do")
	public String newScmActivityFundPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> taxCodeFlagList = scmActivityFundService.selectTaxCodeScmActivityFundFlag();

		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("costCentr", sessionVO.getCostCentr());
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeFlagList));
		return "eAccounting/scmActivityFund/scmActivityFundNewExpensesPop";
	}

	@RequestMapping(value = "/selectTaxCodeScmActivityFundFlag.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTaxCodeScmActivityFundFlag(Model model) {

		List<EgovMap> taxCodeFlagList = scmActivityFundService.selectTaxCodeScmActivityFundFlag();

		return ResponseEntity.ok(taxCodeFlagList);
	}

	@RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "scmActivityFund", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		scmActivityFundApplication.insertScmActivityFundAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params);

		params.put("attachFiles", list);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/insertScmActivityFundExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertScmActivityFundExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		scmActivityFundService.insertScmActivityFundExp(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectScmActivityFundItemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmActivityFundItemList(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> itemList = scmActivityFundService.selectScmActivityFundItems((String) params.get("clmNo"));

		return ResponseEntity.ok(itemList);
	}

	@RequestMapping(value = "/viewScmActivityFundPop.do")
	public String viewScmActivityFundPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		// TODO selectExpenseItems
		List<EgovMap> itemList = scmActivityFundService.selectScmActivityFundItems((String) params.get("clmNo"));
		List<EgovMap> taxCodeFlagList = scmActivityFundService.selectTaxCodeScmActivityFundFlag();

		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("itemList", new Gson().toJson(itemList));
		model.addAttribute("clmNo", (String) params.get("clmNo"));
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeFlagList));
		if(itemList.size() > 0) {
			model.addAttribute("appvPrcssNo", itemList.get(0).get("appvPrcssNo"));
		}
		return "eAccounting/scmActivityFund/scmActivityFundViewExpensesPop";
	}

	@RequestMapping(value = "/selectScmActivityFundInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectScmActivityFundInfo(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		EgovMap info = scmActivityFundService.selectScmActivityFundInfo(params);
		List<EgovMap> itemGrp = scmActivityFundService.selectScmActivityFundItemGrp(params);

		info.put("itemGrp", itemGrp);

		String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> attachList = scmActivityFundService.selectAttachList(atchFileGrpId);
			info.put("attachList", attachList);
		}

		return ResponseEntity.ok(info);
	}

	@RequestMapping(value = "/attachFileUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "scmActivityFund", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		scmActivityFundApplication.updateScmActivityFundAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);

		params.put("attachFiles", list);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateScmActivityFundExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateScmActivityFundExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		scmActivityFundService.updateScmActivityFundExp(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(ModelMap model) {
		return "eAccounting/scmActivityFund/approveLinePop";
	}

	@RequestMapping(value = "/registrationMsgPop.do")
	public String registrationMsgPop(ModelMap model) {
		return "eAccounting/scmActivityFund/registrationMsgPop";
	}

	@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO
		scmActivityFundService.insertApproveManagement(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/completedMsgPop.do")
	public String completedMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute("clmNo", params.get("clmNo"));
		return "eAccounting/scmActivityFund/completedMsgPop";
	}

	@RequestMapping(value = "/deleteScmActivityFundExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteScmActivityFundExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		scmActivityFundApplication.deleteScmActivityFundAttachBiz(FileType.WEB_DIRECT_RESOURCE, params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/editRejected.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> editRejected(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        String clmNo = scmActivityFundService.selectNextClmNo();
        params.put("newClmNo", clmNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        scmActivityFundService.editRejected(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }
}
