package com.coway.trust.web.common;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.GSTZeroRateLocationService;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class GSTZeroRateLocationController {

	private static final Logger LOGGER = LoggerFactory.getLogger(GSTZeroRateLocationController.class);

	@Autowired
	private GSTZeroRateLocationService gstZeroRateLocationService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/gstZeroRateLocation.do")
	public String getStateCodeList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		return "/common/gstZeroRateLocation";
	}

	@RequestMapping(value = "/getStateCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectJsonSampleList(@RequestParam Map<String, Object> params) {
		Precondition.checkNotNull(params.get("stusCodeId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "stusCodeId" }));

		LOGGER.debug("stusCodeId : {}", params.get("stusCodeId"));

		List<EgovMap> stateCodeList = gstZeroRateLocationService.getStateCodeList(params);
		return ResponseEntity.ok(stateCodeList);
	}

	@RequestMapping(value = "/getSubAreaList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getSubAreaList(@RequestParam Map<String, Object> params) {
		Precondition.checkNotNull(params.get("areaStusId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "areaStusId" }));
		Precondition.checkNotNull(params.get("areaStateId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "areaStateId" }));

		LOGGER.debug("areaStusId : {}", params.get("areaStusId"));
		LOGGER.debug("areaStateId : {}", params.get("areaStateId"));

		List<EgovMap> subAreaList = gstZeroRateLocationService.getSubAreaList(params);
		return ResponseEntity.ok(subAreaList);
	}

	@RequestMapping(value = "/getZRLocationList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getZRLocationList(@RequestParam Map<String, Object> params) {

		LOGGER.debug("zrLocId : {}", params.get("zrLocId"));
		LOGGER.debug("zrLocStusId : {}", params.get("zrLocStusId"));
		LOGGER.debug("zrLocStateId : {}", params.get("zrLocStateId"));
		LOGGER.debug("areaId : {}", params.get("areaId"));
		LOGGER.debug("postCode : {}", params.get("postCode"));

		List<EgovMap> zrLocationList = gstZeroRateLocationService.getZRLocationList(params);
		return ResponseEntity.ok(zrLocationList);
	}
}
