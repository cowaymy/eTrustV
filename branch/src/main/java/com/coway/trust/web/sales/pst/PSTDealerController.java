package com.coway.trust.web.sales.pst;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.pst.PSTDealerService;
import com.coway.trust.biz.sales.pst.PSTRequestDOService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/pst")
public class PSTDealerController {
	private static final Logger logger = LoggerFactory.getLogger(PSTDealerController.class);
	
	@Resource(name = "pstDealerService")
	private PSTDealerService pstDealerService;
	
	@Resource(name = "pstRequestDOService")
	private PSTRequestDOService pstRequestDOService;
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	
	/**
	 * 화면 호출.
	 */
	@RequestMapping(value = "/pstDealerList.do")
	public String pstDealerList(@RequestParam Map<String, Object>params, ModelMap model) {
		
		return "sales/pst/pstDealerList";
	}
	
	@RequestMapping(value = "/pstDealerJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> pstDealerJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		String[] pstDealerStusList = request.getParameterValues("cmbDealerStus");
		params.put("pstDealerStusList", pstDealerStusList);
		
		String[] pstDealerTypeList = request.getParameterValues("cmbDealerType");
		params.put("pstDealerTypeList", pstDealerTypeList);
		
		List<EgovMap> pstDealerList = pstDealerService.pstDealerList(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(pstDealerList);
	}
	
	/**
	 * 화면 호출. -New pst (팝업화면)
	 */
	@RequestMapping(value = "/pstDealerDetailPop.do")
	public String pstDealerDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {

		params.put("stusCode", 9);
		
		params.put("dealerId", params.get("paramDealerId"));
		EgovMap pstDealerBasicInfo = pstDealerService.pstDealerDtBasicInfo(params);
		EgovMap dealerAddrTop =  pstRequestDOService.pstEditAddrDetailTopPop(params);
		EgovMap dealerCntTop = pstRequestDOService.pstNewContactPop(params);
		params.put("dealerUserId", pstDealerBasicInfo.get("userId"));
		EgovMap pstDealerDtUserInfo = pstDealerService.pstDealerDtUserInfo(params);
		
		// Detail Popup Tab
		model.addAttribute("pstDealerBasicInfo", pstDealerBasicInfo);
		model.addAttribute("dealerAddrTop", dealerAddrTop);
		model.addAttribute("dealerCntTop", dealerCntTop);
		model.addAttribute("pstDealerDtUserInfo", pstDealerDtUserInfo);
		model.addAttribute("dealerId", params.get("paramDealerId"));
				
		return "sales/pst/pstDealerDetailPop";
	}
	
	/**
	 * dealer Detail Pop - Main Address Grid
	 */
	@RequestMapping(value = "/pstDealerAddrJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> pstDealerAddrJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		List<EgovMap> dealerAddrList =  pstRequestDOService.pstEditAddrDetailListPop(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(dealerAddrList);
	}
	
	/**
	 * dealer Detail Pop - Main Contact Grid
	 */
	@RequestMapping(value = "/pstDealerCntJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> pstDealerCntJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		List<EgovMap> dealerCntList =  pstRequestDOService.pstNewContactListPop(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(dealerCntList);
	}
	
	/**
	 * 화면 호출. - pst Address View (팝업화면)
	 */
	@RequestMapping(value = "/pstDealerAddrViewPop.do")
	public String pstDealerAddrViewPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		EgovMap addrView = pstRequestDOService.pstRequestDODelvryAddress(params);
		model.addAttribute("addrView", addrView);
		
		return "sales/pst/pstDealerAddrViewPop";
	}
	
	/**
	 * 화면 호출. - pst Contact View (팝업화면)
	 */
	@RequestMapping(value = "/pstDealerCntViewPop.do")
	public String pstDealerCntViewPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		EgovMap cntView = pstRequestDOService.pstRequestDOMailContact(params);
		model.addAttribute("cntView", cntView);
		
		return "sales/pst/pstDealerCntViewPop";
	}
	
	@RequestMapping(value = "/pstDealerAddrComboList")
	public ResponseEntity<List<EgovMap>>  pstDealerAddrComboList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> postList = null;
		logger.debug("==========params=========== :: " + params.toString());
		postList = pstDealerService.pstDealerAddrComboList(params);
		
		return ResponseEntity.ok(postList);
	}
	
	@RequestMapping(value = "/getDealerAreaId.do")
	public ResponseEntity<EgovMap> getDealerAreaId(@RequestParam Map<String, Object> params) throws Exception{
		
		EgovMap areaMap = null;
		
		areaMap = pstDealerService.getAreaId(params);
		
		return ResponseEntity.ok(areaMap);
		
	}
	
	/**
	 * 화면 호출. -New pst (팝업화면)
	 */
	@RequestMapping(value = "/pstDealerNewPop.do")
	public String pstDealerNewPop(@RequestParam Map<String, Object>params, ModelMap model) {

		return "sales/pst/pstDealerNewPop";
	}
	
	@RequestMapping(value = "/dealerBrnchJsonList")
	public ResponseEntity<List<EgovMap>>  dealerBrnchList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> brnchtList = null;
		brnchtList = pstDealerService.dealerBrnchList();
		
		return ResponseEntity.ok(brnchtList);
	}
	
	@RequestMapping(value = "/newDealer.do", method = RequestMethod.GET) 
	public ResponseEntity<ReturnMessage> newDealer(@RequestParam Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{
		
		params.put("userId", sessionVO.getUserId());
		
		pstDealerService.newDealer(params);
		
		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData("");
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    
    	return ResponseEntity.ok(message);
		
	}
	
	/**
	 * 화면 호출. -New pst (팝업화면)
	 */
	@RequestMapping(value = "/getPstDealerEditPop.do")
	public String getPstDealerEditPop(@RequestParam Map<String, Object>params, ModelMap model) {

		params.put("stusCode", 9);
		params.put("paramDealerId", params.get("dealerId"));
		
		EgovMap pstDealerBasicInfo = pstDealerService.pstDealerDtBasicInfo(params);
		EgovMap dealerAddrTop =  pstRequestDOService.pstEditAddrDetailTopPop(params);
		EgovMap dealerCntTop = pstRequestDOService.pstNewContactPop(params);
		
		model.addAttribute("pstDealerBasicInfo", pstDealerBasicInfo);
		model.addAttribute("dealerAddrTop", dealerAddrTop);
		model.addAttribute("dealerCntTop", dealerCntTop);
		model.addAttribute("paramDealerId", params.get("dealerId"));
		return "sales/pst/pstDealerEditPop";
	}
	
	@RequestMapping(value = "/editDealer.do", method = RequestMethod.GET) 
	public ResponseEntity<ReturnMessage> editDealer(@RequestParam Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{
		
		params.put("userId", sessionVO.getUserId());
		logger.debug("==========params=========== :: " + params.toString());
		pstDealerService.editDealer(params);
		
		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData("");
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    
    	return ResponseEntity.ok(message);
		
	}
	
	
	/**
	 * Addr new Address(Edit)
	 * @param model
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/editDealerNewAddressPop.do")
	public String editDealerNewAddressPop(@RequestParam Map<String, Object> params , ModelMap model) throws Exception{
		
		model.addAttribute("insDealerId", params.get("paramDealerId"));
		
		return "sales/pst/pstDealerNewAddressPop";
	}
	
	
	/**
	 * 화면 호출. -New pst (팝업화면)
	 */
	@RequestMapping(value = "/dealerEditAddrUpdPop.do")
	public String dealerEditAddrUpdPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		logger.info("###################3 :  " + params.toString());
		model.addAttribute("dealerId", params.get("dealerId"));
		params.put("pstDealerMailAddId", params.get("editDealerAddId"));
		EgovMap updAddrInfo = pstRequestDOService.pstRequestDOMailAddress(params);
		logger.info("########################### :  " + updAddrInfo.get("areaId"));
		model.addAttribute("updAddrInfo", updAddrInfo);
		
		return "sales/pst/dealerEditAddrUpdPop";
	}
	
	
	/**
	 * 화면 호출. -dealer edit Contact update
	 */
	@RequestMapping(value = "/dealerEditCntUpdPop.do")
	public String dealerEditCntUpdPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		params.put("dealerId", params.get("paramDealerId"));
		params.put("pstDealerMailCntId", params.get("editDealerCntId"));
		EgovMap dealerCntTop = pstRequestDOService.pstRequestDOMailContact(params);
		
		
		// Detail Popup Tab
		model.addAttribute("flag", params.get("requestdo"));
		model.addAttribute("dealerCntTop", dealerCntTop);
		model.addAttribute("dealerId", params.get("paramDealerId"));
		model.addAttribute("dealerCntId", params.get("editDealerCntId"));
				
		return "sales/pst/dealerEditCntUpdPop";
	}
	
	
	@RequestMapping(value = "/updDealerCntr.do", method = RequestMethod.GET) 
	public ResponseEntity<ReturnMessage> updDealerCntr(@RequestParam Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{
		
		params.put("userId", sessionVO.getUserId());
		logger.debug("==========params=========== :: " + params.toString());
		pstDealerService.updDealerCntSAL0032D(params);
		
		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData("");
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    
    	return ResponseEntity.ok(message);
		
	}

}
