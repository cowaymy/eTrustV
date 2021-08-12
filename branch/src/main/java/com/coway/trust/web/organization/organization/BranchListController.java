package com.coway.trust.web.organization.organization;

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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.organization.BranchListService;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller 
@RequestMapping(value = "/organization")
public class BranchListController {
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	private static final Logger logger = LoggerFactory.getLogger(MemberRawDataController.class);
	
	@Resource(name = "memberListService")
	private MemberListService memberListService;
	
	@Resource(name = "branchListService")
	private BranchListService branchListService;
	
	@RequestMapping(value = "/initBranchList.do")
	public String initBranchList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "organization/organization/branchList";
	}
	
	@RequestMapping(value = "/branchNewPop.do")
	public String branchNewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> nationality = memberListService.nationality();
		model.addAttribute("nationality", nationality);
		
		List<EgovMap> branchType = branchListService.getBranchType(params);
		model.addAttribute("branchType", branchType);
		
		return "organization/organization/branchListPop";
	}
	
	
	
	@RequestMapping(value = "/selectBranchList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBranchList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		String[] branchTypeList = request.getParameterValues("branchType");
		String[] regionList = request.getParameterValues("region");

		params.put("branchTypeList", branchTypeList);
		params.put("regionList", regionList);
		
		List<EgovMap> branchList = null;
		
        // 조회.
		branchList = branchListService.selectBranchList(params);        

		return ResponseEntity.ok(branchList);
	}
	
	
	
	
	
	@RequestMapping(value = "/getBranchDetailPop.do")
	public String getBranchDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
//		logger.debug("requestStatus : {}", params.get("promoId"));
		
		List<EgovMap> nationality = memberListService.nationality();
		model.addAttribute("nationality", nationality);
		
		List<EgovMap> branchType = branchListService.getBranchType(params);
		model.addAttribute("branchType", branchType);
		
		EgovMap branchDetail = branchListService.getBranchDetailPop(params);
		EgovMap branchAddr = branchListService.getBranchAddrDetail(branchDetail);
		logger.debug("branchDetail : {} " + branchDetail);
		logger.debug("branchAddr : {} " + branchAddr);
		model.addAttribute("branchDetail", branchDetail);
		model.addAttribute("branchAddr", branchAddr);
		
		return "organization/organization/branchListEditPop";
	}
	
	
	

	
	@RequestMapping(value = "/branchListUpdate", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> branchListUpdate(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
		
		logger.debug("in  saveBranchSave ");
		
		
		params.put("user_id", sessionVO.getUserId());
		
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		int  resultUpc=0;
		if(!"".equals(params.get("branchNo"))){
			//update 
			resultUpc = branchListService.branchListUpdate(params); 			
		}else {
			int  resultInt = branchListService.branchListInsert(params); 
		}
		
		
		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));


		// 데이터 리턴.
		return ResponseEntity.ok(message);
	}
	
	
	
	
	
	
	
	@RequestMapping(value = "/getStateList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getStateList(@RequestParam Map<String, Object>params) {
        // Member Type 에 따른 Organization 조회.
		List<EgovMap> resultList = branchListService.getStateList(params);        

		return ResponseEntity.ok(resultList);
	}
	
	
	
	
	@RequestMapping(value = "/getAreaList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getAreaList(@RequestParam Map<String, Object>params) {
        // Member Type 에 따른 Organization 조회.
		List<EgovMap> resultList = branchListService.getAreaList(params);        

		return ResponseEntity.ok(resultList);
	}
	
	
	
	@RequestMapping(value = "/getPostcodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getPostcodeList(@RequestParam Map<String, Object>params) {
        // Member Type 에 따른 Organization 조회.
		List<EgovMap> resultList = branchListService.getPostcodeList(params);        

		return ResponseEntity.ok(resultList);
	}
	
	
	@RequestMapping(value = "/getBranchViewPop.do")
	public String getBranchViewPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
//		logger.debug("requestStatus : {}", params.get("promoId"));
		
		List<EgovMap> nationality = memberListService.nationality();
		model.addAttribute("nationality", nationality);
		
		List<EgovMap> branchType = branchListService.getBranchType(params);
		model.addAttribute("branchType", branchType);
		
		EgovMap branchDetail = branchListService.getBranchDetailPop(params);
		EgovMap branchAddr = branchListService.getBranchAddrDetail(branchDetail);
		logger.debug("branchDetail : {} " + branchDetail);
		logger.debug("branchAddr : {} " + branchAddr);
		model.addAttribute("branchDetail", branchDetail);
		model.addAttribute("branchAddr", branchAddr);
		
		return "organization/organization/branchListDetailPop";
	}
	
	@RequestMapping(value = "/selectBranchCdInfo.do")
	public ResponseEntity<List<EgovMap>> selectBranchCdInfo(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
	
		List<EgovMap> selectBranchCdInfo = branchListService.selectBranchCdInfo(params);
	
		logger.debug("mList : {}", selectBranchCdInfo);
		
	return ResponseEntity.ok(selectBranchCdInfo);
	}	
	
}
