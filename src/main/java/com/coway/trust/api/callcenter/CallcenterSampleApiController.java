package com.coway.trust.api.callcenter;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.sample.SampleDto;
import com.coway.trust.api.sample.SampleForm;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.model.DisplayPagination;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "콜센터 샘플", description = "sample api")
@RestController
@RequestMapping(AppConstants.CALL_CENTER_API_BASE_URI + "/sample")
public class CallcenterSampleApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CallcenterSampleApiController.class);

	@Resource(name = "sampleService")
	private SampleService sampleService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@ApiOperation(value = "콜센터 샘플 목록 조회")
	@RequestMapping(value = "/contents", method = RequestMethod.GET)
	public ResponseEntity<DisplayPagination<SampleDto>> selectSampleList(@ModelAttribute SampleForm sampleForm,
			ModelMap model) throws Exception {
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

}
