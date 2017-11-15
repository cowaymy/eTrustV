package com.coway.trust.web.common;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.MainNoticeService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class MainNoticeController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MainNoticeController.class);

	@Autowired
	private MainNoticeService mainNoticeService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/selectDailyCount.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDailyCount(@RequestParam Map<String, Object> params) {
		List<EgovMap> selectDailyCountList = mainNoticeService.selectDailyCount(params);

		LOGGER.debug("return_Values: " + selectDailyCountList.toString());

		return ResponseEntity.ok(selectDailyCountList);
	}


	@RequestMapping(value = "/getMainNotice.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getMainNotice(@RequestParam Map<String, Object> params) {
		List<EgovMap> notice = mainNoticeService.getMainNotice(params);
		return ResponseEntity.ok(notice);
	}

}
