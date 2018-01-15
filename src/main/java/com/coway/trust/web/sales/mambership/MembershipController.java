/**
 * 
 */
package com.coway.trust.web.sales.mambership;

import java.util.HashMap;
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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.mambership.MembershipService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Controller
@RequestMapping(value = "/sales/membership")
public class MembershipController {

	private static Logger logger = LoggerFactory.getLogger(MembershipController.class);

	@Resource(name = "membershipService")
	private MembershipService membershipService;
	
	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@RequestMapping(value = "/membershipList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		logger.debug("sessionVO ============>> " + sessionVO.getUserTypeId());
		
		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){

			params.put("userId", sessionVO.getUserId());
			EgovMap result =  salesCommonService.getUserInfo(params);
			
			model.put("orgCode", result.get("lastOrgCode"));
			model.put("grpCode", result.get("lastGrpCode"));
			model.put("deptCode", result.get("lastDeptCode"));
			model.put("memCode", result.get("memCode"));
		}
		
		return "sales/membership/membershipList";
	} 

	@RequestMapping(value = "/selectMembershipList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectMembershipList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		logger.debug("in  selectMembershipList ");

		String[] MBRSH_STUS_ID = request.getParameterValues("MBRSH_STUS_ID");

		params.put("MBRSH_STUS_ID", MBRSH_STUS_ID);
		params.put("userTypeId", sessionVO.getUserTypeId());

		// MBRSH_ID
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipService.selectMembershipList(params);

	
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selMembershipView.do")
	public String selMembershipView(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  selMembershipView ");

		EgovMap membershipInfoTab = null;
		EgovMap orderInfoTab = null;
		EgovMap contactInfoTab = null;
		EgovMap filterChargeInfoTab = null;

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		membershipInfoTab = membershipService.selectMembershipInfoTab(params);
		orderInfoTab = membershipService.selectOderInfoTab(params);
		contactInfoTab = membershipService.selectInstallAddr(params);

		model.addAttribute("membershipInfoTab", membershipInfoTab);
		model.addAttribute("orderInfoTab", orderInfoTab);
		model.addAttribute("contactInfoTab", contactInfoTab);

		return "sales/membership/selMembershipViewPop";
	}

	@RequestMapping(value = "/inc_orderInfo.do")
	public String inc_orderInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  inc_orderInfo ");
		EgovMap orderInfoTab = null;
		EgovMap contactInfoTab = null;
		
		
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		  
		orderInfoTab = membershipService.selectOderInfoTab(params);
		contactInfoTab = membershipService.selectInstallAddr(params);
		

		model.addAttribute("orderInfoTab", orderInfoTab);
		model.addAttribute("contactInfoTab", contactInfoTab);
		
		return "sales/membership/inc_membershipOderInfoPop";
	}
	
	
	@RequestMapping(value = "/inc_orderInfoData", method = RequestMethod.GET)
	public ResponseEntity<Map>  inc_orderInfoData(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  inc_orderInfoData ");
		EgovMap orderInfoTab = null;
		EgovMap contactInfoTab = null;
		
		
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		  
		orderInfoTab = membershipService.selectOderInfoTab(params);
		contactInfoTab = membershipService.selectInstallAddr(params);
		
		Map<String, Object> map = new HashMap();
		map.put("orderInfoTab", orderInfoTab);
		map.put("contactInfoTab", contactInfoTab);
		
		return ResponseEntity.ok(map);
		
	} 

	@RequestMapping(value = "/inc_membershipInfo.do")
	public String inc_membershipInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  inc_membershipInfo ");
		EgovMap membershipInfoTab = null;
	

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		membershipInfoTab = membershipService.selectMembershipInfoTab(params);
		model.addAttribute("membershipInfoTab", membershipInfoTab);

		return "sales/membership/inc_membershipInfoPop";
	}

	@RequestMapping(value = "/inc_contactPersonInfo.do")
	public String inc_contactPersonInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  inc_contactPersonInfo ");

		EgovMap membershipInfoTab = null;
		
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		membershipInfoTab = membershipService.selectMembershipInfoTab(params);
		model.addAttribute("membershipInfoTab", membershipInfoTab);
		

		return "sales/membership/inc_membershipContactPersonPop";
	}
	
	
	@RequestMapping(value = "/inc_contactPersonInfoData", method = RequestMethod.GET)
	public ResponseEntity<Map>  inc_contactPersonInfoData(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		EgovMap membershipInfoTab = null;
		
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		membershipInfoTab = membershipService.selectMembershipInfoTab(params);
		
		Map<String, Object> map = new HashMap();
		map.put("contactInfoTab", membershipInfoTab);
		
		return ResponseEntity.ok(map);
		
	}
	
	
	
	@RequestMapping(value = "/inc_quotFilterInfo.do")
	public String inc_quotFilterInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  inc_quotFilterInfo ");

		EgovMap membershipInfoTab = null;
		
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		return "sales/membership/inc_membershipQuotFilterInfoPop";
	}

	
	

	
	
	@RequestMapping(value = "/inc_quotInfo")
	public String inc_quotInfo(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		logger.debug("in  inc_quotInfo ");

		EgovMap quotInfo = null;
		
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		quotInfo = membershipService.selectQuotInfo(params);
		model.addAttribute("quotInfo", quotInfo);
	
		return "sales/membership/inc_membershipQuoInfoPop" ;
	}
	
	
	@RequestMapping(value = "/selectMembershipQuotInfo", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipQuotInfo(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("in  selectMembershipQuotInfo ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipService.selectMembershipQuotInfo(params);

	
		return ResponseEntity.ok(list);
	}
	

	@RequestMapping(value = "/selectMembershipQuotFilter", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipQuotFilter(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("in  selectMembershipQuotFilter ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipService.selectMembershipQuotFilter(params);

	
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selMembershipViewLeader.do")
	public String selMembershipViewLeader(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  selMembershipViewLeader ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		model.addAttribute("MBRSH_ID", params.get("MBRSH_ID"));

		return "sales/membership/selMembershipViewLeaderPop";
	}

	@RequestMapping(value = "/selectMembershipViewLeader", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipViewLeader(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("in  selectMembershipViewLeader ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipService.selectMembershipViewLeader(params);

	
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/membershipFreePop.do")
	public String membershipFree(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  membershipFree ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		model.addAttribute("MBRSH_ID", params.get("MBRSH_ID"));
		return "sales/membership/membershipFreePop";
	}

	@RequestMapping(value = "/memberFreeContactPop.do")
	public String memberFreePop_contactPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  memberFreeContactPop ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		return "sales/membership/memberFreeContactPop";
	}

	@RequestMapping(value = "/memberFreeNewContactPop.do")
	public String memberFreeNewContactPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  memberFreeNewContactPop ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		return "sales/membership/memberFreeNewContactPop";
	}

	@RequestMapping(value = "/selectMembershipFreeConF", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipFreeConF(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("in  selectMembershipFreeConF ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipService.selectMembershipFreeConF(params);

	
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectMembershipFreeDataInfo")
	public ResponseEntity<Map> selectMembershipFreeDataInfo(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		logger.debug("in  selectMembershipFreeDataInfo ");

		EgovMap basic = null;
		EgovMap installation = null;
		EgovMap srvconfig = null;

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		basic = membershipService.selectMembershipFree_Basic(params);
		installation = membershipService.selectMembershipFree_installation(params);
		srvconfig = membershipService.selectMembershipFree_srvconfig(params); 

		Map<String, Object> map = new HashMap();
		map.put("basic", basic);
		map.put("installation", installation);
		map.put("srvconfig", srvconfig);
		
		logger.debug("srvconfig====>"+srvconfig.toString());
		

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectMembershipFree_oList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipFree_oList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		List<EgovMap> oList = null;

		logger.debug("in  selectMembershipFree_oList ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipService.selectMembershipFree_oList(params);

	
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectMembershipFree_bs", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipFree_bs(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		List<EgovMap> oList = null;

		logger.debug("in  selectMembershipFree_bs ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipService.selectMembershipFree_bs(params);

	
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectMembershipFree_cPerson", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipFree_cPerson(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		List<EgovMap> oList = null;

		logger.debug("in  selectMembershipFree_cPerson ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipService.selectMembershipFree_cPerson(params);

	
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/callOutOutsProcedure", method = RequestMethod.GET)
	public ResponseEntity<Map> callOutOutsProcedure(@RequestParam Map<String, Object> params, ModelMap model,
			HttpServletRequest request) {

		EgovMap item = new EgovMap();

		item = (EgovMap) membershipService.callOutOutsProcedure(params);

		logger.debug("v_result : {}", params.get("p1"));

		Map<String, Object> map = new HashMap();
		map.put("outSuts", params.get("p1"));

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectMembershipFree_Packg", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipFree_Packg(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		List<EgovMap> oList = null;

		logger.debug("in  selectMembershipFree_Packg ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipService.selectMembershipFree_Packg(params);

	
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectMembershipFree_PChange", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipFree_PChange(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		List<EgovMap> oList = null;

		logger.debug("in  selectMembershipFree_PChange ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipService.selectMembershipFree_PChange(params);

	
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectMembershipFree_save", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectMembershipFree_save(@RequestParam Map<String, Object> params, ModelMap model,
			HttpServletRequest request, SessionVO sessionVO) {

		logger.debug("in  selectMembershipFree_save ");

		params.put("user_id", sessionVO.getUserId());
		params.put("branch_id", sessionVO.getUserBranchId());

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		
		int resultIntKey = membershipService.membershipFree_save(params);
		
		ReturnMessage message = new ReturnMessage();
		
		if(resultIntKey >0){
    		message.setCode(AppConstants.SUCCESS);
    		message.setData(resultIntKey);
    		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}
		
		
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectMembershipContatList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipContatList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		List<EgovMap> oList = null;

		logger.debug("in  selectMembershipContatList ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipService.selectMembershipContatList(params);

	
		return ResponseEntity.ok(list);
	}

	/**
	 * @param params
	 * @param request
	 * @param model
	 * @param sessionVO
	 * @return
	 */
	@RequestMapping(value = "/membershipNewContatSave", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> membershipNewContatSave(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		logger.debug("in  membershipNewContatSave ");

		params.put("user_id", sessionVO.getUserId());

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		int resultUpc = 0;

		if ("on".equals(params.get("NEW_MAIN_SET"))) {
		
			resultUpc = membershipService.membershipNewContatUpdate(params);
		}

		int resultInt = membershipService.membershipNewContatSave(params);

	
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	
		//결과 
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/membershipOutrightKeyInListPop.do")
	public String membershipOutrightKeyInList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/membership/membershipOutrightKeyInRPop";
	}

	@Autowired
	private MessageSourceAccessor messageAccessor;

	
	
	@RequestMapping(value="/membershipOutrightYSListingPop.do")
	public String membershipOutrightYSListingPop(){
		
		return "sales/membership/membershipOutrightYSListingPop";
	}
	
	@RequestMapping(value="/getOGDCodeList")
	public ResponseEntity<List<EgovMap>> getOGDCodeList(@RequestParam Map<String, Object> params) throws Exception{
	
		List<EgovMap> ogdCodeList = null;
		
		ogdCodeList = membershipService.getOGDCodeList(params);
		
		return ResponseEntity.ok(ogdCodeList);
	}
	
	@RequestMapping(value="/membershipOutrightExpireListPop.do")
	public String membershipOutrightExpireListPop(ModelMap model, SessionVO sessionVO) {

		model.put("userTypeId", sessionVO.getUserTypeId());
		
		return "sales/membership/membershipOutrightExpireListPop";
	}
	
	@RequestMapping(value="/membershipOutrightExpireYearListPop.do")
	public String membershipOutrightExpireYearListPop(){
		
		return "sales/membership/membershipOutrightExpireYearListPop";
	}
	
	
	@RequestMapping(value = "/getBrnchCodeListByBrnchId")
	public ResponseEntity<List<EgovMap>> getBrnchCodeListByBrnchId (@RequestParam Map<String, Object> params, @RequestParam(value="brnchArr[]") String brnchArr[]) throws Exception{
		//params
		int inputLang = brnchArr.length;
		params.put("brnchList", brnchArr);
		
		List<EgovMap> codeList = null;
		codeList = membershipService.getBrnchCodeListByBrnchId(params);
		if(inputLang == codeList.size()){
			return ResponseEntity.ok(codeList);
		}else{
			return null;
		}
	}
}
