package com.coway.trust.api.callcenter.common;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.util.EgovFormBasedFileVo;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import springfox.documentation.annotations.ApiIgnore;

@Api(value = "파일관리", description = "file api")
@RestController(value = "CallcenterFileApiController")
@RequestMapping(AppConstants.CALL_CENTER_API_BASE_URI + "/file")
public class FileApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileApiController.class);

	@Value("${com.file.callcenter.upload.path}")
	private String uploadDir;

	@Autowired
	private FileApplication fileApplication;

	// 공통 파일 테이블에서 관리하는 api 입니다.
	// TODO : 파일 테이블을 업무테이블에서 관리한다면 그에 맞게 api 를 추가로 개발해야 합니다.
	@ApiOperation(value = "파일업로드", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public ResponseEntity<FileDto> fileUpload(@ApiIgnore MultipartHttpServletRequest request,
			@ModelAttribute FileForm fileForm) throws Exception {
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, fileForm.getSubPath(),
				AppConstants.UPLOAD_MAX_FILE_SIZE);

		Map<String, Object> params = fileForm.createMap(fileForm);

		LOGGER.debug("param01 : {}", params.get(""));
		LOGGER.debug("list.size : {}", list.size());

		// serivce 에서 파일정보를 가지고, DB 처리.
		int fileGroupKey = fileApplication.commonAttach(AppConstants.FILE_CALL_CENTER, FileVO.createList(list), params);
		FileDto fileDto = FileDto.create(list, fileGroupKey);
		return ResponseEntity.ok(fileDto);
	}

}
