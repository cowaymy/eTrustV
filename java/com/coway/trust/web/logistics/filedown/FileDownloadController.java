package com.coway.trust.web.logistics.filedown;

import java.io.File;
import java.io.FileFilter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.logistics.filedown.FileDownloadService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/file")
public class FileDownloadController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;
	@Value("${web.resource.upload.file}")
	private String uploadDirWeb;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "FileDownloadService")
	private FileDownloadService FileDownloadService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private FileApplication fileApplication;

	@RequestMapping(value = "/FileDownload.do")
	public String filedownload(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/FileDown/fileDownloadList";
	}

	@RequestMapping(value = "/FileRawData.do")
	public String filerawdata(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/FileDown/fileDownloadRowData";
	}

   @RequestMapping(value = "/DataMart.do")
    public String datamart(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        return "logistics/FileDown/fileDownloadDataMart";
    }
 //BI Enhancement
	@RequestMapping(value = "/fileDownloadList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> fileDownloadList(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String[] searchFileType = request.getParameterValues("searchFileType");
		String searchTypeLabel = request.getParameter("searchTypeLabel");
		String searchFilename = request.getParameter("searchFilename");

		logger.debug("searchFileType    값 : {}", searchFileType);
		logger.debug("searchTypeLabel    값 : {}", searchTypeLabel);
		logger.debug("searchFilename    값 : {}", searchFilename);

		Map<String, Object> smap = new HashMap();

		smap.put("searchFileType", searchFileType);
		smap.put("searchTypeLabel", searchTypeLabel);
		smap.put("searchFilename", searchFilename);

		List<EgovMap> list = FileDownloadService.fileDownloadList(smap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectLabelList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTypeList(@RequestParam Map<String, Object> params) {

		List<EgovMap> LabelList = FileDownloadService.selectLabelList(params);
		return ResponseEntity.ok(LabelList);
	}

	@RequestMapping(value = "/insertFileSpace.do", method = RequestMethod.POST)
	// public ResponseEntity<ReturnMessage> insertFileSpace(MultipartHttpServletRequest request,
	public ResponseEntity<Map<String, Object>> insertFileSpace(@RequestBody Map<String, Object> params, ModelMap mode,
			SessionVO sessionVO) throws Exception {

		int re = 0;
		String TypeLabel = (String) params.get("insTypeLabel");

		if (TypeLabel.equals("E")) {
			TypeLabel = (String) params.get("insExistingLabel");
		} else {
			TypeLabel = (String) params.get("insNewLabel");
		}

		params.put("insStaff", params.get("insStaff") != null ? 1 : 0);
		params.put("insCody", params.get("insCody") != null ? 1 : 0);
		params.put("insHP", params.get("insHP") != null ? 1 : 0);
		params.put("insHT", params.get("insHT") != null ? 1 : 0);
		params.put("TypeLabel", TypeLabel);

		int loginId = sessionVO.getUserId();

		params.put("crt_user_id", loginId);
		params.put("upd_user_id", loginId);

		int cnt = FileDownloadService.existFileCheck(params);
		ReturnMessage message = new ReturnMessage();
		if (1 > cnt) {
			re = FileDownloadService.insertFileSpace(params);
			message.setCode(AppConstants.SUCCESS);
		}
		Map<String, Object> reVal = new HashMap();
		reVal.put("re", re);
		reVal.put("cnt", cnt);
		reVal.put("msg", message);
		return ResponseEntity.ok(reVal);
	}

	@RequestMapping(value = "/deleteFileSpace.do", method = RequestMethod.POST)
	// public ResponseEntity<ReturnMessage> insertFileSpace(MultipartHttpServletRequest request,
	public ResponseEntity<ReturnMessage> deleteFileSpace(@RequestBody Map<String, Object> params, ModelMap mode,
			SessionVO sessionVO) throws Exception {
		int loginId = sessionVO.getUserId();

		params.put("upd_user_id", loginId);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		FileDownloadService.deleteFileSpace(params);

		return ResponseEntity.ok(message);
	}

	/**
	 * 공통 파일 테이블 사용 Upload를 처리한다.
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertFile.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovFormBasedFileVo>> insertFile(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDirWeb, "FileUpload",
				1024 * 1024 * 5);

		String upId = (String) params.get("upId");
		logger.debug("upId : {}", upId);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		int fileGroupKey = fileApplication.commonAttachByUserId(FileType.WEB, FileVO.createList(list), params);
		logger.debug("fileGroupKey : {}", fileGroupKey);
		params.put("fileGroupKey", fileGroupKey);
		logger.debug("params : {}", params);
		FileDownloadService.updateFileGroupKey(params);
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/checkDirectory.do", method = RequestMethod.GET)
	public ResponseEntity<List<Map>> checkDirectory(@RequestParam Map<String, Object> params) {

		String last = "";
		if ("PB".equals(params.get("groupCode"))) {
			last += "Public";
		} else if ("BI".equals(params.get("groupCode"))) {
            last += "BizIntel";
        } else {
			last += "Privacy";
		}

		// String path = uploadDir + "/RawData/" + last;
		String path = uploadDirWeb + "/RawData/" + last;

		File directory = new File(path);

		logger.debug("directory    값 : {}", directory);

		FileFilter directoryFileFilter = new FileFilter() {
			@Override
			public boolean accept(File file) {
				return file.isDirectory();
			}
		};


		File[] directoryListAsFile = directory.listFiles(directoryFileFilter);


		List<String> foldersInDirectory = new ArrayList<String>(directoryListAsFile.length);
		for (File directoryAsFile : directoryListAsFile) {
			foldersInDirectory.add(directoryAsFile.getName());
		}

		Collections.sort(foldersInDirectory);


		List<Map> list = new ArrayList<>();
		for (int i = 0; i < foldersInDirectory.size(); i++) {
			Map<String, Object> rtn = new HashMap();
			rtn.put("codeId", foldersInDirectory.get(i));
			rtn.put("codeName", foldersInDirectory.get(i));

			list.add(rtn);

		}
		logger.debug("foldersInDirectory23    값 : {}", foldersInDirectory);
		logger.debug("list    값 : {}", list);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/rawdataList.do", method = RequestMethod.GET)
	public ResponseEntity<List<Map>> rawdataList(@RequestParam Map<String, Object> params) throws Exception {

		logger.debug("groupCode : {}", params);
		// String path = uploadDir + "/RawData/" + params.get("type");
		String path = uploadDirWeb + "/RawData/" + params.get("type");
		File dirFile = new File(path);
		File[] fileList = dirFile.listFiles();
		List<Map> list = new ArrayList<>();
		for (File tempFile : fileList) {
			if (tempFile.isFile()) {
				Map<String, Object> rtn = new HashMap();
				String tempPath = tempFile.getParent();
				String tempFileName = tempFile.getName();
				logger.debug("tempPath : {}", tempPath);
				logger.debug("tempFileName : {}", tempFileName);
				File f = new File(tempPath, tempFileName);
				Date made = new Date(f.lastModified());
				Long length = f.length();
				logger.debug("made : {}", made);
				logger.debug("length : {}", length);

				rtn.put("orignlfilenm", tempFileName);
				rtn.put("updDt", made);
				rtn.put("filesize", length);
				rtn.put("subpath", tempPath);
				list.add(rtn);
			}

		}

		logger.debug("rtn : {}", list);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/checkDirectoryDataMart.do", method = RequestMethod.GET)
	public ResponseEntity<List<Map>> checkDirectoryDataMart(@RequestParam Map<String, Object> params) {
		// String path = uploadDir + "/RawData/" + last;
		String path = uploadDirWeb + "/DataMart";

		File directory = new File(path);

		logger.debug("directory    값 : {}", directory);

		FileFilter directoryFileFilter = new FileFilter() {
			@Override
			public boolean accept(File file) {
				return file.isDirectory();
			}
		};


		File[] directoryListAsFile = directory.listFiles(directoryFileFilter);

		List<Map> list = new ArrayList<>();
		if(directoryListAsFile == null){
			return ResponseEntity.ok(list);
		}
		List<String> foldersInDirectory = new ArrayList<String>(directoryListAsFile.length);
		for (File directoryAsFile : directoryListAsFile) {
			foldersInDirectory.add(directoryAsFile.getName());
		}

		Collections.sort(foldersInDirectory);

		for (int i = 0; i < foldersInDirectory.size(); i++) {
			Map<String, Object> rtn = new HashMap();
			rtn.put("codeId", foldersInDirectory.get(i));
			rtn.put("codeName", foldersInDirectory.get(i));

			list.add(rtn);

		}
		logger.debug("foldersInDirectory23    값 : {}", foldersInDirectory);
		logger.debug("list    값 : {}", list);

		return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/dataMartList.do", method = RequestMethod.GET)
	public ResponseEntity<List<Map>> dataMartList(@RequestParam Map<String, Object> params) throws Exception {

		logger.debug("groupCode : {}", params);
		// String path = uploadDir + "/RawData/" + params.get("type");
		String path = uploadDirWeb + "/DataMart/" + params.get("type");
		File dirFile = new File(path);
		File[] fileList = dirFile.listFiles();
		List<Map> list = new ArrayList<>();
		for (File tempFile : fileList) {
			if (tempFile.isFile()) {
				Map<String, Object> rtn = new HashMap();
				String tempPath = tempFile.getParent();
				String tempFileName = tempFile.getName();
				logger.debug("tempPath : {}", tempPath);
				logger.debug("tempFileName : {}", tempFileName);
				File f = new File(tempPath, tempFileName);
				Date made = new Date(f.lastModified());
				Long length = f.length();
				logger.debug("made : {}", made);
				logger.debug("length : {}", length);

				rtn.put("orignlfilenm", tempFileName);
				rtn.put("updDt", made);
				rtn.put("filesize", length);
				rtn.put("subpath", tempPath);
				list.add(rtn);
			}

		}

		logger.debug("rtn : {}", list);

		return ResponseEntity.ok(list);
	}
}
