package com.coway.trust.web.logistics.adjustment;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.logistics.adjustment.CountStockAuditService;
import com.coway.trust.biz.logistics.adjustment.StockAuditService;
import com.coway.trust.biz.logistics.serialmgmt.SerialScanningGRService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CountStockAuditController.java
 * @Description : Count-StockAudit Controller
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
public class CountStockAuditController {

	private static final Logger logger = LoggerFactory.getLogger(CountStockAuditController.class);

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private FileApplication fileApplication;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private StockAuditService stockAuditService;

	@Resource(name = "SerialScanningGRService")
	private SerialScanningGRService serialScanningGRService;

	@Autowired
	private CountStockAuditService countStockAuditService;

	@RequestMapping(value = "/countStockAuditList.do")
	public String countStockAuditList(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVo) throws Exception {
		// Location Type/Code selection
		if(sessionVo.getUserTypeId() == 2) { 			// CODY
			params.put("locgb", "04");
		} else if(sessionVo.getUserTypeId() == 3) { // CT
			params.put("locgb", "03");
		}
		params.put("userBrnchId", sessionVo.getUserBranchId());
		String defLocType = serialScanningGRService.selectDefLocationType(params);

		model.addAttribute("defLocType", defLocType);
		params.put("locgb", defLocType);

		if("03".equals(defLocType) || "04".equals(defLocType)) {
			params.put("userName", sessionVo.getUserName());
		}
		String defLocCode = serialScanningGRService.selectDefLocationCode(params);
		model.addAttribute("defLocCode", defLocCode);

		return "logistics/adjustment/countStockAuditList";
	}

	@RequestMapping(value = "/selectCountStockAuditList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectCountStockAuditList(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {

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

		int cnt = countStockAuditService.selectCountStockAuditListCnt(params);

		if(cnt > 0){
			list =  countStockAuditService.selectCountStockAuditList(params);
			excelList =  countStockAuditService.selectCountStockAuditListExcel(params);

			mp.put("list", list);
			mp.put("excelList", excelList);
		}

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setTotal(cnt);
		result.setData(mp);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectCountStockAuditListExcel", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectCountStockAuditListExcel(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {

		ReturnMessage result = new ReturnMessage();

		List<EgovMap> list = null;

		int cnt = countStockAuditService.selectCountStockAuditListCnt(params);

		if(cnt > 0){
			list =  countStockAuditService.selectCountStockAuditListExcel(params);
		}

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setTotal(cnt);
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}


	@RequestMapping(value = "/countStockAuditRegisterPop.do")
	public String countStockAuditRegisterPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		EgovMap docInfo = countStockAuditService.selectStockAuditDocInfo(params);
		params.put("atchFileGrpId", docInfo.get("atchFileGrpId"));

		List<EgovMap> files = countStockAuditService.getAttachmentFileInfo(params);
		List<EgovMap> itemList = countStockAuditService.selectStockAuditItemList(params);

		model.addAttribute("docInfo", docInfo);
		model.addAttribute("itemList", new Gson().toJson(itemList));
		model.addAttribute("files", files);
		model.addAttribute("action", params.get("action"));
		return "logistics/adjustment/countStockAuditRegisterPop";
	}

	@RequestMapping(value = "/countStockAuditItemList.do")
	public ResponseEntity<List<EgovMap>> countStockAuditItemList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		List<EgovMap> itemList = countStockAuditService.selectStockAuditItemList(params);

		return ResponseEntity.ok(itemList);
	}

	@RequestMapping(value = "/stockAuditUploadFile.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> stockAuditUploadFile (MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

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

	@RequestMapping(value = "/saveCountStockAuditNew.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCountStockAuditNew (HttpServletRequest request, @RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception {

		params.put("userId", sessionVO.getUserId());

		countStockAuditService.saveCountStockAuditNew(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveAppvInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAppvInfo(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

		params.put("userId", sessionVO.getUserId());

		countStockAuditService.saveAppvInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectOtherReasonCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOtherReasonCodeList(@RequestParam Map<String, Object> params) {

		logger.debug("selectOtherReasonCodeList indVal : {}", params.get("indVal"));

		List<EgovMap> codeList = countStockAuditService.selectOtherReasonCodeList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectStockAuditLocDtTime.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectStockAuditLocDtTime(@RequestParam Map<String, Object> params, SessionVO sessionVO) {

	    EgovMap result = countStockAuditService.selectStockAuditLocDtTime(params);
	    return ResponseEntity.ok(result);
	}
}
