package com.coway.trust.web.organization.organization;

import java.util.ArrayList;
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

import com.coway.trust.biz.organization.organization.OrgChartListService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller 
@RequestMapping(value = "/organization")
public class OrgChartListController {
	
	private static final Logger logger = LoggerFactory.getLogger(MemberRawDataController.class);
	
	@Resource(name = "orgChartListService")
	private OrgChartListService orgChartListService;
	
	@RequestMapping(value = "/initOrgChartList.do")
	public String initOrgChartList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "organization/organization/orgChartList";
	}

	
	@RequestMapping(value = "/selectOrgChartHpList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrgChartHpList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model,SessionVO sessionVO) {
		
		List<EgovMap> orgChartHpList = null;
		
		logger.debug("memberLevel : {}", sessionVO.getMemberLevel());
		logger.debug("userName : {}", sessionVO.getUserName());
		
		params.put("memberLevel", sessionVO.getMemberLevel());
		params.put("userName", sessionVO.getUserName());
		
		params.put("memType", sessionVO.getUserTypeId());
		params.put("memLvl",  sessionVO.getMemberLevel());
		//params.put("groupCode","");
		
		String type="";
		if (params.get("memType" ) == "4" ) {
			type = orgChartListService.selectLastGroupCode(params);        
		}
		
		logger.debug("type : {}", type);

		if ( type == "42") {
			params.put("memType", "2");
		} else if ( type == "42") {
			params.put("memType", "3");
		} else if ( type == "45") {
			params.put("memType", "1");			
		} else {
			params.put("memType", "");
		}
		
		if ( params.get("memType").equals("") || params.get("memType").equals("1")) {
        // 조회.
			orgChartHpList = orgChartListService.selectOrgChartHpList(params);        
		}
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
	public ResponseEntity<List<EgovMap>> selectCdChildList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model,SessionVO sessionVO) {
		
		List<EgovMap> orgChartCdList = null;
		
		logger.debug("memberLevel : {}", sessionVO.getMemberLevel());
		logger.debug("userName : {}", sessionVO.getUserName());
		
		params.put("memberLevel", sessionVO.getMemberLevel());
		params.put("userName", sessionVO.getUserName());
		
		params.put("memType", sessionVO.getUserTypeId());
		params.put("memLvl",  sessionVO.getMemberLevel());
		//params.put("groupCode","");
		
		String type="";
		if (params.get("memType" ) == "4" ) {
			type = orgChartListService.selectLastGroupCode(params);        
		}
		
		logger.debug("type : {}", type);

		if ( type == "42") {
			params.put("memType", "2");
		} else if ( type == "42") {
			params.put("memType", "3");
		} else if ( type == "45") {
			params.put("memType", "1");			
		} else {
			params.put("memType", "");
		}
		
		if ( params.get("memType").equals("") || params.get("memType").equals("2") || params.get("memType").equals("3")) {
			// 조회.
			orgChartCdList = orgChartListService.selectOrgChartCdList(params);        
		}
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
	public ResponseEntity<List<EgovMap>> selectOrgChartDetList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model,SessionVO sessionVO) {
		
		logger.debug(" :::: "+params.toString());
		
		params.put("memberLevel", sessionVO.getMemberLevel());
		params.put("userName", sessionVO.getUserName());
		
		String str1 = params.get("memLvl").toString();
		String[] codeList = str1.split(",");
		params.put("codeList", codeList);
		
		
		List<EgovMap> OrgChartDetList = orgChartListService.selectOrgChartDetList(params);
		return ResponseEntity.ok(OrgChartDetList);
	}
	
}
