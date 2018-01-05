package com.coway.trust.web.organization.organization;

import java.util.HashMap;
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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.services.tagMgmt.TagMgmtService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/organization")
public class MemberListController {
	private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);

	@Resource(name = "memberListService")
	private MemberListService memberListService;

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "tagMgmtService")
	TagMgmtService tagMgmtService;
	
	/**
	 * Call commission rule book management Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/memberList.do")
	public String memberList(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		
		logger.debug("sessionVO  getUserTypeId  {} " , sessionVO.getUserTypeId());
		
		//화면에 공통코드값....가져와........
		List<EgovMap> nationality = memberListService.nationality();
		params.put("groupCode",1);
		params.put("userTypeId", sessionVO.getUserTypeId());
		
		String type="";
		if (params.get("userTypeId" ) == "4" ) {
			type = memberListService.selectTypeGroupCode(params);        
		} else {
			params.put("userTypeId", sessionVO.getUserTypeId());
		}
		
		logger.debug("type : {}", type);

		if ( params.get("userTypeId" ) == "4"  && type == "42") {
			params.put("userTypeId", "2");
		} else if ( params.get("userTypeId" ) == "4"  && type == "43") {
			params.put("userTypeId", "3");
		} else if ( params.get("userTypeId" ) == "4"  && type == "45") {
			params.put("userTypeId", "1");			
		} else if ( params.get("userTypeId" ) == "4"  && type.equals("")){
			params.put("userTypeId", "");
		}  
		
		List<EgovMap> memberType = commonService.selectCodeList(params);
		params.put("mstCdId",2);
		params.put("dtailDisabled",0);
		List<EgovMap> race = commonService.getDetailCommonCodeList(params);
		List<EgovMap> status = memberListService.selectStatus();
		List<EgovMap> userBranch = memberListService.selectUserBranch();
		List<EgovMap> user = memberListService.selectUser();
		logger.debug("-------------controller------------");
		logger.debug("nationality    " + nationality);
		logger.debug("memberType    " + memberType);
		logger.debug("race    " + race);
		logger.debug("status    " + status);
		logger.debug("userBranch    " + userBranch);
		logger.debug("user    " + user);
		model.addAttribute("nationality", nationality);
		model.addAttribute("memberType", memberType);
		model.addAttribute("race", race);
		model.addAttribute("status", status);
		model.addAttribute("userBranch", userBranch);
		model.addAttribute("user", user);

		// 호출될 화면
		return "organization/organization/memberList";
	}

	/*By KV start - Position - This is for Position link for Position is list in selection*/
	@RequestMapping(value = "/positionList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>positionList (@RequestParam Map<String, Object> params, ModelMap model){
		return ResponseEntity.ok(memberListService.selectPosition(params));
	}
	/*By KV end - Position - This is for Position link for Position is list in selection*/

	/*By KV start - ReplacementCT - selection in requestvacation*/
	@RequestMapping(value = "/selectReplaceCTList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectReplaceCTList(@RequestParam Map<String, Object> params, ModelMap model ,SessionVO sessionVO) {
		   logger.debug("groupCode : {}", params);
           params.put("brnch_id", params.get("brnch_id")  );
           params.put("mem_id",params.get("mem_id") );
           params.put("mem_code",params.get("mem_code") );
		   List<EgovMap> replacementCTList = memberListService.selectReplaceCTList(params);
		   return ResponseEntity.ok(replacementCTList);
	}
	/*By KV end - ReplacementCT - selection in requestvacation*/

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/memberListSearch", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectmemberListSearch(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		logger.debug("memTypeCom : {}", params.get("memTypeCom"));
		logger.debug("code : {}", params.get("code"));
		logger.debug("name : {}", params.get("name"));
		logger.debug("icNum : {}", params.get("icNum"));
		logger.debug("birth : {}", params.get("birth"));
		logger.debug("nation : {}", params.get("nation"));
		logger.debug("race : {}", params.get("race"));
		logger.debug("status : {}", params.get("status"));

		//By KV start - Do Search Button for Position Level
		logger.debug("position : {}",params.get("position"));
		//By KV end - Do Search Button for Position Level

		logger.debug("contact : {}", params.get("contact"));
		logger.debug("keyUser : {}", params.get("keyUser"));
		logger.debug("keyBranch : {}", params.get("keyBranch"));
		logger.debug("createDate : {}", params.get("createDate"));
		logger.debug("endDate : {}", params.get("endDate"));

		logger.debug("memberLevel : {}", sessionVO.getMemberLevel());
		logger.debug("userName : {}", sessionVO.getUserName());
		
		params.put("memberLevel", sessionVO.getMemberLevel());
		params.put("userName", sessionVO.getUserName());
		
		List<EgovMap> memberList = null;

		String MemType = params.get("memTypeCom").toString();
		if(MemType.equals("2803"))
		{
			memberList = memberListService.selectHPApplicantList(params);
		}
		else
		{
			memberList = memberListService.selectMemberList(params);
		}

		return ResponseEntity.ok(memberList);
	}

	/**
	 * Call commission rule book management Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMemberListDetailPop.do")
	public String selectMemberListDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {

		
		logger.debug("selCompensation in.............");
		logger.debug("params : {}", params);
		
		
		params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));
		
		EgovMap selectMemberListView = null;
		
		if ( params.get("MemberType").equals("2803")) {
			selectMemberListView = memberListService.selectHPMemberListView(params);
		}else {
			selectMemberListView = memberListService.selectMemberListView(params);
		}
		//EgovMap selectMemberListView = memberListService.selectMemberListView(params);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
		EgovMap PAExpired = memberListService.selectCodyPAExpired(params);
		logger.debug("PAExpired : {}", PAExpired);
		logger.debug("selectMemberListView : {}", selectMemberListView);
		logger.debug("issuedBank : {}", selectIssuedBank);
		logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
		model.addAttribute("PAExpired", PAExpired);
		model.addAttribute("ApplicantConfirm", ApplicantConfirm);
		model.addAttribute("memberView", selectMemberListView);
		model.addAttribute("issuedBank", selectIssuedBank);

		// 호출될 화면
		return "organization/organization/memberListDetailPop";
	}

	/**
	 * Call commission rule book management Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMemberListNewPop.do")
	public String selectMemberListNewPop(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		params.put("mstCdId",2);
		List<EgovMap> race = commonService.getDetailCommonCodeList(params);
		params.put("mstCdId",4);
		List<EgovMap> marrital = commonService.getDetailCommonCodeList(params);
		List<EgovMap> nationality = memberListService.nationality();
		params.put("groupCode","state");
		params.put("codevalue","1");
		params.put("country","Malaysia");
		List<EgovMap> state = commonService.selectAddrSelCode(params);
		params.put("mstCdId",5);
		List<EgovMap> educationLvl = commonService.getDetailCommonCodeList(params);
		params.put("mstCdId",3);
		List<EgovMap> language = commonService.getDetailCommonCodeList(params);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		
		List<EgovMap> mainDeptList = memberListService.getMainDeptList();
		params.put("groupCode", "");
		List<EgovMap> subDeptList = memberListService.getSubDeptList(params) ;
		
		params.put("mstCdId",377);
		List<EgovMap> Religion = commonService.getDetailCommonCodeList(params);

		String userName = sessionVO.getUserName();
		params.put("userName", userName);
		
		List<EgovMap> DeptCdList = memberListService.getDeptCdListList(params);
		
		List<EgovMap> list = memberListService.getSpouseInfoView(params);
		logger.debug("return_Values: " + list.toString());
		
		logger.debug("race : {} "+race);
		logger.debug("marrital : {} "+marrital);
		logger.debug("nationality : {} "+nationality);
		logger.debug("state : {} "+state);
		logger.debug("educationLvl : {} "+educationLvl);
		logger.debug("language : {} "+language);
		logger.debug("Religion : {} "+Religion);
		
		logger.debug("DeptCdList : {} "+DeptCdList);

		model.addAttribute("race", race);
		model.addAttribute("marrital", marrital);
		model.addAttribute("nationality", nationality);
		model.addAttribute("state", state);
		model.addAttribute("educationLvl", educationLvl);
		model.addAttribute("language", language);
		model.addAttribute("issuedBank", selectIssuedBank);
		model.addAttribute("mainDeptList", mainDeptList);
		model.addAttribute("subDeptList", subDeptList);
		model.addAttribute("Religion", Religion);
		model.addAttribute("DeptCdList", DeptCdList);
		
		model.addAttribute("userType", sessionVO.getUserTypeId());
		
		model.addAttribute("spouseInfoView", list);


		// 호출될 화면
		return "organization/organization/memberListNewPop";
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDocSubmission", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDocSubmission(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("MemberType : {} "+params.get("MemberType"));

		params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));
		List<EgovMap> selectDocSubmission;

		if("2".equals(params.get("MemberType").toString().trim())){//type가 Coway Lady면 쿼리가 살짝다름.....
			selectDocSubmission = memberListService.selectDocSubmission2(params);
		}else{
			selectDocSubmission = memberListService.selectDocSubmission(params);
		}

		logger.debug("selectDocSubmission : {}", selectDocSubmission);
		return ResponseEntity.ok(selectDocSubmission);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPromote", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromote(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> selectPromote = memberListService.selectPromote(params);
		logger.debug("selectPromote : {}", selectPromote);
		return ResponseEntity.ok(selectPromote);
	}


	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPaymentHistory", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPaymentHistory(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> selectPaymentHistory = memberListService.selectPaymentHistory(params);
		logger.debug("selectPaymentHistory : {}", selectPaymentHistory);
		return ResponseEntity.ok(selectPaymentHistory);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectRenewalHistory", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRenewalHistory(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> selectRenewalHistory = memberListService.selectRenewalHistory(params);
		logger.debug("selectRenewalHistory : {}", selectRenewalHistory);
		return ResponseEntity.ok(selectRenewalHistory);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectArea", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectArea(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		params.put("groupCode","area");
		params.put("codevalue",params.get("codevalue"));
		List<EgovMap> area = commonService.selectAddrSelCode(params);
		logger.debug("area : {}", area);
		return ResponseEntity.ok(area);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/memberSave", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMemberl(@RequestBody Map<String, Object> params, Model model) {


		Boolean success = false;
		String msg = "";
		logger.debug("memberNm : {}", params.get("memberNm"));
		logger.debug("memberType : {}", params.get("memberType"));
		logger.debug("joinDate : {}", params.get("joinDate"));
		logger.debug("gender : {}", params.get("gender"));
		logger.debug("gender : {}", params.get("gender"));
		logger.debug("update : {}", params.get("docType"));
		logger.debug("myGridID : {}", params.get("params"));

		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		//Map<String , Object> formMap1 = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

		logger.debug("udtList : {}", updList);
		logger.debug("formMap : {}", formMap);
		String memCode = "";
		memCode = memberListService.saveMember(formMap, updList);
		logger.debug("memCode : {}", memCode);
		// 결과 만들기.
   	ReturnMessage message = new ReturnMessage();
//    	message.setCode(AppConstants.SUCCESS);
//    	message.setData(map);
   	if(memCode.equals("") && memCode.equals(null)){
   		message.setMessage("fail saved");
   	}else{
   		message.setMessage("Compelete to Create a Member Code : " +memCode);
   	}
   	logger.debug("message : {}", message);

   	System.out.println("msg   " + success);
//
	return ResponseEntity.ok(message);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectHpDocSubmission", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHpDocSubmission(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("memberType : {} "+params.get("memberType"));

		List<EgovMap> selectDocSubmission;

		if("2".equals(params.get("memberType").toString().trim())){//type가 Coway Lady면 쿼리가 살짝다름.....
			selectDocSubmission = memberListService.selectCodyDocSubmission(params);
		}else{
			selectDocSubmission = memberListService.selectHpDocSubmission(params);
		}

		logger.debug("selectDocSubmission : {}", selectDocSubmission);
		return ResponseEntity.ok(selectDocSubmission);
	}


	/**
	 * Call commission rule book management Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/requestTerminateResign.do")
	public String selectTerminateResign(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));
		logger.debug("codeValue : {}", params.get("codeValue"));

		EgovMap selectMemberListView = memberListService.selectMemberListView(params);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
		EgovMap PAExpired = memberListService.selectCodyPAExpired(params);
		logger.debug("PAExpired : {}", PAExpired);
		logger.debug("selectMemberListView : {}", selectMemberListView);
		logger.debug("issuedBank : {}", selectIssuedBank);
		logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
		model.addAttribute("PAExpired", PAExpired);
		model.addAttribute("ApplicantConfirm", ApplicantConfirm);
		model.addAttribute("memberView", selectMemberListView);
		model.addAttribute("issuedBank", selectIssuedBank);
		model.addAttribute("codeValue", params.get("codeValue"));
		// 호출될 화면
		return "organization/organization/memberListDetailPop";
	}

	/**
	 * Member - Request Terminate/Resign
	 * Member - Request Promote/Demote
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/terminateResignSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertTerminateResign(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();
		if(sessionVO != null){
			logger.debug("params : {}", params);
			logger.debug("sessionVO : {}", sessionVO.getUserId());
			boolean success = false;
			if(params.get("codeValue").toString().equals("1")){
	    		int memberId = params.get("requestMemberId") != null ? Integer.parseInt(params.get("requestMemberId").toString()) : 0;
	    		params.put("MemberID", memberId);
	    		resultValue = memberListService.insertTerminateResign(params,sessionVO);
	    		message.setMessage(resultValue.get("message").toString());

			}else{
				int memberId = params.get("requestMemberId") != null ? Integer.parseInt(params.get("requestMemberId").toString()) : 0;
	    		params.put("memberId", memberId);
	    		resultValue = memberListService.insertTerminateResign(params,sessionVO);
	    		message.setMessage(resultValue.get("message").toString());
			}
		}
		return ResponseEntity.ok(message);
	}

	/**
	 * Request Vacation Pop open List
	 * By KV
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/requestVacationPop.do")
	public String selectRequestVacation(@RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap selectMemberListView = memberListService.selectMemberListView(params);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
		List<EgovMap> vact_type_id = commonService.getDetailCommonCodeList(params);
		/*EgovMap PAExpired = memberListService.selectCodyPAExpired(params);*/
		/*logger.debug("PAExpired : {}", PAExpired);*/
		logger.debug("selectMemberListView : {}", selectMemberListView);
		logger.debug("issuedBank : {}", selectIssuedBank);
		logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
		logger.debug("vact_type_id    " + vact_type_id);
		/*model.addAttribute("PAExpired", PAExpired);*/
		model.addAttribute("ApplicantConfirm", ApplicantConfirm);
		model.addAttribute("memberView", selectMemberListView);
		model.addAttribute("issuedBank", selectIssuedBank);
		model.addAttribute("codeValue", params.get("codeValue"));
		/* By Goo - get type of leave */
		model.addAttribute("vact_type_id", vact_type_id);
		return "organization/organization/requestVacationPop";
	}

	/**
	 * Save Request Vacation function
	 * By KV
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/requestVacationSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertRequestVacation(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();
		if(sessionVO != null){
			logger.debug("params : {}", params);
			logger.debug("sessionVO : {}", sessionVO.getUserId());
			boolean success = false;

	    		int memberId = params.get("requestMemberId") != null ? Integer.parseInt(params.get("requestMemberId").toString()) : 0;
	    		params.put("MemberID", memberId);
	    		resultValue = memberListService.insertRequestVacation(params,sessionVO);
	    		message.setMessage(resultValue.get("message").toString());

		}
		return ResponseEntity.ok(message);
	}


	/**
	 * Request Trainee To Member Pop open List
	 * By KV
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/confirmMemRegisPop.do")
	public String selectRequestTraineeToMem(@RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap selectMemberListView = memberListService.selectMemberListView(params);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
		/*EgovMap PAExpired = memberListService.selectCodyPAExpired(params);*/
		/*logger.debug("PAExpired : {}", PAExpired);*/
		logger.debug("selectMemberListView : {}", selectMemberListView);
		logger.debug("issuedBank : {}", selectIssuedBank);
		logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
		/*logger.debug("vact_type_id    " + vact_type_id);*/
		/*model.addAttribute("PAExpired", PAExpired);*/
		model.addAttribute("ApplicantConfirm", ApplicantConfirm);
		model.addAttribute("memberView", selectMemberListView);
		model.addAttribute("issuedBank", selectIssuedBank);
		model.addAttribute("codeValue", params.get("codeValue"));
		return "organization/organization/confirmMemRegisPop";
	}

	/**
	 * Save Trainee To Member function - no yet done
	 * By KV
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	/*
	@RequestMapping(value = "/confirmMemRegisSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertRequestVacation(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();
		if(sessionVO != null){
			logger.debug("params : {}", params);
			logger.debug("sessionVO : {}", sessionVO.getUserId());
			boolean success = false;

	    		int memberId = params.get("requestMemberId") != null ? Integer.parseInt(params.get("requestMemberId").toString()) : 0;
	    		params.put("MemberID", memberId);
	    		resultValue = memberListService.insertRequestVacation(params,sessionVO);
	    		message.setMessage(resultValue.get("message").toString());

		}
		return ResponseEntity.ok(message);
	}
	*/






	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSuperiorTeam", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSuperiorTeam(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		params.put("memberLvl", params.get("groupCode[memberLvl]"));
		params.put("memberType", params.get("groupCode[memberType]"));
		params.put("memberID", params.get("groupCode[memberID]"));
		logger.debug("params : {}", params);
		List<EgovMap> superiorTeam = memberListService.selectSuperiorTeam(params);
		logger.debug("superiorTeam : {}", superiorTeam);
		return ResponseEntity.ok(superiorTeam);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDeptCode", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDeptCode(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		logger.debug("params : {}", params);
		params.put("memberLvl", params.get("groupCode[memberLvl]"));
		params.put("flag", params.get("groupCode[flag]"));
		params.put("branchVal", params.get("groupCode[branchVal]"));
		logger.debug("params : {}", params);
		List<EgovMap> deptCode = memberListService.selectDeptCode(params);
		return ResponseEntity.ok(deptCode);
	}


	@RequestMapping(value = "/selectDeptCodeHp", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDeptCodeHp(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
/*		logger.debug("params : {}", params);
		params.put("memberLvl", params.get("groupCode[memberLvl]"));
		params.put("flag", params.get("groupCode[flag]"));
		params.put("branchVal", params.get("groupCode[branchVal]"));
		logger.debug("params : {}", params);*/
		//List<EgovMap> deptCode = memberListService.selectDeptCodeHp(params);
		
		String userName = sessionVO.getUserName();
		params.put("userName", userName);
		
		List<EgovMap> deptCode = memberListService.getDeptCdListList(params);
		return ResponseEntity.ok(deptCode);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCourse.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCourse(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		List<EgovMap> course = memberListService.selectCourse();
		return ResponseEntity.ok(course);
	}



	@RequestMapping(value = "/traineeUpdate.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage>  traineeUpdate(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();

		logger.debug("in...... traineeUpdate");
		logger.debug("params : {}", params);


		resultValue = memberListService.traineeUpdate(params,sessionVO);

		if(null != resultValue){
			message.setMessage((String)resultValue.get("memCode"));
		}


		return ResponseEntity.ok(message);
	}

	/**
	 * MemberList Edit Pop open
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/memberListEditPop.do")
	public String memberListEditPop(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));
		EgovMap selectMemberListView = memberListService.selectMemberListView(params);
		logger.debug("selectMemberListView : {}", selectMemberListView);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		logger.debug("issuedBank : {}", selectIssuedBank);
		EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
		logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
		EgovMap PAExpired = memberListService.selectCodyPAExpired(params);
		logger.debug("PAExpired : {}", PAExpired);
		List<EgovMap> mainDeptList = memberListService.getMainDeptList();
		logger.debug("mainDeptList : {}", mainDeptList);
		
		params.put("groupCode", selectMemberListView.get("mainDept"));
		logger.debug("params : {}", params);
		List<EgovMap> subDeptList = memberListService.getSubDeptList(params) ;
		logger.debug("subDeptList : {}", subDeptList);
		
		model.addAttribute("PAExpired", PAExpired);
		model.addAttribute("ApplicantConfirm", ApplicantConfirm);
		model.addAttribute("memberView", selectMemberListView);
		model.addAttribute("issuedBank", selectIssuedBank);
		model.addAttribute("mainDeptList", mainDeptList);
		model.addAttribute("subDeptList", subDeptList);
		// 호출될 화면
		return "organization/organization/memberListEditPop";
	}

	@RequestMapping(value = "/getMemberListMemberView", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getMemberListMemberView(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		logger.debug("in  getMemberListMemberView.....");
		logger.debug("params : {}", params.toString());


		List<EgovMap> list = memberListService.getMemberListView(params);
		logger.debug("return_Values: " + list.toString());

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/memberUpdate", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateMemberl(@RequestBody Map<String, Object> params, Model model,SessionVO sessionVO) throws Exception {

		//memberListService.saveDocSubmission(memberListVO,params, sessionVO);

		Boolean success = false;
		String msg = "";



		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		//Map<String , Object> formMap1 = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

		int userId = sessionVO.getUserId();
		formMap.put("user_id", userId);

		logger.debug("udtList : {}", updList);
		logger.debug("formMap : {}", formMap);

		logger.debug("memberNm : {}", formMap.get("memberNm"));
		logger.debug("memberType : {}", formMap.get("memberType"));
		logger.debug("joinDate : {}", formMap.get("joinDate"));
		logger.debug("gender : {}", formMap.get("gender"));
		logger.debug("update : {}", formMap.get("docType"));
		logger.debug("myGridID : {}", formMap.get("params"));

		String memCode = "";
		boolean update = false;

		logger.debug("memCode : {}", formMap.get("memCode"));

		//update = memberListService.updateMember(formMap, updList,sessionVO);

		//update
		
		memCode =  (String)formMap.get("memCode");

		int resultUpc1 = 0;
		int resultUpc2 = 0;
		int resultUpc3 = 0;
		int resultUpc4 = 0;
		resultUpc1 = memberListService.memberListUpdate_user(formMap);
		resultUpc2 = memberListService.memberListUpdate_memorg(formMap);
		resultUpc3 = memberListService.memberListUpdate_member(formMap);
		
		
		String memType = (String)formMap.get("memType");
		logger.debug("================================================================================");
		logger.debug("=============== memType {} ",  memType);
		logger.debug("================================================================================");
		
		if ( memType.trim().equals("5") ) {
			logger.debug("================================================================================");
			logger.debug("=============== insert =====================================");
			logger.debug("================================================================================");
			resultUpc4 = memberListService.traineeUpdateInfo(formMap, sessionVO);
		}
		
		logger.debug("result UPC : " + Integer.toString(resultUpc1)+ " , "+ Integer.toString(resultUpc2)+ " , "+ Integer.toString(resultUpc3)+ " , ");

		// 결과 만들기.
   	ReturnMessage message = new ReturnMessage();
//    	message.setCode(AppConstants.SUCCESS);
//    	message.setData(map);
   	if(memCode.equals("") && memCode.equals(null)){
   		message.setMessage("fail saved");
   	}else{
   		message.setMessage("Compelete to Edit a Member Code : " +memCode);
   	}
   	logger.debug("message : {}", message);

   	System.out.println("msg   " + success);
//
	return ResponseEntity.ok(message);
	}
	/*
	@RequestMapping(value = "/getMemberListEditPop.do")
	public String getMemberListEditPop(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));

		EgovMap selectMemberListView = memberListService.selectMemberListView(params);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
		EgovMap PAExpired = memberListService.selectCodyPAExpired(params);
		logger.debug("PAExpired : {}", PAExpired);
		logger.debug("selectMemberListView : {}", selectMemberListView);
		logger.debug("issuedBank : {}", selectIssuedBank);
		logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
		model.addAttribute("PAExpired", PAExpired);
		model.addAttribute("ApplicantConfirm", ApplicantConfirm);
		model.addAttribute("memberView", selectMemberListView);
		model.addAttribute("issuedBank", selectIssuedBank);
		// 호출될 화면
		return "organization/organization/memberListEditPop";
	}
	*/


	@RequestMapping(value = "/hpMemRegister.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage>  hpMemRegister(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();

		logger.debug("in...... hpMemRegister");
		logger.debug("params : {}", params);

		params.put("MemberID", Integer.parseInt((String) params.get("memberId")));
		
		resultValue = memberListService.hpMemRegister(params,sessionVO);
		
		logger.debug("in...... hpMemRegiste Result");
		logger.debug("params : {}", params);
		logger.debug("resultValue : {}", resultValue);

		if(null != resultValue){
			message.setMessage((String)resultValue.get("memCode"));
		}


		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectSubDept.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getSubDept( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		
		params.put("groupCode",  params.get("groupCode"));
		
		List<EgovMap> subDeptList = memberListService.getSubDeptList(params) ;
		
		return ResponseEntity.ok( subDeptList);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCoureCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCoureCode( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("selectCoureCode params : {}", params);
		
		
		Calendar Startcal = Calendar.getInstance();
		
		Startcal.add(Calendar.MONTH,2);
		
		//현재 년도, 월, 일
	    StringBuffer today2 = new StringBuffer();
	    today2.append(String.format("%04d", Startcal.get(Startcal.YEAR)));
	    today2.append(String.format("%02d", Startcal.get(Startcal.MONTH)));
        //today2.append(String.format("%02d",  01));
	    
	    String startDay = today2.toString(); 
	    
		Calendar Endcal = Calendar.getInstance();
	    
		Endcal.add(Calendar.MONTH,3);
		//Endcal.set(year, month+3, day); //월은 -1해줘야 해당월로 인식
		
	    StringBuffer today3 = new StringBuffer();
	    today3.append(String.format("%04d", Endcal.get(Endcal.YEAR)));
	    today3.append(String.format("%02d", Endcal.get(Endcal.MONTH) ));
	    //today3.append(String.format("%02d", Endcal.getActualMaximum(Endcal.DAY_OF_MONTH)));
		
	    String endDay = today3.toString();
		logger.debug("=====================todate2=========================" +startDay + " <>  " + endDay);
		
		params.put("startDay", startDay);
		params.put("endDay", endDay);
		
		List<EgovMap> deptCode = memberListService.selectCoureCode(params);
		return ResponseEntity.ok(deptCode);
	}

	@RequestMapping(value = "/selectDepartmentCode", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDepartmentCode(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> deptCode = memberListService.selectDepartmentCodeLit(params);
		return ResponseEntity.ok(deptCode);
	}	
	
	@RequestMapping(value = "/selectBranchCode", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBranchCode(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> deptCode = memberListService.selectBranchCodeLit(params);
		return ResponseEntity.ok(deptCode);
	}		
	
	@RequestMapping(value = "/checkNRIC1.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> checkNRIC1(@RequestParam Map<String, Object> params, Model model) {

//		logger.debug("nric : {} " + params.get("nric"));
//		String nric = "";
		logger.debug("nric_params : {} " + params);
		List<EgovMap> checkNRIC1 = memberListService.checkNRIC1(params);
		
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		
		if (checkNRIC1.size() > 0) {
			message.setMessage("This applicant had been registered");
		} else {
			message.setMessage("pass");
		}
		logger.debug("message : {}", message);
    
    	return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/checkNRIC2.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> checkNRIC2(@RequestParam Map<String, Object> params, Model model) {

		logger.debug("nric_params : {} " + params);
		List<EgovMap> checkNRIC2 = memberListService.checkNRIC2(params);
		String memType = "";
		
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		
		if (checkNRIC2.size() > 0) {
			memType = checkNRIC2.get(0).get("memType").toString();
			logger.debug("memType : " + memType);
			
			if (memType.equals("1") || memType.equals("2") || memType.equals("3") || memType.equals("4")) {
				message.setMessage("This member is our existing HP/Cody/Staff/CT");
			} else {
				message.setMessage("pass");
			}
		} else {
			message.setMessage("pass");
		}
		
		logger.debug("message : {}", message);
    
    	return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/checkNRIC3.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> checkNRIC3(@RequestParam Map<String, Object> params, Model model) {

		logger.debug("nric_params : {} " + params);
		List<EgovMap> checkNRIC3 = memberListService.checkNRIC3(params);
		
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		
		if (checkNRIC3.size() > 0) {
			message.setMessage("Member must 18 years old and above");
		} else {
			message.setMessage("pass");
		}
		logger.debug("message : {}", message);
    
    	return ResponseEntity.ok(message);
	}
	
}
