package com.coway.trust.api.callcenter.common;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.type.FileType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.util.EgovFormBasedFileVo;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import springfox.documentation.annotations.ApiIgnore;

@Api(value = "filemanagement", description = "file api")
@RestController(value = "CallcenterFileApiController")
@RequestMapping(AppConstants.CALL_CENTER_API_BASE_URI + "/file")
public class FileApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileApiController.class);

	@Value("${com.file.callcenter.upload.path}")
	private String uploadDir;

	@Autowired
	private FileApplication fileApplication;

	@Autowired
	private FileService fileService;

	// 공통 파일 테이블에서 관리하는 api 입니다.
	@ApiOperation(value = "FileUpload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public ResponseEntity<FileDto> fileUpload(@ApiIgnore MultipartHttpServletRequest request,
			@ModelAttribute FileForm fileForm) throws Exception {
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, fileForm.getSubPath(),
				AppConstants.UPLOAD_MAX_FILE_SIZE);

		Map<String, Object> params = fileForm.createMap(fileForm);

		LOGGER.debug("param01 : {}", params.get(""));
		LOGGER.debug("list.size : {}", list.size());

		int fileGroupKey = fileApplication.commonAttachByUserId(FileType.CALL_CENTER, FileVO.createList(list), params);
		FileDto fileDto = FileDto.create(list, fileGroupKey);
		return ResponseEntity.ok(fileDto);
	}

	@ApiOperation(value = "FileSearch", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/{fileGroupId}/files", method = RequestMethod.GET)
	public ResponseEntity<FileDto> getFilesByGroupId(
			@ApiParam(value = "파일 그룹 아이디", required = true) @PathVariable int fileGroupId) throws Exception {
		List<FileVO> list = fileService.getFiles(fileGroupId);
		FileDto fileDto = FileDto.createByFileVO(list, fileGroupId);
		return ResponseEntity.ok(fileDto);
	}
}
