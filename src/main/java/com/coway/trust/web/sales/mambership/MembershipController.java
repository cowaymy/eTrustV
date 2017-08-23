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
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.mambership.MembershipService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Controller
@RequestMapping(value = "/sales/membership")
public class  MembershipController {

	private static Logger logger = LoggerFactory.getLogger(MembershipController.class);
	
	@Resource(name = "membershipService")
	private MembershipService membershipService;
	
	@RequestMapping(value = "/membership.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/membership/membershipList";
	}
	
	@RequestMapping(value = "/selectMembershipList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  selectMembershipList ");
		
		
		String[] MBRSH_STUS_ID   = request.getParameterValues("MBRSH_STUS_ID"); 

		params.put("MBRSH_STUS_ID", MBRSH_STUS_ID);
		
		//MBRSH_ID        
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		
		List<EgovMap>  list = membershipService.selectMembershipList(params);  

		// 데이터 리턴.
		return ResponseEntity.ok(list);
	}
	
	
	
	
	@RequestMapping(value = "/selMembershipView.do")
	public String selMembershipView(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		logger.debug("in  selMembershipView ");
		
		EgovMap membershipInfoTab  = null;
		EgovMap orderInfoTab		    = null;
		EgovMap contactInfoTab	    = null;
		EgovMap filterChargeInfoTab	= null;
		
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
				
		
		membershipInfoTab 		= membershipService.selectMembershipInfoTab(params);
		orderInfoTab 				= membershipService.selectOderInfoTab(params);
		contactInfoTab 			= membershipService.selectInstallAddr(params);
		
		
		model.addAttribute("membershipInfoTab", membershipInfoTab);
		model.addAttribute("orderInfoTab", orderInfoTab);
		model.addAttribute("contactInfoTab", contactInfoTab);
	
		return "sales/membership/selMembershipViewPop";
	}
	
	
	

	
	@RequestMapping(value = "/selectMembershipQuotInfo", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipQuotInfo(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  selectMembershipQuotInfo ");
		
	      
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		
		List<EgovMap>  list = membershipService.selectMembershipQuotInfo(params);  

		// 데이터 리턴.
		return ResponseEntity.ok(list);
	}
	
	
	
	
	@RequestMapping(value = "/selectMembershipQuotFilter", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipQuotFilter(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  selectMembershipQuotFilter ");
		
	      
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		
		List<EgovMap>  list = membershipService.selectMembershipQuotFilter(params);  

		// 데이터 리턴.
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selMembershipViewLeader.do")
	public String selMembershipViewLeader(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		logger.debug("in  selMembershipViewLeader ");
		
		
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
				
		
		
		model.addAttribute("MBRSH_ID", params.get("MBRSH_ID"));  
		
		return "sales/membership/selMembershipViewLeaderPop";
	}
	
	
	
	
	

	@RequestMapping(value = "/selectMembershipViewLeader", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipViewLeader(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  selectMembershipViewLeader ");
		
	      
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		
		List<EgovMap>  list = membershipService.selectMembershipViewLeader(params);  

		// 데이터 리턴.
		return ResponseEntity.ok(list);
	}
	
	
	@RequestMapping(value = "/membershipFreePop.do")
	public String membershipFree(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		logger.debug("in  membershipFree ");
		
		
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		return "sales/membership/membershipFreePop";
	}
	
	
	

	@RequestMapping(value = "/selectMembershipFreeConF", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipFreeConF(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  selectMembershipFreeConF ");
		
	      
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		
		List<EgovMap>  list = membershipService.selectMembershipFreeConF(params);  

		// 데이터 리턴.
		return ResponseEntity.ok(list);
	}
	
	
	

	@RequestMapping(value = "/selectMembershipFreeDataInfo")
	public ResponseEntity <Map> selectMembershipFreeDataInfo(@RequestParam Map<String, Object> params , Model model) throws Exception {
		
		logger.debug("in  selectMembershipFreeDataInfo ");
		
		EgovMap basic  			= null;
		EgovMap installation		= null;
		EgovMap srvconfig	    = null;
		
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
				
		
		basic 				= membershipService.selectMembershipFree_Basic(params);
		installation 		= membershipService.selectMembershipFree_installation(params);
		srvconfig 		= membershipService.selectMembershipFree_srvconfig(params);

		
		Map<String, Object> map = new HashMap();
		map.put("basic", basic);
		map.put("installation", installation);
		map.put("srvconfig", srvconfig);
	
		return  ResponseEntity.ok(map); 
	}
	
	
	

	@RequestMapping(value = "/selectMembershipFree_oList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipFree_oList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		List<EgovMap>  oList     = null;	
		
		logger.debug("in  selectMembershipFree_oList ");
		
	      
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipService.selectMembershipFree_oList(params);  
		
		// 데이터 리턴.
		return ResponseEntity.ok(list);
	}
	

	@RequestMapping(value = "/selectMembershipFree_bs", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipFree_bs(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		List<EgovMap>  oList     = null;	
		
		logger.debug("in  selectMembershipFree_bs ");
		
	      
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipService.selectMembershipFree_bs(params);  
		
		// 데이터 리턴.
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectMembershipFree_cPerson", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipFree_cPerson(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		List<EgovMap>  oList     = null;	
		
		logger.debug("in  selectMembershipFree_cPerson ");
		
	      
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipService.selectMembershipFree_cPerson(params);  
		
		// 데이터 리턴.
		return ResponseEntity.ok(list);
	}
	
	
	
	
	@RequestMapping(value = "/callOutOutsProcedure", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> callOutOutsProcedure(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
	
		EgovMap item = new EgovMap();
	
		item = (EgovMap) membershipService.callOutOutsProcedure(params);  
		
		logger.debug("v_result : {}", params.get("v_result"));

		return ResponseEntity.ok(item);
	}
	
	

	@RequestMapping(value = "/selectMembershipFree_Packg", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipFree_Packg(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		List<EgovMap>  oList     = null;	
		
		logger.debug("in  selectMembershipFree_Packg ");
		
	      
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipService.selectMembershipFree_Packg(params);  
		
		// 데이터 리턴.
		return ResponseEntity.ok(list);
	}

	
	@RequestMapping(value = "/selectMembershipFree_PChange", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipFree_PChange(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		List<EgovMap>  oList     = null;	
		
		logger.debug("in  selectMembershipFree_PChange ");
		
	      
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipService.selectMembershipFree_PChange(params);  
		
		// 데이터 리턴.
		return ResponseEntity.ok(list);
	}
	
	
	

	@RequestMapping(value = "/selectMembershipFree_save", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectMembershipFree_save(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request ,SessionVO sessionVO) {
	
		logger.debug("in  selectMembershipFree_save ");
		
		
		
		params.put("user_id", sessionVO.getUserId());
		params.put("branch_id", sessionVO.getUserBranchId());
		
		logger.debug("			pram set  log");
		logger.debug("					"+params.toString());  
		logger.debug("			pram set end  ");
		
		EgovMap SEQ  			= null;
		EgovMap  rtnMap  = new EgovMap();
		//채번 
		SEQ  	 =membershipService.getSAL0095d_SEQ(params);  
		
		logger.debug(SEQ.toString());
		
		if(null != SEQ.get("seq")){
			 params.put("SAVE_SR_MEM_ID", SEQ.get("seq"));
			 int resultIntKey =membershipService.membershipFree_save(params);  
			 
			logger.debug("		resultIntKey["+resultIntKey+"] ");
			
			if(resultIntKey >0 ){
				membershipService.srvConfigPeriod(params);    
			}  
			
			rtnMap.put("result", "ok");
			
		}else{ 	rtnMap.put("result", "no");  }
		
		return ResponseEntity.ok(rtnMap);
	}
	
	
	
}
