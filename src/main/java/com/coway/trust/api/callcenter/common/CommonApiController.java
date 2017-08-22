package com.coway.trust.api.callcenter.common;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

@Api(value = "공통 api", description = "공통 api")
@RestController(value = "CallCenterCommonController")
@RequestMapping(AppConstants.CALL_CENTER_API_BASE_URI + "/common")
public class CommonApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonApiController.class);

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@ApiOperation(value = "공통코드 전체 목록 조회", produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/codes", method = RequestMethod.GET)
	public ResponseEntity<List<CommonCodeDto>> getCommonCodesPage(@ModelAttribute CommonCodeAllForm commonCodeAllForm)
			throws Exception {

		Map<String, Object> params = commonCodeAllForm.createMap(commonCodeAllForm);

		List<EgovMap> commonCodes = commonService.getAllCommonCodes(params);
		List<CommonCodeDto> list = commonCodes.stream().map(r -> CommonCodeDto.create(r)).collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "공통코드 목록 조회", produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/{codeMasterId}/codes", method = RequestMethod.GET)
	public ResponseEntity<List<CommonCodeDto>> getCommonCodes(
			@ApiParam(value = "코드 마스터 아이디", required = true) @PathVariable int codeMasterId,
			@ModelAttribute CommonCodeForm commonCodeForm) throws Exception {

		LOGGER.debug("MasterCodeId : {}", codeMasterId);
		LOGGER.debug("codeDisab : {}", commonCodeForm.getCodeDisab());

		Map<String, Object> params = CommonCodeForm.createMap(commonCodeForm, codeMasterId);

		List<EgovMap> commonCodes = commonService.getCommonCodes(params);
		List<CommonCodeDto> list = commonCodes.stream().map(r -> CommonCodeDto.create(r)).collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
}
