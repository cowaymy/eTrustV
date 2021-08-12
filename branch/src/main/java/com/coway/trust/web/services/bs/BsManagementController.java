package com.coway.trust.web.services.bs;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.services.bs.BsManagementService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller 
@RequestMapping(value = "/bs")
public class BsManagementController {

	@Resource(name = "bsManagementService")
	private BsManagementService bsManagementService;
	
	
	@RequestMapping(value = "/initBsManagementList.do")
	public String initBsManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> bsStateList = bsManagementService.selectBsStateList(params);
		model.addAttribute("bsStateList", bsStateList);
		
		List<EgovMap> areaList = bsManagementService.selectAreaList(params);
		model.addAttribute("areaList", areaList);
		
		return "services/bs/bsManagement";
	}
	
	
	@RequestMapping(value = "/selectBsManagementList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBsManagementList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
		
		params.put("user_id", sessionVO.getUserId());
		
        // 조회.
		List<EgovMap> bsManagementList = bsManagementService.selectBsManagementList(params);        
		
		return ResponseEntity.ok(bsManagementList);
	}
	
	
	
}
