package com.coway.trust.web.logistics.file;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.file.FileDownloadService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/file")
public class FileDownloadController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "FileDownloadService")
	private FileDownloadService FileDownloadService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;
	
	@RequestMapping(value = "/FileDownload.do")
	public String filedownload(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/File/fileDownloadList";
	}
	
	@RequestMapping(value = "/fileDownloadList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> fileDownloadList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
	
		String[] searchFileType = request.getParameterValues("searchFileType");
		String searchTypeLabel = request.getParameter("searchTypeLabel");
		String searchFilename = request.getParameter("searchFilename");
	
	
	logger.debug("searchFileType    값 : {}",searchFileType);
	logger.debug("searchTypeLabel    값 : {}",searchTypeLabel);
	logger.debug("searchFilename    값 : {}", searchFilename);


	Map<String, Object> smap = new HashMap();
	
	smap.put("searchFileType", searchFileType);
	smap.put("searchTypeLabel", searchTypeLabel);
	smap.put("searchFilename", searchFilename);

	

	List<EgovMap> list = FileDownloadService.fileDownloadList(smap);
	
	for (int i = 0; i < list.size(); i++) {
		logger.debug("fileDownloadList       값 : {}",list.get(i));
	}
	
	Map<String, Object> map = new HashMap();
	map.put("data", list);

	return ResponseEntity.ok(map);
}
	
	@RequestMapping(value = "/selectLabelList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTypeList(@RequestParam Map<String, Object> params) {
		

		List<EgovMap> LabelList = FileDownloadService.selectLabelList(params);
		for (int i = 0; i < LabelList.size(); i++) {
			logger.debug("%%%%%%%%LabelList%%%%%%%: {}", LabelList.get(i));
		}
		return ResponseEntity.ok(LabelList);
	}
	
			
	@RequestMapping(value = "/insertFileSpace.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertFileSpace(@RequestBody Map<String, Object> params, ModelMap mode) throws Exception {	
		
		String TypeLabel = (String) params.get("insTypeLabel");
		
		if(TypeLabel.equals("E")){
			TypeLabel = (String) params.get("insExistingLabel");
		}else{
			TypeLabel = (String) params.get("insNewLabel");
		}
		
		
		logger.debug("TypeLabel @@@@@@@@@  : {}", TypeLabel);
		
		params.put("insStaff", params.get("insStaff") != null ? 1 : 0);
		params.put("insCody", params.get("insCody") != null ? 1 : 0);
		params.put("insHP", params.get("insHP") != null ? 1 : 0);
		params.put("TypeLabel", TypeLabel);
		
//		logger.debug("insExistingLabel  : {}", params.get("insExistingLabel"));
//		logger.debug("insNewLabel  : {}", params.get("insNewLabel"));
		logger.debug("insType  : {}", params.get("insType"));
		logger.debug("insFileNm  : {}", params.get("insFileNm"));
		logger.debug("insTypeLabel  : {}", params.get("insTypeLabel"));
		logger.debug("insStaff  : {}", params.get("insStaff"));
		logger.debug("insCody  : {}", params.get("insCody"));
		logger.debug("insHP  : {}", params.get("insHP"));
			

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		String retMsg = AppConstants.MSG_SUCCESS;
		
		Map<String, Object> map = new HashMap();
		
		params.put("crt_user_id", loginId);
		params.put("upd_user_id", loginId);
		
		try {
			//FileDownloadService.insertFileSpace(params,loginId);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}
	
	
	
	
	
	
	
	
}
