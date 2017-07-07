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
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "샘플", description = "sample api")
@RestController
@RequestMapping(AppConstants.API_BASE_URI + "/sample")
public class SampleApiController {
	private static final Logger logger = LoggerFactory.getLogger(SampleApiController.class);

	@Resource(name = "sampleService")
	private SampleService sampleService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@ApiOperation(value = "샘플 목록 조회")
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ResponseEntity<List<SampleDto>> selectSampleList(@ModelAttribute SampleForm sampleForm,
			ModelMap model) throws Exception {
		//
		HttpSession session = sessionHandler.getCurrentSession();
		
		Precondition.checkNotNull(sampleForm.getId(), messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "ID" }));
		
		logger.debug("id : {}", sampleForm.getId());

		// 서비스 파라미터에 맞게 변환.
		SampleVO sampleVO = sampleForm.createSampleVO(sampleForm);
		Map<String, Object> params = sampleForm.createMap(sampleForm);
		
		// 서비스 호출. - parameter : VO
		List<EgovMap> sampleList = sampleService.selectSampleList(sampleVO);
		int totCnt = sampleService.selectSampleListTotCnt(sampleVO);
		
		// 서비스 호출. - parameter : Map
		List<EgovMap> sampleList2 = sampleService.selectSampleList(params);

		return ResponseEntity.ok(sampleList.stream().map(r -> SampleDto.create(r)).collect(Collectors.toList()));
	}

	@ApiOperation(value = "샘플 저장")
	@RequestMapping(value = "/saveSample.do", method = RequestMethod.POST)
	public void saveSample(@RequestBody SampleForm searchForm, Model model)
			throws Exception {

		String id = searchForm.getId();
		String name = searchForm.getName();

		logger.debug("id : {}", id);

		// 필수 체크.
		Precondition.checkNotNull(id, messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "ID" }));
		Precondition.checkNotNull(name,
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "NAME" }));


		logger.debug("id : {}", id);
		logger.debug("name : {}", name);

		// serivce DB 처리.
		// sampleService.saveSample(sampleForm.createSampleVO(sampleForm));

	}
}
