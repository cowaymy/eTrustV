package com.coway.trust.api.mobile.common;

import java.io.File;
import java.util.List;
import java.util.Map;

import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;

import io.swagger.annotations.Api;
import springfox.documentation.annotations.ApiIgnore;

import javax.ws.rs.Consumes;

@Api(value = "파일관리", description = "file api")
@RestController(value = "MobileFileApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/file")
public class FileApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileApiController.class);

	@Value("${com.file.mobile.upload.path}")
	private String uploadDir;

	@Autowired
	private FileApplication fileApplication;

	// @Autowired
	// private MessageSourceAccessor messageAccessor;

	// sampleUpload 는 공통 파일 테이블에서 관리하는 api 입니다.
	// TODO : 파일 테이블을 업무테이블에서 관리한다면 그에 맞게 api 를 추가로 개발해야 합니다.
	@ApiOperation(value = "파일업로드(임시)", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public ResponseEntity<List<EgovFormBasedFileVo>> sampleUpload(@ApiIgnore  MultipartHttpServletRequest request,
																  @ApiIgnore  @RequestParam Map<String, Object> params, @ApiIgnore SessionVO sessionVO) throws Exception {
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				"subPath1" + File.separator + "subPath2", AppConstants.UPLOAD_MAX_FILE_SIZE);

		String param01 = (String) params.get("param01");
		LOGGER.debug("param01 : {}", param01);
		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		fileApplication.businessAttach(AppConstants.FILE_MOBILE, FileVO.createList(list), params);

		// TODO : 에러 발생시 파일 삭제 처리 예정.
		return ResponseEntity.ok(list);
	}

}
