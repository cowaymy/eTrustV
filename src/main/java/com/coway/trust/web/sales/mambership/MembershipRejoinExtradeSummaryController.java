package com.coway.trust.web.sales.mambership;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.mambership.MembershipRejoinExtradeSummaryService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/membership")
public class  MembershipRejoinExtradeSummaryController {

	private static Logger logger = LoggerFactory.getLogger(MembershipRejoinExtradeSummaryController.class);

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "accessMonitoringService")
	private AccessMonitoringService accessMonitoringService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Resource(name = "membershipRejoinExtradeSummaryService")
	private MembershipRejoinExtradeSummaryService membershipRejoinExtradeSummaryService;

	@RequestMapping(value = "/membershipRejoinExtradeSummary.do")
	public String membershipRejoinExtradeSummaryList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){

			params.put("userId", sessionVO.getUserId());
			EgovMap result =  salesCommonService.getUserInfo(params);

			model.put("orgCode", result.get("orgCode"));
			model.put("grpCode", result.get("grpCode"));
			model.put("deptCode", result.get("deptCode"));
			model.put("memCode", result.get("memCode"));
		}

		return "sales/membership/membershipRejoinExtradeSummary";
	}

	@RequestMapping(value = "/selectRejoinExtradeSummaryList", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectRejoinExtradeSummaryList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		//Log down user search params
        SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    	StringBuffer requestUrl = new StringBuffer(request.getRequestURI());
		accessMonitoringService.insertSubAccessMonitoring(requestUrl.toString(), params, request,sessionVO);

		List<EgovMap> list = membershipRejoinExtradeSummaryService.selectRejoinExtradeSummaryList(params);
        return ResponseEntity.ok(list);
    }

}
