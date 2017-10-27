/**
 * 
 */
package com.coway.trust.web.sales.mambership;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.mambership.MembershipRentalStatusService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author kmo
 *
 */
@Controller
@RequestMapping(value = "/sales/membership")
public class MembershipRentalStatusController {

	private static Logger logger = LoggerFactory.getLogger(MembershipRentalStatusController.class);

	@Resource(name = "membershipRentalStatusService")
	private MembershipRentalStatusService membershipRentalStatusService;

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@RequestMapping(value = "/membershipStatusConversion.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/membership/membershipRentalStusCnvrList";
	} 
	
	@RequestMapping(value = "/selectCnvrList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectCnvrList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("in  selectCnvrList ");

		String[] rsStusId = request.getParameterValues("rsStusId");
		String[] rsCnvrStusId = request.getParameterValues("rsCnvrStusId");
		String[] rsCnvrStusFrom = request.getParameterValues("rsCnvrStusFrom");
		String[] rsCnvrStusTo = request.getParameterValues("rsCnvrStusTo");

		params.put("rsStusId", rsStusId);
		params.put("rsCnvrStusId", rsCnvrStusId);
		params.put("rsCnvrStusFrom", rsCnvrStusFrom);
		params.put("rsCnvrStusTo", rsCnvrStusTo);

		// MBRSH_ID
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipRentalStatusService.selectCnvrList(params);

	
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/membershipRentalStusCnvrNewPop.do")
	public String newStusCnvr(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/membership/membershipRentalStusCnvrNewPop";
	} 
	
	@RequestMapping(value = "/membershipRentalStusCnvrViewPop.do")
	public String viewStusCnvr(@RequestParam Map<String, Object> params, ModelMap model) {		
		return "sales/membership/membershipRentalStusCnvrViewPop";
	} 
	
	
	@RequestMapping(value = "/selectCnvrDetailList", method = RequestMethod.GET) 
	public ResponseEntity<EgovMap> selectCnvrDetailList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("in  selectCnvrDetailList ");

		logger.debug("param ===================>>  " + params);

		params.put("rsCnvrId", params.get("sRsCnvrId"));
		params.put("rsStusId", params.get("sRsStusId"));
		
		// MBRSH_ID
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		EgovMap result = new EgovMap();

		List<EgovMap> cnvrDetailList = membershipRentalStatusService.selectCnvrDetailList(params);
		EgovMap cnvrDetail = membershipRentalStatusService.selectCnvrDetail(params);
		int totalCnt = membershipRentalStatusService.selectCnvrDetailCount(params);
		
		result.put("cnvrDetailList", cnvrDetailList);
		result.put("cnvrDetail", cnvrDetail);
		result.put("totalCnt", totalCnt);
	
		return ResponseEntity.ok(result);
	}
	
}
