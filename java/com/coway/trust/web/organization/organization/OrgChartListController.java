package com.coway.trust.web.organization.organization;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.organization.organization.OrgChartListService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class OrgChartListController {

	private static final Logger logger = LoggerFactory.getLogger(MemberRawDataController.class);

	@Resource(name = "orgChartListService")
	private OrgChartListService orgChartListService;

	@Resource(name = "memberListService")
	private MemberListService memberListService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@RequestMapping(value = "/initOrgChartList.do")
	public String initOrgChartList(@RequestParam Map<String, Object> params, ModelMap model ,SessionVO sessionVO) {


		params.put("userTypeId", sessionVO.getUserTypeId());

		String type="";
		String userTypeId="";
		if (params.get("userTypeId" ) == "4" ) {
			type = memberListService.selectTypeGroupCode(params);
		} else {
			userTypeId = String.valueOf(sessionVO.getUserTypeId());
		}

		logger.debug("type : {}", type);

		if ( params.get("userTypeId" ) == "4"  && type == "42") {
			userTypeId =  "2";
		} else if ( params.get("userTypeId" ) == "4"  && type == "43") {
			userTypeId =  "3";
		} else if ( params.get("userTypeId" ) == "4"  && type == "45") {
			userTypeId =  "1";
		} else if ( params.get("userTypeId" ) == "4"  && type.equals("")){
			userTypeId =  "";
		}

		model.put("memLvl",  sessionVO.getMemberLevel());
		model.put("memType",  userTypeId);
		//model.put("userName", sessionVO.getUserName());

		return "organization/organization/orgChartList";
	}


	@RequestMapping(value = "/selectOrgChartHpList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrgChartHpList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {

		params.put("userName", sessionVO.getUserName());

		logger.debug("selectOrgChartHpList params : {}", params);

		if ( params.get("memType").equals("")) {
			params.put("memType", "1");
		}

		List<EgovMap> orgChartHpList = null;

        // 조회.
		orgChartHpList = orgChartListService.selectOrgChartHpList(params);

		return ResponseEntity.ok(orgChartHpList);
	}




	@RequestMapping(value = "/selectHpChildList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHpChildList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

        // 조회.
		List<EgovMap> orgHpChildList = orgChartListService.selectHpChildList(params);

		return ResponseEntity.ok(orgHpChildList);
	}





	@RequestMapping(value = "/getDeptTreeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getDeptTreeList(@RequestParam Map<String, Object>params) {
        // Member Type 에 따른 Organization 조회.
		List<EgovMap> resultList = orgChartListService.getDeptTreeList(params);

		return ResponseEntity.ok(resultList);
	}



	@RequestMapping(value = "/getGroupTreeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getGroupTreeList(@RequestParam Map<String, Object>params) {

		logger.debug("  "+params.toString());
		//Member Type 이 선행 조회된 이후(고정) Member Id 변경 시
		// 조회.
		List<EgovMap> resultList = orgChartListService.getGroupTreeList(params);

		return ResponseEntity.ok(resultList);
	}











	@RequestMapping(value = "/selectOrgChartCdList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCdChildList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model  ,SessionVO sessionVO) {

		//params.put("memLvl",  sessionVO.getMemberLevel());
		//params.put("memType",  sessionVO.getUserTypeId());
		params.put("userName", sessionVO.getUserName());

		logger.debug("selectOrgChartCdList params : {}", params);

        // 조회.
		List<EgovMap> orgChartCdList = orgChartListService.selectOrgChartCdList(params);

		return ResponseEntity.ok(orgChartCdList);
	}


//	@RequestMapping(value = "/selectOrgChartCtList.do", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> selectCtChildList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
//
//        // 조회.
//		List<EgovMap> orgChartCdList = orgChartListService.selectOrgChartCdList(params);
//
//		return ResponseEntity.ok(orgChartCdList);
//	}



	@RequestMapping(value = "/initOrgChartListDet.do")
	public String initMembersList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "organization/organization/orgChartListDet";
	}






	@RequestMapping(value = "/selectOrgChartDetList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrgChartDetList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		logger.debug(" :::: "+params.toString());

		String str1 = params.get("memLvl").toString();
		String[] codeList = str1.split(",");
		params.put("codeList", codeList);


		List<EgovMap> OrgChartDetList = orgChartListService.selectOrgChartDetList(params);
		return ResponseEntity.ok(OrgChartDetList);
	}

	@RequestMapping(value="/SponsorListingPop.do")
	public String SponsorListingPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO){
		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){

			params.put("userId", sessionVO.getUserId());
			EgovMap result =  salesCommonService.getUserInfo(params);


			model.put("name", result.get("name"));
			model.put("memCode", result.get("memCode"));
			model.put("memLvl", result.get("memLvl"));
		}

		return "organization/organization/sponsorListingPop";
	}

	@RequestMapping(value = "/selectStatus.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStatus(@RequestParam Map<String, Object> params) {
		List<EgovMap> status = orgChartListService.selectStatus();
		return ResponseEntity.ok(status);
	}

	@RequestMapping(value = "/selectMemberName.do")
	public ResponseEntity<List<EgovMap>> selectCustomerOrderView(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{


		List<EgovMap> memName;

		memName = orgChartListService.selectMemberName(params);



		return ResponseEntity.ok(memName);
	}

	@RequestMapping(value="/OrganizationListingPop.do")
	public String OrganizationListingPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO){
		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){

			params.put("userId", sessionVO.getUserId());
			EgovMap result =  salesCommonService.getUserInfo(params);


			model.put("name", result.get("name"));
			model.put("memCode", result.get("memCode"));
			model.put("memLvl", result.get("memLvl"));
		}

		return "organization/organization/organizationListingPop";
	}



}
