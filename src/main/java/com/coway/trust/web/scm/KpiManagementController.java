package com.coway.trust.web.scm;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.scm.KpiManagementService;
import com.coway.trust.biz.scm.ScmCommonService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class KpiManagementController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(KpiManagementController.class);
	
	@Autowired
	private ScmCommonService scmCommonService;
	@Autowired
	private KpiManagementService kpiManagementService;
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	/*
	 * View
	 */
	//	Inventory Report
	@RequestMapping(value = "/inventoryReport.do")
	public String inventoryReportView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/inventoryReport";
	}
	
	/*
	 * Inventory Report
	 */
	//	Search Total
	@RequestMapping(value = "/selectInventoryReportTotal.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectInventoryReportTotal(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectInventoryReportTotal : {}", params.toString());
		String planYearMonth	= "";
		
		Map<String, Object> map	= new HashMap<>();
		planYearMonth	= params.get("planYearMonth").toString();
		planYearMonth	= planYearMonth.replace("/", "");
		planYearMonth	= planYearMonth.substring(2, 6) + planYearMonth.substring(0, 2);
		params.put("planYearMonth", planYearMonth);
		LOGGER.debug("selectInventoryReportTotal : {}", params.toString());
		
		//List<EgovMap> selectInventoryReportTotalHeader	= kpiManagementService.selectInventoryReportTotalHeader(params);
		//List<EgovMap> selectInventoryReportDetailHeader	= kpiManagementService.selectInventoryReportDetailHeader(params);
		List<EgovMap> selectInventoryReportTotal	= kpiManagementService.selectInventoryReportTotal(params);
		List<EgovMap> selectInventoryReportDetail	= kpiManagementService.selectInventoryReportDetail(params);
		
		//map.put("selectInventoryReportTotalHeader", selectInventoryReportTotalHeader);
		//map.put("selectInventoryReportDetailHeader", selectInventoryReportDetailHeader);
		map.put("selectInventoryReportTotal", selectInventoryReportTotal);
		map.put("selectInventoryReportDetail", selectInventoryReportDetail);
		
		return	ResponseEntity.ok(map);
	}
	//	Search Detail
	@RequestMapping(value = "/selectInventoryReportDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectInventoryReportDetail(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectInventoryReportDetail : {}", params.toString());
		String planYearMonth	= "";
		
		Map<String, Object> map	= new HashMap<>();
		planYearMonth	= params.get("planYearMonth").toString();
		planYearMonth	= planYearMonth.replace("/", "");
		planYearMonth	= planYearMonth.substring(2, 6) + planYearMonth.substring(0, 2);
		params.put("planYearMonth", planYearMonth);
		LOGGER.debug("selectInventoryReportDetail : {}", params.toString());
		
		//List<EgovMap> selectInventoryReportTotalHeader	= kpiManagementService.selectInventoryReportTotalHeader(params);
		//List<EgovMap> selectInventoryReportDetailHeader	= kpiManagementService.selectInventoryReportDetailHeader(params);
		//List<EgovMap> selectInventoryReportTotal	= kpiManagementService.selectInventoryReportTotal(params);
		List<EgovMap> selectInventoryReportDetail	= kpiManagementService.selectInventoryReportDetail(params);
		
		//map.put("selectInventoryReportTotalHeader", selectInventoryReportTotalHeader);
		//map.put("selectInventoryReportDetailHeader", selectInventoryReportDetailHeader);
		//map.put("selectInventoryReportTotal", selectInventoryReportTotal);
		map.put("selectInventoryReportDetail", selectInventoryReportDetail);
		
		return	ResponseEntity.ok(map);
	}
}