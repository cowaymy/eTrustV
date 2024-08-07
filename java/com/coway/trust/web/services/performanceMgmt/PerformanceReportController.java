package com.coway.trust.web.services.performanceMgmt;

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

import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.biz.services.performanceMgmt.PerformanceReportService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/performanceMgmt")
public class PerformanceReportController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PerformanceReportController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Resource(name = "hsManualService")
	private HsManualService hsManualService;
	
	@Resource(name = "performanceReportService")
	private PerformanceReportService performanceReportService;
	
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@RequestMapping(value = "/performanceReport.do")
	public String performanceReport(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		List<EgovMap> branchList = performanceReportService.selectBranchList(params);
		model.addAttribute("branchList", branchList);
		
		return "services/performanceMgmt/performanceReport";
	}
	
	
	
	
	
	
	
		@RequestMapping(value = "/selectPfReportRejoin.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectPfReportRejoin(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) throws Exception {

			params.put("user_id", sessionVO.getUserId());

	        // 조회.
			List<EgovMap> pfReportRejoin = performanceReportService.selectPfReportRejoin(params) ;

			return ResponseEntity.ok(pfReportRejoin);
		}
		
		
		@RequestMapping(value = "/selectPfReportCollection.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectPfReportCollection(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) throws Exception {

			params.put("user_id", sessionVO.getUserId());

	        // 조회.
			List<EgovMap> pfReportCollection = performanceReportService.selectPfReportCollection(params);

			return ResponseEntity.ok(pfReportCollection);
		}
		
		@RequestMapping(value = "/selectPfReportHeartService.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectPfReportHeartService(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) throws Exception {

			params.put("user_id", sessionVO.getUserId());

	        // 조회.
			List<EgovMap> pfReportHeartService = performanceReportService.selectPfReportHeartService(params);

			return ResponseEntity.ok(pfReportHeartService);
		}
		
		
		@RequestMapping(value = "/selectPfReportSales.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectPfReportSales(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) throws Exception {

			params.put("user_id", sessionVO.getUserId());

	        // 조회.
			List<EgovMap> pfReportSales = performanceReportService.selectPfReportSales(params);

			return ResponseEntity.ok(pfReportSales);
		}
		
	


		
		
		@RequestMapping(value = "/performanceReportCT.do")
		public String performanceReportCT(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
			List<EgovMap> branchList = hsManualService.selectBranchList(params);
			model.addAttribute("branchList", branchList);
			
			return "services/performanceMgmt/performanceReportCt";
		}
		
		
		
		
		@RequestMapping(value = "/hqDashboard.do")
		public String performanceReportHQ(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
			List<EgovMap> branchList = hsManualService.selectBranchList(params);
			model.addAttribute("branchList", branchList);
			
			return "services/performanceMgmt/performanceReportHQ";
		}		
		
		
		
		
	
}
