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

import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller 
@RequestMapping(value = "/bs")
public class HsManualController {

	@Resource(name = "hsManualService")
	private HsManualService hsManualService;
	
	
	@RequestMapping(value = "/initHsManualList.do")
	public String initBsManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> branchList = hsManualService.selectBranchList(params);
		model.addAttribute("branchList", branchList);
		
		
		return "services/bs/hsManual";
	}
	
	
	@RequestMapping(value = "/selectHsManualList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHsManualList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
		
		params.put("user_id", sessionVO.getUserId());
		
        // 조회.
		List<EgovMap> bsManagementList = hsManualService.selectHsManualList(params);        
		
		return ResponseEntity.ok(bsManagementList);
	}
	
	
	
	
	@RequestMapping(value = "/getCdUpMemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getCdUpMemList(@RequestParam Map<String, Object>params) {
        // Member Type 에 따른 Organization 조회.
		List<EgovMap> resultList = hsManualService.getCdUpMemList(params);        

		return ResponseEntity.ok(resultList);
	}
	
	
	
	@RequestMapping(value = "/getCdList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getCdList(@RequestParam Map<String, Object>params) {
        // Member Type 에 따른 Organization 조회.
		List<EgovMap> resultList = hsManualService.getCdList(params);        

		return ResponseEntity.ok(resultList);
	}
	
}
