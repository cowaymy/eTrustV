package com.coway.trust.api.mobile;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.coway.trust.AppConstants;
import com.coway.trust.api.sample.SampleDto;
import com.coway.trust.api.sample.SampleForm;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "모바일 샘플", description = "sample api")
@RestController
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/sample")
public class MobileSampleApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MobileSampleApiController.class);

	@Resource(name = "sampleService")
	private SampleService sampleService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@ApiOperation(value = "모바일 샘플 조회")
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
