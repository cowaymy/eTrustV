package com.coway.trust.web.homecare.services.install;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import com.coway.trust.biz.homecare.services.install.HcInstallationReversalService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.services.installation.InstallationReversalService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/homecare/services")
public class HcInstallationReversalController {
	private static final Logger logger = LoggerFactory.getLogger(HcInstallationReversalController.class);

	@Resource(name = "hcInstallationReversalService")
	private HcInstallationReversalService hcInstallationReversalService;

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
	@RequestMapping(value = "/hcInstallationReversal.do")
	public String hcInstallationReversal(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		List<EgovMap> selectReverseReason = hcInstallationReversalService.selectReverseReason();
		List<EgovMap> selectFailReason = hcInstallationReversalService.selectFailReason();

		model.addAttribute("selectReverseReason", selectReverseReason);
		model.addAttribute("selectFailReason", selectFailReason);

		return "homecare/services/install/hcInstallationReversal";
	}

	/**
	 * Search installation reversal orderNo
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationReversalSearch.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> installationReversalListSearch(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) throws Exception{

		//Apply filter for ACI able to search thier own ACI order only
		int isAC = sessionVO.getIsAC();
		if(isAC == 1){
			params.put("isAC", isAC);
		}

		List<EgovMap> orderList = hcInstallationReversalService.selectOrderList(params);
//		logger.debug("list : {}", orderList);
		return ResponseEntity.ok(orderList);
	}


	@RequestMapping(value = "/installationReversalSearchDetail.do" ,method = RequestMethod.POST)
	public ResponseEntity<Map>  installationReversalSearchDetail(@RequestBody Map<String, Object> params, Model model)	throws Exception {
		EgovMap  list1 = hcInstallationReversalService.selectOrderListDetail1(params);
		EgovMap  list2 = installationReversalService.installationReversalSearchDetail2(params);
		EgovMap  list3 = installationReversalService.installationReversalSearchDetail3(params);
		EgovMap  list4 = installationReversalService.installationReversalSearchDetail4(params);
		EgovMap  list5 = installationReversalService.installationReversalSearchDetail5(params);

		//logger.debug("list : {}", list1);
		Map<String, Object> map = new HashMap();
		map.put("list1", list1);
		map.put("list2", list2);
		map.put("list3", list3);
		map.put("list4", list4);
		map.put("list5", list5);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/saveResavalSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveResavalSerial(@RequestBody Map<String, Object> params, Model model,SessionVO sessionVO) throws Exception {
		//logger.debug("-------------0.saveResavalSerial---------------");
		params.put("userId", sessionVO.getUserId());

		hcInstallationReversalService.multiResaval(params, sessionVO);

		ReturnMessage message = new ReturnMessage();
		message.setMessage("reversal complete");
		return ResponseEntity.ok(message);
	}
}
