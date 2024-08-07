package com.coway.trust.web.organization.organization;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.organization.organization.LoyaltyHPStatusReportService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping("/organization")
public class LoyaltyHPStatusReportController {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoyaltyHPStatusReportController.class);

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Resource(name = "loyaltyHPStatusReportService")
	private LoyaltyHPStatusReportService loyaltyHPStatusReportService;

	@RequestMapping(value = "/LoyaltyHPStatusReport.do")
	public String LoyaltyHPStatusReport(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);

		model.addAttribute("today", today);

	    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

	    params.put("userId", sessionVO.getUserId());

	    if(sessionVO.getUserTypeId() == 1){
	    	EgovMap getUserInfo = salesCommonService.getUserInfo(params);
	        model.put("memType", getUserInfo.get("memType"));
	        model.put("orgCode", getUserInfo.get("orgCode"));
	        model.put("grpCode", getUserInfo.get("grpCode"));
	        model.put("deptCode", getUserInfo.get("deptCode"));
	        model.put("memCode", getUserInfo.get("memCode"));
	        LOGGER.info("memType ##### " + getUserInfo.get("memType"));
	    }
	    return "organization/organization/LoyaltyHPStatusReport";
	}

	@RequestMapping(value = "/selectOrgCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrgCode(@RequestParam Map<String, Object>params, ModelMap model) {
		List<EgovMap> OrgCode = loyaltyHPStatusReportService.selectOrgCode(params);
		LOGGER.info("OrgCode ##### " + OrgCode);

		return ResponseEntity.ok(OrgCode);
	}
}
