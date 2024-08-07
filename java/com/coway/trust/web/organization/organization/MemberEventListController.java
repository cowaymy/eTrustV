package com.coway.trust.web.organization.organization;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.organization.MemberEventService;

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


	@RequestMapping(value = "/groupEvent.do")
	public String listdevice2(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

//		memberEventService.getMemberEventDetailPop(params)

		List<EgovMap> reqPersonComboList = memberEventService.reqPersonComboList();
		List<EgovMap> reqStatusComboList = memberEventService.reqStatusComboList();

		model.addAttribute("reqStatusComboList", reqStatusComboList);
		model.addAttribute("reqPersonComboList", reqPersonComboList);


		return "organization/organization/memberGroupList";
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
		String[] requestTypeList = request.getParameterValues("requestType");		// reqStatus 콤보박스 값
		String[] memTypeList = request.getParameterValues("memberType");		// reqStatus 콤보박스 값

		params.put("StatusList", reqStatusComboList);
		params.put("PersonList", requestPersonComboList);
		params.put("requestTypeList", requestTypeList);
		params.put("memTypeList", memTypeList);

        // 조회.
		organizationEvent = memberEventService.selectOrganizationEventList(params);


		logger.debug("organizationEvent : {}", organizationEvent);
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
		logger.debug("promoInfo : {}", promoInfo);
		model.addAttribute("promoInfo", promoInfo);

		return "organization/organization/memberEventDetailPop";
	}





	@RequestMapping(value = "/selectPromteDemoteList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromteDemoteList(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> selectPromote = memberEventService.selectPromteDemoteList(params);
		logger.debug("selectPromote : {}", selectPromote);
		return ResponseEntity.ok(selectPromote);
	}


	@RequestMapping(value = "/selectMemberPromoEntries" , method = RequestMethod.GET)
	public   ResponseEntity<ReturnMessage> selectMemberPromoEntries(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		boolean success =false;
//		int promoId = 0;
//		List<EgovMap> promoEntries = null;
		logger.debug("params : {}", params);
		//Map<String, Object> param = null;
		//param = new HashMap<String, Object>();
		//param.put("promoId", params.get("promoId"));

//		String promoId = request.getParameterValues("promoId");
//		params.put("promoId", promoId);

		success = memberEventService.selectMemberPromoEntries(params);		//수정시 조심 updateMemberListApprove, Fail  같이쓰인다

//		List<EgovMap> promoEntries = memberEventService.selectMemberPromoEntries(param);
//		logger.debug("promoEntries : {}", promoEntries);
//
//		model.put("promoEntries", promoEntries);
		if(success){
			if(params.get("confirmStatus").toString().equals("04")){
				message.setMessage("Complete this event Completed " + params.get("memCode"));
			}
    		else if(params.get("confirmStatus").toString().equals("10")){
    			message.setMessage("Complete this event Cancelled " + params.get("memCode"));
    		}else{
    			message.setMessage("Fail this event Fail " + params.get("memCode"));
    		}




		}
		return ResponseEntity.ok(message);

	}



	@RequestMapping(value = "/getMemberEventViewPop.do")
	public String getMemberEventViewPop(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("requestStatus : {}", params.get("promoId"));

		params.put("promoId", params.get("promoId"));
		EgovMap promoInfo = memberEventService.getMemberEventDetailPop(params);
		logger.debug("promoInfo : {}", promoInfo);
		model.addAttribute("promoInfo", promoInfo);

		return "organization/organization/memberEventViewPop";
	}






	@RequestMapping(value = "/getAvailableChild.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> getAvailableChild(@RequestParam Map<String, Object>params) {


		logger.debug(" in getAvailableChild ...");
		logger.debug(" in getAvailableChild prams ["+params.toString()+"]");

		EgovMap  resultList = memberEventService.getAvailableChild(params);

		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/updateMemberListApprove", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateMemberListApprove(@RequestBody Map<String, ArrayList<Object>> params ){
		ReturnMessage message = new ReturnMessage();
		logger.debug("params {}", params);
		List<Object> updateList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		logger.debug("updateList {}", updateList);
		Map<String, Object> approveMap  = null;
		int approveCount = 0;



		for(int i = 0 ; i < updateList.size(); i++  ){
			approveMap = (Map<String, Object>) updateList.get(i);
			approveMap = (Map<String, Object>) approveMap.get("item");
			logger.debug("approveMap {}" , approveMap);
			approveMap.put("promoId" , approveMap.get("promoId").toString() );
			approveMap.put("confirmStatus", "4");
			approveMap.put("memId" , approveMap.get("memberid").toString() );
//			approveMap.put("evtApplyDate" , approveMap.get("eventdt").toString() );
			if(approveMap.get("branchid") != null){
				approveMap.put("branchId" , approveMap.get("branchid").toString() );
			}
			//memId confirmStatus branchId evtApplyDate
			logger.debug("approveMap {}", approveMap);
			memberEventService.selectMemberPromoEntries(approveMap);

			approveCount++;
		}

		message.setMessage( approveCount  + " Request Event Completed " );

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/updateMemberListFail", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateMemberListFail(@RequestBody Map<String, ArrayList<Object>> params ){
		ReturnMessage message = new ReturnMessage();
		logger.debug("params {}", params);
		List<Object> updateList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		logger.debug("updateList {}", updateList);
		Map<String, Object> approveMap  = null;
		int approveCount = 0;
		for(int i = 0 ; i < updateList.size(); i++  ){

			approveMap = (Map<String, Object>) updateList.get(i);
			approveMap = (Map<String, Object>) approveMap.get("item");
			logger.debug("approveMap {}" , approveMap);
			approveMap.put("promoId" , approveMap.get("promoId").toString() );
			approveMap.put("confirmStatus", "10");
			approveMap.put("memId" , approveMap.get("memberid").toString() );
//			approveMap.put("evtApplyDate" , approveMap.get("eventdt").toString() );
			if(approveMap.get("branchid") != null){
				approveMap.put("branchId" , approveMap.get("branchid").toString() );
			}

			//memId confirmStatus branchId evtApplyDate
			logger.debug("approveMap {}", approveMap);
			memberEventService.selectMemberPromoEntries(approveMap);

			approveCount++;
		}

		message.setMessage( approveCount  + " Request Event Cancelled" );

		return ResponseEntity.ok(message);
	}


}
