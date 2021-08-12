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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.MembershipRCService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author kmo
 *
 */
@Controller
@RequestMapping(value = "/sales/membership")
public class MembershipRentalCancellationController {

	private static Logger logger = LoggerFactory.getLogger(MembershipRentalCancellationController.class);

	@Resource(name = "membershipRCService")
	private MembershipRCService membershipRCService;

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@RequestMapping(value = "/cancellationList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/membership/membershipRentalCancellationList";
	} 
	
	@RequestMapping(value = "/cancellationViewPop.do")
	public String cancellationView(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  cancellationView ");
		logger.debug("param ===================>>  " + params);
		

		model.addAttribute("trmnatId",params.get("trmnatId")); 
		
		return "sales/membership/membershipRentalCancellationViewPop";
	} 
	
	@RequestMapping(value = "/cancellationRAW.do")
	public String cancellationRAW(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/membership/membershipRCRAW";
	} 
	
	@RequestMapping(value = "/cancellationNewPop.do")
	public String cancellationNewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/membership/membershipRentalCancellationNewPop";
	} 
		
	@RequestMapping(value = "/selectCancellationList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectCancellationList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("in  selectCancellationList ");
		logger.debug("param ===================>>  " + params);


		List<EgovMap> list = membershipRCService.selectCancellationList(params);

	
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectCancellReqInfo", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectCancellReqInfo(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  selectCancellReqInfo ");
		logger.debug("param ===================>>  " + params);
		
		
		List<EgovMap> list = membershipRCService.selectCancellReqInfo(params);
		
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectBranchList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectBranchList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  selectBranchList ");
		logger.debug("param ===================>>  " + params);
		
		List<EgovMap> list = membershipRCService.selectBranchList(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectReasonList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectReasonList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  selectReasonList ");
		logger.debug("param ===================>>  " + params);		
		
		List<EgovMap> list = membershipRCService.selectReasonList(params);		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectCodeList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  selectCodeList ");
		logger.debug("param ===================>>  " + params);		
		
		List<EgovMap> list = membershipRCService.selectCodeList(params);		
		return ResponseEntity.ok(list);
	}
	
	
	@RequestMapping(value = "/selectCancellationInfo", method = RequestMethod.GET) 
	public ResponseEntity<EgovMap> selectCancellationInfo(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  selectReasonList ");
		logger.debug("param ===================>>  " + params);		
		
		EgovMap cancellInfo = membershipRCService.selectCancellationInfo(params);		

		cancellInfo.put("srvCntrctId", params.get("trmnatId"));
		
		return ResponseEntity.ok(cancellInfo);
	}
	
	@RequestMapping(value = "/cancellationSaveViewPop.do")
	public String cancellationSaveViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("in  cancellationSaveViewPop ");
		logger.debug("param ===================>>  " + params);
			
		//Membership info
		EgovMap memInfo = membershipRCService.selectMemInfo(params);       
		
		//Order Info
		EgovMap ordInfo =  membershipRCService.selectOrdInfo(params);
		
		EgovMap SrvMemConfigInfo = membershipRCService.selectSrvMemConfigInfo(params);
		
		if(!CommonUtils.isEmpty(SrvMemConfigInfo)){
			memInfo.put("srvPrdExprDt", SrvMemConfigInfo.get("srvPrdExprDt"));
			memInfo.put("srvCntrctPacDesc", SrvMemConfigInfo.get("pacDesc"));
		}
		
		//Order Info
		params.put("custId", ordInfo.get("custId"));
		
		EgovMap custInfo =  membershipRCService.selectCustInfo(params);
		
		
		model.addAttribute("ordInfo", ordInfo); 
		model.addAttribute("memInfo", memInfo); 
		model.addAttribute("custInfo", custInfo); 
		return "sales/membership/membershipRentalCancellationNewSavePop";
	} 
	
	@RequestMapping(value = "/saveContractCancellation", method = RequestMethod.POST) 
	public ResponseEntity<ReturnMessage> saveContractCancellation (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{		
		logger.debug("in  saveContractCancellation ");
		logger.debug("param ===================>>  " + params);
		
		params.put("userId", sessionVO.getUserId());
		
		String docNo = membershipRCService.saveContractCancellation(params); 
		
		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(docNo);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    
    	return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value="/membershipRentalCancellationRAWPop.do")
	public String membershipRentalCancellationRAWPop(){
		
		return "sales/membership/membershipRentalCancellationRAWPop";
	}
	
	
}
