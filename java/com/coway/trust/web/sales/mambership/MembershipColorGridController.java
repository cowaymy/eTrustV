package com.coway.trust.web.sales.mambership;

import java.util.Arrays;
import java.util.List;
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

import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.mambership.MembershipColorGridService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping("/sales/membership")
public class MembershipColorGridController {

	private static final Logger logger = LoggerFactory.getLogger(MembershipColorGridController.class);

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "membershipColorGridService")
	private MembershipColorGridService membershipColorGridService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@RequestMapping(value = "/membershipColorGridList.do")
	public String membershipColorGridList(@RequestParam Map<String, Object> params, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

			if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
				EgovMap getUserInfo = salesCommonService.getUserInfo(params);
				model.put("memType", getUserInfo.get("memType"));
				model.put("orgCode", getUserInfo.get("orgCode"));
				model.put("grpCode", getUserInfo.get("grpCode"));
				model.put("deptCode", getUserInfo.get("deptCode"));
				model.put("memCode", getUserInfo.get("memCode"));
			}

		return "sales/membership/membershipColorGridList";
	}

	@RequestMapping(value = "/membershipColorGridJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> membershipColorGridJsonList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		logger.info("##################### params #####" + params.toString());

		List<EgovMap> membershipColorGridList = membershipColorGridService.membershipColorGridList(params);

		return ResponseEntity.ok(membershipColorGridList);

	}

}
