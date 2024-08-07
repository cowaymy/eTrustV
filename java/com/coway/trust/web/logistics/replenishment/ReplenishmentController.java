/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.web.logistics.replenishment;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.replenishment.ReplenishmentService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/replenishment")
public class ReplenishmentController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "ReplenishmentService")
	private ReplenishmentService replenishment;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/replenishment.do")
	public String list(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/replenishment/replenishment";
	}

	@RequestMapping(value = "/replenishmentRdc.do")
	public String list2(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/replenishment/replenishmentRdc";
	}

	@RequestMapping(value = "/replenishmentct.do")
	public String ctlist(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/replenishment/replenishmentCT";
	}

	@RequestMapping(value = "/replenishmentcd.do")
	public String cdlist(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/replenishment/replenishmentCODY";
	}

	@RequestMapping(value = "/replenishmentMDsc.do")
	public String dsc(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/replenishment/replenishmentMDsc";
	}

	@RequestMapping(value = "/exceldata.do", method = RequestMethod.GET)
	public ResponseEntity<Map> excelDataSearch(@RequestParam Map<String, Object> params, Model model) throws Exception {

		logger.debug(":: {}", params);

		Map<String, Object> list = replenishment.excelDataSearch(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/relenishmentSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> relenishmentSave(@RequestBody Map<String, Object> params, Model model)
			throws Exception {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		replenishment.relenishmentSave(params, sessionVO.getUserId());

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/relenishmentSaveMsCt.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> relenishmentSaveMsCt(@RequestBody Map<String, Object> params, Model model)
			throws Exception {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		replenishment.relenishmentSaveMsCt(params, sessionVO.getUserId());

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/relenishmentPopSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> relenishmentPopSave(@RequestBody Map<String, Object> params, Model model)
			throws Exception {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		replenishment.relenishmentPopSave(params, sessionVO.getUserId());

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/searchList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> searchList(@RequestBody Map<String, Object> params, Model model) throws Exception {

		logger.debug(":: {}", params);

		List<EgovMap> list = replenishment.searchList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/searchListMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> searchListMaster(@RequestBody Map<String, Object> params, Model model)
			throws Exception {

		logger.debug(":: {}", params);

		List<EgovMap> list = replenishment.searchListMaster(params);

		ReturnMessage message = new ReturnMessage();
		message.setData(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/searchListMasterDsc.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> searchListMasterDsc(@RequestBody Map<String, Object> params, Model model)
			throws Exception {

		logger.debug(":: {}", params);

		List<EgovMap> list = replenishment.searchListMasterDsc(params);

		ReturnMessage message = new ReturnMessage();
		message.setData(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/searchListRdc.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> searchListRdc(@RequestBody Map<String, Object> params, Model model)
			throws Exception {

		logger.debug(":: {}", params);

		List<EgovMap> list = replenishment.searchListRdc(params);

		ReturnMessage message = new ReturnMessage();
		message.setData(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/PopCheck.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> PopCheck(@RequestBody Map<String, Object> params, Model model)
			throws Exception {

		logger.debug(":: {}", params);

		List<EgovMap> list = replenishment.PopCheck(params);

		ReturnMessage message = new ReturnMessage();
		message.setData(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/searchAutoCTList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> searchAutoCTList(@RequestBody Map<String, Object> params, Model model) throws Exception {

		logger.debug(":: {}", params);

		List<EgovMap> list = replenishment.searchAutoCTList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/relenishmentSaveCt.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> relenishmentSaveCt(@RequestBody Map<String, Object> params, Model model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();

		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		logger.debug("insList {}", insList);

		Map<String, Object> param = new HashMap();
		param.put("add", insList);
		param.put("userId", loginId);
		// String reqNo = replenishment.relenishmentSaveCt(param);
		replenishment.relenishmentSaveCt(param);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		// message.setData(reqNo);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/relenishmentSaveRdc.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> relenishmentSaveRdc(@RequestBody Map<String, Object> params, Model model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();

		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		logger.debug("insList {}", insList);
		
		Map<String, Object> param = new HashMap();
		param.put("add", insList);
		param.put("userId", loginId);
		// String reqNo = replenishment.relenishmentSaveCt(param);
		replenishment.relenishmentSaveRdc(param);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		// message.setData(reqNo);

		return ResponseEntity.ok(message);
	}
}
