package com.coway.trust.api.common;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.util.EgovFormBasedFileVo;

import io.swagger.annotations.Api;

@Api(value = "파일관리", description = "file api")
@RestController
@RequestMapping(AppConstants.API_BASE_URI + "/file")
public class FileApiController {
	private static final Logger logger = LoggerFactory.getLogger(FileApiController.class);

	@Value("${com.file.mobile.upload.path}")
	private String uploadDir;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	// TODO : 업무별 어떻게 처리 및 관리를 해야 할 것인지 설계 필요.
	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public ResponseEntity<List<EgovFormBasedFileVo>> sampleUpload(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model) throws Exception {
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				"subPath1" + File.separator + "subPath2", AppConstants.UPLOAD_MAX_FILE_SIZE);

		String param01 = (String) params.get("param01");
		logger.debug("param01 : {}", param01);
		logger.debug("list.size : {}", list.size());
		// serivce 에서 파일정보를 가지고, DB 처리.
		// TODO : 에러 발생시 파일 삭제 처리 예정.
		return ResponseEntity.ok(list);
	}

}
