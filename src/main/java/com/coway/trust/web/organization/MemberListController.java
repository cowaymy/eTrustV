package com.coway.trust.web.organization;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.organization.MemberListService;
import com.coway.trust.biz.sample.SampleDefaultVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/organization")
public class MemberListController {
	private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);
	
	@Resource(name = "memberListService")
	private MemberListService memberListService;
	
	@Resource(name = "commonService")
	private CommonService commonService;
	/**
	 * Call commission rule book management Page 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/memberList.do")
	public String memberList(@RequestParam Map<String, Object> params, ModelMap model) {
		//화면에 공통코드값....가져와........
		List<EgovMap> nationality = memberListService.nationality();
		params.put("groupCode",1);
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
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/memberListSearch", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectmemberListSearch(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("memTypeCom : {}", params.get("memTypeCom"));
		logger.debug("code : {}", params.get("code"));
		logger.debug("name : {}", params.get("name"));
		logger.debug("icNum : {}", params.get("icNum"));
		logger.debug("birth : {}", params.get("birth"));
		logger.debug("nation : {}", params.get("nation"));
		logger.debug("race : {}", params.get("race"));
		logger.debug("status : {}", params.get("status"));
		logger.debug("contact : {}", params.get("contact"));
		logger.debug("keyUser : {}", params.get("keyUser"));
		logger.debug("keyBranch : {}", params.get("keyBranch"));
		logger.debug("createDate : {}", params.get("createDate"));
		logger.debug("endDate : {}", params.get("endDate"));
		
		List<EgovMap> memberList = memberListService.selectMemberList(params);
		logger.debug("memberList : {}", memberList);
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
		
		logger.debug("MemberID : {}", params.get("MemberID"));
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
	public String selectMemberListNewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		// 호출될 화면
		return "organization/organization/memberListNewPop";
	}
}
