package com.coway.trust.web.organization.organization;

import java.util.HashMap;
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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.organization.ComplianceCallLogService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/organization/compliance")
public class ComplianceCallLogController {
	private static final Logger logger = LoggerFactory.getLogger(ComplianceCallLogController.class);
	
	@Resource(name = "complianceCallLogService")
	private ComplianceCallLogService complianceCallLogService;
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	/**
	 * Organization Compliance Call Log 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/initComplianceCallLog.do")
	public String initComplianceCallLog(@RequestParam Map<String, Object> params, ModelMap model) {

		// 호출될 화면
		return "organization/organization/complianceCallLog";
	}
	
	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/complianceCallLog.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectComplianceLog(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		String[] caseStatusList = request.getParameterValues("caseStatus");
		params.put("caseStatusList", caseStatusList);
		List<EgovMap> complianceList = complianceCallLogService.selectComplianceLog(params);
		logger.debug("complianceList : {}",complianceList);
		return ResponseEntity.ok(complianceList);
	}
	
	/**
	 * Organization Compliance Call Log new 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/complianceCallLogNewPop.do")
	public String complianceCallLogNewPop(@RequestParam Map<String, Object> params, ModelMap model) {

		// 호출될 화면
		return "organization/organization/complianceCallLogNewPop";
	}
	
	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getMemberDetail.do", method = RequestMethod.GET)
	public ResponseEntity <Map<String, EgovMap>> gettMemberDetail(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		EgovMap complianceMemDetail = complianceCallLogService.getMemberDetail(params);
		logger.debug("complianceList : {}",complianceMemDetail);
		Map<String, EgovMap> resultList = new HashMap<String, EgovMap>();
		resultList.put("complianceMemDetail",complianceMemDetail);
		return ResponseEntity.ok(resultList);
	}
	
	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveCompliance.do", method = RequestMethod.POST)
	public ResponseEntity <ReturnMessage> insertCompliance(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVo) {
		
		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		//Map<String , Object> formMap1 = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<EgovMap> insList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ALL);
		/*List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);*/
		
		logger.debug("insList : {}",insList);
		/*logger.debug("updList : {}",updList);
		logger.debug("remList : {}",remList);*/
		
		complianceCallLogService.insertCompliance(formMap,sessionVo,insList);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getCheckOrderNo.do", method = RequestMethod.GET)
	public ResponseEntity <EgovMap> getCheckOrderNo(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		EgovMap checkOrder = complianceCallLogService.selectCheckOrder(params);
		logger.debug("checkOrder : {}",checkOrder);
		return ResponseEntity.ok(checkOrder);
	}
	
	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getComplianceOrderDetail.do", method = RequestMethod.GET)
	public ResponseEntity <EgovMap> getComplianceOrderDetail(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		EgovMap orderDetailGrid = complianceCallLogService.selectComplianceOrderDetail(params);
		logger.debug("orderDetail : {}",orderDetailGrid);
		return ResponseEntity.ok(orderDetailGrid);
	}
	
	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/complianceOrderFullDetailPop.do", method = {RequestMethod.POST,RequestMethod.GET})
	public String complianceOrderFullDetail(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) throws Exception {
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params ,sessionVO);
		
		logger.debug("orderDetail : {}",orderDetail);
		model.addAttribute("orderDetail", orderDetail);
		return "organization/organization/complianceOrderFullDetailPop";
	}
	
	
	
}
