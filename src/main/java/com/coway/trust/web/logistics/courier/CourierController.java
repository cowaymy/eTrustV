package com.coway.trust.web.logistics.courier;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.courier.CourierService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/courier")
public class CourierController {

	private static final Logger logger = LoggerFactory.getLogger(CourierController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "courierService")
	private CourierService courierService;

	/**
	 * Courier List 초기 화면
	 * 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/courierList.do")
	public String CourierList(@RequestParam Map<String, Object> params, ModelMap model) {

		return "logistics/courier/courierList";

	}

	@RequestMapping(value = "/selectCourierList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectCourierList(@RequestBody Map<String, Object> params,
			ModelMap model) throws Exception {

		List<EgovMap> list = courierService.selectCourierList(params);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("data", list);
		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectCourierDetail", method = RequestMethod.GET)
	public ResponseEntity<Map> selectCourierDetail(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("courierid : {}", params.get("courierid"));
		List<EgovMap> result = courierService.selectCourierDetail(params);
		Map<String, Object> rmap = new HashMap<>();
		rmap.put("result", result);
		return ResponseEntity.ok(rmap);
	}

	@RequestMapping(value = "/motifyCourier.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> motifyCourier(@RequestBody Map<String, Object> params, ModelMap mode)
			throws Exception {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		String retMsg = AppConstants.MSG_SUCCESS;

		// loginId
		params.put("upd_user", loginId);

		Map<String, Object> map = new HashMap();

		try {
			courierService.motifyCourier(params);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/insertCourier.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertCourier(@RequestBody Map<String, Object> params, ModelMap mode)
			throws Exception {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		String retMsg = AppConstants.MSG_SUCCESS;

		// loginId
		params.put("upd_user", loginId);

		Map<String, Object> map = new HashMap();

		try {
			courierService.insertCourier(params);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/selectCourierComboList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCourierComboList(@RequestParam Map<String, Object> params,
			ModelMap model) {

		List<EgovMap> codeList = courierService.selectCourierComboList(params);
		return ResponseEntity.ok(codeList);
	}
}
