package com.coway.trust.api.sample;

import java.util.ArrayList;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.Precondition;
import com.coway.trust.web.sample.SampleRegForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
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
	public ResponseEntity<List<SampleDto>> selectSampleList(@ModelAttribute("searchVO") SampleDefaultVO searchVO,
			@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		//
		HttpSession session = sessionHandler.getCurrentSession();

		String param01 = (String) params.get("param01");
		logger.debug("param01 : {}", param01);

		/** pageing setting */
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());
		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		List<EgovMap> sampleList = sampleService.selectSampleList(searchVO);
		int totCnt = sampleService.selectSampleListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		return ResponseEntity.ok(sampleList.stream().map(r -> SampleDto.create(r)).collect(Collectors.toList()));
	}

	@ApiOperation(value = "샘플 저장")
	@RequestMapping(value = "/saveSample.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> saveSample(@RequestBody SampleRegForm searchForm, Model model)
			throws Exception {

		String id = searchForm.getId();
		String name = searchForm.getName();
		String description = searchForm.getDescription();
		int seq = searchForm.getSeq();

		logger.debug("id : {}", id);

		// eTRUST 에서는 DB에 의해 관리할 예정임.
		Precondition.checkNotNull(id, messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "ID" }));
		Precondition.checkNotNull(name,
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "NAME" }));

		// Precondition.checkNotNull(id, "id은 필수 항목입니다.");
		// Precondition.checkNotNull(name, "name은 필수 항목입니다.");
		// Precondition.checkArgument(seq > 0, "seq은 필수 입력값입니다.");

		logger.debug("id : {}", id);
		logger.debug("name : {}", name);
		logger.debug("description : {}", description);

		// serivce DB 처리.

		Map<String, Object> ret = new HashMap<>();
		ret.put("id", id);
		ret.put("name", name);
		ret.put("description", description);
		ret.put("seq", seq);

		List list = new ArrayList<Map<String, Object>>();
		list.add(ret);
		list.add(ret);
		list.add(ret);
		list.add(ret);

		Map<String, Object> retForList = new HashMap<>();

		retForList.put("param01", "param01");
		retForList.put("param02", "param02");
		retForList.put("data", list);

		return ResponseEntity.ok(retForList);
	}
}
