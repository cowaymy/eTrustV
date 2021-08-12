package com.coway.trust.web.logistics.adjustment;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.logistics.adjustment.CountStockAuditService;
import com.coway.trust.biz.logistics.adjustment.StockAuditService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : StockAuditController.java
 * @Description : StockAudit Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 07.   KR-OHK        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/logistics/adjustment")
public class StockAuditController {

	private static final Logger logger = LoggerFactory.getLogger(StockAuditController.class);

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private FileApplication fileApplication;

	@Autowired
	private StockAuditService stockAuditService;

	@Autowired
	private CountStockAuditService countStockAuditService;

	@RequestMapping(value = "/selectLocCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLocCodeList(@RequestParam Map<String, Object> params) {

		logger.debug("groupCode : {}", params.get("groupCode"));

		List<EgovMap> codeList = stockAuditService.selectLocCodeList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/stockAuditList.do")
	public String stockAuditList(ModelMap model) throws Exception {
		return "logistics/adjustment/stockAuditList";
	}

	@RequestMapping(value = "/stockAuditRegisterPop.do")
	public String stockAuditRegisterPop(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) {
		if("MOD".equals(params.get("action"))) {
    		model.addAttribute("stockAuditNo", params.get("stockAuditNo"));
		}
		model.addAttribute("action", params.get("action"));

		return "logistics/adjustment/stockAuditRegisterPop";
	}

	@RequestMapping(value = "/stockAuditApprovePop.do")
	public String stockAuditApprovePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		EgovMap docInfo = stockAuditService.selectStockAuditDocInfo(params);
		params.put("atchFileGrpId", docInfo.get("atchFileGrpId"));

		List<EgovMap> files = countStockAuditService.getAttachmentFileInfo(params);
		List<EgovMap> locList = stockAuditService.selectStockAuditSelectedLocList(params);
		List<EgovMap> itemList = countStockAuditService.selectStockAuditItemList(params);

		model.addAttribute("docInfo", docInfo);
		model.addAttribute("locList", new Gson().toJson(locList));
		model.addAttribute("itemList", new Gson().toJson(itemList));
		model.addAttribute("files", files);
		model.addAttribute("action", params.get("action"));

		return "logistics/adjustment/stockAuditApprovePop";
	}

	@RequestMapping(value = "/stockAuditOtherPop.do")
	public String stockAuditOtherPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		EgovMap docInfo = stockAuditService.selectStockAuditDocInfo(params);

		List<EgovMap> itemList = stockAuditService.selectOtherGIGRItemList(params);

		model.addAttribute("docInfo", docInfo);
		model.addAttribute("itemList", new Gson().toJson(itemList));
		model.addAttribute("action", params.get("action"));

		return "logistics/adjustment/stockAuditOtherPop";
	}

	@RequestMapping(value = "/stockAuditDetailPop.do")
	public String stockAuditDetailPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		EgovMap docInfo = stockAuditService.selectStockAuditDocInfo(params);
		params.put("atchFileGrpId", docInfo.get("atchFileGrpId"));

		List<EgovMap> files = countStockAuditService.getAttachmentFileInfo(params);
		List<EgovMap> locList = stockAuditService.selectLocInHisList(params);
		List<EgovMap> itemList = stockAuditService.selectItemInHisList(params);

		model.addAttribute("docInfo", docInfo);
		model.addAttribute("locList", new Gson().toJson(locList));
		model.addAttribute("itemList", new Gson().toJson(itemList));
		model.addAttribute("files", files);
		model.addAttribute("action", params.get("action"));

		return "logistics/adjustment/stockAuditDetailPop";
	}

	@RequestMapping(value = "/stockAuditReuploadPop.do")
	public String stockAuditReuploadPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		EgovMap docInfo = stockAuditService.selectStockAuditDocInfo(params);
		params.put("atchFileGrpId", docInfo.get("atchFileGrpId"));

		List<EgovMap> files = countStockAuditService.getAttachmentFileInfo(params);

		model.addAttribute("docInfo", docInfo);
		model.addAttribute("files", files);

		return "logistics/adjustment/stockAuditReuploadPop";
	}

	@RequestMapping(value = "/selectStockAuditEditInfo", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectStockAuditEditInfo(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) throws Exception {

		EgovMap docInfo = stockAuditService.selectStockAuditDocInfo(params);
		List<EgovMap> locList = stockAuditService.selectStockAuditSelectedLocList(params);
		List<EgovMap> itemList = stockAuditService.selectStockAuditSelectedItemList(params);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docInfo", docInfo);
		map.put("locList", locList);
		map.put("itemList", itemList);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectOtherDetail", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectOtherDetail(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) throws Exception {

		EgovMap docInfo = stockAuditService.selectStockAuditDocInfo(params);
		List<EgovMap> itemList = stockAuditService.selectOtherGIGRItemList(params);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setData(docInfo.get("docStusCodeId"));
		result.setDataList(itemList);

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectStockAuditList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectStockAuditList(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {

		ReturnMessage result = new ReturnMessage();

		int firstIndex = -1;
		int lastIndex  = -1;

		// 한페이지에서 보여줄 행 수
		int rowCount = params.containsKey("rowCount")?(int)params.get("rowCount"):0;

		// 호출한 페이지
		int goPage = params.containsKey("goPage")?(int)params.get("goPage"):0;

		if(rowCount != 0 && goPage != 0){
			firstIndex = (rowCount * goPage) - rowCount;
			lastIndex = rowCount * goPage;
		}
		params.put("firstIndex", firstIndex);
		params.put("lastIndex", lastIndex);

		List<EgovMap> list = null;
		List<EgovMap> excelList = null;
		HashMap<String, Object> mp = new HashMap<String, Object>();

		int cnt = stockAuditService.selectStockAuditListCnt(params);

		if(cnt > 0){
			list =  stockAuditService.selectStockAuditList(params);
			excelList =  stockAuditService.selectStockAuditListExcel(params);

			mp.put("list", list);
			mp.put("excelList", excelList);
		}

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setTotal(cnt);
		result.setData(mp);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectStockAuditDetailList", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectStockAuditDetailList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> list = stockAuditService.selectStockAuditLocDetail(params);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);

	}

	@RequestMapping(value = "/selectItemList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectItemList(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {

		List<EgovMap> list =  stockAuditService.selectItemList(params);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);

	}

	@RequestMapping(value = "/selectLocationList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectLocationList(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {

		List<EgovMap> list =  stockAuditService.selectLocationList(params);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);

	}

	@RequestMapping(value = "/selectStockAuditDocDtTime.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectStockAuditDocDtTime(@RequestParam Map<String, Object> params, SessionVO sessionVO) {

	    EgovMap result = stockAuditService.selectStockAuditDocDtTime(params);
	    return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/createStockAuditDoc.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> createStockAuditDoc(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

		params.put("userId", sessionVO.getUserId());

		String stockAuditNo = stockAuditService.createStockAuditDoc(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(stockAuditNo);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/startStockAudit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> startStockAudit (@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

		params.put("userId", sessionVO.getUserId());

		EgovMap movLocMap = stockAuditService.startStockAudit(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(movLocMap);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/uploadGroupwareFile.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> uploadGroupwareFile(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		logger.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				"logitics" + File.separator + "stockAudit", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		String remove = (String) params.get("deleteFileIds");

		params.put("userId", sessionVO.getUserId());
		params.put("fileGroupKey", params.get("atchFileGrpId"));

		if(list.size() > 0 &&  CommonUtils.isEmpty(params.get("atchFileGrpId"))) { // file new
			fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		} else if(list.size() > 0 || !StringUtils.isEmpty(remove)) {
			stockAuditService.updateStockAuditAttachBiz(FileVO.createList(list), FileType.WEB, params);
		}

 		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params.get("fileGroupKey"));
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveDocAppvInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveDocAppvInfo(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

		params.put("userId", sessionVO.getUserId());

		stockAuditService.saveDocAppvInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveAppv2Info.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAppv2Info(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

		params.put("userId", sessionVO.getUserId());

		stockAuditService.saveAppv2Info(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveOtherGiGr.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveOtherGiGr(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

		params.put("userId", sessionVO.getUserId());

		String reVal = stockAuditService.saveOtherGiGr(params);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("reVal", reVal);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(map);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
}
