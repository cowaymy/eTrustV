package com.coway.trust.web.services.installation;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.services.installation.InstallationReversalService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services")
public class InstallationReversalController {
	private static final Logger logger = LoggerFactory.getLogger(InstallationReversalController.class);

	@Resource(name = "installationReversalService")
	private InstallationReversalService installationReversalService;
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	/**
	 * organization transfer page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationReversal.do")
	public String installationResultList(@RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> selectReverseReason = installationReversalService.selectReverseReason();
		List<EgovMap> selectFailReason = installationReversalService.selectFailReason();



		model.addAttribute("selectReverseReason", selectReverseReason);
		model.addAttribute("selectFailReason", selectFailReason);

		return "services/installation/installationReversal";
	}

	/**
	 * Search installation reversal orderNo
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationReversalSearch", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> installationReversalListSearch(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {

//		logger.debug("orderNo : {}", params.get("orderNo"));

		List<EgovMap> orderList = installationReversalService.selectOrderList(params);
//		logger.debug("list : {}", orderList);
		return ResponseEntity.ok(orderList);
	}

	@RequestMapping(value = "/installationReversalSearchDetail" ,method = RequestMethod.POST)
	public ResponseEntity<Map>  installationReversalSearchDetail(@RequestBody Map<String, Object> params, Model model)	throws Exception {

//		logger.debug("in  installation reversal detail ");
//		logger.debug("			pram set  log");
//		logger.debug("					" + params.toString());
//		logger.debug("			pram set end  ");
//

		EgovMap  list1 = installationReversalService.installationReversalSearchDetail1(params);
		EgovMap  list2 = installationReversalService.installationReversalSearchDetail2(params);
		EgovMap  list3 = installationReversalService.installationReversalSearchDetail3(params);
		EgovMap  list4 = installationReversalService.installationReversalSearchDetail4(params);
		EgovMap  list5 = installationReversalService.installationReversalSearchDetail5(params);

//		logger.debug("list : {}", list1);


		Map<String, Object> map = new HashMap();
		map.put("list1", list1);
		map.put("list2", list2);
		map.put("list3", list3);
		map.put("list4", list4);
		map.put("list5", list5);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/saveResaval", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveResaval(@RequestBody Map<String, Object> params, Model model,SessionVO sessionVO) throws Exception {
	  installationReversalService.saveResaval2(sessionVO, params);
		ReturnMessage message = new ReturnMessage();
		message.setMessage("reversal complete");
		return ResponseEntity.ok(message);
	}

	// KR-OHK
	@RequestMapping(value = "/saveResavalSerial", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveResavalSerial(@RequestBody Map<String, Object> params, Model model,SessionVO sessionVO) throws Exception {
		logger.debug("-------------0.saveResavalSerial---------------");
		params.put("userId", sessionVO.getUserId());

		installationReversalService.saveResavalSerial(params);

		ReturnMessage message = new ReturnMessage();
		message.setMessage("reversal complete");
		return ResponseEntity.ok(message);
	}

}
