package com.coway.trust.web.organization;

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

import com.coway.trust.biz.organization.MemberEventService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class MemberEventListController {

	private static final Logger logger = LoggerFactory.getLogger(MemberEventListController.class);
	
	@Resource(name = "memberEventService")
	private MemberEventService memberEventService;
	
	@RequestMapping(value = "/memberEvent.do")
	public String listdevice(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		
//		memberEventService.getMemberEventDetailPop(params)
		
		List<EgovMap> reqPersonComboList = memberEventService.reqPersonComboList();
		List<EgovMap> reqStatusComboList = memberEventService.reqStatusComboList();				
		
		model.addAttribute("reqStatusComboList", reqStatusComboList);
		model.addAttribute("reqPersonComboList", reqPersonComboList);
		

		return "organization/organization/memberEventList";
	}

	
	
	
	/**
	 * selectOrganizationEventList Statement Transaction 리스트 조회
	 * @param 
	 * @param params
	 * @param model 
	 * @return
	 */
	@RequestMapping(value = "/selectMemberEventList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrganizationEventList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		//검색 파라미터 확인.(화면 Form객체 입력값)
        logger.debug("requestStatus : {}", params.get("requestStatus"));
        logger.debug("requestType : {}", params.get("requestType"));
        logger.debug("requestPerson : {}", params.get("requestPerson"));
        logger.debug("memberType : {}", params.get("memberType"));        
        logger.debug("requestNoF : {}", params.get("requestNoF"));
        logger.debug("requestNoT : {}", params.get("requestNoT"));
        logger.debug("requestDateF : {}", params.get("requestDateF"));
        logger.debug("requestDateT : {}", params.get("requestDateT"));
		
        List<EgovMap> organizationEvent = null;
        
        String[] reqStatusComboList = request.getParameterValues("requestStatus");		// reqStatus 콤보박스 값        
		String[] requestPersonComboList = request.getParameterValues("requestPerson");		// reqStatus 콤보박스 값
		
		params.put("StatusList", reqStatusComboList);
		params.put("PersonList", requestPersonComboList);
		
        // 조회.
		organizationEvent = memberEventService.selectOrganizationEventList(params);        
		
        // 화면 단으로 전달할 데이터.
//        model.addAttribute("organizationEvent", organizationEvent);
        
        // 조회 결과 리턴.
//        return "organization/organization/organizationEventList";
        return ResponseEntity.ok(organizationEvent);
        
	} 
	
	
	
	@RequestMapping(value = "/getMemberEventDetailPop.do")
	public String getMemberEventDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		logger.debug("requestStatus : {}", params.get("promoId"));
		
		params.put("promoId", params.get("promoId"));
		EgovMap promoInfo = memberEventService.getMemberEventDetailPop(params);
		model.addAttribute("promoInfo", promoInfo);

		return "organization/organization/memberEventDetailPop";
	}

		
	

	
	
	
				
}
