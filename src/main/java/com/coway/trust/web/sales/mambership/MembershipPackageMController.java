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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.MembershipPackageMService;
import com.coway.trust.biz.sales.mambership.MembershipService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * 
 * @author hamhg
 *
 */
@Controller
@RequestMapping(value = "/sales/mPackages")
public class  MembershipPackageMController {

	private static Logger logger = LoggerFactory.getLogger(MembershipPackageMController.class);
	
	@Resource(name = "membershipPackageMService") 
	private MembershipPackageMService  membershipPackageMService;      

	@Resource(name = "membershipService")
	private MembershipService membershipService;
	
	
	@RequestMapping(value = "/membershipPackageRList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  membershipPackageRList.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");   
		
		
		return "sales/membership/membershipPackageRList";  
	}
	 
	
	@RequestMapping(value = "/membershipPackageRPop.do")
	public String membershipPackageRPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  membershipPackageRPop.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");   
		 
		
		model.addAttribute("packItemID",params.get("packItemID")); 
		model.addAttribute("packID",params.get("packID")); 
		model.addAttribute("modType",params.get("mod")); 
		model.addAttribute("packType",params.get("packType")); 
		
		return "sales/membership/membershipPackageRPop";  
	}
	 

	

	@RequestMapping(value = "/membershipPackageRNew.do")
	public String membershipPackageRNew(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  membershipPackageRNew.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");   
		
		
		return "sales/membership/membershipPackageRNewPop";  
	}
	
	

	@RequestMapping(value = "/selectList" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  selectList(@RequestParam Map<String, Object> params, HttpServletRequest request,Model model)	throws Exception {

		logger.debug("in  selectList ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		String[] SRV_CNTRCT_PAC_STUS_ID = request.getParameterValues("SRV_CNTRCT_PAC_STUS_ID");
		String[] PAC_TYPE = request.getParameterValues("PAC_TYPE");

		params.put("SRV_CNTRCT_PAC_STUS_ID", SRV_CNTRCT_PAC_STUS_ID);
		params.put("PAC_TYPE", PAC_TYPE);
		List<EgovMap>  list = membershipPackageMService.selectList(params);
		
		return ResponseEntity.ok(list);
	}
	
	
	

	@RequestMapping(value = "/selectPopUpList" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  selectPopUpList(@RequestParam Map<String, Object> params, HttpServletRequest request,Model model)	throws Exception {

		logger.debug("in  selectPopUpList ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipPackageMService.selectPopUpList(params);
		
		return ResponseEntity.ok(list);
	}
	
	
	
	
	@RequestMapping(value = "/selectPopDetail" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  selectPopDetailList(@RequestParam Map<String, Object> params, Model model)	throws Exception {

		logger.debug("in  selectPopDetail ");
		logger.debug("			pram set  log");  
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipPackageMService.selectPopDetail(params); 
		
		return ResponseEntity.ok(list);
	}
	
	

	

	@RequestMapping(value = "/mListUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertRentalChannel(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
		
		logger.debug("in  mListUpdate ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");  
		
		params.put("updator", sessionVO.getUserId());
		
		int  o = membershipPackageMService.SAL0081D_update(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData("");
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

				
		return ResponseEntity.ok(message);  
		
	}

	

	@RequestMapping(value = "/deletePackage.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deletePackage(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
		
		logger.debug("in  deletePackage ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");  
		
		params.put("updator", sessionVO.getUserId());
		
		int  o = membershipPackageMService.SAL0082D_delete(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData("");
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

				
		return ResponseEntity.ok(message);  
		
	}


	@RequestMapping(value = "/insertPackage.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertPackage(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
		
		logger.debug("in  insertRentalChannel ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");  
		
		params.put("updator", sessionVO.getUserId());
		
		int  o = -1;  
		String str="";
		ReturnMessage message = new ReturnMessage();
		
		if(params.get("mod").equals("EDIT")){
			  o= membershipPackageMService.SAL0082D_update(params);
			  message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			  
		}else if(params.get("mod").equals("ADD")){
			  o= 	membershipPackageMService.SAL0082D_insert(params);
			  message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			str ="unknown  mod type!!!" ;
			message.setMessage(messageAccessor.getMessage(str));
		}
	
	
		message.setCode(AppConstants.SUCCESS);
		message.setData(o);
		
		return ResponseEntity.ok(message);
		
	}

	

	@RequestMapping(value = "/selectCodel" ,method = RequestMethod.GET)
	public ResponseEntity<Map>    selectCodel(@RequestParam Map<String, Object> params, Model model)	throws Exception {

		logger.debug("in  selectCodel ");
		logger.debug("			pram set  log");  
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		Map<String, Object> map = new HashMap();
		List<EgovMap>  codeList = membershipPackageMService.selectGroupCode(params); 
		List<EgovMap>  groupCodeList = membershipPackageMService.selectGroupCodeGroupby(params); 
		
		map.put("codeList",codeList); 
		map.put("groupCodeList",groupCodeList); 
		
		return ResponseEntity.ok(map);
	}
	

	@RequestMapping(value = "/newRPackageAdd.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> newQPackageAdd(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
		
		logger.debug("in  newRPackageAdd ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");  
		
		params.put("updator", sessionVO.getUserId());
		params.put("userId", sessionVO.getUserId());
		
		List<EgovMap>  add			= (List<EgovMap>)  params.get("add");
		List<EgovMap>  remove	= (List<EgovMap>)  params.get("remove");
		List<EgovMap>  update 	= (List<EgovMap>)  params.get("update");
		
		
		int rtnValue = membershipPackageMService.SAL0081D_insert(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(rtnValue);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

				
		return ResponseEntity.ok(message);  
		
	}
	
	
	
	@RequestMapping(value = "/IsExistSVMPackage" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  IsExistSVMPackage(@RequestParam Map<String, Object> params, Model model)	throws Exception {

		logger.debug("in  IsExistSVMPackage ");
		logger.debug("			pram set  log");  
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipPackageMService.IsExistSVMPackage(params); 
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectFilterList" ,method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>>  selectFilterList(@RequestBody Map<String, Object> params, Model model)	throws Exception {
		
		logger.debug("in  selectFilterList ");
		logger.debug("			pram set  log");  
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		params.put("srvItmStkId", Integer.parseInt(params.get("srvItmStkId").toString()));
		
		List<EgovMap>  list = membershipPackageMService.selectFilterList(params); 
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/saveFilterInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveFilterInfo(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
		
		logger.debug("in  saveFilterInfo ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");  
		
		params.put("userId", sessionVO.getUserId());
		
		int rtnValue = membershipPackageMService.saveFilterInfo(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(rtnValue);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		
		return ResponseEntity.ok(message);  
		
	}
	
	@RequestMapping(value = "/selectStkCode" ,method = RequestMethod.GET)
	public ResponseEntity<String>  selectStkCode(@RequestParam Map<String, Object> params, Model model)	throws Exception {
		
		logger.debug("in  IsExistSVMPackage ");
		logger.debug("			pram set  log");  
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		String stkCode = membershipPackageMService.selectStkCode(params); 
		
		return ResponseEntity.ok(stkCode);
	}	
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
}
