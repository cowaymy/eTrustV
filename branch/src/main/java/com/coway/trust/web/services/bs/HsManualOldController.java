package com.coway.trust.web.services.bs;

import java.text.ParseException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.services.bs.HsManualOldService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.MemberListController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/bs")
public class HsManualOldController {
	private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);

	@Resource(name = "hsManualOldService")
	private HsManualOldService hsManualOldService;

	@RequestMapping(value = "/hsManualOld.do")
	public String hsManualOld(@RequestParam Map<String, Object> params, ModelMap model) {
		return "services/bs/hsManualOldVersion";
	}

	@RequestMapping(value = "/selectHsOldBasicList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHsOldBasicList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
		params.put("user_id", sessionVO.getUserId());
        // 조회.
		List<EgovMap> hsBasicList = hsManualOldService.selectHsOldConfigList(params);

		return ResponseEntity.ok(hsBasicList);
	}

	@RequestMapping(value = "/selectStateList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStateList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> stateList = hsManualOldService.selectStateList(params);
		return ResponseEntity.ok(stateList);
	}

	@RequestMapping(value = "/selectAreaList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAreaList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> areaList = hsManualOldService.selectAreaList(params);
		return ResponseEntity.ok(areaList);
	}

	@RequestMapping(value = "/selectHSCodyOldList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHSCodyOldList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		List<EgovMap> hsCodyList = hsManualOldService.selectHSCodyOldList(params) ;
		return ResponseEntity.ok(hsCodyList);
	}

	@RequestMapping(value = "/hsConfigBasicOldPop.do")
	public String hsConfigBasicOldPop(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
		params.put("user_id", sessionVO.getUserId());
		model.put("SALEORD_ID",(String) params.get("salesOrdId"));

        EgovMap configBasicOldInfo = hsManualOldService.selectHsOldBasicListDetail(params);

        model.put("configBasicOldInfo", configBasicOldInfo);

        return "services/bs/hsManualOldPop";
	}


	@RequestMapping(value = "/getHSConfigBasicOldInfo.do")
	public String getHSConfigBasicOldInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {

		logger.debug("params : {}", params.toString());
		params.put("orderNo", params.get("salesOrdId"));

		return "services/bs/hsManualOldPop";
	}

}



