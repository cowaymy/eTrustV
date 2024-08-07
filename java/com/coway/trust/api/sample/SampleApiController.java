package com.coway.trust.api.sample;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.model.DisplayPagination;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "샘플", description = "sample api")
@RestController
@RequestMapping(AppConstants.API_BASE_URI + "/sample")
public class SampleApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(SampleApiController.class);

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "sampleService")
	private SampleService sampleService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@ApiOperation(value = "샘플 공통코드 목록 조회(page)", produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/codes", method = RequestMethod.GET)
	public ResponseEntity<DisplayPagination<CommonCodeDto>> getCommonCodesPage(
			@ModelAttribute CommonCodePageForm commonCodePageForm) throws Exception {

		LOGGER.debug("MasterCodeId : {}", commonCodePageForm.getCodeMasterId());
		LOGGER.debug("PageNo : {}", commonCodePageForm.getPageNo());
		LOGGER.debug("ContentSize : {}", commonCodePageForm.getContentSize());

		Map<String, Object> params = commonCodePageForm.createMap(commonCodePageForm);

		List<EgovMap> commonCodes = commonService.getCommonCodesPage(params);
		List<CommonCodeDto> list = commonCodes.stream().map(r -> CommonCodeDto.create(r)).collect(Collectors.toList());

		int totCnt = commonService.getCommonCodeTotalCount(params);
		DisplayPagination<CommonCodeDto> dto = DisplayPagination.create(commonCodePageForm.getPageNo(), totCnt, list);

		return ResponseEntity.ok(dto);
	}

	@ApiOperation(value = "샘플 목록 조회", produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/contents", method = RequestMethod.GET)
	public ResponseEntity<DisplayPagination<SampleDto>> selectSampleList(@ModelAttribute SampleForm sampleForm,
			ModelMap model) throws Exception {
		//
		HttpSession session = sessionHandler.getCurrentSession();

		Precondition.checkNotNull(sampleForm.getUserId(),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "ID" }));

		LOGGER.debug("userId : {}", sampleForm.getUserId());

		// 서비스 파라미터에 맞게 변환.
		SampleVO sampleVO = sampleForm.createSampleVO(sampleForm);
		Map<String, Object> params = sampleForm.createMap(sampleForm);

		// 서비스 호출. - parameter : VO
		List<EgovMap> sampleList = sampleService.selectSampleList(sampleVO);

		// 서비스 호출. - parameter : Map
		List<EgovMap> sampleList2 = sampleService.selectSampleList(params);

		int totCnt = sampleService.selectSampleListTotCnt(sampleVO);

		List<SampleDto> list = sampleList.stream().map(r -> SampleDto.create(r)).collect(Collectors.toList());

		DisplayPagination<SampleDto> dto = DisplayPagination.create(sampleForm.getPageNo(), totCnt, list);
		return ResponseEntity.ok(dto);
	}

	@ApiOperation(value = "샘플 저장", produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/contents", method = RequestMethod.POST)
	public void saveSample(@RequestBody SampleForm regForm, Model model) throws Exception {

		String userId = regForm.getUserId();
		String name = regForm.getName();

		LOGGER.debug("id : {}", userId);

		// 필수 체크.
		Precondition.checkNotNull(userId,
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "USER ID" }));
		Precondition.checkNotNull(name,
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "NAME" }));

		LOGGER.debug("id : {}", userId);
		LOGGER.debug("name : {}", name);

		// serivce DB 처리.
		// sampleService.saveSample(sampleForm.createSampleVO(sampleForm));

	}

	@ApiOperation(value = "샘플 조회")
	@RequestMapping(value = "/contents/{id}", method = RequestMethod.GET)
	public ResponseEntity<SampleDto> selectSample(@ModelAttribute SampleForm sampleForm, @PathVariable int id,
			ModelMap model) throws Exception {

		LOGGER.debug("@PathVariable id : {}", id);
		LOGGER.debug("userId : {}", sampleForm.getUserId());

		// 서비스 파라미터에 맞게 변환.
		Map<String, Object> params = sampleForm.createMap(sampleForm);

		// 서비스 호출. - parameter : Map
		EgovMap sample = sampleService.selectSample(params);
		SampleDto dto = SampleDto.create(sample);

		return ResponseEntity.ok(dto);
	}

}
